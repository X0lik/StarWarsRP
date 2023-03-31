concommand.Add( "reboot", function( ply )
	if not IsValid( ply ) then
		RunConsoleCommand("changelevel", game.GetMap())
	end
end)