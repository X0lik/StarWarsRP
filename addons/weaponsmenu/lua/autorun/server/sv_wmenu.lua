util.AddNetworkString( 'WM:OpenMenu' )
util.AddNetworkString( 'WM:GiveWeapon' )
util.AddNetworkString( 'WM:SomeGive' )

hook.Add( 'PlayerSay', 'WMenu', function( ply, txt )

	if string.lower( txt ) == WM.Command and WM.Groups[ ply:GetUserGroup() ] then
		net.Start( 'WM:OpenMenu' )
		net.Send( ply )
		return ''
	end

end)

local weapon
net.Receive( 'WM:GiveWeapon', function( _, ply )

	if WM.Groups[ ply:GetUserGroup() ] then

		if ply.TakedWeapon then
			ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[WM] ", Color( 255, 255, 255 ), "Вы уже брали это, подождите ' .. WM.Time .. 's!" ) ' )
			return false
		end

		weapon = net.ReadString()
		ply:Give( weapon )
		ply.TakedWeapon = true

		timer.Simple( WM.Time, function() if IsValid( ply ) then ply.TakedWeapon = false end end)

	end

end)

local type, amount, class
net.Receive( 'WM:SomeGive', function( _, ply )

	if WM.Groups[ ply:GetUserGroup() ] then

		type = net.ReadString()
		amount = net.ReadInt(15)

		if type == 'ammo' then
			if ply.TakedAmmo then
				ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[WM] ", Color( 255, 255, 255 ), "Вы уже брали это, подождите ' .. WM.Time .. 's!" ) ' )
				return false
			end

			class = net.ReadString()
			print( class )
			ply:GiveAmmo( amount, tonumber( class ), false )
			ply.TakedAmmo = true

			timer.Simple( WM.Time, function() if IsValid( ply ) then ply.TakedAmmo = false end end)
		elseif type == 'armor' then
			if ply.TakedArmor then
				ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[WM] ", Color( 255, 255, 255 ), "Вы уже брали это, подождите ' .. WM.Time .. 's!" ) ' )
				return false
			end

			ply:SetArmor( amount )
			ply.TakedArmor = true

			timer.Simple( WM.Time, function() if IsValid( ply ) then ply.TakedArmor = false end end)
		elseif type == 'health' then
			if ply.TakedHealth then
				ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[WM] ", Color( 255, 255, 255 ), "Вы уже брали это, подождите ' .. WM.Time .. 's!" ) ' )
				return false
			end

			ply:SetHealth( amount )
			ply.TakedHealth = true

			timer.Simple( WM.Time, function() if IsValid( ply ) then ply.TakedHealth = false end end)
		end

	end

end)

hook.Add( 'PlayerInitialSpawn', 'WM:LoadPlayer', function( ply )

	timer.Simple( 0.1, function()
		ply.TakedAmmo = false
		ply.TakedHealth = false
		ply.TakedArmor = false
		ply.TakedWeapon = false
	end)

end)