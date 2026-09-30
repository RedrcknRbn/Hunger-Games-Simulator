--!strict
local CharacterModule = {}
local self = CharacterModule

-- Seal Globals
local json = require("@std/serde/json")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")
local fs = require("@std/fs")

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
    local data: { [string]: CharacterData } = {default = DefaultCharacterData}

    local success, err = pcall(function()
        data = json.readfile(seasonPath)
    end)

    if not data or not success then
        if err then
            print(colors.red("Error reading characters file: " .. tostring(err)))
        end
        print(colors.red("Characters file not found or otherwise invalid. Creating default characters..."))
        json.writefile(seasonPath, {default = DefaultCharacterData})
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

function CharacterModule.setSpecificCharacterData(seasonPath: string, characterName: string, characterData: CharacterData)
    local data = self.verifyAndReturnCharacterData(seasonPath)
    data[characterName] = characterData
    json.writefile(seasonPath, data)
end

return CharacterModule