--!strict

-- Seal Globals
local _input = require("@std/io/input")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")
local time = require("@std/time")
local _json = require("@std/serde/json")

-- Helper Modules
local settings = require("./Modules/settings")

-- The "entrypoint" of sorts for the program.
function entry()
	print(colors.bold.yellow("Welcome to the Hunger Games!"))

	time.wait(0.1)

	print(colors.bold.yellow("Inspired by BrantSteele, created by RedrcknRbn"))

	time.wait(0.5)

	local data = settings.verifyAndReturnSettings()

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
		settings.settingsEditor()
        entry()
	elseif opt == 4 then
		print(colors.bold.red("Exiting..."))
		return
	end
end

entry()
