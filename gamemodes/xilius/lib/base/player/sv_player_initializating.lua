hook.Add( "PlayerInitialSpawn", "XL:SetDefaultTeam", function( ply )
	timer.Simple( 0, function()

		ply:SetCrouchedWalkSpeed( XL.Config.DefaultCrouch )
		ply:SetSlowWalkSpeed( XL.Config.DefaultSlowWalk )
		ply:SetWalkSpeed( XL.Config.DefaultWalk )
		ply:SetRunSpeed( XL.Config.DefaultRun )
		ply:SetMaxSpeed( XL.Config.DefaultRun )
		ply:SetJumpPower( XL.Config.DefaultJump )
		ply:SetName( "Connecting.." )

		if XL.Modules["money"] then
			ply.Money = XL.Config.StartMoney
		end
	end)
end)
