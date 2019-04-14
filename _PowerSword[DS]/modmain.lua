--[[

This mod shows how to load custom prefabs and assets so that they are usable
by the game.

--]]
-- The Assets list here in modmain.lua is used to alert the game to any textures
-- that you need to load that aren't part of a prefab. (The assets of a prefab
-- are listed within the prefab. Also use this to overwrite in-game textures.
Assets = {
	Asset("ANIM", MODROOT.."anim/ziiosword.zip"),
	Asset("ANIM", MODROOT.."anim/ziio_projectile.zip"),
	Asset("ANIM", MODROOT.."anim/swap_ziiosword.zip"),
	Asset("IMAGE", MODROOT.."images/inventoryimages/ziiosword.tex"),
	Asset("ATLAS", MODROOT.."images/inventoryimages/ziiosword.xml"),
	
	Asset("IMAGE", MODROOT.."images/ziiotab.tex"),
	Asset("ATLAS", MODROOT.."images/ziiotab.xml"),
}
-- The PrefabFiles list is the list of all the files in your <modname>/scripts/prefabs folder
-- that you want to load prefabs from
PrefabFiles = {
	"ziiosword",
	"ziio_projectile",
}

-- xxx

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe


-- the bar
STRINGS.TABS.ZIIOTABS = "Ziio Items"
count = 1
for _ in pairs(RECIPETABS) do count = count + 1 end
RECIPETABS["ZIIOTABS"] = {str = STRINGS.TABS.ZIIOTABS, sort = count, icon = "ziiotab.tex", icon_atlas = "images/ziiotab.xml"}

-- add recipe
function load() 
	local ziiosword = GLOBAL.Recipe( "ziiosword", { Ingredient("cutgrass", 1)} , RECIPETABS.ZIIOTABS, {SCIENCE = 0} )
    ziiosword.atlas = "images/inventoryimages/ziiosword.xml"
end

AddGamePostInit(load)









-- Import things we like into our mod's own global scope, so we don't have 
-- to type "GLOBAL." every time want to use them.
SpawnPrefab = GLOBAL.SpawnPrefab


AddSimPostInit(SimInit)


