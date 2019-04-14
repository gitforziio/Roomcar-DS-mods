require "prefabutil"
require "recipe"
require "modutil"


local assets=
{
    Asset("ANIM", "anim/elfmodhat_wht.zip"),
    Asset("ATLAS", "images/inventoryimages.xml"),
    Asset("ATLAS", "images/inventoryimages/godhat.xml"),
}

local prefabs =
{
    "tornado",
}

-------------------------------------------------------------------------------

local lang = TUNING.ROOMCAR_GODHAT_LANG

local function ChangeV(zoomstep,mindist,maxdist,mindistpitch,maxdistpitch,distancetarget,gains,default)

    local camera = TheCamera
    zoomstep = zoomstep or camera.zoomstep
    mindist = mindist or camera.mindist
    maxdist = maxdist or camera.maxdist
    mindistpitch = mindistpitch or camera.mindistpitch
    maxdistpitch = maxdistpitch or camera.maxdistpitch
    distancetarget = distancetarget or camera.distancetarget
    
    camera.zoomstep = zoomstep
    camera.mindist = mindist
    camera.maxdist = maxdist
    camera.mindistpitch = mindistpitch
    camera.maxdistpitch = maxdistpitch
    --camera:SetDistance(math.ceil(mindist*2)-.1)
    camera.distancetarget = distancetarget
    
    if default then
        camera:SetDefault()
    end
end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function spawntornado(staff, target, pos)
    local tornado = SpawnPrefab("tornado")
    tornado.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(staff, target))
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end
end

local function giveitems(inst, data)
    if data.owner.components.inventory and data.recipe then
        for ik, iv in pairs(data.recipe.ingredients) do
            if not data.owner.components.inventory:Has(iv.type, iv.amount) then
                for i = 1, iv.amount do
                    local item = SpawnPrefab(iv.type)
                    data.owner.components.inventory:GiveItem(item)
                end
            end
        end
    end
end

local function PeriodicTaskContent(inst, owner)
    if (owner.components.health and
        owner.components.health.currenthealth < owner.components.health.maxhealth )then
        owner.components.health:SetPercent(1)
    end
    if (owner.components.sanity and
        owner.components.sanity.current < owner.components.sanity.max * 0.85 )then
        owner.components.sanity:SetPercent(1)
    end
    if (owner.components.hunger and
        owner.components.hunger.current < (owner.components.hunger.max * 0.85) )then
        owner.components.hunger:SetPercent(1)
    end


    owner.components.moisture:SetPercent(0)
    owner.components.temperature:SetTemperature(25)


    if (TheWorld:HasTag("cave") or TheWorld.state.isnight) then
        owner.components.playervision:ForceNightVision(true)
        owner.components.playervision:SetCustomCCTable("images/colour_cubes/purple_moon_cc.tex")
        if owner.components.talker ~= nil and inst.shouldsayNVon ~= nil and inst.shouldsayNVon then
            if lang == 1 then
                owner.components.talker:Say('夜视：开启')
            else
                owner.components.talker:Say('Night Vision: On')
            end
            inst.shouldsayNVon = false
            inst.shouldsayNVoff = true
        end
    else
        owner.components.playervision:ForceNightVision(false)
        owner.components.playervision:SetCustomCCTable(nil)
        if owner.components.talker ~= nil and inst.shouldsayNVoff ~= nil and inst.shouldsayNVoff then
            if lang == 1 then
                owner.components.talker:Say('夜视：关闭')
            else
                owner.components.talker:Say('Night Vision: Off')
            end
            inst.shouldsayNVon = true
            inst.shouldsayNVoff = false
        end
    end
end

local function onplay(inst, musician, instrument)
    musician.components.moisture:SetPercent(0)
    musician.components.temperature:SetTemperature(25)
end

