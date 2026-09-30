--!strict

-- Seal Globals
local _input = require("@std/io/input")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")
local fs = require("@std/fs")
local _json = require("@std/serde/json")

-- Helper Modules
local settings = require("./Modules/settings")
local characters = require("./Modules/characters")
local districts = require("./Modules/districts")

-- The "entrypoint" of sorts for the program.
function entry()
	print(colors.bold.yellow("Welcome to the Hunger Games!"))

	print(colors.bold.yellow("Inspired by BrantSteele, created by RedrcknRbn"))

	print(colors.yellow(settings.StringifySettings()))

	local opt = prompt.pick("What would you like to do?", {
		"Manage Simulations",
		"Grab old simulation results",
		"Change settings",
		colors.red("Exit"),
	})

	if opt == 1 then
		print(colors.green("Loading Simulation Data..."))
		manageSimulation(seasonSelection())
	elseif opt == 2 then
		print(colors.red("This feature is not yet implemented."))
		entry()
	elseif opt == 3 then
		settings.settingsEditor()
		entry()
	elseif opt == 4 then
		print(colors.bold.red("Exiting..."))
		return
	end
end

-- Requests the user to pick a season from the SeasonData folder, and returns the name of the folder.
function seasonSelection()
	fs.makedir("./SeasonData",{error_if_exists = false})
	local seasonFolders = fs.listdir("./SeasonData", false, function(path: string)
		return if string.match(path, "Season%w") then true else false
	end)
	-- :(
	if seasonFolders == nil or #seasonFolders == 0 then
		print(colors.bold.red("Error: No season folders found in ./SeasonData. Creating a Season 1 Folder."))
		fs.makedir("./SeasonData/Season1", { error_if_exists = false })
		seasonFolders = { "./SeasonData/Season1" }
	end
	local seasonPath = prompt.pick("Which season would you like to simulate?", seasonFolders, 1)
	return seasonFolders[seasonPath]
end

function manageSimulation(seasonFolder: string)
	print(colors.green(string.format("Preparing to manage simulation %s...", seasonFolder)))
	characters.verifyAndReturnCharacterData(seasonFolder .. "/characters.json")
	print(colors.green("Character data verified."))
	local opt = prompt.pick("What would you like to do?", {
		"Manage character data",
        "Manage District data",
		colors.red("Exit"),
	})

	if opt == 1 then
		characters.characterManager(seasonFolder .. "/characters.json")
		manageSimulation(seasonFolder)
	elseif opt == 2 then
        districts.districtManager(seasonFolder .. "/districts.json")
		manageSimulation(seasonFolder)
	elseif opt == 3 then
		entry()
		return
	end
end

entry()
