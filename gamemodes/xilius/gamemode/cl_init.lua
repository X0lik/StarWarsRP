include( "shared.lua" )

function GM:HUDDrawTargetID()
	return false
end

function GM:DrawDeathNotice()
	return false
end

local hideHudTable = {
	["CHudAmmo"] = true, ["CHudBattery"] = true,  ["CHudCrosshair"] = true,
	["CHudDamageIndicator"] = true, ["CHudGeiger"] = true, ["CHudHealth"] = true, 
	["CHudSecondaryAmmo"] = true, ["CHudChat"] = true, ["CHudWeaponSelection"] = true 

}

function GM:HUDShouldDraw( name )
	if hideHudTable[name] then
		return false
	end
	return true
end