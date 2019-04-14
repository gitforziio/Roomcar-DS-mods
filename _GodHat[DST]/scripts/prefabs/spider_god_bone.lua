local assets =
{
    Asset("ANIM", "anim/chester_eyebone.zip"),
    Asset("ANIM", "anim/chester_eyebone_build.zip"),
    Asset("ANIM", "anim/chester_eyebone_snow_build.zip"),
    Asset("ANIM", "anim/chester_eyebone_shadow_build.zip"),
    Asset("INV_IMAGE", "chester_eyebone"),
    Asset("INV_IMAGE", "chester_eyebone_closed"),
    Asset("INV_IMAGE", "chester_eyebone_closed_shadow"),
    Asset("INV_IMAGE", "chester_eyebone_closed_snow"),
    Asset("INV_IMAGE", "chester_eyebone_shadow"),
    Asset("INV_IMAGE", "chester_eyebone_snow"),
}

local SPAWN_DIST = 30

-- local function OnAttacked(inst, data)
--     inst.components.combat:ShareTarget(data.attacker, 60, function(dude)
--         return dude:HasTag("spider_god")
--             and not dude.components.health:IsDead()
--             and dude.components.follower ~= nil
--             -- and dude.components.follower.leader == inst.components.follower.leader
--     end, 10)
-- end

local function OpenEye(inst)
    if not inst.isOpenEye then
        inst.isOpenEye = true
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst.AnimState:PlayAnimation("idle_loop", true)
    end
end

local function CloseEye(inst)
    if inst.isOpenEye then
        inst.isOpenEye = nil
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
        inst.AnimState:PlayAnimation("dead", true)
    end
end

local function RefreshEye(inst)
    inst.components.inventoryitem:ChangeImageName(inst.isOpenEye and inst.openEye or inst.closedEye)
end

-- local function MorphShadowEyebone(inst)
--     inst.AnimState:SetBuild("chester_eyebone_shadow_build")

--     inst.openEye = "chester_eyebone_shadow"
--     inst.closedEye = "chester_eyebone_closed_shadow"
--     RefreshEye(inst)

--     inst.EyeboneState = "SHADOW"
-- end

-- local function MorphSnowEyebone(inst)
--     inst.AnimState:SetBuild("chester_eyebone_snow_build")

--     inst.openEye = "chester_eyebone_snow"
--     inst.closedEye = "chester_eyebone_closed_snow"
--     RefreshEye(inst)

--     inst.EyeboneState = "SNOW"
-- end

--[[
local function MorphNormalEyebone(inst)
    inst.AnimState:SetBuild("chester_eyebone_build")

    inst.openEye = "chester_eyebone"
    inst.closedEye = "chester_eyebone_closed"
    RefreshEye(inst)

    inst.EyeboneState = "NORMAL"
end
]]

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

-- local function ProtectLeader(chester, thebone)
--     if thebone.components.inventoryitem.owner ~= nil then
--         print("thebone has owner")
--         local master = thebone.components.inventoryitem.owner
--         if master.components.combat.lastattacker ~= nil then
--             print("thebone's owner get attacked")
--             local attacker = master.components.combat.lastattacker
--             chester.components.combat:SetTarget(attacker)
--         end
--     end
--     if chester.components.combat.target ~= nil then
--         print("ProtectLeader")
--         print(chester.components.combat.target)
--     end
-- end

local function SpawnChester(inst)
    --print("chester_eyebone - SpawnChester")

    local pt = inst:GetPosition()
    --print("    near", pt)

    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        --print("    at", spawn_pt)
        local chester = SpawnPrefab("spider_god")
        if chester ~= nil then
            chester.Physics:Teleport(spawn_pt:Get())
            chester:FacePoint(pt:Get())

            -- chester.task = chester:DoPeriodicTask(1, ProtectLeader, nil, thebone)

            return chester
        end

    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        print("chester_eyebone - SpawnChester: Couldn't find a suitable spawn point for chester")
    end
end

local StartRespawn

