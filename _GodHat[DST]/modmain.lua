local require = GLOBAL.require

print("Loading GOD Hat mod...")

--------------------------------------------------------------------------------------------------------------------------
-- [Prefab Files]

PrefabFiles = {
    "spider_god",
    "spider_god_bone",
    "godhat",
}

--------------------------------------------------------------------------------------------------------------------------
-- [Assets]

local assets=
{
    Asset("ANIM", "anim/elfmodhat_wht.zip"),
    -- Asset("ANIM", "anim/hat_winter.zip"),
    -- Asset("ATLAS", "images/inventoryimages.xml"),
    Asset("IMAGE", "images/inventoryimages.tex"),
    Asset("ATLAS", "images/inventoryimages/godhat.xml"),
    -- Asset("IMAGE", "minimap/minimap_atlas.tex"),
    -- Asset("ATLAS", "minimap/minimap_data.xml"),
}

--------------------------------------------------------------------------------------------------------------------------
-- [TUNING]

TUNING.ROOMCAR_GODHAT_LANG = GetModConfigData("LANG")
TUNING.ROOMCAR_GODHAT_GIVE = GetModConfigData("GIVE")
TUNING.ROOMCAR_GODHAT_STACK = GetModConfigData("STACK")
TUNING.ROOMCAR_GODHAT_FRESH = GetModConfigData("FRESH")
TUNING.ROOMCAR_GODHAT_LIGHT = GetModConfigData("LIGHT")
TUNING.ROOMCAR_GODHAT_RECIPE = GetModConfigData("RECIPE")
TUNING.ROOMCAR_GODHAT_PUNISH = GetModConfigData("PUNISH")
TUNING.ROOMCAR_GODHAT_WALKSPEED = GetModConfigData("WALKSPEED")

--------------------------------------------------------------------------------------------------------------------------
-- [Miniap Icon]

-- AddMinimapAtlas("minimap/godhat.xml")

-- AddMinimapAtlas("minimap/minimap_data.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]

local Ingredient = GLOBAL.Ingredient

--------------------------------------------------------------------------------------------------------------------------
-- [Custom Recipe]

local rcp = RcpN
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_GODHAT_RECIPE

local RcpVC = {Ingredient("cutgrass", 1)}
local RcpC = {Ingredient("goldnugget", 5)}
local RcpN = {Ingredient("goldnugget", 10), Ingredient("nightmarefuel", 5)}
local RcpE = {Ingredient("purplegem", 2), Ingredient("goldnugget", 10), Ingredient("nightmarefuel", 10)}
local RcpVE = {Ingredient("purplegem", 6), Ingredient("goldnugget", 50), Ingredient("nightmarefuel", 20)}

if RcpType == 1 then
    rcp = RcpVC
    tec = GLOBAL.TECH.NONE
elseif  RcpType == 2 then
    rcp = RcpC
    tec = GLOBAL.TECH.SCIENCE_ONE
elseif  RcpType == 3 then
    rcp = RcpN
    tec = GLOBAL.TECH.SCIENCE_TWO
elseif  RcpType == 4 then
    rcp = RcpE
    tec = GLOBAL.TECH.MAGIC_ONE
elseif  RcpType == 5 then
    rcp = RcpVE
    tec = GLOBAL.TECH.MAGIC_TWO
end

local godhat = AddRecipe("godhat", -- name
rcp, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/godhat.xml", -- atlas
"godhat.tex" -- image
)

local godhat = AddRecipe("spider_god_bone", -- name
rcp, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages.xml", -- atlas
"chester_eyebone_shadow.tex" -- image
)

--------------------------------------------------------------------------------------------------------------------------

print("GOD Hat mod DONE")
