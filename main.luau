--!strict

-- Seal Globals
local _input = require("@std/io/input")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")
local time = require("@std/time")
local json = require("@std/serde/json")

local DefaultSettings = {
	ExportPath = "./results/",
	ExportImages = true,
	ExportJSON = true,
	PrintResults = true,
}

-- The "entrypoint" of sorts for the program.
function entry()
	print(colors.bold.yellow("Welcome to the Hunger Games!"))

	time.wait(0.1)

	print(colors.bold.yellow("Inspired by BrantSteele, created by RedrcknRbn"))

	time.wait(0.5)

	local data = verifyAndReturnSettings()

	print(
		string.format(
			[[Current Settings: 
Export Path: %s
Export Images: %s
Export JSON: %s
Print Results: %s]],
			data.ExportPath,
			tostring(data.ExportImages),
			tostring(data.ExportJSON),
			tostring(data.PrintResults)
		)
	)

	time.wait(0.5)

	local opt = prompt.pick("What would you like to do?", {
		"Start a new simulation using current settings",
		"Grab old simulation results",
		"Change settings",
        colors.red("Exit"),
	})

	if opt == 1 then
		print(colors.green("Starting a new simulation..."))
	elseif opt == 2 then
		print(colors.red("This feature is not yet implemented. Please check back later."))
		entry()
	elseif opt == 3 then
		settingsEditor()
	end
end

-- Verifies the settings file exists and is valid, and returns the settings table.
function verifyAndReturnSettings()
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

function settingsEditor()
    local data = verifyAndReturnSettings()

    print(colors.bold.yellow("Welcome to the Settings Editor!"))

    for setting, value in pairs(data) do
        print(string.format("%s: %s", colors.yellow(setting), colors.cyan(tostring(value))))
    end

    local settingToChange = prompt.pick("Which setting would you like to change?", {
        "Export Path",
        "Export Images",
        "Export JSON",
        "Print Results",
        colors.red("Go back to main menu"),
    })

    if settingToChange == 5 then
        entry()
        return
    end

    local settingKeys = { "ExportPath", "ExportImages", "ExportJSON", "PrintResults" }
    local settingName = settingKeys[settingToChange]

    if settingName ~= nil then
        print(colors.yellow(string.format("Current value of %s: %s", settingName, colors.cyan(tostring(data[settingName])))))
        if data[settingName] == true or data[settingName] == false then
            local newValue = prompt.confirm("Would you like this setting enabled?")
            data[settingName] = newValue
        else
            local newValue = prompt.text("Enter new value: ")
            data[settingName] = newValue
        end
		json.writefile("./settings.json", data)
        print(colors.green(string.format("Setting %s updated to: %s", settingName, colors.cyan(tostring(data[settingName])))))
        settingsEditor()
    else
        print(colors.red("Invalid setting selected."))
        settingsEditor()
    end

end

entry()
