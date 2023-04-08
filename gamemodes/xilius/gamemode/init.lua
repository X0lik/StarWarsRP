AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

hook.Add( "PlayerLoadout", "XL:LoadPlayer", function( ply )

	XL:Log( "Loading player", ply:Name(), greenColor )
	local team = XL.Teams[ply:Team()]
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

	timer.Simple( 0, function()
		if team.models ~= nil then
			ply:SetModel( team.models[math.random( #team.models )] )
		end
	end)
	return true

end)

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( XL.DefaultTeam )
end