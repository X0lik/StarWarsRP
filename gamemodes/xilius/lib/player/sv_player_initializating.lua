hook.Add( "PlayerInitialSpawn", "XL:SetDefaultTeam", function( ply )
	timer.Simple( 0, function()
		ply:SetTeam( 0 )
		ply:SetWalkSpeed( XL.Config.DefaultWalk )
		ply:SetRunSpeed( XL.Config.DefaultRun )
		ply:SetJumpPower( XL.Config.DefaultJump )

		if XL.Modules["money"] then
			ply.Money = XL.Config.StartMoney
		end
	end)
end)