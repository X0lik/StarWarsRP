concommand.Add( 'gm_spawn', function( ply, cmd, args )

		if ply:CanSpawn() then
				CCSpawn( ply, cmd, args )
		else
			XD:ChatLog( ply, 'Этот баг мы пофиксили. Багоюзить нельзя :)', nil, XD.DefaultColor )
		end

end )
