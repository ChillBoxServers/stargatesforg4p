---- G4P Stargates By Carnate v0.1 -----
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");


function ENT:Initialize()
	self:SetModel("models/hunter/tubes/tube4x4x05.mdl")
	self:SetMaterial("phoenix_storms/metalset_1-2")
 	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor(Color(255, 255, 255,255))
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetUseType(3)
	self.CanTeleport = false
	self.CanOpen = true
	self.outpos = Vector(0,0,0)
	self.outang = Angle(0,0,0)
	self:SetTrigger(true )
	self:UseTriggerBounds( true,1 )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:SetUpPortal()
	if(IsValid(self.portal))then self.portal:Remove() end
	self.CanOpen = false
	self.CanTeleport = false
	self.portal = ents.Create("prop_physics")
	self.portal:SetModel("models/hunter/tubes/circle4x4.mdl")
	self.portal:SetPos(self:GetPos())
	self.portal:SetAngles(self:GetAngles())
	self.portal:SetModelScale(0)
	self.portal:SetMaterial("models/props_combine/stasisshield_sheet")
	self.portal:Spawn()
		
	self.portal:SetParent(self)
	self.portal:SetModelScale(0.5,0.3)
	self.portal:GetPhysicsObject():EnableMotion(false)
	self.portal:SetNWString("Owner","World")
	local physObject = self:GetPhysicsObject()
	physObject:EnableMotion(false)
    physObject:EnableGravity(false)
    physObject:EnableCollisions(false)

	timer.Simple(0.3, function() self.portal:SetModelScale(0,0.3) end)
	timer.Simple(0.6, function() self.portal:SetModelScale(0.10,0.4)  end)
	timer.Simple(0.9, function() self.portal:SetModelScale(0.60,0.7)  end)
	timer.Simple(1.2, function() self.portal:SetModelScale(0,0.7)  end)
	timer.Simple(1.5, function() self.portal:SetModelScale(0.97,0.7)  end)
	timer.Simple(0.7, function() self.CanTeleport = true  end)
	timer.Simple(8, function() self:DoShutDown() self.CanTeleport=false self.CanOpen = true  end)



end

function ENT:SetUpConsole(world)
	local console = ents.Create("prop_physics")
	console:SetModel("models/props_combine/combine_interface001.mdl")
	console:SetPos(self:GetPos())
	console:Spawn()
	console:SetUseType( SIMPLE_USE )
	console:SetParent(self)
	console:SetModelScale(0.65,0)
	console:Activate()
	console.IsConsole = true
	console.gate = self;
	console:SetLocalPos(Vector(87.254761, -103.899445, 57.747894))
	console:SetLocalAngles( Angle( -87.787, 23.574, -23.626))
	console:SetNWString("GateWorld",world)
	local physObject = console:GetPhysicsObject()
	physObject:EnableMotion(false)
    physObject:EnableGravity(false)
    physObject:EnableCollisions(false)
	
	console:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	timer.Simple(5, function()
		console:SetParent(nil) 
		console:CPPISetOwner(game.GetWorld())
		console:SetNWString("Owner","World") 
	end)
	
end

function ENT:DoShutDown()
	timer.Simple(0.3, function() self.portal:SetModelScale(0.8,0.3) end)
	timer.Simple(0.6, function() self.portal:SetModelScale(0.97,0.4)  end)
	timer.Simple(0.9, function() self.portal:SetModelScale(0.60,0.7)  end)
	timer.Simple(1.2, function() self.portal:SetModelScale(0.5,0.7)  end)
	timer.Simple(1.5, function() self.portal:SetModelScale(0,0.7)  end)
end

function ENT:TeleportPlayer(ply,pos,ang)
	ply:SetPos(pos )
	ply:SetEyeAngles(ang)
	ply:DropToFloor()
end

function ENT:SetOutPos(pos)
	self.outpos = pos
end

function ENT:SetOutAng(ang)
	self.outang = ang
end

function ENT:StartTouch(ent)
	if(!ent:IsPlayer())then return end
	if(self.CanTeleport == false)then return end
	self:TeleportPlayer(ent,self.outpos,self.outang)
end

