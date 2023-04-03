if pcall(require, "chttp") and CHTTP ~= nil then
	my_http = CHTTP
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

--ply:TimeConnected()