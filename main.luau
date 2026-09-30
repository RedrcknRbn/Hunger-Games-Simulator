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
	print("Welcome to the Hunger Games!")

	time.wait(0.1)

	print("Inspired by BrantSteele, created by RedrcknRbn")

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
	})

	if opt == 1 then
		print(colors.green("Starting a new simulation..."))
	elseif opt == 2 then
		print(colors.red("This feature is not yet implemented. Please check back later."))
		entry()
	elseif opt == 3 then
		print(colors.red("This feature is not yet implemented. Please check back later."))
		entry()
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
		print(colors.red("Settings file not found. Creating default settings..."))
		json.writefile("./settings.json", DefaultSettings)
		return DefaultSettings
	end

	return data
end

entry()
