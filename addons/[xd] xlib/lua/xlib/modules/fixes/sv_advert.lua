local args, cmd, txt, msg
local function SendToPlayers( type, ply, message )

	if type == 'ANON' then
		msg = ' chat.AddText( Color( 32, 17, 130 ), "[ANON] ", Color( 255, 255, 255 ), "' .. message .. '" ) '
	elseif type == 'ADVERT' then
		msg = ' chat.AddText( Color( 255, 72, 0 ), "[Объявление][' .. ply:Nick() .. ']", Color( 255, 255, 255 ), "' .. message .. '" ) '
	elseif type == 'OOC' then
		msg = ' chat.AddText( Color( 183, 0, 255 ), "[OOC][' .. ply:Nick() .. ']", Color( 255, 255, 255 ), "' .. message .. '" ) '
	end

	for i,v in ipairs( player.GetAll() ) do
		ply:SendLua( msg )
	end

end

hook.Add( 'PlayerSay', 'XD:AdvertFix', function( ply, text )

	args = string.Explode(" ", text)
	cmd = string.lower(args[1])

	if cmd == '/ooc' or cmd == '//' then

		txt = table.concat(args, ' ', 2, #args)
		if txt != '' then
			SendToPlayers( 'OOC', ply, txt )
		end

	elseif cmd == '/advert' or cmd == '/adv' then

		txt = table.concat(args, ' ', 2, #args)
		if txt != '' then
			SendToPlayers( 'ADVERT', ply, message )
		end

	elseif cmd == "/anonymous" or cmd == "/ano" then

		txt = table.concat(args, ' ', 2, #args)
		if txt != '' then
			SendToPlayers( 'ANON', ply, txt )
		end

	end

end)
