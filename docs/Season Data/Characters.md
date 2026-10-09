# Characters

Characters are the actual "Players" of the Hunger Games.

The terms Characters, Players, and Members have their own unique meanings.

- Character: Internal programming name/term for the characters
- Player: The end-user name for the characters
- Member: Used to define a character in relation to a district (eg: Player1 is a Member of District1)

A Character UID is 

## Editing

You can edit characters by either going to `SeasonData\Season#\characters.json`, or by using the script's Character Manager

## Format

Characters have a UID (Unique ID), Nickname *(Nick)*, Full Name *(Name)*, Gender, Icon, and Death Chance *(DeathChance)* as defined in `characters.json`

- **Character UID:** The **Unique** ID defined internally to refer to a character. This may differ from Nick or Name
- **Name:** The full name of the character, used at the very start and very end of the simulation.
- **Nick:** The nickname of the character, used in events (eg: Foo attacked Bar)
- **Icon:** The name of the image asset used for the character, if any.
- **DeathChance:** The likely-hood this character dies. Higher number = Greater chance.
- **Gender:** The "gender" of the character, defines pronouns used for events. Currently, 4 accepted valuesL
    - f - Feminine (she/her)
    - m - Masculine (he/him)
    - nb - Nonbinary (they/them)
    - p - Plural/Multiple (they/them, plural, used for multiple people defined as one character)

Character Data is stored within a JSON file, explained below

Comments/Explanations are defined by `//`

```json
{
    "Player1": { // Character data, defined by Character UID
        "Name": "Player One", // The "full name" of sorts of the character, used at the very start and very end of the simulation.
        "Nick": "Foo", // The nickname of the character, used in events (eg: Foo attacked Bar)
        "Gender": "m", // The "gender" of the character, defines pronouns used for events. Currently, 4 accepted values: see documentation
        "Icon": "ExampleFoo", // The name of the image asset used for the character, if any.
        "DeathChance": 1 // The likely-hood this character dies. Higher number = Greater chance.
    },
    "Player2": {
        "Name": "Player Two",
        "Nick": "Bar",
        "Gender": "f",
        "Icon": "ExampleBar",
        "DeathChance": 1
    }
}
```