
print("Loading Big Bag Prefab...")



TUNING.ROOMCAR_BIGBAG_STACK = true
TUNING.ROOMCAR_BIGBAG_FRESH = true





local assets=
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_bigbag.zip"),
    Asset("ATLAS", "images/inventoryimages/bigbag.xml"),
    Asset("ATLAS", "images/bigbagbg.xml"),
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

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    if inst.components.container and not inst.components.container:IsEmpty() then
        for i = 1, inst.components.container.numslots do
            local item = inst.components.container.slots[i]
            if item ~= nil then
                if item.components.stackable and TUNING.ROOMCAR_BIGBAG_STACK then
                    -- item.components.stackable:SetMaxSize(43)
                    item.components.stackable:SetStackSize(item.components.stackable.maxsize)
                end
            end
        end
    end
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    if inst.components.container and not inst.components.container:IsEmpty() then
        for i = 1, inst.components.container.numslots do
            local item = inst.components.container.slots[i]
            if item ~= nil and TUNING.ROOMCAR_BIGBAG_FRESH then
                if item.components.perishable then
                    item.components.perishable:SetPercent(1)
                end
                if item.components.finiteuses then
                    item.components.finiteuses:SetPercent(1)
                end
                if item.components.fueled then
                    item.components.fueled:SetPercent(1)
                end
                if item.components.armor then
                    item.components.armor:SetPercent(1)
                end
            end
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "swap_body")
    -- owner.components.inventory:SetOverflow(inst)
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    -- owner.components.inventory:SetOverflow(nil)
    inst.components.container:Close(owner)
end

local function itemtestFunction(inst, item, slot)
    return not item:HasTag("bigbag")
end

-- local function onopen(inst)
    -- inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open", "open")
-- end

-- local function onclose(inst)
    -- inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close", "open")
-- end

local slotpos = {}

for m = 0, 7 do
    local gridsize = 66
    local mis = 3.5*gridsize
    for n = 0, 7 do
        table.insert(slotpos, Vector3(m*gridsize - mis, n*gridsize - mis, 0))
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("bigbag.tex")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_bigbag")
    inst.AnimState:PlayAnimation("anim")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bigbag.xml"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/krampuspack"

    -- [[can be carried]]!!!!!!!!!!!!!!!!!!!!
    inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = 1.15

    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("umbrella")
    inst:AddTag("bigbag")

    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtestFunction
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos

    -- [[background]]
    -- inst.components.container.widgetanimbank = "ui_piggyback_2x6"
    -- inst.components.container.widgetanimbuild = "ui_piggyback_2x6"
    inst.components.container.widgetanimbank = nil
    inst.components.container.widgetanimbuild = nil
    inst.components.container.widgetbgatlas = "images/bigbagbg.xml"
    inst.components.container.widgetbgimage = "bigbagbg.tex"
    inst.components.container.widgetpos = Vector3(-200,-60,0)
    -- inst.components.container.widgetpos = Vector3(-180,-50,0)
    -- 基准是中心点，原点是右侧中点，-x向左调节，-y向下调节。

    inst.components.container.side_widget = true
    inst.components.container.type = "pack"
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    if IsDLCEnabled(REIGN_OF_GIANTS) then
        print("RoG support enabled")
        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(30)
        inst.components.insulator:SetSummer()
    elseif IsDLCEnabled(REIGN_OF_GIANTS) then
        print("RoG support disabled")
        inst:AddComponent("insulator")
        inst.components.insulator.insulation = 30
    end

    return inst
end

return Prefab( "common/inventory/bigbag", fn, assets)
