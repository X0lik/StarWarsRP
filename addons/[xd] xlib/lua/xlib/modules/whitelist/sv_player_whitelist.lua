XD = XD or {}

XD.CBT = false
XD.AdminWorks = false

local EarlyAccess = {
	[ 'STEAM_0:1:572284808' ] = true, -- X0lik#2127
	[ 'STEAM_0:0:152015201' ] = true, -- JOJO#9197
	[ 'STEAM_0:1:555030832' ] = true, -- Krya_Kryakin#8375
}

local AdminAccess = {
	//[ 'STEAM_0:1:57228480' ] = true, -- X0lik#2127
	[ 'STEAM_0:0:152015201' ] = true, -- JOJO#9197
	[ 'STEAM_0:1:555030832' ] = true, -- Krya_Kryakin#8375
}

concommand.Add( 'xd.cbt', function( ply )

	if ply == nil or ply:IsOP() then

		if XD.CBT then
			XD.CBT = false
		else
			XD.CBT = true
			for i,v in ipairs( player.GetAll() ) do
				if not EarlyAccess[ v:SteamID() ] then
					v:Kick( 'Вы не являетесь участником закрытого бета-тестирования.\nПожалуйста, зайдите позже!\nDiscord: https://discord.gg/fEvdDNZsNj' )
				end
			end
		end

	end

end)

concommand.Add( 'xd.adminworks', function( ply )

	if ply == nil or ply:IsOP()  then

		if XD.AdminWorks then
			XD.AdminWorks = false
		else
			XD.AdminWorks = true
			for i,v in ipairs( player.GetAll() ) do
				if not AdminAccess[ v:SteamID() ] then
					v:Kick( 'На сервере проводятся технические работы.\nПожалуйста, зайдите позже!\nDiscord: https://discord.gg/fEvdDNZsNj' )
				end
			end
		end

	end

end)


hook.Add( 'PlayerInitialSpawn', 'XD:WhiteList', function( ply, steamid )

	timer.Simple( 0.1, function()

		if XD.CBT then
			if not EarlyAccess[ steamid ] then
				ply:Kick( 'Вы не являетесь участником закрытого бета-тестирования.\nПожалуйста, зайдите позже!\nDiscord: https://discord.gg/fEvdDNZsNj' )
			end
		end

		if XD.AdminWorks then
			if not AdminAccess[ steamid ] then
				ply:Kick( 'На сервере проводятся технические работы.\nПожалуйста, зайдите позже!\nDiscord: https://discord.gg/fEvdDNZsNj' )
			end
		end

	end)

end)
