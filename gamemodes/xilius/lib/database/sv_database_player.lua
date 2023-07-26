local db = XL.DB

local osTime = os.time
local hook = hook.Add
local timer = timer.Simple
hook( "PlayerInitialSpawn", "XL:Database:PlayerInit", function( pl )

	timer( 0, function()

		db:Query( "SELECT * FROM xilius_players WHERE steamid=" .. pl:SteamID64() .. ";", function( res )
			local data = res[1].data
			if #data == 0 then
				db:Query('INSERT INTO xilius_players( `steamid`, `name`, `money`, `group`, `firstjoin`, `lastseen`, `playtime` ) VALUES( ' .. pl:SteamID64() .. ', "' .. pl:GetName() .. '", ' .. XL.Config.StartMoney .. ', "user", ' .. osTime() .. ', ' .. osTime() .. ', 0 );' )
			else
				data = data[1]
				--pl:SetMoney( data.money )
				pl:SetUserGroup( data.group )
				pl:SetName( data.name )
				db:Query('UPDATE xilius_players SET lastseen = ' .. osTime() .. ' WHERE steamid=' .. pl:SteamID64() .. ';' )
			end
			pl.CurSession = osTime()

			XL:Log( "Database", pl:GetName() .. " synchronized successfully!", defaultColor )
		end)

	end)

end)