---- G4P Stargates By Carnate v0.1 -----
SGS_CL_Worlds = {
	[0] = {"spawn", "Spawn World"},
	[1] = {"cave", "Cave World"},
	[2] = {"snow", "Snow World"},
	[3] = {"pyramid", "Pyramid World"},
	[4] = {"islands", "Islands World"},
	[5] = {"arena", "The Arena"},
	[7] = {"bunker", "The Bunker"},
	[8] = {"pvp1", "PVP World (North Side)"},
	[9] = {"pvp2", "PVP World (South Side)"},
}

SGS_ConsoleMenuOpen = false
function SGS_OpenStargeteConsole()
	if(SGS_ConsoleMenuOpen == true)then return end
	SGS.consolemenu = vgui.Create( "DFrame" )
	SGS.consolemenu:ShowCloseButton(true)
	SGS.consolemenu:SetDraggable(false)
	SGS.consolemenu:SetSize( 320,340 )
	SGS.consolemenu:SetPos( ScrW() / 2 - 160, ScrH() / 2 - 170 )
	SGS.consolemenu:SetTitle(" Stargete Console v0.1 (WIP)")
	SGS.consolemenu:MakePopup()
	SGS_ConsoleMenuOpen = true

	local worldlist = vgui.Create( "DListView", SGS.consolemenu )
	worldlist:Dock( FILL )
	worldlist:SetMultiSelect( false )
	worldlist:AddColumn( "World" )
	worldlist:AddColumn( "Id" )
	local TextEntry = vgui.Create( "DTextEntry", SGS.consolemenu)
	TextEntry:Dock( BOTTOM )

	TextEntry.OnEnter = function( self )
		--Todo: Setup codes
	end

	local DermaButton = vgui.Create( "DButton", TextEntry ) 
	DermaButton:SetText( "Use Code" )					
	DermaButton:Dock(RIGHT)				
	DermaButton.DoClick = function()				
		
	end

	for k,v in pairs(SGS_CL_Worlds) do
		worldlist:AddLine(v[2],v[1])
	end

	worldlist.OnRowSelected = function( lst, index, pnl )
		local cmd = worldlist:GetLine(worldlist:GetSelectedLine()):GetValue(2)
		RunConsoleCommand("sgs_setgateworld",cmd)
		SGS_ConsoleMenuOpen = false
		SGS.consolemenu:Close()
	end

	function SGS.consolemenu:OnClose()		
		SGS_ConsoleMenuOpen = false
	end 
end