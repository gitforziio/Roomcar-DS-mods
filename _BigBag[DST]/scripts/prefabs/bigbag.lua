require "prefabutil"
require "recipe"
require "modutil"


local assets=
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_bigbag.zip"),
    Asset("ATLAS", "images/inventoryimages/bigbag.xml"),
    Asset("ATLAS", "images/bigbagbg.xml"),
}

-------------------------------------------------------------------------------

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
                if item:HasTag("spoiled") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("stale") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("fresh") then
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
    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.Light:Enable(true)
    end
    if TUNING.ROOMCAR_BIGBAG_GIVE then
        owner:ListenForEvent("cantbuild", giveitems)
    end
    owner.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "swap_body")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.Light:Enable(false)
    end
    if TUNING.ROOMCAR_BIGBAG_GIVE then
        owner:RemoveEventCallback("cantbuild", giveitems)
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.entity:AddLight()
        local light = inst.entity:AddLight()
        inst.Light:SetRadius(0.25)
        inst.Light:SetFalloff(0.5)
        inst.Light:SetIntensity(0.25)
        inst.Light:SetColour(255/255,255/255,255/255)
    end

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_bigbag")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("umbrella")
    inst:AddTag("bigbag")

    inst.MiniMapEntity:SetIcon("bigbag.tex")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bigbag.xml"
    inst.components.inventoryitem.cangoincontainer = true -- [[can be carried]]!!!!!!!!!!!!!!!!!!!!

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.ROOMCAR_BIGBAG_WALKSPEED

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("bigbag")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

if TUNING.ROOMCAR_BIGBAG_LANG == 1 then
    --local STRINGS=GLOBAL.STRINGS

    STRINGS.NAMES.BIGBAG                                     = "大背包"
    STRINGS.RECIPE_DESC.BIGBAG                               = "一个好大好大的背包！"

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGBAG               = "这个包也太大了吧！"
    STRINGS.CHARACTERS.WX78.DESCRIBE.BIGBAG                  = "=-!-=- 大 - 大 - 大 -=-!-="
    STRINGS.CHARACTERS.WEBBER.DESCRIBE.BIGBAG                = "~~ 好棒的包，我好喜欢! ~~"
    STRINGS.CHARACTERS.WILLOW.DESCRIBE.BIGBAG                = "我可不会烧掉这个包。"
    STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BIGBAG              = "吼吼~好给力的包！"
    STRINGS.CHARACTERS.WENDY.DESCRIBE.BIGBAG                 = "要是给我的姐妹一个这样的包就好了。"
    STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BIGBAG          = "此乃禁忌之包。"
    STRINGS.CHARACTERS.WOODIE.DESCRIBE.BIGBAG                = "可以放好多的木头！"
    STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BIGBAG               = "这包很酷，很适合我。"
    STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BIGBAG            = "这包太棒啦！"
else
    --local STRINGS=GLOBAL.STRINGS

    STRINGS.NAMES.BIGBAG                                     = "Big Bag"
    STRINGS.RECIPE_DESC.BIGBAG                               = "A really big bag."

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGBAG               = "This bag is really big!"
    STRINGS.CHARACTERS.WX78.DESCRIBE.BIGBAG                  = "=-!-=- BIG - BAG -=-!-="
    STRINGS.CHARACTERS.WEBBER.DESCRIBE.BIGBAG                = "~~ Nice bag, I LOVE IT! ~~"
    STRINGS.CHARACTERS.WILLOW.DESCRIBE.BIGBAG                = "I wouldn't light this bag."
    STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BIGBAG              = "Very powerful!"
    STRINGS.CHARACTERS.WENDY.DESCRIBE.BIGBAG                 = "What if my sister got this bag."
    STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BIGBAG          = "A cursed bag."
    STRINGS.CHARACTERS.WOODIE.DESCRIBE.BIGBAG                = "Woods can be put in it!"
    STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BIGBAG               = "Cool bag, my style."
    STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BIGBAG            = "Wonderful bag!"
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

return Prefab( "common/inventory/bigbag", fn, assets)
