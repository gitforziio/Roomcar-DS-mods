local assets =
{
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/spider_build.zip"),
    Asset("SOUND", "sound/spider.fsb"),
    Asset("ANIM", "anim/ghost_wx78_build.zip"),
    Asset("ANIM", "anim/wx78.zip"),
    Asset("SOUND", "sound/wx78.fsb"),

    -- Asset("MINIMAP_IMAGE", "wx78"),
}

-- local warrior_assets =
-- {
--     Asset("ANIM", "anim/ds_spider_basic.zip"),
--     Asset("ANIM", "anim/ds_spider_warrior.zip"),
--     Asset("ANIM", "anim/spider_warrior_build.zip"),
--     Asset("SOUND", "sound/spider.fsb"),
-- }

local prefabs =
{
    "monstermeat",
    -- "spidergland",
    -- "silk",
}

local brain = require "brains/spider_godbrain"

-- local function ondonetalking(inst)
--     inst.localsounds.SoundEmitter:KillSound("talk")
-- end

-- local function ontalk(inst)
--     local sound = inst.lucy_classified ~= nil and inst.lucy_classified:GetTalkSound() or nil
--     if sound ~= nil then
--         inst.localsounds.SoundEmitter:KillSound("talk")
--         inst.localsounds.SoundEmitter:PlaySound(sound)
--     elseif not inst.localsounds.SoundEmitter:PlayingSound("talk") then
--         inst.localsounds.SoundEmitter:PlaySound("dontstarve/characters/woodie/lucytalk_LP", "talk")
--     end
-- end

-- local TALLER_TALKER_OFFSET = Vector3(0, -700, 0)
-- local DEFAULT_TALKER_OFFSET = Vector3(0, -400, 0)
-- local function GetTalkerOffset(inst)
--     local rider = inst.replica.rider
--     return (rider ~= nil and rider:IsRiding() or inst:HasTag("playerghost"))
--         and TALLER_TALKER_OFFSET
--         or DEFAULT_TALKER_OFFSET
-- end

local function OnStopFollowing(inst)
    inst:RemoveTag("companion")
    inst.components.talker:Say("Bye")
end

local function OnStartFollowing(inst)
    inst:AddTag("companion")
    inst.components.talker:Say("Hello")
end

local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return inst.components.combat:CanTarget(guy) and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "hound", "monster" },--musttags
        { "INLIMBO", "character" }--,canttags--{ "monster", "INLIMBO" }--mustoneoftags
    )
end

