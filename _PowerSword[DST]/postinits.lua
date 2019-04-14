-- -- Variables related to stategraphs:
-- local State = GLOBAL.State
-- local Action = GLOBAL.Action
-- local ActionHandler = GLOBAL.ActionHandler
-- local TimeEvent = GLOBAL.TimeEvent
-- local EventHandler = GLOBAL.EventHandler
-- local ACTIONS = GLOBAL.ACTIONS
-- local FRAMES = GLOBAL.FRAMES
-- local SpawnPrefab = GLOBAL.SpawnPrefab
-- -- other
-- local FOODGROUP = GLOBAL.FOODGROUP
-- local FOODTYPE = GLOBAL.FOODTYPE


-- 	local function DefaultChangeFoodPostInit(inst)
-- 		if GLOBAL.TheWorld.ismastersim then
-- 			inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.NORAWMEATS, FOODTYPE.NORAWMEATSMOD, FOODTYPE.VEGGIE, FOODTYPE.SEEDS, FOODTYPE.GENERIC})
-- 		end
-- 	end
-- 	AddPrefabPostInit("default", DefaultChangeFoodPostInit)
-- end

-- -- CONTAINERS:
-- local containers = GLOBAL.require("containers")
-- local oldwidgetsetup = containers.widgetsetup
-- _G=GLOBAL

-- mods=_G.rawget(_G,"mods")or(function()local m={}_G.rawset(_G,"mods",m)return m end)()
-- mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
-- containers.widgetsetup = function(container, prefab, ...)
--     if not prefab and container.inst.prefab == "freezereye" then
--         prefab = "treasurechest"
--     end
--     return oldwidgetsetup(container, prefab, ...)
-- end
 
-- local oldwidgetsetup2 = containers.widgetsetup
-- containers.widgetsetup = function(container, prefab, ...)
--     if not prefab and container.inst.prefab == "glommpack"  then
--         prefab = "backpack"
--     end
--     return oldwidgetsetup2(container, prefab, ...)
-- end