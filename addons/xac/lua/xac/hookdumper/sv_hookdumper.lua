local strFind, strLower, addNetString, netReceive, netReadTable = string.find, string.lower, util.AddNetworkString, net.Receive, net.ReadTable
local badNames = {
	"wh", "wallhack", "wall",
	"aim", "aimbot", "trigger", "triggerbot", "bot",
	"bhop", "bh", "bunnyhop", "autojump",
	"antisg", "screengrab", "antiscreengrab",
	"auto", "cheats", "cheat", "hack", "crash", "crasher",
	"spamer",
}


local function checkHookName( hookName )

	for i,v in pairs( badNames ) do
		local isBadName = select( 1, strFind( strLower( hookName ), v ) )
		if isBadName then
			return true
		end
	end
	return false

end

addNetString( "XAC:HookDump" )
netReceive( "XAC:HookDump", function( _, ply )

	local unknownHooks = netReadTable()
	local strHooks = ""
	for i,v in next, unknownHooks do
		if checkHookName(v) then
			ply:XACBan( "Bad hooks (" .. v .. ")" )
			return
		end
		strHooks = strHooks .. v .. " "
	end

	local file = XAC:LogFile( "hookdump", ply:SteamID64(), strHooks )
	XAC:Log( ply:Nick() .. "(" .. ply:SteamID() .. ")" ..  " probably cheating" )
	XAC:Log( "Detected Hooks: " .. strHooks )
	XAC:Log( "Hooks saved to file: " .. file .. "\n" )
	XAC:DiscordLog( "Detect", ply, "Unknown Hooks", strHooks, file )

end)