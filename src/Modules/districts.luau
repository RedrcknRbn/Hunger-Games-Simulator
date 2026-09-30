--!strict
local DistrictModule = {}
local self = DistrictModule

-- Seal Globals
local json = require("@std/serde/json")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")

-- Helper Modules
local characters = require("./characters")

-- Types!
export type DistrictData = {
	Name: string,
	Members: { string }, -- list of character IDs that belong to this district
}

local DefaultDistrictData: DistrictData = {
	Name = "Default District",
	Members = { "Default1", "Default2" },
}

-- Verifies the district data file exists and is valid, and returns the district data table. Should ideally be called before any other district functions are called.
function DistrictModule.verifyAndReturnDistrictData(seasonPath: string)
	local data: { [number]: DistrictData } = { [1] = DefaultDistrictData }

	local success, err = pcall(function()
		data = json.readfile(seasonPath)
	end)

	if not data or not success then
		if err then
			print(colors.red("Error reading districts file: " .. tostring(err)))
		end
		print(colors.red("Districts file not found or otherwise invalid. Creating default districts..."))
		json.writefile(seasonPath, { [1] = DefaultDistrictData })
		return { [1] = DefaultDistrictData }
	end

	return data
end

-- helper funcs
function DistrictModule.getDistrictData(seasonPath: string)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	return data
end

function DistrictModule.getSpecificDistrictData(seasonPath: string, districtID: string)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	return data[tonumber(districtID) or 1]
end

function DistrictModule.setSpecificDistrictData(seasonPath: string, districtID: string, districtData: DistrictData)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	data[tonumber(districtID) or 1] = districtData
	json.writefile(seasonPath, data)
end

function DistrictModule.getAllDistrictNames(seasonPath: string)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	local names: { string } = {}
	for _, district in pairs(data) do
		table.insert(names, district.Name)
	end
	return names
end

function DistrictModule.stringifyDistrictData(districtData: DistrictData)
	return string.format("Name: %s\nMembers: %s", districtData.Name, table.concat(districtData.Members, ", "))
end

function DistrictModule.shuffleDistricts(seasonPath: string, charactersPerDistrict: number)
	if charactersPerDistrict < 1 or charactersPerDistrict % 1 ~= 0 then
		print(colors.red("Characters per district must be a positive whole number."))
		return
	end

	local data: { DistrictData } = {}
	local characterPath = string.gsub(seasonPath, "districts%.json$", "characters.json")
	local characterData = characters.verifyAndReturnCharacterData(characterPath)

	local remainingCharactersIDs: { string } = {}
	local districtTable: DistrictData = { Name = "District", Members = {} }
	local currentDistrict = 1

	for characterID in pairs(characterData) do
		table.insert(remainingCharactersIDs, characterID)
	end

	while #remainingCharactersIDs > 0 do
		local randIndex = math.random(#remainingCharactersIDs)
		local chosenCharacterID = remainingCharactersIDs[randIndex]

		if #districtTable.Members >= charactersPerDistrict then
			districtTable.Name = "District " .. currentDistrict
			table.insert(data, districtTable)
            print(self.stringifyDistrictData(districtTable))
			currentDistrict += 1
			districtTable = { Name = "District", Members = {} }
		end

		table.insert(districtTable.Members, chosenCharacterID)
		table.remove(remainingCharactersIDs, randIndex)
	end

	if districtTable then
		districtTable.Name = "District " .. currentDistrict
		table.insert(data, districtTable)
        print(self.stringifyDistrictData(districtTable))
	end

	json.writefile(seasonPath, data)
	print("Districts shuffled.")
end

-- some menus!
function DistrictModule.districtDataEditor(seasonPath: string, oldDistrictData: DistrictData)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	local newDistrict: DistrictData = oldDistrictData
	local districtID = prompt.text("Enter the Number ID of the district: ")
	newDistrict.Name = prompt.text("Enter the name of the district: ")
	newDistrict.Members = {}

	local memberChoice
	repeat
		memberChoice = prompt.text("Enter a character ID to add to the district (or 'done' to finish): ")
		if memberChoice ~= "done" then
			table.insert(newDistrict.Members, memberChoice)
		end
	until memberChoice == "done"

	print(colors.yellow("The following is the data for the new district: " .. newDistrict.Name))
	print(self.stringifyDistrictData(newDistrict))
	if prompt.confirm("Do you want to save this district?") then
		data[tonumber(districtID) or #data + 1] = newDistrict
		json.writefile(seasonPath, data)
		print(colors.green("District saved!"))
	else
		print(colors.red("District not saved."))
	end

	return newDistrict
end

function DistrictModule.districtEditor(seasonPath: string)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	local districtNames = self.getAllDistrictNames(seasonPath)

	local districtChoice = prompt.pick("Select a district to edit:", districtNames, 1)
	local selectedDistrictName = districtNames[districtChoice]
	local selectedDistrictData = data[tonumber(districtChoice) or 1]

	print(colors.yellow("Current data for " .. selectedDistrictName .. ":"))
	print(self.stringifyDistrictData(selectedDistrictData))

	if prompt.confirm("Do you want to edit this district?") then
		self.districtDataEditor(seasonPath, selectedDistrictData)
	else
		print(colors.red("District not edited."))
	end
end

function DistrictModule.districtCreator(seasonPath: string)
	print(colors.yellow("Creating a new district..."))
	self.districtDataEditor(seasonPath, DefaultDistrictData)
end

function DistrictModule.districtDeleter(seasonPath: string)
	local data = self.verifyAndReturnDistrictData(seasonPath)
	local districtNames = self.getAllDistrictNames(seasonPath)

	local districtChoice = prompt.pick("Select a district to delete:", districtNames, 1)
	local selectedDistrictName = districtNames[districtChoice]
	local selectedDistrictID = tonumber(districtChoice) or 1

	if prompt.confirm("Are you sure you want to delete " .. selectedDistrictName .. "?") then
		data[selectedDistrictID] = nil
		json.writefile(seasonPath, data)
		print(colors.green(selectedDistrictName .. " has been deleted."))
	else
		print(colors.red("District not deleted."))
	end
end

function DistrictModule.districtManager(seasonPath: string)
	local options = {
		"Create a new District",
		"Edit an existing District",
		"Shuffle Districts based on characters.json",
		"Delete a District",
		colors.red("Exit"),
	}

	local choice = prompt.pick("What would you like to do?", options, 1)

	if choice == 1 then
		self.districtCreator(seasonPath)
		self.districtManager(seasonPath)
	elseif choice == 2 then
		self.districtEditor(seasonPath)
		self.districtManager(seasonPath)
	elseif choice == 3 then
		if prompt.confirm(colors.red("Are you sure you want to shuffle districts? This is ")..colors.bold.red("IRREVERSIBLE")) then
            local num = tonumber(prompt.text("How many characters per district?")) or 2
            self.shuffleDistricts(seasonPath, num)
		else
			print(colors.red("Districts not shuffled"))
		end
		self.districtManager(seasonPath)
	elseif choice == 4 then
		self.districtDeleter(seasonPath)
		self.districtManager(seasonPath)
	elseif choice == 5 then
		print(colors.bold.red("Exiting District manager..."))
		return
	end
end

return DistrictModule
