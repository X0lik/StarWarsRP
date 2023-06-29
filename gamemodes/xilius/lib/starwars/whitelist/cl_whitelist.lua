local writeUInt, writeEntity, netStart, sendToServer = net.WriteUInt, net.WriteEntity, net.Start, net.SendToServer
local getPlayers, getPlayerCounts = player.GetAll, player.GetCount
local drawBox, drawText = draw.RoundedBox, draw.SimpleText
local xLerp, frameTime = Lerp, FrameTime
local getHostName = GetHostName
local uiCreate = vgui.Create
local isValid = IsValid

local function WhitelistOpen()

	local sw, sh = ScrW(), ScrH()
	local wbw, wbh = sw*.7, sh*.7
	local isAnimating = true
	local lastCurUser, lastCurTeam, lastCurRank
	local curUser, curTeam, curRank

	local wlFrame = uiCreate( "EditablePanel" )
	wlFrame:SizeTo( wbw, wbh, .2, 0, -1 )
	wlFrame:SetAlpha( 0 )
	wlFrame:AlphaTo( 255, 0.2, 0 )
	wlFrame:Center()
	wlFrame:MakePopup()
	wlFrame.Paint = function( self, w, h )
		drawBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
		drawText( "Jobs Menu", "XL:Scoreboard:Title", w*.02, h*.05, whiteColor, 0, 1)
	end
	wlFrame.Think = function()
		if isAnimating then
			wlFrame:Center()
		end
	end

	local closeBtn = uiCreate( "DButton", wlFrame )
	closeBtn:SetSize( 26, 26 )
	closeBtn:SetPos( wbw-40, 10 )
	closeBtn:SetText("")
	closeBtn.lerp = 0
	closeBtn.Paint = function( self, w, h )
		drawBox( 5, 0, 0, w, h, Color( 240, 0, 52, self.lerp ) )
		drawText( "X", "XL:Scoreboard:Names", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )

		if self:IsHovered() then
			self.lerp = xLerp( frameTime()*8, self.lerp, 255 )
		else
			self.lerp = xLerp( frameTime()*8, self.lerp, 0 )
		end
	end

	closeBtn.DoClick = function()
		wlFrame:SizeTo( 0, 0, .2, 0, -1 )
		timer.Simple( .3, function() wlFrame:Remove() end)
	end

	local cbColor, ctColor = Color( 40, 40, 40 ), Color( 70, 70, 70 )
	local confirmBtn = uiCreate( "DButton", wlFrame )
	confirmBtn:SetSize( wbw*.31, wbh*.08 )
	confirmBtn:SetPos( wbw*.68, wbh*.9 )
	confirmBtn:SetText("")
	confirmBtn.rl, confirmBtn.gl, confirmBtn.bl = 0, 184, 89
	confirmBtn.Paint = function( self, w, h )
		drawBox( 5, 0, 0, w, h, cbColor )
		drawText( "Установить", "XL:Scoreboard:Teams", w/2, h/2, ctColor, 1, 1 )

		if curUser ~= nil and curTeam ~= nil then
			cbColor = Color( self.rl, self.gl, self.bl )
			ctColor = Color( 255, 255, 255 )

			if self:IsHovered() then
				self.rl = xLerp( frameTime()*8, self.rl, 116 )
				self.gl = xLerp( frameTime()*8, self.gl, 0 )
				self.bl = xLerp( frameTime()*8, self.bl, 255 )
			else
				self.rl = xLerp( frameTime()*8, self.rl, 0 )
				self.gl = xLerp( frameTime()*8, self.gl, 184 )
				self.bl = xLerp( frameTime()*8, self.bl, 89 )
			end
		else
			cbColor = Color( 40, 40, 40 )
			ctColor = Color( 70, 70, 70 )
		end

	end

	confirmBtn.DoClick = function()

		if curUser == nil or curTeam == nil then return end
		netStart( "XL:Whitelist:SetTeam" )
		writeEntity( curUser )
		writeUInt( curTeam, 9 )

		if curRank ~= nil then
			writeUInt( curRank, 9 )
		end
		
		sendToServer()

	end

	local plist = uiCreate( "DScrollPanel", wlFrame )
	plist:SetSize( wbw*.25, wbh*.881 )
	plist:SetPos( wbw*.01, wbh*.1 )
	plist.Paint = function(self,w,h) drawBox( 0, 0, 0, w, h, Color( 25, 25, 25 ) ) end

	for i,v in next, getPlayers() do

		local playerGroup = XL.ScoreboardGroups[v:GetUserGroup()]
		local playerBtn = uiCreate( "DButton", plist )
		playerBtn:Dock( TOP )
		playerBtn:DockMargin(0, 0, 0, 5)
		playerBtn:SetSize( wbw*.25, wbh*.07 )
		playerBtn:SetText("")
		playerBtn.lerp = 0
		playerBtn.slerp = 0
		playerBtn.Paint = function( self, w, h )
			drawBox( 0, 0, 0, w, h, Color( 35, 35, 35 ) )
			drawBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )
			drawBox( 0, 0, 0, self.slerp, h, Color( 116, 0, 255 ) )

			drawText( v:Nick(), "XL:Scoreboard:Names", w*.23, h*.35, whiteColor, 0, 1 )
			drawText( playerGroup.name, "XL:Scoreboard:Groups", w*.23, h*.75, playerGroup.color, 0, 1 )
			drawText( XL:GetTeamName(v), "XL:Scoreboard:Names", w*.65, h/2, whiteColor, 1, 1 )

			if self:IsHovered() then
				self.lerp = xLerp( frameTime()*8, self.lerp, w*.03 )
			else
				self.lerp = xLerp( frameTime()*8, self.lerp, 0 )
			end

			if self.selected then
				self.slerp = xLerp( frameTime()*8, self.slerp, w+1 )
			else
				self.slerp = xLerp( frameTime()*8, self.slerp, 0 )
			end
		end
		playerBtn.Think = function()
			if not isValid( v ) then
				playerBtn:Remove()
			end
		end

		local playerAvatar = uiCreate( "AvatarImage", playerBtn )
		playerAvatar:SetSize( playerBtn:GW(.13), playerBtn:GT(.8) )
		playerAvatar:SetPos( playerBtn:GW(.07), playerBtn:GT(.1) )
		playerAvatar:SetPlayer( v, 64 )

		playerBtn.DoClick = function()
			if lastCurUser ~= nil then
				lastCurUser.selected = false
			end

			if lastCurUser == playerBtn then
				lastCurUser = nil
				playerBtn.selected = false
				curUser = nil
			else
				lastCurUser = playerBtn
				playerBtn.selected = true
				curUser = v
			end
		end

	end

	local rlist = uiCreate( "DScrollPanel", wlFrame )
	rlist:SetSize( wbw*.31, wbh*.78 )
	rlist:SetPos( wbw*.68, wbh*.1 )
	rlist.Paint = function(self,w,h) drawBox( 0, 0, 0, w, h, Color( 25, 25, 25 ) ) end

	local function ShowRanks( team )

		rlist:Clear()
		if team.ranks ~= nil then

			local rank = team.ranks
			for i,v in next, rank do

				local rankBtn = uiCreate( "DButton", rlist )
				rankBtn:Dock( TOP )
				rankBtn:DockMargin(0, 0, 0, 5)
				rankBtn:SetSize( wbw*.25, wbh*.07 )
				rankBtn:SetText("")
				rankBtn.lerp = 0
				rankBtn.slerp = 0
				rankBtn.Paint = function( self, w, h )
					drawBox( 0, 0, 0, w, h, Color( 35, 35, 35 ) )
					drawBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )
					drawBox( 0, 0, 0, self.slerp, h, Color( 116, 0, 255 ) )

					drawText( v.name, "XL:Scoreboard:Names", w*.25, h/2, v.color, 0, 1 )

					if self:IsHovered() then
						self.lerp = xLerp( frameTime()*8, self.lerp, w*.02 )
					else
						self.lerp = xLerp( frameTime()*8, self.lerp, 0 )
					end

					if self.selected then
						self.slerp = xLerp( frameTime()*8, self.slerp, w+1 )
					else
						self.slerp = xLerp( frameTime()*8, self.slerp, 0 )
					end
				end

				local rankAvatar = uiCreate( "DModelPanel", rankBtn )
				rankAvatar:SetSize( rankBtn:GW(.13), rankBtn:GT(.8) )
				rankAvatar:SetPos( rankBtn:GW(.07), rankBtn:GT(.1) )
				rankAvatar:SetModel( team.models[1] )
				rankAvatar:SetFOV( 8 )
				rankAvatar:SetCamPos( Vector( 50, 50, 80 ) )
				rankAvatar:SetLookAt( Vector( 0, -4, 65 ) )
				rankAvatar.LayoutEntity = function() return end

				rankBtn.DoClick = function()
					if lastCurRank ~= nil then
						lastCurRank.selected = false
					end

					if lastCurRank == rankBtn then
						lastCurRank = nil
						rankBtn.selected = false
						curRank = nil
					else
						lastCurRank = rankBtn
						rankBtn.selected = true
						curRank = i
					end
				end

			end

		end

	end

	local jlist = uiCreate( "DScrollPanel", wlFrame )
	jlist:SetSize( wbw*.4, wbh*.881 )
	jlist:SetPos( wbw*.27, wbh*.1 )
	jlist.Paint = function(self,w,h) drawBox( 0, 0, 0, w, h, Color( 25, 25, 25 ) ) end

	for i,v in next, XL.Teams do

		local teamBtn = uiCreate( "DButton", jlist )
		teamBtn:Dock( TOP )
		teamBtn:DockMargin(0, 0, 0, 5)
		teamBtn:SetSize( wbw*.25, wbh*.07 )
		teamBtn:SetText("")
		teamBtn.lerp = 0
		teamBtn.slerp = 0
		teamBtn.Paint = function( self, w, h )
			drawBox( 0, 0, 0, w, h, Color( 35, 35, 35 ) )
			drawBox( 0, 0, 0, self.lerp, h, Color( 116, 0, 255 ) )
			drawBox( 0, 0, 0, self.slerp, h, Color( 116, 0, 255 ) )

			drawText( v.name, "XL:Scoreboard:Names", w*.25, h/2, v.color, 0, 1 )
			drawText( "Ranks: " .. ( ( v.ranks ~= nil and #v.ranks ) or 0 ), "XL:Scoreboard:Names", w*.65, h/2, whiteColor, 0, 1 )

			if self:IsHovered() then
				self.lerp = xLerp( frameTime()*8, self.lerp, w*.02 )
			else
				self.lerp = xLerp( frameTime()*8, self.lerp, 0 )
			end

			if self.selected then
				self.slerp = xLerp( frameTime()*8, self.slerp, w+1 )
			else
				self.slerp = xLerp( frameTime()*8, self.slerp, 0 )
			end
		end

		local teamAvatar = uiCreate( "DModelPanel", teamBtn )
		teamAvatar:SetSize( teamBtn:GW(.13), teamBtn:GT(.8) )
		teamAvatar:SetPos( teamBtn:GW(.07), teamBtn:GT(.1) )
		teamAvatar:SetModel( v.models[1] )
		teamAvatar:SetFOV( 8 )
		teamAvatar:SetCamPos( Vector( 50, 50, 80 ) )
		teamAvatar:SetLookAt( Vector( 0, -4, 65 ) )
		teamAvatar.LayoutEntity = function() return end

		teamBtn.DoClick = function()
			if lastCurTeam ~= nil then
				lastCurTeam.selected = false
			end

			if lastCurTeam == teamBtn then
				lastCurTeam = nil
				teamBtn.selected = false
				curTeam = nil
			else
				lastCurTeam = teamBtn
				teamBtn.selected = true
				curTeam = i
			end

			ShowRanks(v)
		end

	end

end

local nwReceive = net.Receive
nwReceive( "XL:Whitelist:OpenMenu", WhitelistOpen )
concommand.Add( "debug.whitelist", WhitelistOpen )