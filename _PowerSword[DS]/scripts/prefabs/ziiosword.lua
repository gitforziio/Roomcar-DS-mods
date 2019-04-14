local assets=
{
    Asset("ANIM", "anim/ziiosword.zip"),
    Asset("ANIM", "anim/swap_ziiosword.zip"),
    
    Asset("IMAGE", "images/inventoryimages/ziiosword.tex"),
    Asset("ATLAS", "images/inventoryimages/ziiosword.xml"),
}

local prefabs =
{
    "iron",
    "sparks_fx",
    "sparks_green_fx",
    "laser_ring",
}



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
    owner.components.temperature:SetTemp(20)
    GetPlayer():PushEvent("stopfreezing")
    GetPlayer():PushEvent("stopoverheating")

    owner.components.hunger:DoDelta(500)
    owner.components.sanity:DoDelta(500)
    owner.components.health:DoDelta(500)
    owner:AddTag("ancient_robot")
    owner:AddTag("beam_attack")
    owner:AddTag("has_gasmask")

    owner:ListenForEvent("cantbuild", giveitems)

end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    inst.Light:Enable(false)
    owner.components.temperature:SetTemp(nil)

    owner.components.hunger:DoDelta(500)
    owner.components.sanity:DoDelta(500)
    owner.components.health:DoDelta(500)
    owner:RemoveTag("ancient_robot")
    owner:RemoveTag("beam_attack")
    owner:RemoveTag("has_gasmask")

    owner:RemoveEventCallback("cantbuild", giveitems)

end


local function onattack(inst, owner, target)
    owner.components.hunger:DoDelta(500)
    owner.components.sanity:DoDelta(500)
    owner.components.health:DoDelta(500)
    if owner.components.combat.target then
        local target = owner.components.combat.target
        owner:PushEvent("dobeamattack",{target=owner.components.combat.target})
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("nightmaresword")
    inst.AnimState:SetBuild("ziiosword")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("ziio")
    inst:AddTag("sharp")

    inst:AddTag("venting")
    inst:AddTag("fogproof")



--  yu'san
    inst:AddComponent("dapperness")
    inst.components.dapperness.mitigates_rain = true
--  diao'yu'gan
    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(1, 5)
    inst.components.fishingrod:SetStrainTimes(0, 10)
--  shun'yi
    inst:AddComponent("blinkstaff")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(9999999)
    inst.components.weapon:SetRange(2, 100)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetProjectile("ziio_projectile")
    -------
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ziiosword.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.walkspeedmult = 3,
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(20)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.95)
    inst.Light:SetColour(255/255,255/255,255/255)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_HUGE

    if IsDLCEnabled(PORKLAND_DLC) then
        inst:AddTag("PORKLAND_DLC")
    --  ball pein hammer (hamlet)
        inst:AddComponent("dislodger")
        inst:AddTag("gasmask")
        inst.components.equippable.insulated = true
        inst.components.equippable.poisongasblocker = true
        inst:AddComponent("windproofer")
        inst.components.windproofer:SetEffectiveness(999999)
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(999999)
    elseif IsDLCEnabled(REIGN_OF_GIANTS) then
        inst:AddTag("REIGN_OF_GIANTS")
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(999999)
    elseif IsDLCEnabled(CAPY_DLC) then
        inst:AddTag("CAPY_DLC")
        inst:AddComponent("windproofer")
        inst.components.windproofer:SetEffectiveness(999999)
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(999999)
    end





    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.DIG)
    inst.components.tool:SetAction(ACTIONS.CHOP,   100)
    -- if ACTIONS.SPY ~= nil then
    --     inst:AddTag("magnifying_glass")
    --     inst.components.tool:SetAction(ACTIONS.SPY)
    -- end
    if ACTIONS.DISLODGE ~= nil then
        inst.components.tool:SetAction(ACTIONS.DISLODGE)
    end
    if ACTIONS.HACK ~= nil then
        inst.components.tool:SetAction(ACTIONS.HACK, 100)
    end
    if ACTIONS.SHEAR ~= nil then
        inst.components.tool:SetAction(ACTIONS.SHEAR, 100)
    end
    inst.components.tool:SetAction(ACTIONS.MINE,   100)
    inst.components.tool:SetAction(ACTIONS.HAMMER, 100)
    inst.components.tool:SetAction(ACTIONS.NET)
    if ACTIONS.SMILE ~= nil then
        inst.components.tool:SetAction(ACTIONS.SMILE, 100)
    end




    return inst
end

STRINGS.NAMES.ZIIOSWORD = "Ziio Sword"
STRINGS.RECIPE_DESC.ZIIOSWORD = "It's very awful."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZIIOSWORD = "This sword is very awful."

return Prefab( "common/inventory/ziiosword", fn, assets, prefabs)
