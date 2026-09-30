--!strict
local CharacterModule = {}
local self = CharacterModule

-- Seal Globals
local json = require("@std/serde/json")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")

-- Types!
export type CharacterData = {
	Name: string,
	Nick: string,
	Gender: string, -- m (male), f (female), nb (nonbinary), p (plural) -- affects pronoun usage
	Icon: string, -- the icon to use for this character, should be in ./Assets/Icons/
	DeathChance: number, -- used for influencing the death of a character, often for filler characters :)
}

local DefaultCharacterData: CharacterData = {
	Name = "Firstname Lastname",
	Nick = "Nickname",
	Gender = "nb",
	Icon = "default.png",
	DeathChance = 1,
}

-- Verifies the character data file exists and is valid, and returns the character data table. Should ideally be called before any other character functions are called.
function CharacterModule.verifyAndReturnCharacterData(seasonPath: string)
	local data: { [string]: CharacterData } = { default = DefaultCharacterData }

	local success, err = pcall(function()
		data = json.readfile(seasonPath)
	end)

	if not data or not success then
		if err then
			print(colors.red("Error reading characters file: " .. tostring(err)))
		end
		print(colors.red("Characters file not found or otherwise invalid. Creating default characters..."))
		json.writefile(seasonPath, { default = DefaultCharacterData })
		return { default = DefaultCharacterData }
	end

	return data
end

-- helper funcs
function CharacterModule.getCharacterData(seasonPath: string)
	local data = self.verifyAndReturnCharacterData(seasonPath)
	return data
end

function CharacterModule.getSpecificCharacterData(seasonPath: string, characterName: string)
	local data = self.verifyAndReturnCharacterData(seasonPath)
	return data[characterName]
end

function CharacterModule.setSpecificCharacterData(
	seasonPath: string,
	characterName: string,
	characterData: CharacterData
)
	local data = self.verifyAndReturnCharacterData(seasonPath)
	data[characterName] = characterData
	json.writefile(seasonPath, data)
end

function CharacterModule.getAllCharacterNames(seasonPath: string)
    local data = self.verifyAndReturnCharacterData(seasonPath)
    local names: { string } = {}
    for name, _ in pairs(data) do
        table.insert(names, name)
    end
    return names
end

function CharacterModule.stringifyCharacterData(characterData: CharacterData)
    return string.format(
        "Name: %s\nNickname: %s\nGender: %s\nIcon: %s\nDeath Chance: %d",
        characterData.Name,
        characterData.Nick,
        characterData.Gender,
        characterData.Icon,
        characterData.DeathChance
    )
end

-- some menus!
function CharacterModule.characterDataEditor(seasonPath: string, oldCharacterData: CharacterData)
	local data = self.verifyAndReturnCharacterData(seasonPath)
    local newCharacter: CharacterData = oldCharacterData
	newCharacter.Name = prompt.text("Enter the full name (first and last if applicable) of the character: ")
	newCharacter.Nick = prompt.text("Enter the nickname (display) of the character: ")

	local genderOptions = { "m", "f", "nb", "p" }
	local genderChoice = prompt.pick("Select the gender of the character:", {
		"Male (he/him)",
		"Female (she/her)",
		"Non-Binary (they/them)",
		"Plural (it/its)",
	}, 1)
	newCharacter.Gender = genderOptions[genderChoice]

	newCharacter.Icon =
		prompt.text("Enter the filename of the icon for the character (should be in ./Assets/Icons/): ")
	newCharacter.DeathChance = tonumber(
		prompt.text("Enter the death chance of the character (a number, higher means more likely to die): ")
	) or 1

    local CharacterID = prompt.text("Enter the UNIQUE character ID of the character: ")

    print(colors.yellow("The following is the data for the new character:"))
    print(self.stringifyCharacterData(newCharacter))
    if prompt.confirm("Do you want to save this character?") then
        data[CharacterID] = newCharacter
        json.writefile(seasonPath, data)
        print(colors.green("Character saved!"))
    else
        print(colors.red("Character not saved."))
    end

    return newCharacter, CharacterID
end

function CharacterModule.characterEditor(seasonPath: string)
    local data = self.verifyAndReturnCharacterData(seasonPath)
    local characterNames = self.getAllCharacterNames(seasonPath)

    local characterChoice = prompt.pick("Select a character to edit:", characterNames, 1)
    local selectedCharacterName = characterNames[characterChoice]
    local selectedCharacterData = data[selectedCharacterName]

    print(colors.yellow("Current data for " .. selectedCharacterName .. ":"))
    print(self.stringifyCharacterData(selectedCharacterData))

    if prompt.confirm("Do you want to edit this character?") then
        self.characterDataEditor(seasonPath, selectedCharacterData)
    else
        print(colors.red("Character not edited."))
    end
end

function CharacterModule.characterCreator(seasonPath: string)
    print(colors.yellow("Creating a new character..."))
    self.characterDataEditor(seasonPath, DefaultCharacterData)
end

function CharacterModule.characterDeleter(seasonPath: string)
    local data = self.verifyAndReturnCharacterData(seasonPath)
    local characterNames = self.getAllCharacterNames(seasonPath)

    local characterChoice = prompt.pick("Select a character to delete:", characterNames, 1)
    local selectedCharacterName = characterNames[characterChoice]

    if prompt.confirm("Are you sure you want to delete " .. selectedCharacterName .. "?") then
        data[selectedCharacterName] = nil
        json.writefile(seasonPath, data)
        print(colors.green(selectedCharacterName .. " has been deleted."))
    else
        print(colors.red("Character not deleted."))
    end
end

function CharacterModule.characterManager(seasonPath: string)
    local options = {
        "Create a new character",
        "Edit an existing character",
        "Delete a character",
        colors.red("Exit"),
    }

    local choice = prompt.pick("What would you like to do?", options, 1)

    if choice == 1 then
        self.characterCreator(seasonPath)
        self.characterManager(seasonPath)
    elseif choice == 2 then
        self.characterEditor(seasonPath)
        self.characterManager(seasonPath)
    elseif choice == 3 then
        self.characterDeleter(seasonPath)
        self.characterManager(seasonPath)
    elseif choice == 4 then
        print(colors.bold.red("Exiting character manager..."))
        return
    end
end

return CharacterModule

