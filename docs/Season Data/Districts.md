# Districts

Districts are starting groups/alliances, with set amounts of characters, with characters being either randomized or manually set. 

Characters in the same district will not attack each other to start out, only betraying each other upon dissolution of alliances. (todo, figure out when this would be?)

## Editing

You can edit districts by either going to `SeasonData\Season#\districts.json`, or by using the script's District Manager

## Format

District Data is stored within a JSON file, explained below

Comments/Explanations are defined by `//`

```json
[
    { // District
        "Name": "District Name",
        "Members": [ // All the Character UIDs for the District
            "Member1",
            "Member2"
        ]
    },
    {
        "Name": "District Name",
        "Members": [
            "Member1",
            "Member2"
        ]
    }
]
```