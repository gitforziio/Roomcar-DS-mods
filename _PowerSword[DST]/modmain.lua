local TUNING = GLOBAL.TUNING

local require = GLOBAL.require
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH

PrefabFiles = {
    "ziiosword",--"ziio_projectile",
}

-- TUNING.ZIIOSWORDFUNCTION = {}
-- TUNING.ZIIOSWORDFUNCTION.HUNGER = GetModConfigData("hungermode")
-- TUNING.ZIIOSWORDFUNCTION.HEALTH = GetModConfigData("healthmode")
-- TUNING.ZIIOSWORDFUNCTION.SANITY = GetModConfigData("sanitymode")
-- TUNING.ZIIOSWORDFUNCTION.TEMP   = GetModConfigData("tempmode")
-- TUNING.ZIIOSWORDFUNCTION.RANGE  = GetModConfigData("rangemode")
-- TUNING.ZIIOSWORDFUNCTION.PROT   = GetModConfigData("protmode")
-- TUNING.ZIIOSWORDFUNCTION.RES    = GetModConfigData("resmode")
-- TUNING.ZiioRecipeType = GetModConfigData("recipemethod")

Assets = {
    Asset("ANIM", "anim/ziiosword.zip"),
    --Asset("ANIM", "anim/ziio_projectile.zip"),
    Asset("ANIM", "anim/swap_ziiosword.zip"),
    Asset("IMAGE", "images/inventoryimages/ziiosword.tex"),
    Asset("ATLAS", "images/inventoryimages/ziiosword.xml"),
    Asset("IMAGE", "images/ziiotab.tex"),
    Asset("ATLAS", "images/ziiotab.xml"),
}

--RECIPETABS.ZIIOWORKS = AddRecipeTab("ZiioWorks", 956, "images/ziiotab.xml", "ziiotab.tex", "ziioworker")

modimport("strings.lua")
modimport("recipes.lua")
modimport("postinits.lua")

AddMinimapAtlas("images/inventoryimages/ziiosword.xml")
