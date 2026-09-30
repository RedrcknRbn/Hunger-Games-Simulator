--!strict

-- Seal Globals
local _input = require("@std/io/input")
local prompt = require("@std/io/prompt")
local colors = require("@std/io/colors")
local time = require("@std/time")

-- Modules :3
local Settings = require("./settings")

function entry()
	print("Welcome to the Hunger Games!")

	time.wait(0.1)

	print("Inspired by BrantSteele, created by RedrcknRbn")

	time.wait(0.5)

	print(string.format(
		[[Current Settings:
    Season: %d,
    Export Results as Image: %s]],
		Settings.Season,
		tostring(Settings.ExportResultsAsImage)
	))

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

entry()
