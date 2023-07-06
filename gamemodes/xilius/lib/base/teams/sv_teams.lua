function XL:SetTeam( ply, team, rank )
	ply:SetTeam( team )
	ply.teamRank = 0

	local teamTable = XL.Teams[team]
	ply:SetNWString( "XL:TeamName", teamTable.name ) 
	if rank ~= nil and rank ~= 0 then
		ply.teamRank = rank
		ply:SetNWString( "XL:TeamName", teamTable.ranks[rank].name )
		ply:StripWeapons()
		XL:UpdateTeam( ply )
	end

end

function XL:UpdateTeam( ply )

	--XL:Log( "Loading player", ply:Name(), greenColor )
	local team = XL.Teams[ply:Team()]
	local rank = ply.teamRank

	if team == nil then return end
	if rank ~= nil and rank ~= 0 and team.ranks ~= nil and team.ranks[rank] ~= nil then
		rank = team.ranks[rank]
	else
		rank = nil
	end

	for i,v in next, XL.Config.DefaultWeapons do
		ply:Give( v )
	end

	if rank ~= nil && rank.weapons ~= nil then
		for i,v in next, rank.weapons do
			ply:Give( v )
		end
	elseif team.weapons ~= nil then
		for i,v in next, team.weapons do
			ply:Give( v )
		end
	end

	if rank ~= nil && rank.health ~= nil then
		ply:SetHealth( rank.health )
		ply:SetMaxHealth( rank.health )
	elseif team.health ~= nil then
		ply:SetHealth( team.health )
		ply:SetMaxHealth( team.health )
	end

	if rank ~= nil && rank.armor ~= nil then
		ply:SetArmor( rank.armor )
	elseif team.armor ~= nil then
		ply:SetArmor( team.armor )
	end


	if rank ~= nil && rank.ammo ~= nil then
		for i,v in next, rank.ammo do
			ply:GiveAmmo( i, v, false )
		end
	end

	if team.ammo ~= nil then
		for i,v in next, team.ammo do
			ply:GiveAmmo( i, v, false )
		end
	end

	if rank ~= nil && rank.spawn ~= nil then
		rank.spawn(ply)
	elseif team.spawn ~= nil then
		team.spawn(ply)
	end

	if ply:IsAdmin() and XL.Config.GiveAdminWeapons then
		for i,v in next, XL.Config.AdminWeapons do
			ply:Give( v )
		end
	end

	timer.Simple( 0, function()
		if rank ~= nil && rank.models ~= nil then
			--randomModel = math.random( #rank.models )
			ply:SetModel( rank.models[math.random( #rank.models )] )
		elseif team.models ~= nil then
			--randomModel = math.random( #team.models )
			ply:SetModel( team.models[math.random( #team.models )] )
		end
		ply.teamModel = randomModel

		if rank ~= nil && rank.bodygroups ~= nil then
			for i,v in next, rank.bodygroups do
				ply:SetBodygroup( i, v )
			end
		elseif team.bodygroups ~= nil then
			for i,v in next, team.bodygroups do
				ply:SetBodygroup( i, v )
			end
		end
	end)

end

hook.Add( "PlayerChangedTeam", "XL:ChangeTeam", function( ply, oldTeam, newTeam )
	
	local team = XL.Teams[newTeam]
	timer.Simple( 0, function()
		ply:StripWeapons()
		XL:UpdateTeam( ply )
	end)

end)