local Vector3 = GLOBAL.Vector3
local require = GLOBAL.require

print("Loading Big Bag mod...")

--------------------------------------------------------------------------------------------------------------------------
-- [Prefab Files]

PrefabFiles = {
	"bigbag",
}

--------------------------------------------------------------------------------------------------------------------------
-- [Assets]

local assets=
{
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
-- [TUNING]

TUNING.ROOMCAR_BIGBAG_LANG = GetModConfigData("LANG")
TUNING.ROOMCAR_BIGBAG_GIVE = GetModConfigData("GIVE")
TUNING.ROOMCAR_BIGBAG_STACK = GetModConfigData("STACK")
TUNING.ROOMCAR_BIGBAG_FRESH = GetModConfigData("FRESH")
TUNING.ROOMCAR_BIGBAG_LIGHT = GetModConfigData("LIGHT")
TUNING.ROOMCAR_BIGBAG_RECIPE = GetModConfigData("RECIPE")
TUNING.ROOMCAR_BIGBAG_WALKSPEED = GetModConfigData("WALKSPEED")

--------------------------------------------------------------------------------------------------------------------------
-- [Miniap Icon]

AddMinimapAtlas("minimap/bigbag.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]

local Ingredient = GLOBAL.Ingredient

--------------------------------------------------------------------------------------------------------------------------
-- [Custom Recipe]

local rcp = RcpN
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_BIGBAG_RECIPE

local RcpPlus = {Ingredient("purplegem", 5)}

local RcpVC = {Ingredient("cutgrass", 1)}
local RcpC = {Ingredient("pigskin", 5)}
local RcpN = {Ingredient("goldnugget", 10), Ingredient("pigskin", 10)}
local RcpE = {Ingredient("goldnugget", 20), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 5)}
local RcpVE = {Ingredient("goldnugget", 40), Ingredient("pigskin", 10), Ingredient("nightmarefuel", 20)}

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

if TUNING.ROOMCAR_BIGBAG_GIVE then
    for _,v in ipairs(RcpPlus) do
        table.insert(rcp,v)
    end
end

local bigbag = AddRecipe("bigbag", -- name
rcp, -- ingredients Add more like so , {Ingredient("boards", 1), Ingredient("rope", 2), Ingredient("twigs", 1), etc}
GLOBAL.RECIPETABS.REFINE, -- tab ( FARM, WAR, DRESS etc)
tec, -- level (GLOBAL.TECH.NONE, GLOBAL.TECH.SCIENCE_ONE, etc)
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/bigbag.xml", -- atlas
"bigbag.tex") -- image
-- bigbag.min_spacing = 1

--------------------------------------------------------------------------------------------------------------------------
-- [[set container]]

local containers = require("containers")
local widgetsetup_Base = containers.widgetsetup or function() return true end

local containers = GLOBAL.require "containers"

local params = {}

params.bigbag =
{
    widget =
    {
        slotpos = {},
        animbank = nil,
        animbuild = nil,
        bgatlas = "images/bigbagbg.xml",
        bgimage = "bigbagbg.tex",
        pos = Vector3(-200,-60,0),
    },
    issidewidget = true,
    type = "pack",
}
for m = 0, 7 do
    local gridsize = 66
    local mis = 3.5*gridsize
    for n = 0, 7 do
        table.insert(params.bigbag.widget.slotpos, Vector3(m*gridsize - mis, n*gridsize - mis, 0))
    end
end

function params.bigbag.itemtestfn(container, item, slot)
    if item:HasTag("bigbag") then
        return false
    end
    return true
end


containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.bigbag.widget.slotpos ~= nil and #params.bigbag.widget.slotpos or 0)

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = data or params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    end
end

function containers.widgetsetup(container, prefab, data)
    local t = prefab or container.inst.prefab
    if t == "bigbag" then
        local t = params[t]
        if t ~= nil then
            for k, v in pairs(t) do
                container[k] = v
            end
            container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        end
    else
        return containers_widgetsetup(container, prefab)
    end
end

--------------------------------------------------------------------------------------------------------------------------

print("Big Bag mod DONE")
