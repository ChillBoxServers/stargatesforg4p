---- G4P Stargates By Carnate v0.1 -----
SGS_AllStargates = {}


SGS_AllStargates.CaveWorld = {
	world = "cave",
	pos = Vector(-13983.995117, -10367.982422, 1440.532104),
	ang = Angle(89.856, 77.419, 77.463),
	outpos = Vector(-13843.223633, -10374.012695, 1424.031250),
	outang = Angle(0,0,0)
}

SGS_AllStargates.SnowWorld = {
	world = "snow",
	pos = Vector(-9088.000000, 10016.000000, 1443.910034),
	ang = Angle(90, 179.973, -90.001),
	outpos = Vector(-9080.263672, 9893.278320, 1424.031250),
	outang = Angle(0,-90,0)
}

SGS_AllStargates.PyramidWorld = {
	world = "pyramid",
	pos = Vector(10655.359375, -10240.013672, 3408.515137),
	ang = Angle(89.666, -142.916, 37.074),
	outpos = Vector(10526.654297, -10246.675781, 3392.031250),
	outang = Angle(0,180,0)
}

SGS_AllStargates.SecretWorld = {
	world = "1234",
	pos = Vector(-14240.000977, -3839.999512, 8867.909180),
	ang = Angle(90, -89.999, -90.001),
	outpos = Vector(-14109.905273, -3832.127930, 8848.031250),
	outang = Angle(-0.406936, -30.390093, 0.000000
)
}

SGS_AllStargates.IslandWorld = {
	world = "islands",
	pos = Vector(2911.466797, 10751.969727, 2024.665039),
	ang = Angle(89.595, -159.918, -160.072),
	outpos = Vector(3032.123779, 10754.386719, 2008.031250),
	outang = Angle(0,0,0)
}

SGS_AllStargates.ArenaWorld = {
	world = "arena",
	pos = Vector(-15520.336914, 2047.978394, 8208.492188),
	ang = Angle(89.808, -111.528, -111.563),
	outpos = Vector(-15418.801758, 2037.150269, 8192.031250),
	outang = Angle(0,0,0)
}

SGS_AllStargates.BunkerWorld = {
	world = "bunker",
	pos = Vector(-12032.000977, 8576.000977, 7507.550293),
	ang = Angle(89.997, 180, 180.000),
	outpos = Vector(-11916.337891, 8572.362305, 7488.031250),
	outang = Angle(0,0,0)
}

SGS_AllStargates.PVPWorld1 = {
	world = "pvp1",
	pos = Vector(7680.000488, -351.999939, 6467.550293),
	ang = Angle(89.995, 89.972, 180.000),
	outpos = Vector(7680.000000, -512.000000, 6448.189453),
	outang = Angle(0,-90,0)
	
}

SGS_AllStargates.PVPWorld2 = {
	world = "pvp2",
	pos = Vector(7679.999023, -8863.999023, 6467.910156),
	ang = Angle(89.992, -89.983, 180.000),
	outpos = Vector(7665.458984, -8747.639648, 6448.031250),
	outang = Angle(0, 90,0)
}


SGS_AllStargates.SpawnWorld = {
	world = "spawn",
	pos = Vector(10368.000977 ,13440.001953 ,9503.549805),
	ang = Angle(89.996, 90.032, 180.000),
	outpos = Vector(10365.642578, 13306.291016, 9480.031250),
	outang = Angle(0, -90, 0)
}

SGS_Stargates_Loaded = false;


function SGS_LoadStargates()
	if(SGS_Stargates_Loaded == true)then return end
	for k,v in pairs(ents.GetAll()) do
		if(v.IsConsole == true)then v:Remove() end
		if(v:GetClass() == "sgs_stargate")then v:Remove() end
	end

	print("Loading Stargates...")

	for k,v in pairs(SGS_AllStargates) do
		local gate = ents.Create("sgs_stargate")
		gate:SetPos(v["pos"])
		gate:SetAngles(v["ang"])
		gate:Spawn()
		gate:SetNWString("Owner","World")
		gate:SetNWString("GateWorld",v["world"])
		print(gate:GetNWString("GateWorld"))
		gate:SetUpConsole(v["world"])
		
	end
	SGS_Stargates_Loaded = true;

end

function SGS_SetTelePorterDestination(ply,cmd,args)
	
	for k,v in pairs(ents.FindInSphere(ply:GetPos(),200)) do
		if(v:GetClass()=="sgs_stargate")then
			if(v.CanOpen == false)then ply:ChatPrint("Stargate already active!") return end
			for k2,v2 in pairs(SGS_AllStargates) do
				if(args[1]== v:GetNWString("GateWorld"))then ply:ChatPrint("You are already in this world.") return end
				if(args[1]== v2["world"])then
					v:SetOutPos(v2["outpos"])
					v:SetOutAng(v2["outang"])
				end
			end
			SGS.LastUsedGate = v
			break

		end
	end
	SGS.LastUsedGate:SetUpPortal()

	for k,v in pairs(ents.FindByClass("sgs_stargate")) do
		if(v:GetNWString("GateWorld") ==  args[1])then
			if(v.CanOpen == false)then ply:ChatPrint("Target stargate already active!") return end
			for k2,v2 in pairs(SGS_AllStargates) do
				if(v2["world"] == SGS.LastUsedGate:GetNWString("GateWorld"))then
					v:SetOutPos(v2["outpos"])
				end
			end

			SGS.LastUsedGate = v
			break
		end
		
	end
	SGS.LastUsedGate:SetUpPortal()

end
concommand.Add( "sgs_setgateworld", SGS_SetTelePorterDestination )

hook.Add( "PlayerConnect", "JoinGlobalMessage", function( )
	SGS_LoadStargates()
	SGS_Stargates_Loaded = true;
	
end )

hook.Add( "PlayerUse", "sgs_usegateconsole", function( ply, ent )--Todo: find out why SetUseType wont set or make this only fire once
	if(ent.IsConsole == true)then
		ply:SendLua("SGS_OpenStargeteConsole()")
	 end
end )




