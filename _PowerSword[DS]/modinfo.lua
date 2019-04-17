-- This information tells other players more about the mod
name = "_A_Powerful_Sword_"
description = "A powerful sword that have many usages."
author = "Roomcar"
version = "0.5.0"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
-- Example:
-- http://forums.kleientertainment.com/showthread.php?19505-Modders-Your-new-friend-at-Klei!
-- becomes
-- 19505-Modders-Your-new-friend-at-Klei!
forumthread = ""

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
porkland_compatible = true
hamlet_compatible = true

--priority = 4

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 6
-- api_version_dst = 10

-- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"


-- optional (if it's the same mod for DST and single-player)
dst_compatible = false
-- This lets clients know if they need to get the mod from the Steam Workshop to join the game
-- all_clients_require_mod = true
-- This is basically the opposite; it specifies that this mod doesn't affect other players at all, and if set, won't mark your server as modded
-- client_only_mod = false
-- This lets people search for servers with this mod by these tags
-- server_filter_tags = {"ziio", "item", "roomcar", "powerful sword"}




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
