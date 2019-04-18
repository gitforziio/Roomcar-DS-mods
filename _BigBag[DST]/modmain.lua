local Vector3 = GLOBAL.Vector3
local require = GLOBAL.require

print("    BIGBAG    MOD Loading")

--------------------------------------------------------------------------------------------------------------------------
-- [Prefab Files]
--------------------

PrefabFiles = {
	"bigbag",
}

--------------------------------------------------------------------------------------------------------------------------
-- [Assets]
--------------------

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
--------------------

TUNING.ROOMCAR_BIGBAG_LANG = GetModConfigData("LANG")
TUNING.ROOMCAR_BIGBAG_GIVE = GetModConfigData("GIVE")
TUNING.ROOMCAR_BIGBAG_STACK = GetModConfigData("STACK")
TUNING.ROOMCAR_BIGBAG_FRESH = GetModConfigData("FRESH")
TUNING.ROOMCAR_BIGBAG_LIGHT = GetModConfigData("LIGHT")
TUNING.ROOMCAR_BIGBAG_RECIPE = GetModConfigData("RECIPE")
TUNING.ROOMCAR_BIGBAG_WALKSPEED = GetModConfigData("WALKSPEED")

--------------------------------------------------------------------------------------------------------------------------
-- [Miniap Icon]
--------------------

AddMinimapAtlas("minimap/bigbag.xml")

--------------------------------------------------------------------------------------------------------------------------
-- [Global Strings]
--------------------

local Ingredient = GLOBAL.Ingredient

--------------------------------------------------------------------------------------------------------------------------
-- [Custom Recipe]
--------------------

local rcp = RcpN
local tec = GLOBAL.TECH.NONE
local RcpType = TUNING.ROOMCAR_BIGBAG_RECIPE

local RcpPlus = {Ingredient("purplegem", 1)}

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

if TUNING.ROOMCAR_BIGBAG_FRESH and TUNING.ROOMCAR_BIGBAG_STACK then
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
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------





--------------------------------------------------------------------------------------------------------------------------
-- [[set container]]
--------------------

--------------------------------------------------------------------------

-- 这两句抄自 containers.lua 开头。

-- 准备一个params结构放置bigbag的信息。
local params = {}
-- 在 containers.lua 中是“local containers = { MAXITEMSLOTS = 0 }”
-- 但我们直接引入了 containers，所以不需要再写这条了。
local containers = require("containers")

--------------------

-- 备份原本的 containers.widgetsetup （后面又有了，冗余了）
-- local widgetsetup_Base = containers.widgetsetup or function() return true end

--------------------

-- 应该是冗余的： local containers = GLOBAL.require "containers"

--------------------

-- -- 这段是原始的containers的widgetsetup，供参考，冗余。

-- function containers.widgetsetup(container, prefab, data)
--     local t = data or params[prefab or container.inst.prefab]
--     if t ~= nil then
--         for k, v in pairs(t) do
--             container[k] = v
--         end
--         container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
--     end
-- end

--------------------

-- 备份原本的 containers.widgetsetup（“or”后面的大概是保险的冗余的写法）
local containers_widgetsetup = containers.widgetsetup or function() return true end

--------------------

-- 替代原有的 containers.widgetsetup 函数

function containers.widgetsetup(container, prefab, data, ...)
    local tt = prefab or container.inst.prefab
    if tt == "bigbag" then
        -- 针对bigbag做特殊处理（其实并不特殊，可能是我在别的mod里抄来的）
        local t = params[tt]
        if t ~= nil then
            for k, v in pairs(t) do
                container[k] = v
            end
            container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        end
    else
        -- 针对非bigbag的容器，用原始的函数来处理
        return containers_widgetsetup(container, prefab, data, ...)
    end
end

--------------------------------------------------------------------------

-- 依次设置mod中新增的各个容器
-- 假装有很多个容器要处理

--------------------------------------------------------------------------
--[[ bigbag ]]
--------------------------------------------------------------------------

-- 基本设定

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

-- 格子设定

for m = 0, 7 do
    local gridsize = 66
    local mis = 3.5*gridsize
    for n = 0, 7 do
        table.insert(params.bigbag.widget.slotpos, Vector3(m*gridsize - mis, n*gridsize - mis, 0))
    end
end

-- 放入时检测设定

function params.bigbag.itemtestfn(container, item, slot)
    if item:HasTag("bigbag") then
        return false
    end
    return true
end

--------------------------------------------------------------------------
--[[ 假装这儿有另一个容器 ]]
--------------------------------------------------------------------------

-- -- here should be code for another container

--------------------------------------------------------------------------

-- 计算所有容器的最大容量（针对mod中的单个容器bigbag用，其实不太鲁棒，建议换成下面的）
-- containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.bigbag.widget.slotpos ~= nil and #params.bigbag.widget.slotpos or 0)

-- 计算所有容器的最大容量（mod中有多个容器时用，抄自 containers.lua）
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

--------------------------------------------------------------------------

-- 此处，containers.lua中还有一句“return containers”，
-- 但MOD不需要这样做吧。

--------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------

print("    BIGBAG    MOD DONE")
