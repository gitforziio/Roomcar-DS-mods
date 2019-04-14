local assets=
{
	Asset("ANIM", "anim/ziio_projectile.zip"),
}

local function OnHit(inst, owner, target)
    inst:Remove()
end

local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("projectile")
    anim:SetBuild("ziio_projectile")
    
    inst:AddTag("projectile")
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnHit)
    
    return inst
end


local function brp()
    local inst = common()
    inst.AnimState:PlayAnimation("ice_spin_loop", true)
	local light = inst.entity:AddLight()
    inst.Light:Enable(true)
	inst.Light:SetRadius(5)
    inst.Light:SetFalloff(0.2)
    inst.Light:SetIntensity(0.95)
    inst.Light:SetColour(255/255,255/255,255/255)
	
    return inst
end



return Prefab( "common/inventory/ziio_projectile", brp, assets)
	  
      
