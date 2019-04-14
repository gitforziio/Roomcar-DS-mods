require "prefabutil"
require "recipe"
require "modutil"

local assets=
{
    Asset("ANIM", "anim/ziiosword.zip"),
    Asset("ANIM", "anim/swap_ziiosword.zip"),
    Asset("IMAGE", "images/inventoryimages/ziiosword.tex"),
    Asset("ATLAS", "images/inventoryimages/ziiosword.xml"),
}

-- local hungermode = TUNING.ZIIOSWORDFUNCTION.HUNGER
-- local healthmode = TUNING.ZIIOSWORDFUNCTION.HEALTH
-- local sanitymode = TUNING.ZIIOSWORDFUNCTION.SANITY
-- local tempmode   = TUNING.ZIIOSWORDFUNCTION.TEMP
-- local rangemode  = TUNING.ZIIOSWORDFUNCTION.RANGE
-- local protmode   = TUNING.ZIIOSWORDFUNCTION.PROT
-- local resmode    = TUNING.ZIIOSWORDFUNCTION.RES

local hungermode = true
local healthmode = true
local sanitymode = true
local tempmode   = true
local rangemode  = true
local protmode   = true
local resmode    = true

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

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_ziiosword", "swap_nightmaresword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    inst.Light:Enable(true)
    inst.task = inst:DoPeriodicTask(5, function() 
        if owner.components.health and healthmode then
            owner.components.health:DoDelta(250)
        end
        if owner.components.hunger and hungermode then
            owner.components.hunger:DoDelta(5)
        end
        if owner.components.sanity and sanitymode then
            owner.components.sanity:DoDelta(10)
        end
        if owner.components.temperature and tempmode then
            owner.components.temperature:SetTemperature(30)
        end
        if owner.components.moisture and tempmode then
            owner.components.moisture:SetPercent(0)
        end
    end)
    if resmode then owner:ListenForEvent("cantbuild", giveitems) end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.Light:Enable(false)
    if inst.task then
        inst.task:Cancel()
        inst.task = nil
    end
    if resmode then owner:RemoveEventCallback("cantbuild", giveitems) end
end

local function onattack(inst, owner, target)
    owner.components.hunger:DoDelta(-1)
    owner.components.sanity:DoDelta(-1)
    owner.components.health:DoDelta(-1)
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "ziiosword.tex" )
    
    local light = inst.entity:AddLight()
    inst.Light:SetRadius(10)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.95)
    inst.Light:SetColour(255/255,255/255,255/255)
    
    inst.AnimState:SetBank("nightmaresword")
    inst.AnimState:SetBuild("ziiosword")
    inst.AnimState:PlayAnimation("idle")
    -- inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("ziio")
    inst:AddTag("ziiosword")
    inst:AddTag("sharp")
    inst:AddTag("umbrella")
    inst:AddTag("waterproofer")
    
    if protmode then
        inst:AddTag("prototyper")
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()
    
    if protmode then
        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = {SCIENCE = 9, MAGIC = 9, ANCIENT = 9, SHADOW = 9, CARTOGRAPHY = 0, SCULPTING = 9, ORPHANAGE = 0,}
    end

    -- if sanitymode then
    --     inst:AddComponent("dapperness")
    --     inst.components.equippable.dapperness = math.huge
    --     inst.components.dapperness.dapperness = math.huge
    --     inst.components.dapperness.mitigates_rain = true
    -- end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ziiosword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.walkspeedmult = 2.25,
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(9999999)
    if rangemode then inst.components.weapon:SetRange(10,20) end
    inst.components.weapon:SetOnAttack(onattack)
    -- inst.components.weapon:SetProjectile("ziio_projectile")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP,   100)
    inst.components.tool:SetAction(ACTIONS.MINE,   100)
    inst.components.tool:SetAction(ACTIONS.HAMMER, 100)
    inst.components.tool:SetAction(ACTIONS.DIG,    100)
    inst.components.tool:SetAction(ACTIONS.NET,    100)

    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(1,3)
    inst.components.fishingrod:SetStrainTimes(0,10)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(1)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = 100 --TUNING.SANITYAURA_HUGE

    inst:AddComponent("blinkstaff")

    MakeHauntableWork(inst)
    
    return inst
end

return Prefab( "common/inventory/ziiosword", fn, assets) 
