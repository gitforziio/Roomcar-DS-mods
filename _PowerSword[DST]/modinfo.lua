name = "A powerful Sword"
description = "A powerful sword. Improved from Dev Tool."
author = "Roomcar"
version = "0.1"

forumthread = ""

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

--priority = 4

api_version_dst = 10
api_version = 6
-- optional (if it's the same mod for DST and single-player)
dst_compatible = true
--This lets clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = true
--This is basically the opposite; it specifies that this mod doesn't affect other players at all, and if set, won't mark your server as modded
client_only_mod = false
--This lets people search for servers with this mod by these tags
server_filter_tags = {"ziio", "item", "dev", "in development"}


icon_atlas = "ziiosword.xml"
icon = "ziiosword.tex"


configuration_options =
{
    {
        name = "hungermode",
        label = "Auto Feeder",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "healthmode",
        label = "Healer",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true,
    },
    {
        name = "sanitymode",
        label = "Very Dapper",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "tempmode",
        label = "Heater/Cooler",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "rangemode",
        label = "Long Ranged Weapon",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "protmode",
        label = "Build-in Prototyper",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "resmode",
        label = "Infinite Resources Supply",
        options =
        {
            {description = "Yes", data = true},
            {description = "No",  data = false},
        },
        default = true
    },
    {
        name = "recipemethod",
        label = "How To Recipe",
        options =
        {
            {description = "Easy", data = 1},
            {description = "Hard",  data = 2},
            {description = "Forbidden",  data = 3},
        },
        default = 1
    },
}