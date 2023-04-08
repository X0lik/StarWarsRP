AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

hook.Add( "PlayerLoadout", "XL:LoadPlayer", function( ply )

	XL:UpdateTeam( ply )
	return true

end)

function GM:PlayerInitialSpawn( ply )
	XL:SetTeam( ply, XL.DefaultTeam )
end