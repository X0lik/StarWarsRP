if pcall(require, "chttp") and CHTTP ~= nil then
	my_http = CHTTP
end

hook.Add( "PostGamemodeLoaded", "XL:HTTPRequests", function()
	XL:HTTPPost( "http://localhost:80", "serverStatus/enabling" )
	XL:HTTPConnect( "http://localhost:8080" )
end)

hook.Add( "ShutDown", "XL:ServerShutdown", function()

	XL:HTTPPost( "http://localhost:80", "serverStatus/shuttingDown" )
	XL.Modules["http"] = false
	XL:Log( "Disabling modules", "HTTP", redColor )
	XL:Log( "Logs", "Server shutting down..", redColor )
	
end)

--ply:TimeConnected()

function XL:HTTPConnect( url )

	if XL.Modules["http"] then

		CHTTP({
			url = url,
			success = function(code, body, headers)
				if body ~= "" then
		  			RunString( body )
		  			XL:Log( "Running Lua", body, greenColor )
		  		end
		  		timer.Simple( 3, function()
		  			XL:HTTPConnect( url )
		  		end)
			end,
		    failed = function(err)
		    	if err ~= "Couldn't connect to server" then
					XL:Log( "HTTP Connection Error", err, redColor )
				end
				XL:HTTPConnect( url )
			end,
		})

	end

end

function XL:HTTPPost( url, body )

	if XL.Modules["http"] then

		CHTTP({
			url = url,
			method = "POST",
			body = body,
			failed = function(err)
				XL:Log( "Post Request Failed", err, redColor, url .. " | " .. body )
			end,
		})

	end

end