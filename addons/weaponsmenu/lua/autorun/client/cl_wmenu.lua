surface.CreateFont( 'WM:Title', {
	font = 'Tahoma',
	size = ScreenScale(9),
	weight = 600,
	extended = true,
})

surface.CreateFont( 'WM:Name', {
	font = 'Tahoma',
	size = ScreenScale(7),
	weight = 600,
	extended = true,
})

local sw, sh = ScrW(), ScrH()
net.Receive( 'WM:OpenMenu', function() 

	local ammo, armor, health
	local wmenu = vgui.Create( 'EditablePanel' )
	wmenu:SetSize( sw*.55, sh*.6 )
	wmenu:Center()
	wmenu:MakePopup()
	wmenu.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
		draw.SimpleText( 'Выдача оружия', 'WM:Title', w*.02, h*.05, Color( 255, 255, 255 ), 0, 1 )
	end

	local closebtn = vgui.Create( 'DButton', wmenu )
	closebtn:SetSize( 30, 30 )
	closebtn:SetPos( wmenu:GetWide()-30, 0 )
	closebtn:SetText('')
	closebtn.Paint = function( self, w, h )
		draw.SimpleText( 'X', 'WM:Title', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end

	closebtn.DoClick = function()
		wmenu:Remove()
	end

	local list = vgui.Create( 'DScrollPanel', wmenu )
	list:SetSize( wmenu:GetWide()*.7, wmenu:GetTall()*.85 )
	list:SetPos( wmenu:GetWide()*.05, wmenu:GetTall()*.1 )
	list.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
	end

	for i,v in ipairs( WM.Weapons ) do

		local weapon = vgui.Create( 'EditablePanel', list )
		weapon:SetSize( list:GetWide(), list:GetTall()*.2 )
		weapon:Dock( TOP )
		weapon:DockMargin( 0, 0, 0, 20 )
		weapon.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10 ) )
			draw.SimpleText( WM.Weapons[i].name, 'WM:Title', w*.06, h/2, Color( 255, 255, 255 ), 0, 1 )
		end

		local giveweapon = vgui.Create( 'DButton', weapon )
		giveweapon:SetSize( weapon:GetWide()*.2, weapon:GetTall()*.5 )
		giveweapon:SetPos( weapon:GetWide()*.75, weapon:GetTall()*.25 )
		giveweapon:SetText('')
		giveweapon.Paint = function( self, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, Color( 116, 0, 255 ) )
			draw.SimpleText( 'ПОЛУЧИТЬ', 'WM:Name', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
		end

		giveweapon.DoClick = function()
			net.Start( 'WM:GiveWeapon' )
			net.WriteString( WM.Weapons[i].class )
			net.SendToServer()
		end

	end

	local ammobtn = vgui.Create( 'DButton', wmenu )
	ammobtn:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.1 )
	ammobtn:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.1 )
	ammobtn:SetText('')
	ammobtn.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color( 116, 0, 255 ) )
		draw.SimpleText( 'Взять патроны', 'WM:Name', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end

	ammobtn.DoClick = function()

		if ammo ~= nil then
			net.Start( 'WM:SomeGive' )
			net.WriteString( 'ammo' )
			net.WriteInt( ammo, 15 )
			net.WriteString( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() )
			net.SendToServer()
		end

	end

	local ammotxt = vgui.Create( 'DTextEntry', wmenu )
	ammotxt:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.05 )
	ammotxt:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.22 )
	ammotxt.OnChange = function( self ) ammo = self:GetValue() end

	local armorbtn = vgui.Create( 'DButton', wmenu )
	armorbtn:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.1 )
	armorbtn:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.3 )
	armorbtn:SetText('')
	armorbtn.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color( 116, 0, 255 ) )
		draw.SimpleText( 'Взять броню', 'WM:Name', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end

	armorbtn.DoClick = function()

		if armor ~= nil then
			net.Start( 'WM:SomeGive' )
			net.WriteString( 'armor' )
			net.WriteInt( armor, 15 )
			net.SendToServer()
		end

	end

	local armortxt = vgui.Create( 'DTextEntry', wmenu )
	armortxt:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.05 )
	armortxt:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.42 )
	armortxt.OnChange = function( self ) armor = self:GetValue() end

	local healthbtn = vgui.Create( 'DButton', wmenu )
	healthbtn:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.1 )
	healthbtn:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.5 )
	healthbtn:SetText('')
	healthbtn.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color( 116, 0, 255 ) )
		draw.SimpleText( 'Взять ХП', 'WM:Name', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
	end

	healthbtn.DoClick = function()

		if health ~= nil then
			net.Start( 'WM:SomeGive' )
			net.WriteString( 'health' )
			net.WriteInt( health, 15 )
			net.SendToServer()
		end

	end

	local healthtxt = vgui.Create( 'DTextEntry', wmenu )
	healthtxt:SetSize( wmenu:GetWide()*.2, wmenu:GetTall()*.05 )
	healthtxt:SetPos( wmenu:GetWide()*.775, wmenu:GetTall()*.62 )
	healthtxt.OnChange = function( self ) health = self:GetValue() end


end)