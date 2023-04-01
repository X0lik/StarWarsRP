function XL:UpdateTeam( ply )

	if ply:Team() == 0 then return end
	local team = XL.Teams[ply:Team()]

	if team.health ~= nil then
		ply:SetHealth( team.health )
	end

	if team.armor ~= nil then
		ply:SetArmor( team.armor )
	end

	if team.ammo ~= nil then
		for i,v in next, team.ammo do
			ply:GiveAmmo( i, v, false )
		end
	end

	if team.spawn ~= nil then
		team.spawn(ply)
	end

end

--[[hook.Add( "PlayerSpawn", "XL:UpdateOnDeath", function( ply )
	timer.Simple( 0, function()
		local team = XL.Teams[ply:Team()]
	end)
end)]]

hook.Add( "PlayerChangedTeam", "XL:ChangeTeam", function( ply, oldTeam, newTeam )
	
	local team = XL.Teams[newTeam]
	timer.Simple( 0, function()
		ply:StripWeapons()
		hook.Call( "PlayerLoadout", nil, ply )
	end)

end)