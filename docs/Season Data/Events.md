# Events

Events are what happens to characters throughout the simulation. Currently, these are all defined via `events.json`

## Editing

You can edit districts by going to `SeasonData\Season#\events.json`. There is currently no user-interface method to edit events.

## Format

Event Data is stored within a JSON file, explained below

Event Types:
- Bloodbath
- Day
- Night
- Feast
- Arena
- Event

Event Tags:
- t_Char# // *# = char number*
- t_RandChar // *A random character participating in the event*
- t_Item // *Random Item as defined by `items.json`
- t_Retreat // *A chance for a character to retreat, if they do, they change location, if any*

// *Results are defined by last character tag used*
Event Results:
- r_ItemObtained // *Character gains item*
- r_Death // *Guarunteed death*
- r_Retreat // *Guarunteed retreat*

Comments/Explanations are defined by `//`

```json
{
    "Bloodbath": { // the type of events
        "1": [ // number of characters within this event
            [
                "t_Char1", // Character 1 in the event
                ["grabs a", "grabs a", "grabs a", "grab a"], // Pronouns, M, F, NB, P
                "t_Item", // Random Item
                "t_Retreat", // Chance to retreat
                "r_ItemObtained" // Character gets the item
            ],
            [
                "t_Char1",
                ["attempts to", "attempts to", "attempts to", "attempt to"],
                "grab a",
                "t_Item",
                "but fatally",
                ["gets injured", "gets injured", "gets injured", "get injured"],
                "as a result",
                "r_Death" // Character dies as a result
            ]
        ],
        "2": [
            [
                "t_Char1",
                "and",
                "t_Char2",
                "fight for a",
                "t_Item",
                ".",
                "t_RANDCHAR", // Decides randomly which character the following tags should apply to
                ["gives up","gives up","gives up","give up"],
                "t_Retreat",
                "r_ItemObtained" // the remaining character obtains the item
            ],
            [
                "t_Char1",
                "and",
                "t_Char2",
                "fight for a",
                "t_Item",
                ".",
                "t_RANDCHAR",
                ["dies","dies","dies","die"],
                "from the fight.",
                "r_Death", // Rand character dies
                "r_ItemObtained"
            ]
        ]
    }
}
```