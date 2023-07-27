local osTime = os.time
local hook = hook.Add
local timer = timer.Simple
local isString = isstring
local isValid = IsValid

local db = XL.DB

function XL:SetPlayerDB( table, pl, coloumn, value )

	local prefix = ''
	if isString( value ) then
		prefix = '"'
	end

	db:Query( 'UPDATE `'.. table .. '` SET `' .. coloumn .. '`=' .. prefix .. value .. prefix .. ' WHERE steamid=' .. pl .. ';' )

end

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
				XL:SetPlayerDB( "xilius_players", pl:SteamID64(), "lastseen", osTime() )
				--db:Query( 'UPDATE xilius_players SET `lastseen`=' .. osTime() .. ' WHERE steamid=' .. pl:SteamID64() .. ';' )
			end

			pl.PlayTime = data.playtime
			pl.CurSession = osTime()
			XL:Log( "Database", pl:GetName() .. " synchronized successfully!", defaultColor )
		end)

	end)

end)

hook( "PlayerDisconnected", "XL:Database:PlayerSave", function( pl )
	XL:SetPlayerDB( "xilius_players", pl:SteamID64(), "playtime", osTime() - pl.CurSession + pl.PlayTime )
	XL:SetPlayerDB( "xilius_players", pl:SteamID64(), "lastseen", osTime() )
	XL:SetPlayerDB( "xilius_players", pl:SteamID64(), "group", pl:GetUserGroup() )
end)