---- G4P Stargates By Carnate v0.1 -----
include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	local pl = LocalPlayer()
	local dis = pl:GetPos():DistToSqr(self:GetPos())
	if SGS.drawdistance == nil then return end
		if dis > SGS.drawdistance then 
		self:DestroyShadow()
		return 
	end
	self:CreateShadow()
	self.Entity:DrawModel()

end