local function taegetIsGodOrFollower(inst, god)
    local result = false
    if inst.components.combat.TargetIs(god) or inst.components.combat.IsRecentTarget(god) then
        result = true
    end
    -- if inst.components.combat.target ~= nil then
    --     local tgt =  inst.components.combat.target
    --     if tgt.components.follower ~= nil and tgt.components.follower.leader ~= nil and tgt.components.follower.leader == god then
    --         result = true
    --     end
    -- end
    return result
end

local function giveupAttackingGOD(inst, god)
    if inst.components.combat ~= nil and taegetIsGodOrFollower(inst, god) then
        inst.components.combat.laststartattacktime = 0
        inst.components.combat.DropTarget()
        inst.components.combat.GiveUp()
        inst.components.combat.StopTrackingTarget(inst.components.combat.target)
    end
end

local function onhear(inst, musician, instrument)
    if inst ~= musician and inst.components.combat ~= nil and inst.components.follower ~= nil and
        (TheNet:GetPVPEnabled() or not inst:HasTag("player")) and
        not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) and
        not (inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck()) then
        inst.task = inst:DoPeriodicTask(1, giveupAttackingGOD, nil, musician)
        -- giveupAttackingGOD(inst, musician)
        inst:RemoveTag("scarytoprey")
        inst:RemoveTag("monster")
        inst:RemoveTag("hostile")
        inst:RemoveTag("hound")
        if inst.AnimState ~= nil then
            inst.AnimState:SetMultColour(1, 0.8, 0.2, 1)
        end
        if inst.components.talker ~= nil then
            inst.components.talker:Say('GOD!GOD!GOD!GOD!')
        end
        -- if inst.components.sleeper ~= nil then
        --     inst.components.sleeper:AddSleepiness(10, 40)
        -- elseif inst.components.grogginess ~= nil then
        --     inst.components.grogginess:AddGrogginess(10, 40)
        -- else
        --     inst:PushEvent("knockedout")
        -- end
        if inst.components.follower ~= nil and musician.components.leader ~= nil then
            musician:PushEvent("makefriend")
            musician.components.leader:AddFollower(inst)
            if inst.components.follower.maxfollowtime ~= nil and not (inst.components.combat.TargetIs(musician) or inst.components.combat.IsRecentTarget(musician)) then
                inst.components.follower.maxfollowtime = inst.components.follower.maxfollowtime * 10
            else
                inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME * 10
            end
        end
    end
end

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_nightarmour")
end

