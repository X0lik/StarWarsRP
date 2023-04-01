concommand.Add( "reboot", function( ply )
	if not IsValid( ply ) then
		RunConsoleCommand("changelevel", game.GetMap())
	end
end)

concommand.Add( "xl.reload", function( ply )
	if not IsValid( ply ) then
		XL:Log( "Reloading", "Modules", orangeColor )
		XL:Initialize()
	end
end)