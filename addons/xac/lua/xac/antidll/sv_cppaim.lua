--https://discord.com/api/webhooks/1128106356533104750/F0xnku3O1OiVSZV6U6rd6InKsm9kaZYu7a4N1xMz_KJ0eNEXRcnUOdeWeZ8Ywb8MBKwE

local _CurTime = CurTime
local _IsValid = IsValid
local _hook_Add = hook.Add
local _math_abs = math.abs
local _util_TraceLine = util.TraceLine
local _EyePos = (CLIENT and EyePos or NULL)
local tr

local Blacklisted_Weapons = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["weapon_physcannon"] = true,
    ["hands"] = true,
}

_hook_Add( "StartCommand", "XAC:AntiAim", function( ply, cmd )

    --if not _IsValid( ply ) or not _IsValid(ply.XACFullyLoaded) or not ply.XACFullyLoaded or ply:IsTimingOut() or ply:InVehicle() or not ply:Alive() or ply:GetObserverMode() ~= OBS_MODE_NONE or ply:IsBot() or not _IsValid( ply ) or ply:PacketLoss() > 80 then return end

    if not IsValid( ply ) or not ply:Alive() then return end
    if _IsValid( ply:GetActiveWeapon() ) && Blacklisted_Weapons[ ply:GetActiveWeapon():GetClass() ] then 
        ply.aimbotDetections = 0
        return 
    end

    ply.aimCPPMX = _math_abs( cmd:GetMouseX() )
    ply.aimCPPMY = _math_abs( cmd:GetMouseY() )
    ply.aimView = cmd:GetViewAngles()

    if ply.aimViewOld == nil then
        ply.aimViewOld = ply.aimView
        return
    end

    if ply.aimbotDetections == nil then
        ply.aimbotDetections = 0
    end

    if ply.aimCPPMX == 0 && ply.aimCPPMY == 0 then
        if ( ply.aimView.p ~= ply.aimViewOld.p && ply.aimView.y ~= ply.aimViewOld.y ) then
            tr = _util_TraceLine( {start = ply:EyePos(), endpos = ply:EyePos() + ( (ply.aimView):Forward() * (4096 * 8) ), filter = ply } )
        	if tr.Entity:IsPlayer() then
                if ply.aimbotDetections >= 40 then
                    ply:XACBan( "AimBot Detected" )
                elseif ply.aimbotDetections >= 20 then
                	if not ply.XACAimDetected then
                		XAC:Log( ply:Nick() .. " probably cheating (aimbot)" )
                		XL:DiscordLog( ":shield: XAC | Detect", "**Player:** " .. ply:Nick() .. " (" .. ply:SteamID() .. ")\n**Type:** AimBot\n**Details:** 10 shots to the same place\n", redColor )
                		ply.XACAimDetected = true
                	end
                	ply.aimbotDetections = ply.aimbotDetections + 1
                else
                    ply.aimbotDetections = ply.aimbotDetections + 1
                    if ply.aimbotDetections == 0 then
                    	ply.XACAimDetected = true
                    end
                end
            elseif ply.aimbotDetections != 0 then
                ply.aimbotDetections = ply.aimbotDetections - 1
            end
        elseif ply.aimbotDetections != 0 then
            ply.aimbotDetections = 0
        end
    elseif ply.aimbotDetections != 0 then
        ply.aimbotDetections = 0
    end

    ply.aimViewOld = ply.aimView

end)