local function StopRespawn(inst)
    if inst.respawntask ~= nil then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindChester(inst, chester)
    chester = chester or TheSim:FindFirstEntityWithTag("spider_god")
    if chester ~= nil then
        OpenEye(inst)
        inst:ListenForEvent("death", function() StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME) end, chester)

        if chester.components.follower.leader ~= inst then
            chester.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnChester(inst)
    StopRespawn(inst)
    RebindChester(inst, TheSim:FindFirstEntityWithTag("spider_god") or SpawnChester(inst))
end

StartRespawn = function(inst, time)
    StopRespawn(inst)

    RespawnChester(inst)

    -- time = time or 0
    -- inst.respawntask = inst:DoTaskInTime(time, RespawnChester)
    -- inst.respawntime = GetTime() + time
    CloseEye(inst)
end

local function FixChester(inst)
    print("do fix")
    inst.fixtask = nil
    --take an existing chester if there is one
    if not RebindChester(inst) then
        CloseEye(inst)
        
        if inst.components.inventoryitem.owner ~= nil then
            local time_remaining = inst.respawntime ~= nil and math.max(0, inst.respawntime - GetTime()) or 0
            StartRespawn(inst, time_remaining)
        end
    end
end

local function OnPutInInventory(inst)
    if inst.fixtask == nil then
        inst.fixtask = inst:DoTaskInTime(1, FixChester)
    end
    -- if inst.owner ~= nil then
    --     inst.owner:ListenForEvent("attacked", OnAttacked)
    -- end
end

local function OnSave(inst, data)
    data.EyeboneState = inst.EyeboneState
    if inst.respawntime ~= nil then
        local time = GetTime()
        if inst.respawntime > time then
            data.respawntimeremaining = inst.respawntime - time
        end
    end
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end

    -- if data.EyeboneState == "SHADOW" then
    --     MorphShadowEyebone(inst)
    -- elseif data.EyeboneState == "SNOW" then
    --     MorphSnowEyebone(inst)
    -- end

    if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining + GetTime()
    else
        OpenEye(inst)
    end
end

local function GetStatus(inst)
    return inst.respawntask ~= nil and "WAITING" or nil
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("chester_eyebone")
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")

    inst.AnimState:SetBank("eyebone")
    inst.AnimState:SetBuild("chester_eyebone_build")
    inst.AnimState:PlayAnimation("dead", true)
    inst.AnimState:SetMultColour(255/255, 255/255, 0/255, 1)

    inst.entity:SetPristine() -- means this is a new thing.

    if not TheWorld.ismastersim then
        return inst
    end

    inst.EyeboneState = "NORMAL"
    inst.openEye = "chester_eyebone"
    inst.closedEye = "chester_eyebone_closed"
    inst.isOpenEye = nil

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem:ChangeImageName(inst.closedEye)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    MakeHauntableLaunch(inst)

    --inst.MorphNormalEyebone = MorphNormalEyebone
    -- inst.MorphSnowEyebone = MorphSnowEyebone
    -- inst.MorphShadowEyebone = MorphShadowEyebone

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.fixtask = inst:DoTaskInTime(1, FixChester)

    return inst
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--local STRINGS=GLOBAL.STRINGS

STRINGS.NAMES.SPIDER_GOD_BONE                                     = "SPIDER_GOD_BONE"
STRINGS.RECIPE_DESC.SPIDER_GOD_BONE                               = "SPIDER_GOD_BONE"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPIDER_GOD_BONE               = "SPIDER_GOD_BONE"
STRINGS.CHARACTERS.WX78.DESCRIBE.SPIDER_GOD_BONE                  = "=-!-=- SPIDER_GOD_BONE -=-!-="
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SPIDER_GOD_BONE                = "SPIDER_GOD_BONE"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.SPIDER_GOD_BONE                = ""
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SPIDER_GOD_BONE              = ""
--STRINGS.CHARACTERS.WENDY.DESCRIBE.SPIDER_GOD_BONE                 = ""
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SPIDER_GOD_BONE          = ""
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.SPIDER_GOD_BONE                = ""
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SPIDER_GOD_BONE               = ""
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SPIDER_GOD_BONE            = ""

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

return Prefab("common/inventory/spider_god_bone", fn, assets)
