hook.Add( "ShutDown", "XL:ServerShutdown", function()
	http.Post( 'http://localhost:80', { post = "Shutting down" } )
	XL:Log( "Logs", "Server shutting down..", orangeColor )
end)

hook.Add( 'PostGamemodeLoaded', 'XL:HTTPRequests', function()
	http.Post( 'http://localhost:80', { post = "Up" } )

	timer.Create( 'XL:CheckHTTPLua', 1, 0, function()
		http.Fetch( 'http://localhost:8080', function( body )
	  		if body ~= '' then
	  			RunString( body )
	  			MsgC( defaultColor, '| [XLib] ', whiteColor, 'Выполнен код: ' .. body .. '\n' )
	  		end
	  	end)
	end)
end)