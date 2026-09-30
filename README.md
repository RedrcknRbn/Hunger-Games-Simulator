# Pulus Games
The Pulus Games is a personal Hunger-Games/Big-Brother styled event that happens, where the characters are my friends!

This is a local remake of [BrantSteele's Hunger Games Simulation](https://brantsteele.com/hungergames/classic/), made using [Roblox's Luau programming language](https://luau.org/), powered by [Seal-Runtime](https://github.com/seal-runtime/seal).

## Explanation

We've decided to split from BrantSteele's version due to many reasons, the most important being the automatic export of day-by-day logs as images, so that way I don't get spoiled as GM, and so that way I don't have to resimulate the entire game from the start whenever a new day happens.

This also gives me extra freedom to make more custom events, and be able to use images without having to reformat them.

I'm using Luau via Seal instead of something like Python because,

1. I have more experience with Luau than I do Python
2. Seal gives me extra tools that base Luau is missing.

This codebase has been made public in hopes that others, with similar needs such as my own!

## Usage

Run using [Seal](https://github.com/seal-runtime/seal) by `seal ./main.luau`

You can easily create new Season Data by going to `./SeasonData/Season#/`, and modifying JSON data from any of my seasons!

## Notices

This project is licensed under [GNU GENERAL PUBLIC LICENSE v3](https://www.gnu.org/licenses/gpl-3.0.html), and is in no way affiliated with or endorsed by Roblox, the Luau team, Brantsteele, or Seal Runtime