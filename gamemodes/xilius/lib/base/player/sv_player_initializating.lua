hook.Add( "PlayerInitialSpawn", "XL:SetDefaultTeam", function( ply )
	timer.Simple( 0, function()

		ply.NetTimedOut = {}
		ply:SetCrouchedWalkSpeed( XL.Config.DefaultCrouch )
		ply:SetSlowWalkSpeed( XL.Config.DefaultSlowWalk )
		ply:SetWalkSpeed( XL.Config.DefaultWalk )
		ply:SetRunSpeed( XL.Config.DefaultRun )
		ply:SetMaxSpeed( XL.Config.DefaultRun )
		ply:SetJumpPower( XL.Config.DefaultJump )
		XL:SetTeam( ply, XL.DefaultTeam )
		
		if XL.Modules["starwars"] then
			if not ply:CharLoad() then
				ply:CharMenu()
			end
		end

	end)
end)
