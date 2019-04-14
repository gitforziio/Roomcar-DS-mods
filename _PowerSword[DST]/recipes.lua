local TUNING = GLOBAL.TUNING
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

-------------------------:Mod Recipes:-------------------------


-- TUNING.ZiioRecipeType = GetModConfigData("recipemethod")

-- if TUNING.ZiioRecipeType == 1

AddRecipe("ziiosword", -- name
{Ingredient("cutgrass", 1)}, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
RECIPETABS.TOOLS, -- tab ( ZIIOWORKS, FARM, WAR, DRESS etc)
TECH.NONE, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/ziiosword.xml", -- "images/inventoryimages/bigbag.xml", -- atlas
"ziiosword.tex" -- image

)
-- elseif TUNING.ZiioRecipeType == 2
-- AddRecipe("ziiosword", -- name
-- {Ingredient("cutgrass", 9999)}, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
-- RECIPETABS.TOOLS, -- tab ( ZIIOWORKS, FARM, WAR, DRESS etc)
-- TECH.NONE, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
-- nil, -- placer
-- nil, -- min_spacing
-- nil, -- nounlock
-- nil, -- numtogive
-- nil, -- builder_tag
-- "images/inventoryimages/ziiosword.xml", -- "images/inventoryimages/bigbag.xml", -- atlas
-- "ziiosword.tex" -- image
-- )
-- else
-- AddRecipe("ziiosword", -- name
-- {Ingredient("cutgrass", 9999999)}, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
-- RECIPETABS.TOOLS, -- tab ( ZIIOWORKS, FARM, WAR, DRESS etc)
-- TECH.NONE, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
-- nil, -- placer
-- nil, -- min_spacing
-- nil, -- nounlock
-- nil, -- numtogive
-- "ziioworker", -- builder_tag
-- "images/inventoryimages/ziiosword.xml", -- "images/inventoryimages/bigbag.xml", -- atlas
-- "ziiosword.tex" -- image
-- )
-- end

