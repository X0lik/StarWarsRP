local drawBox, drawText = draw.RoundedBox, draw.SimpleText
local lerp, frameTime = Lerp, FrameTime
local createFont = surface.CreateFont
local scaleToScreen = ScreenScale
local sw, sh = ScrW(), ScrH()
local lp = LocalPlayer

local healthW
local healthL = 0
local health = 100

createFont( "XL:Hud:Percentage", {
	font = "Montserrat Light",
	size = scaleToScreen(12),
	weight = 100
})

local function hudPaint()

	health = lp():Health()
	healthW = sw*.16/lp():GetMaxHealth()
	healthL = lerp( frameTime()*6, healthL, healthW*health )

	drawBox( 6, sw*.015, sh*.9, sw*.16, sh*.022, Color( 0, 0, 0, 173 ) )
	drawBox( 6, sw*.015, sh*.9, healthL, sh*.022, Color( 255, 255, 255 ) )
	drawText( health .. "%", "XL:Hud:Percentage", sw*.179, sh*.909, Color( 255, 255, 255 ), 0, 1 )

end

local hook = hook.Add
hook( "HUDPaint", "XL:Hud", hudPaint )