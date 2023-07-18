local createFont = surface.CreateFont
local scaleToScreen = ScreenScale
local drawBackgroundBlur = Derma_DrawBackgroundBlur
local uiCreate = vgui.Create
local drawBox, drawText = draw.RoundedBox, draw.SimpleText
local xLerp, frameTime = Lerp, FrameTime
local getPlayers, getPlayerCounts, getHostName = player.GetAll, player.GetCount, GetHostName
local isValid = IsValid
local teamColor = team.GetColor
local sbBase

createFont( "XL:Scoreboard:Title", { font = "Manrope Light", size = scaleToScreen(35), weight = 100, extended = true } )
createFont( "XL:Scoreboard:SubTitle", { font = "Manrope Light", size = scaleToScreen(9), weight = 5000 } )
createFont( "XL:Scoreboard:Player", { font = "Manrope", size = scaleToScreen(12), weight = 400, extended = true } )

local function ScoreboardOpen()
	local sw, sh = ScrW(), ScrH()
	local sbw, sbh = sw*.8, sh*.75
	local lastpanel

	sbBase = uiCreate( "EditablePanel" )
	sbBase:SetSize( sw, sh )
	sbBase:SetAlpha( 0 )
	sbBase:AlphaTo( 255, 0.2, 0 )
	sbBase:Center()
	sbBase:MakePopup()
	sbBase.Init = function() self.startTime = SysTime() end
	sbBase.Paint = function( self, w, h )
		drawBackgroundBlur(self, self.startTime)
	end

	local sbTitle = uiCreate( "EditablePanel", sbBase )
	sbTitle:SetSize( sw*.4, sh*.08 )
	sbTitle:SetPos( sw*.3, sh*.02 )
	sbTitle:SetAlpha( 0 )
	sbTitle:AlphaTo( 255, .3, .2 )
	sbTitle.Paint = function( self, w, h )
		drawText( "D  E  F  B  L  A  D  E", "XL:Scoreboard:Title", w/2, h/2, whiteColor, 1, 1 )
	end

	local sbSubTitle = uiCreate( "EditablePanel", sbBase )
	sbSubTitle:SetSize( sw*.5, sh*.04 )
	sbSubTitle:SetPos( sw*.25, sh*.1 )
	sbSubTitle:SetAlpha( 0 )
	sbSubTitle:AlphaTo( 255, .3, .2 )
	sbSubTitle.Paint = function( self, w, h )
		drawBox( 0, w*.22, h*.45, w*.45, h*.1, defaultColor )
		drawText( "STAR WARS ROLEPLAY", "XL:Scoreboard:SubTitle", w*.8, h/2, defaultColor, 1, 1 )
	end

	local list = uiCreate( "EditablePanel", sbBase )
	list:SetSize( sbw, sbh )
	list:SetAlpha( 0 )
	list:AlphaTo( 255, 0.2, .5 )
	list:SetPos( sw*.1, sh*.15 )

	--[[local list = uiCreate( "DScrollPanel", sbFrame )
	list:SetSize( sbw*.9, sbh*.85 )
	list:SetPos( sbw*.05, sbh*.1 )
	list.Paint = function(self,w,h) drawBox( 0, 0, 0, w, h, whiteColor ) end]]
	local pw, ph = list:GW(), list:GT(.07)

	for i,v in next, getPlayers() do

		local pingColor
		local teamColor = teamColor( v:Team() )
		local pnl = uiCreate( "DButton", list )
		pnl:Dock( TOP )
		pnl:DockMargin(0,0,0,5)
		pnl:SetSize( pw, ph )
		pnl:SetText("")
		pnl.Think = function() if not isValid(v) then pnl:Remove() end end
		pnl.lerp = 0
		pnl.r = teamColor.r
		pnl.g = teamColor.g
		pnl.b = teamColor.b
		pnl.Paint = function( self, w, h )
			drawBox( 0, 0, 0, w, h, Color( self.r, self.g, self.b ) )

			drawText( v:Nick(), "XL:Scoreboard:Player", pw*.05, ph/2, whiteColor, 0, 1 )
			drawText( v:GetNWString( "XL:TeamName" ), "XL:Scoreboard:Player", pw*.35, ph/2, whiteColor, 1, 1 )
			drawText( XL.ScoreboardGroups[v:GetUserGroup()].name, "XL:Scoreboard:Player", pw*.55, ph/2, whiteColor, 0, 1 )
			drawText( "8,374" .. "CR", "XL:Scoreboard:Player", pw*.75, ph/2, whiteColor, 0, 1 )

			if v:Ping() <= 60 then
				pingColor = greenColor
			elseif v:Ping() <= 100 then
				pingColor = orangeColor
			else
				pingColor = redColor
			end

			drawText( "Ping:", "XL:Scoreboard:Groups", pw*.945, ph/2, whiteColor, 1, 1 )
			drawText( v:Ping(), "XL:Scoreboard:Groups", pw*.975, ph/2, pingColor, 1, 1 )

			if self:IsHovered() then
				self.r = xLerp( frameTime()*12, self.r, defaultColor.r )
				self.g = xLerp( frameTime()*12, self.g, defaultColor.g )
				self.b = xLerp( frameTime()*12, self.b, defaultColor.b )
			else
				self.r = xLerp( frameTime()*12, self.r, teamColor.r )
				self.g = xLerp( frameTime()*12, self.g, teamColor.g )
				self.b = xLerp( frameTime()*12, self.b, teamColor.b )
			end
		end

		--[[pnl.DoClick = function()

			if lastpanel ~= nil then
				lastpanel:SizeTo( pw, ph, .2, 0, -1 )
			end

			if lastpanel == pnl then
				lastpanel = nil
				pnl:SizeTo( pw, ph, .2, 0, -1 )
			else
				lastpanel = pnl
				pnl:SizeTo( pw, ph*2, .2, 0, -1 )
			end

		end]]

		local avatar = uiCreate( "AvatarImage", pnl )
		avatar:SetSize( list:GW(.04), pnl:GT() )
		avatar:SetPos( 0, 0 )
		avatar:SetPlayer( v, 128 )

	end
	return false

end

local hookAdd = hook.Add
local timerSimple = timer.Simple
hookAdd( "ScoreboardShow", "XL:ScoreboardShow", ScoreboardOpen )
hookAdd( "ScoreboardHide", "XL:ScoreboardShow", function() sbBase:ARemove(0.2) end)