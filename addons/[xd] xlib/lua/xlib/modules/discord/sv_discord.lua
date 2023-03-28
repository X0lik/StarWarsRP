-------------------=[[Need to start]]=-------------------
-------------------===================-------------------

XD = XD or {}
file.CreateDir( 'xd.discord' )
file.CreateDir( 'xd.discord/connections' )

---------------------=[[Functions]]=---------------------
---------------------===============---------------------

function XD.DiscordLog( name, str )

	file.Write( 'xd.discord/' .. name .. '.txt' , str )

end

------------------------=[[HTTP]]=------------------------
------------------------===========-----------------------
//hook.Add( 'PostGamemodeLoaded', 'XD:LuaRunLoad', function()
	timer.Create( 'XD:CheckLuaRun', 1, 0, function()

		//print(123)
	  http.Fetch( 'http://localhost:80', function( body ) if body != '' then RunString( body ) MsgC( Color( 28, 217, 185 ), '| [XLib] ', Color( 255, 255, 255 ), 'Выполнен код: ' .. body .. '\n' ) end end)

	end)
//end)
//timer.Remove( 'XD:CheckLuaRun' )
