local createFont = surface.CreateFont
local scaleToScreen = ScreenScale
local sbFrame

createFont( "XL:Scoreboard:Title", { font = "Istok Web Bold", size = scaleToScreen(18), weigth = 2000, extended = true } )
createFont( "XL:Scoreboard:Names", { font = "Istok Web", size = scaleToScreen(12), weigth = 100, extended = true } )
createFont( "XL:Scoreboard:Groups", { font = "Istok Web", size = scaleToScreen(10), weigth = 1000, extended = true } )
createFont( "XL:Scoreboard:Teams", { font = "Istok Web", size = scaleToScreen(16), weigth = 1000, extended = true } )
local function ScoreboardOpen()

	local uiCreate = vgui.Create
	local drawBox, drawText = draw.RoundedBox, draw.SimpleText
	local xLerp, frameTime = Lerp, FrameTime
	local getHostName = GetHostName
	local getPlayers, getPlayerCounts = player.GetAll, player.GetCount
	local isValid = IsValid
	local sw, sh = ScrW(), ScrH()
	local sbw, sbh = sw*.7, sh*.8
	local lastpanel

	sbFrame = uiCreate( "EditablePanel" )
	sbFrame:SetSize( sbw, sbh )
	sbFrame:SetAlpha( 0 )
	sbFrame:AlphaTo( 255, 0.2, 0 )
	sbFrame:Center()
	sbFrame:MakePopup()
	sbFrame.Paint = function( self, w, h )
		drawBox( 40, 0, 0, w, h, Color( 30, 30, 30 ) )
		drawText( getHostName(), "XL:Scoreboard:Title", w/2, h*.05, whiteColor, 1, 1)
		drawText( "Players:", "XL:Scoreboard:Names", w*.85, h*.05, Color( 112, 112, 112 ), 1, 1)
		drawText( getPlayerCounts() .. " / 64", "XL:Scoreboard:Names", w*.89, h*.05, Color( 112, 112, 112 ), 0, 1)
	end

	local list = uiCreate( "DScrollPanel", sbFrame )
	list:SetSize( sbw*.9, sbh*.85 )
	list:SetPos( sbw*.05, sbh*.1 )
	--list.Paint = function(self,w,h) drawBox( 0, 0, 0, w, h, whiteColor ) end

	for i,v in next, getPlayers() do

		local pw, ph = list:GW(), list:GT(.09)
		local pingColor
		local pnl = uiCreate( "DButton", list )
		pnl:Dock( TOP )
		pnl:DockMargin(0,0,0,5)
		pnl:SetSize( pw, ph )
		pnl:SetText("")
		pnl.Think = function() if not isValid(v) then pnl:Remove() end end
		pnl.lerp = 0
		pnl.Paint = function( self, w, h )
			drawBox( 0, 0, 0, w, h, Color( 58, 58, 58 ) )
			drawBox( 0, 0, 0, self.lerp, h, Color( 217, 217, 217 ) )

			drawText( v:Nick(), "XL:Scoreboard:Names", pw*.08, ph*.35, Color( 255, 255, 255 ), 0, 1 )
			drawText( XL.ScoreboardGroups[v:GetUserGroup()].name, "XL:Scoreboard:Groups", pw*.08, ph*.75, XL.ScoreboardGroups[v:GetUserGroup()].color, 0, 1 )
			drawText( XL:GetTeamName(v), "XL:Scoreboard:Teams", pw/2, ph/2, v:GetTeam().color, 1, 1 )

			if v:Ping() <= 60 then
				pingColor = Color( 0, 255, 102 )
			elseif v:Ping() <= 100 then
				pingColor = Color( 255, 122, 0 )
			else
				pingColor = Color( 255, 0, 77 )
			end

			drawText( "Ping:", "XL:Scoreboard:Groups", pw*.945, ph/2, whiteColor, 1, 1 )
			drawText( v:Ping(), "XL:Scoreboard:Groups", pw*.975, ph/2, pingColor, 1, 1 )

			if self:IsHovered() then
				self.lerp = xLerp( frameTime()*12, self.lerp, w*.009 )
			else
				self.lerp = xLerp( frameTime()*12, self.lerp, 0 )
			end
		end

		pnl.DoClick = function()

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

		end

		local avatar = uiCreate( "AvatarImage", pnl )
		avatar:SetSize( list:GW(.045), pnl:GT(.8) )
		avatar:SetPos( pw*.018, ph*.1 )
		avatar:SetPlayer( v, 64 )

	end
	return false

end

local hookAdd = hook.Add
local timerSimple = timer.Simple
hookAdd( "ScoreboardShow", "XL:ScoreboardShow", ScoreboardOpen )
hookAdd( "ScoreboardHide", "XL:ScoreboardShow", function() sbFrame:ARemove(0.2) end)
--concommand.Add( "debug.scoreboard", ScoreboardOpen )