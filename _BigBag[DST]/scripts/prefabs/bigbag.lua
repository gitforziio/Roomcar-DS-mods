--------------------------------------------------------------------------

require "prefabutil"
require "modutil"

--------------------
require "recipe"

--------------------

local cooking = require("cooking")

--------------------

local assets=
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_bigbag.zip"),
    Asset("ATLAS", "images/inventoryimages/bigbag.xml"),
    Asset("ATLAS", "images/bigbagbg.xml"),
}

--------------------------------------------------------------------------

local function giveitems(inst, eventdata)
    -- 参考“owner:PushEvent("cantbuild", { owner = owner, recipe = recipe })”
    if eventdata.owner.components.inventory and eventdata.recipe then
        for ik, iv in pairs(eventdata.recipe.ingredients) do
            if not eventdata.owner.components.inventory:Has(iv.type, iv.amount) then
                for i = 1, iv.amount do
                    local item = SpawnPrefab(iv.type)
                    eventdata.owner.components.inventory:GiveItem(item)
                end
            end
        end
    end
end

--------------------

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

--------------------

local function onequip(inst, equiper)

    print("    BIGBAG    onequip")
    if TUNING.ROOMCAR_BIGBAG_GIVE then
        print("    BIGBAG    ROOMCAR_BIGBAG_GIVE=true")
    else
        print("    BIGBAG    ROOMCAR_BIGBAG_GIVE=false")
    end

    -- light
    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.Light:Enable(true)
    end

    -- give
    if TUNING.ROOMCAR_BIGBAG_GIVE then
        equiper:ListenForEvent("cantbuild", giveitems)
        print("    BIGBAG    equiper:ListenForEvent(\"cantbuild\", giveitems)")
    end

    -- original
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        equiper:PushEvent("equipskinneditem", inst:GetSkinName())
        equiper.AnimState:OverrideItemSkinSymbol("bigbag", skin_build, "bigbag", inst.GUID, "swap_backpack" )
        equiper.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_backpack" )
    else
        equiper.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "backpack")
        equiper.AnimState:OverrideSymbol("swap_body", "swap_bigbag", "swap_body")
    end
    if inst.components.container ~= nil then
        inst.components.container:Open(equiper)
    end
end

local function onunequip(inst, equiper)

    print("    BIGBAG    onunequip")

    -- light
    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.Light:Enable(false)
    end

    -- give
    if TUNING.ROOMCAR_BIGBAG_GIVE then
        equiper:RemoveEventCallback("cantbuild", giveitems)
        print("    BIGBAG    equiper:RemoveEventCallback(\"cantbuild\", giveitems)")
    end

    -- original
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        equiper:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    equiper.AnimState:ClearOverrideSymbol("swap_body")
    equiper.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(equiper)
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    --------------------
    inst.entity:AddNetwork()
    -- This needs to be in any entity that you want to create on the server 
    -- and have it show up for all players. 
    -- Most things have this, but in a few cases you want things to 
    -- only exist on the server (e.g. meteorspawners, which are invisible), 
    -- and in some very rare cases you may want to create things independently on each client.
    --------------------

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("bigbag.tex")

    if TUNING.ROOMCAR_BIGBAG_LIGHT then
        inst.entity:AddLight()
        inst.Light:Enable(false)
        inst.Light:SetRadius(0.25)
        inst.Light:SetFalloff(0.5)
        inst.Light:SetIntensity(0.25)
        inst.Light:SetColour(255/255,255/255,255/255)
    end

    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("umbrella")
    inst:AddTag("bigbag")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_bigbag")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    --------------------
    inst.entity:SetPristine()
    -- This basically says "everything above this was done on both the client or the server, 
    -- so don't bother networking any of that". 
    -- This reduces a bit of the bandwidth used by creating entities. 
    -- I can't think of a case where you wouldn't want this immediately 
    -- after the "if not TheWorld.ismastersim then return inst end" part, 
    -- which is where you'll see it in the game's code.
    --------------------

    --------------------
    if not TheWorld.ismastersim then
        return inst
    end
    -- This is really important for almost all prefabs. 
    -- This essentially says "if this is running on the client, stop here". 
    -- Almost all components should only be created on the server 
    -- (the really important ones will get replicated to the client through the replica system). 
    -- Visual things and tags that will always be added can go above this, though.
    --------------------

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("bigbag")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bigbag.xml"
    inst.components.inventoryitem.cangoincontainer = true -- [[can be carried]]!!!!!!!!!!!!!!!!!!!!

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.ROOMCAR_BIGBAG_WALKSPEED

    return inst
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

if TUNING.ROOMCAR_BIGBAG_LANG == 1 then
    -- local STRINGS=GLOBAL.STRINGS

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
    -- local STRINGS=GLOBAL.STRINGS

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

--------------------------------------------------------------------------
--------------------------------------------------------------------------

return Prefab( "common/inventory/bigbag", fn, assets)
