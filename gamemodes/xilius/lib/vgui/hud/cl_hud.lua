local drawBox, drawExBox, drawText, drawCircle, drawNoMat = draw.RoundedBox, draw.RoundedBoxEx, draw.SimpleText, draw.Circle, draw.NoTexture
local createFont, setColor = surface.CreateFont, surface.SetDrawColor
local lerp, frameTime = Lerp, FrameTime
local scaleToScreen = ScreenScale
local sw, sh = ScrW(), ScrH()
local lp = LocalPlayer
local hook = hook.Add

local pl
local wep

local healthW
local healthL = 0
local health = 100

local armorW
local armorP1
local armorP2
local armorL1 = 0
local armorL2 = 0
local armorL3 = 0
local armorL4 = 0
local armor = 0

local wepBlacklist = {
	["weapon_physgun"] = true,
	["hands"] = true,
	["gmod_camera"] = true,
	["gmod_tool"] = true,
}

createFont( "XL:Hud:Percentage", {
	font = "Montserrat Light",
	size = scaleToScreen(12),
	weight = 100
})

createFont( "XL:Hud:Ammo", {
	font = "Montserrat",
	size = scaleToScreen(20),
	weight = 500
})

createFont( "XL:Hud:Clip", {
	font = "Montserrat Light",
	size = scaleToScreen(18),
	weight = 100
})

local function hudPaint()

	pl = lp()

	health = pl:Health()
	healthW = sw*.215/pl:GetMaxHealth()
	healthL = lerp( frameTime()*6, healthL, healthW*health )

	armor = pl:Armor()
	armorP1 = pl:GetMaxArmor()/4
	armorP2 = 0
	armorW = sw*.05/armorP1
	--print( armor, armor%4, armorP2 )

	if armor >= 0 and armor <= armorP1 then
		armorP2 = armor
		armorL1 = lerp( frameTime()*6, armorL1, armorW*armorP2 )
		armorL2 = lerp( frameTime()*6, armorL2, 0 )
		armorL3 = lerp( frameTime()*6, armorL3, 0 )
		armorL4 = lerp( frameTime()*6, armorL4, 0 )
	elseif armor > armorP1 and armor <= armorP1*2 then
		armorP2 = armor - armorP1
		armorL1 = lerp( frameTime()*6, armorL1, sw*.05 )
		armorL2 = lerp( frameTime()*6, armorL2, armorW*armorP2 )
		armorL3 = lerp( frameTime()*6, armorL3, 0 )
		armorL4 = lerp( frameTime()*6, armorL4, 0 )
	elseif armor > armorP1*2  and armor <= armorP1*3 then
		armorP2 = armor - armorP1*2
		armorL1 = lerp( frameTime()*6, armorL1, sw*.05 )
		armorL2 = lerp( frameTime()*6, armorL2, sw*.05 )
		armorL3 = lerp( frameTime()*6, armorL3, armorW*armorP2 )
		armorL4 = lerp( frameTime()*6, armorL4, 0 )
	elseif armor > armorP1*3  and armor <= armorP1*4 then
		armorP2 = armor - armorP1*3
		armorL1 = lerp( frameTime()*6, armorL1, sw*.05 )
		armorL2 = lerp( frameTime()*6, armorL2, sw*.05 )
		armorL3 = lerp( frameTime()*6, armorL3, sw*.05 )
		armorL4 = lerp( frameTime()*6, armorL4, armorW*armorP2 )
	else
		armorP2 = armor - armorP1*3
		armorL1 = lerp( frameTime()*6, armorL1, sw*.05 )
		armorL2 = lerp( frameTime()*6, armorL2, sw*.05 )
		armorL3 = lerp( frameTime()*6, armorL3, sw*.05 )
		armorL4 = lerp( frameTime()*6, armorL4, armorW*armorP2 )
	end

	drawNoMat()
	setColor( 0, 0, 0 )
	drawCircle( sw/2, sh/2, 4.5, 10 )
	setColor( 255, 255, 255 )
	drawCircle( sw/2, sh/2, 3, 10 )

	drawBox( 6, sw*.015, sh*.9, sw*.215, sh*.022, Color( 0, 0, 0, 173 ) )
	drawBox( 6, sw*.015, sh*.9, healthL, sh*.022, Color( 255, 255, 255 ) )
	drawText( health .. "%", "XL:Hud:Percentage", sw*.234, sh*.909, Color( 255, 255, 255 ), 0, 1 )

	drawExBox( 5, sw*.015, sh*.93, sw*.05, sh*.022, Color( 0, 0, 0, 173 ), true, false, true, false )
	drawExBox( 5, sw*.015, sh*.93, armorL1, sh*.022, Color( 44, 109, 185 ), true, false, true, false )

	drawExBox( 5, sw*.07, sh*.93, sw*.05, sh*.022, Color( 0, 0, 0, 173 ) )
	drawExBox( 5, sw*.07, sh*.93, armorL2, sh*.022, Color( 44, 109, 185 ) )

	drawExBox( 5, sw*.125, sh*.93, sw*.05, sh*.022, Color( 0, 0, 0, 173 ) )
	drawExBox( 5, sw*.125, sh*.93, armorL3, sh*.022, Color( 44, 109, 185 ) )

	drawExBox( 5, sw*.18, sh*.93, sw*.05, sh*.022, Color( 0, 0, 0, 173 ), false, true, false, true )
	drawExBox( 5, sw*.18, sh*.93, armorL4, sh*.022, Color( 44, 109, 185 ), false, true, false, true )

	if pl:Alive() and pl:GetActiveWeapon() ~= nil and not wepBlacklist[pl:GetActiveWeapon():GetClass()] then
		wep = pl:GetActiveWeapon()
		
		drawText( wep:Clip1(), "XL:Hud:Ammo", sw*.93, sh*.9, Color( 255, 255, 255 ), 2, 1 )
		drawText( pl:GetAmmoCount( wep:GetPrimaryAmmoType() ), "XL:Hud:Clip", sw*.935, sh*.91, Color( 255, 255, 255 ), 0, 1 )
	end

end

hook( "HUDPaint", "XL:Hud", hudPaint )