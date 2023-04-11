hook.Add( "PlayerInitialSpawn", "XL:SetDefaultTeam", function( ply )
	timer.Simple( 0, function()

		ply.NetTimedOut = {}
		XL:SetTeam( ply, XL.DefaultTeam, 1 )
		ply:SetCrouchedWalkSpeed( XL.Config.DefaultCrouch )
		ply:SetSlowWalkSpeed( XL.Config.DefaultSlowWalk )
		ply:SetWalkSpeed( XL.Config.DefaultWalk )
		ply:SetRunSpeed( XL.Config.DefaultRun )
		ply:SetMaxSpeed( XL.Config.DefaultRun )
		ply:SetJumpPower( XL.Config.DefaultJump )
		
		if XL.Modules["starwars"] then
			if not ply:CharLoad() then
				ply:CharMenu()
			end
		end

		if XL.Modules["money"] then
			ply.Money = XL.Config.StartMoney
		end
	end)
end)
