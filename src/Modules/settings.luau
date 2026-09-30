--!strict
local SettingsModule = {}
local self = SettingsModule

-- Seal Globals
local json = require("@std/serde/json")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")

-- ugly hack! could be done much better :P
local DefaultSettings = {
	ExportPath = "./results/",
	ExportImages = true,
	ExportJSON = true,
	PrintResults = true,
}

local settingNames = {
	"Export Path",
	"Export Images",
	"Export JSON",
	"Print Results",
	colors.red("Exit"),
}

local settingkeys = {
	"ExportPath",
	"ExportImages",
	"ExportJSON",
	"PrintResults",
}

-- Verifies the settings file exists and is valid, and returns the settings table. Should ideally be called before any other settings functions are called.
function SettingsModule.verifyAndReturnSettings()
	local data = nil

	local success, err = pcall(function()
		data =
			json.readfile("./settings.json") :: { ExportPath: string, ExportImages: boolean, ExportJSON: boolean, PrintResults: boolean }
	end)

	if not data or not success then
		if err then
			print(colors.red("Error reading settings file: " .. tostring(err)))
		end
		print(colors.red("Settings file not found or otherwise invalid. Creating default settings..."))
		json.writefile("./settings.json", DefaultSettings)
		return DefaultSettings
	end

	return data
end

-- helper funcs
function SettingsModule.getSetting(settingName: string)
    local data = self.verifyAndReturnSettings()
    return data[settingName]
end

function SettingsModule.setSetting(settingName: string, value: any)
    local data = self.verifyAndReturnSettings()
    data[settingName] = value
    json.writefile("./settings.json", data)
end

function SettingsModule.getAllSettings()
    local data = self.verifyAndReturnSettings()
    return data
end

function SettingsModule.StringifySettings()
    local data = self.verifyAndReturnSettings()
    local str = ""
    for k, v in pairs(data) do
        str = str .. string.format("%s: %s\n", k, tostring(v))
    end
    return str
end

-- Handles the settings editor
function SettingsModule.settingsEditor()
	local data = self.verifyAndReturnSettings()

	print(colors.bold.yellow("Welcome to the Settings Editor!"))

	for setting, value in pairs(data) do
		print(string.format("%s: %s", colors.yellow(setting), colors.cyan(tostring(value))))
	end

	local settingToChange = prompt.pick("Which setting would you like to change?", settingNames, 1)

	if settingToChange == 5 then
		print("All Settings Saved.")
		return
	end

	local setting = settingkeys[settingToChange]

	if setting ~= nil then
		print(colors.yellow(string.format("Current value of %s: %s", setting, colors.cyan(tostring(data[setting])))))
		if typeof(data[setting]) == "boolean" then
			local newValue = prompt.confirm("Would you like this setting enabled?")
			self.setSetting(setting, tonumber(newValue))
		elseif typeof(data[setting]) == "string" then
			local newValue = prompt.text("Enter new value: ")
			self.setSetting(setting, newValue)
        elseif typeof(data[setting]) == "number" then
			local newValue = prompt.text("Enter new value: ")
			self.setSetting(setting, tonumber(newValue))
        else
            print(colors.bold.red("Error: Weird data type detected. Please check the settings file."))
		end
		json.writefile("./settings.json", data)
		print(colors.green(string.format("Setting %s updated to: %s", setting, colors.cyan(tostring(data[setting])))))
		self.settingsEditor()
	else
		print(colors.red("Invalid setting selected."))
		self.settingsEditor()
	end
end

return SettingsModule
