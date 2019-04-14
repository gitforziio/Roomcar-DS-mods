
print("Loading Big Bag mod...")

--------------------------------------------------------------------------------------------------------------------------
-- [Prefab Files]

PrefabFiles =
{
	"bigbag",
}

--------------------------------------------------------------------------------------------------------------------------
-- [Assets]

Assets = {

	Asset("ANIM", "anim/swap_bigbag.zip"),

	Asset("IMAGE", "images/inventoryimages/bigbag.tex"),
	Asset("ATLAS", "images/inventoryimages/bigbag.xml"),

	-- Asset("IMAGE", "images/bigbag.tex"),
	-- Asset("ATLAS", "images/bigbag.xml"),

	Asset("IMAGE", "minimap/bigbag.tex"),
	Asset("ATLAS", "minimap/bigbag.xml"),

	Asset("IMAGE", "images/bigbagbg.tex"),
	Asset("ATLAS", "images/bigbagbg.xml"),
}

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe

--------------------------------------------------------------------------------------------------------------------------
-- [Miniap Icon]

AddMinimapAtlas("minimap/bigbag.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Strings]

STRINGS.NAMES.BIGBAG = "Big Bag"
STRINGS.RECIPE_DESC.BIGBAG = "A really big bag."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGBAG = "This bag is really big!"
STRINGS.CHARACTERS.WX78.DESCRIBE.BIGBAG = "BIG BAG"

--------------------------------------------------------------------------------------------------------------------------
-- [Custom Recipe]

local function load()
	local bigbag = GLOBAL.Recipe( "bigbag", {Ingredient("cutgrass", 1)}, RECIPETABS.REFINE, {SCIENCE = 0} )
	bigbag.atlas = "images/inventoryimages/bigbag.xml"
end

AddGamePostInit(load)

--------------------------------------------------------------------------------------------------------------------------

