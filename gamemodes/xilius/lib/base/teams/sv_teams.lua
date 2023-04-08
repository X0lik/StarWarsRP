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

hook.Add( "PlayerChangedTeam", "XL:ChangeTeam", function( ply, oldTeam, newTeam )
	
	local team = XL.Teams[newTeam]
	timer.Simple( 0, function()
		ply:StripWeapons()
		hook.Call( "PlayerLoadout", gmod.GetGamemode(), ply )
	end)

end)

--[[hook.Add( "PlayerSpawn", "XL:PlayerLoadout", function( ply )

	print( ply )
	XL:Log( "Loading player", ply:Name(), greenColor )
	local team = XL.Teams[ply:Team()]
	if team.models ~= nil then
		ply:SetModel( team.models[math.random( #team.models )] )
		XL:Log( "Change Model", ply:Name(), greenColor, team.models[math.random( #team.models )] )
	end

	if team.weapons ~= nil then
		for i,v in next, team.weapons do
			ply:Give( v )
		end
	end

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

	if ply:IsAdmin() and XL.Config.GiveAdminWeapons then
		for i,v in next, XL.Config.AdminWeapons do
			ply:Give( v )
		end
	end

end)]]