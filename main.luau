--!strict

local Settings = require("./settings")

print("Welcome to the Hunger Games!")
print("Inspired by BrantSteele, created by RedrcknRbn")
print(string.format([[Current Settings:
    Season: %d,
    Export Results as Image: %s]], 
    Settings.Season, 
    tostring(Settings.ExportResultsAsImage)
))