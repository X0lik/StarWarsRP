function XL:UpdateTeam( ply )

	if ply:Team() == 1001 then return end
	local team = XL.Teams[ply:Team()]
	if team.weapons ~= nil then
		for i,v in next, team.weapons do
			ply:Give( v )
		end
	end

end

hook.Add( "PlayerSpawn", "XL:UpdateOnDeath", function( ply )
	XL:UpdateTeam(ply)
end)

hook.Add( "PlayerInitialSpawn", "XL:SetDefaultTeam", function( ply )
	timer.Simple( 0, function()
		ply:SetTeam( 0 )
	end)
end)

hook.Add( "PlayerChangedTeam", "XL:ChangeTeam", function( ply, oldTeam, newTeam )
	
	if newTeam == 1001 then return end
	local team = XL.Teams[newTeam]
	ply:StripWeapons()

	if team.models ~= nil or team.models == {} then
		ply:SetModel( team.models[math.random( #team.models )] )
	end

	if team.weapons ~= nil then
		for i,v in next, team.weapons do
			ply:Give( v )
		end
	end

end)