local function RetargetFn(inst)
    -- return FindTarget(inst, inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
    return FindTarget(inst, 10)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

-- local function SummonFriends(inst, attacker)
--     local den = GetClosestInstWithTag("spiderden", inst, SpringCombatMod(TUNING.SPIDER_SUMMON_WARRIORS_RADIUS))
--     if den ~= nil and den.components.combat ~= nil and den.components.combat.onhitfn ~= nil then
--         den.components.combat.onhitfn(den, attacker)
--     end
-- end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("spider")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            -- and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
    inst.components.talker:Say("I Am Attacked")
end

local function ProtectLeader(chester)
    if chester.components.follower.leader ~= nil then
        local thebone = chester.components.follower.leader
        -- chester.components.talker:Say("thebone found")
        if thebone.components.inventoryitem ~= nil and thebone.components.inventoryitem.owner ~= nil then
            -- chester.components.talker:Say("thebone has owner")
            local master = thebone.components.inventoryitem.owner
            if master.components.combat ~= nil and master.components.combat.lastattacker ~= nil then
                local attacker = master.components.combat.lastattacker
                chester.components.combat:SetTarget(attacker)
                if attacker.components.health ~= nil and not attacker.components.health:IsDead() then
                    chester.components.talker:Say("Protect My Lord")
                end
            -- elseif master.components.combat.lasttarget ~= nil then
            --     chester.components.talker:Say("thebone's owner has target")
            --     local target = master.components.combat.lasttarget
            --     chester.components.combat:SetTarget(target)
            -- else
            --     chester.components.talker:Say("thebone's owner not attacked")
            end
        -- else
        --     chester.components.talker:Say("thebone lost owner")
        end
    -- else
    --     chester.components.talker:Say("thebone miss")
    end
end

local function GetSandstormLevel(inst)
    return inst.player_classified ~= nil and inst.player_classified.sandstormlevel:value() / 7 or 0
end

local function create_spider_god()
    local inst = CreateEntity()

    inst.GetSandstormLevel = GetSandstormLevel -- Didn't want to make stormwatcher a networked component

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(0.6,0.6,0.6)

    inst:AddTag("cavedweller")
    inst:AddTag("spider_god")

    --trader (from trader component) added to pristine state for optimization
    -- inst:AddTag("trader")
    
    inst:AddTag("_named")

    inst.MiniMapEntity:SetIcon("wx78.png")
    inst.MiniMapEntity:SetCanUseCache(false)

    inst.AnimState:SetBank("chester")
    inst.AnimState:SetBuild("chester_build")

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wx78")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(255/255, 255/255, 0/255, 1)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(255/255, 255/255, 0/255)
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()
    -- inst.components.talker:SetOffsetFn(GetTalkerOffset)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ----------
    -- inst.OnEntitySleep = OnEntitySleep

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }

    --------

    inst:AddComponent("rider")
    inst:AddComponent("inventory")
    inst:AddComponent("playervision")

    --------

    -- inst:SetStateGraph("SGwilson_client")
    inst:SetStateGraph("SGshadowwaxwell")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
    -- inst.components.lootdropper:AddRandomLoot("silk", .5)
    -- inst.components.lootdropper:AddRandomLoot("spidergland", .5)
    -- inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
    inst.components.lootdropper.numrandomloot = 1

    ---------------------        
    -- MakeMediumBurnableCharacter(inst, "body")
    -- MakeMediumFreezableCharacter(inst, "body")
    -- inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    -- inst.components.combat:SetOnHit(SummonFriends)
    inst.components.combat:SetDefaultDamage(500)
    inst.components.combat:SetAttackPeriod(0.5)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)

    inst:AddComponent("follower")
    -- inst.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    ------------------

    -- inst:AddComponent("sleeper")
    -- inst.components.sleeper:SetResistance(2)
    -- inst.components.sleeper:SetSleepTest(ShouldSleep)
    -- inst.components.sleeper:SetWakeTest(ShouldWake)

    ------------------

    inst:AddComponent("knownlocations")

    ------------------

    -- inst:AddComponent("eater")
    -- inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    -- inst.components.eater:SetCanEatHorrible()
    -- inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    inst:AddComponent("inspectable")

    ------------------

    -- inst:AddComponent("trader")
    -- inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    -- inst.components.trader.onaccept = OnGetItemFromPlayer
    -- inst.components.trader.onrefuse = OnRefuseItem

    ------------------

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("shadowchester")
    -- inst.components.container.onopenfn = OnOpen
    -- inst.components.container.onclosefn = OnClose

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = 60

    MakeHauntablePanic(inst)

    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    inst.task = inst:DoPeriodicTask(1, ProtectLeader, nil)

    -- inst:WatchWorldState("iscaveday", OnIsCaveDay)
    -- OnIsCaveDay(inst, TheWorld.state.iscaveday)

    ------------------

    inst.components.health:SetMaxHealth(100000)

    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 12

    return inst
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--local STRINGS=GLOBAL.STRINGS

STRINGS.NAMES.SPIDER_GOD                                     = "SPIDER_GOD"
STRINGS.RECIPE_DESC.SPIDER_GOD                               = "SPIDER_GOD"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPIDER_GOD               = "SPIDER_GOD"
STRINGS.CHARACTERS.WX78.DESCRIBE.SPIDER_GOD                  = "=-!-=- SPIDER_GOD -=-!-="
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SPIDER_GOD                = "SPIDER_GOD"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.SPIDER_GOD                = ""
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SPIDER_GOD              = ""
--STRINGS.CHARACTERS.wx78.DESCRIBE.SPIDER_GOD                 = ""
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SPIDER_GOD          = ""
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.SPIDER_GOD                = ""
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SPIDER_GOD               = ""
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SPIDER_GOD            = ""

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

return Prefab("spider_god", create_spider_god, assets, prefabs)