local function OnAttacked(inst, data)
    print("OnAttacked")
    inst.components.combat:ShareTarget(data.attacker, 60, function(dude)
        return dude.components.combat ~= nil
            and dude.components.follower ~= nil
            and not dude.components.health:IsDead()
            -- and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
end

local function onequip(inst, owner)

    ---------- ---------- ---------- ----------

    if TheWorld ~= nil and TheWorld:HasTag("cave") then
        ChangeV(6, 10, 180, 25, 90, 80, nil, false)    --cave
    else
        ChangeV(6, 10, 180, 40, 60, 80, nil, false)    --forest
    end
    if lang == 1 then
        owner.components.talker:Say('我看得更远了！')
    else
        owner.components.talker:Say('I can see much farther now!')
    end

    -- owner.components.playervision:ForceNightVision(true)
    -- -- owner.components.playervision:SetCustomCCTable("images/colour_cubes/purple_moon_cc.tex")
    -- owner.components.playervision:SetCustomCCTable("images/colour_cubes/spring_day_cc.tex")

    ---------- ---------- ---------- ----------

    if TUNING.ROOMCAR_GODHAT_LIGHT then
        inst.Light:Enable(true)
    end

    if TUNING.ROOMCAR_GODHAT_GIVE then
        owner:ListenForEvent("cantbuild", giveitems)
    end

    ---------- ---------- ---------- ----------

    owner.AnimState:OverrideSymbol("swap_hat", "elfmodhat_wht", "swap_hat")
    owner.AnimState:Show("HAT")
    -- owner.AnimState:Show("HAT_HAIR")
    -- owner.AnimState:Hide("HAIR_NOHAT")
    -- owner.AnimState:Hide("HAIR")

    ---------- ---------- ---------- ----------

    PeriodicTaskContent(inst, owner)
    inst.task = inst:DoPeriodicTask(1, PeriodicTaskContent, nil, owner)

    ---------- ---------- ---------- ----------

    owner.components.moisture:SetPercent(0)
    owner.components.temperature:SetTemperature(25)

    ---------- ---------- ---------- ----------

    inst:ListenForEvent("blocked", OnBlocked, owner)
    owner:ListenForEvent("attacked", OnAttacked)

    ---------- ---------- ---------- ----------

    if owner.components.combat.damagemultiplier ~= nil then
        owner.components.combat.damagemultiplier = owner.components.combat.damagemultiplier + 10000
    end
    if owner.components.combat.attackrange ~= nil then
        owner.components.combat.attackrange = owner.components.combat.attackrange + 40
    end
    if owner.components.combat.hitrange ~= nil then
        owner.components.combat.hitrange = owner.components.combat.hitrange + 40
    end

    ---------- ---------- ---------- ----------

    -- if inst.components.fueled ~= nil then
    --     inst.components.fueled:StartConsuming()
    -- end

    ---------- ---------- ---------- ----------

    -- owner:PushEvent("stopfreezing")
    -- owner:PushEvent("stopoverheating")

    ---------- ---------- ---------- ----------

end

local function onunequip(inst, owner)

    ---------- ---------- ---------- ----------

    if TheWorld ~= nil and TheWorld:HasTag("cave") then
        ChangeV(4, 15, 35, 25, 40, 25, nil, false)    --cave
    else
        ChangeV(4, 15, 50, 30, 60, 30, nil, false)    --forest
    end
    owner.components.talker:Say("Ops.")

    -- owner.components.playervision:ForceNightVision(false)
    -- owner.components.playervision:SetCustomCCTable(nil)

    ---------- ---------- ---------- ----------

    if TUNING.ROOMCAR_GODHAT_LIGHT then
        inst.Light:Enable(false)
    end

    if TUNING.ROOMCAR_GODHAT_GIVE then
        owner:RemoveEventCallback("cantbuild", giveitems)
    end

    ---------- ---------- ---------- ----------

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    -- owner.AnimState:Hide("HAT_HAIR")
    -- owner.AnimState:Show("HAIR_NOHAT")
    -- owner.AnimState:Show("HAIR")

    ---------- ---------- ---------- ----------

    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end

    if TUNING.ROOMCAR_GODHAT_PUNISH then
        owner.components.hunger:DoDelta(- owner.components.hunger.max * 0.8)
        owner.components.sanity:DoDelta(- owner.components.sanity.max * 0.8)
        owner.components.health:DoDelta(- owner.components.health.maxhealth * 0.5)
    end

    ---------- ---------- ---------- ----------

    -- owner.components.builder:GiveAllRecipes()

    -- local materials = owner.components.builder:GetIngredients("critter_dragonling_builder")

    -- owner.components.inventory:GetItemByName(materials,2)

    -- owner.components.builder:MakeRecipe("critter_dragonling_builder", nil, nil, "dragonling_wyvern_builder", nil)

    -- owner.components.builder:UnlockRecipesForTech("ORPHANAGE")

    -- owner.components.builder:AddRecipe("critter_dragonling_builder")
    -- owner.components.builder:AddRecipe("critter_glomling_builder")
    -- owner.components.builder:AddRecipe("critter_kitten_builder")
    -- owner.components.builder:AddRecipe("critter_puppy_builder")
    -- owner.components.builder:AddRecipe("critter_lamb_builder")

    -- owner.components.builder:UnlockRecipe("critter_dragonling_builder")
    -- owner.components.builder:UnlockRecipe("critter_glomling_builder")
    -- owner.components.builder:UnlockRecipe("critter_kitten_builder")
    -- owner.components.builder:UnlockRecipe("critter_puppy_builder")
    -- owner.components.builder:UnlockRecipe("critter_lamb_builder")

    ---------- ---------- ---------- ----------

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    owner:RemoveEventCallback("attacked", OnAttacked)

    if (TheWorld:HasTag("cave") or TheWorld.state.isnight) then
        owner.components.playervision:ForceNightVision(false)
        owner.components.playervision:SetCustomCCTable(nil)
        if owner.components.talker ~= nil and inst.shouldsayNVoff ~= nil and inst.shouldsayNVoff then
            if lang == 1 then
                owner.components.talker:Say('夜视：丧失')
            else
                owner.components.talker:Say('Night Vision: Lost')
            end
            inst.shouldsayNVon = true
            inst.shouldsayNVoff = false
        end
    end

    ---------- ---------- ---------- ----------

    if owner.components.combat.damagemultiplier ~= nil then
        owner.components.combat.damagemultiplier = owner.components.combat.damagemultiplier - 10000
    end
    if owner.components.combat.attackrange ~= nil then
        owner.components.combat.attackrange = owner.components.combat.attackrange - 40
    end
    if owner.components.combat.hitrange ~= nil then
        owner.components.combat.hitrange = owner.components.combat.hitrange - 40
    end

    ---------- ---------- ---------- ----------

    -- if inst.components.fueled ~= nil then
    --     inst.components.fueled:StopConsuming()
    -- end

    ---------- ---------- ---------- ----------

    owner.components.temperature:SetTemp(25)

    ---------- ---------- ---------- ----------

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("elfmodhat_wht")
    inst.AnimState:SetBuild("elfmodhat_wht")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("flute")

    inst:AddTag("hat")
    inst:AddTag("umbrella")
    inst:AddTag("waterproofer") --waterproofer (from waterproofer component) added to pristine state for optimization
    -- inst:AddTag("nightvision")
    -- inst:AddTag("show_spoilage")

    inst:AddTag("prototyper")

    inst.MiniMapEntity:SetIcon("godhat.tex")

    inst.entity:SetPristine()

    inst.shouldsayNVon = true
    inst.shouldsayNVoff = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("prototyper")
    inst.components.prototyper.trees = {SCIENCE = 9, MAGIC = 9, ANCIENT = 9, SHADOW = 9, CARTOGRAPHY = 0, SCULPTING = 0, ORPHANAGE = 0,}

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/godhat.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("instrument")
    inst.components.instrument.range = 40
    inst.components.instrument:SetOnHeardFn(onhear)
    inst.components.instrument:SetOnPlayedFn(onplay)

    inst:AddComponent("tradable")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORRUINS*1000000, 1)

    inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
    inst.components.heater.heat = 25
    inst.components.heater.equippedheat = 25
    inst.components.heater.carriedheat = 25

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE*100)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(1)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.walkspeedmult = TUNING.ROOMCAR_GODHAT_WALKSPEED
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    if TUNING.ROOMCAR_GODHAT_LIGHT then
        local light = inst.entity:AddLight()
        inst.Light:Enable(true)
        inst.Light:SetRadius(20)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(0.99)
        inst.Light:SetColour(255/255,255/255,255/255)
    end

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = 100

    MakeHauntableLaunch(inst)

    return inst
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--local STRINGS=GLOBAL.STRINGS

STRINGS.NAMES.GODHAT                                     = "GOD's Hat"
STRINGS.RECIPE_DESC.GODHAT                               = "GOD's Hat."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.GODHAT               = "This is GOD's Hat!"
STRINGS.CHARACTERS.WX78.DESCRIBE.GODHAT                  = "=-!-=- GOD S HAT -=-!-="
STRINGS.CHARACTERS.WEBBER.DESCRIBE.GODHAT                = "~~ Nice hat from GOD, I LOVE IT! ~~"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.GODHAT                = ""
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.GODHAT              = ""
--STRINGS.CHARACTERS.WENDY.DESCRIBE.GODHAT                 = ""
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.GODHAT          = ""
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.GODHAT                = ""
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.GODHAT               = ""
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.GODHAT            = ""

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

return Prefab( "common/inventory/godhat", fn, assets)
