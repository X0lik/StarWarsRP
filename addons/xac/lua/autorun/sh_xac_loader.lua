local XACMessage = [[


████╗██╗  ██╗ █████╗  █████╗ ████╗
██╔═╝╚██╗██╔╝██╔══██╗██╔══██╗╚═██║
██║   ╚███╔╝ ███████║██║  ╚═╝  ██║
██║   ██╔██╗ ██╔══██║██║  ██╗  ██║
████╗██╔╝╚██╗██║  ██║╚█████╔╝████║
╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝ ╚═══╝

]]

local selectThis, fileFind, includeFile, addCSFile, strSub, strLen = select, file.Find, include, AddCSLuaFile, string.sub, string.len
local dirs = select( 2, fileFind( "xac/*", "LUA" ) )
local function loadFile( dir, file )

	local part = strSub( file, 1, 2 )
    if part == "sv" then
        if SERVER then
            includeFile( "xac/" .. dir .. "/" .. file )
        end
    elseif part == "sh" then
        if SERVER then
            addCSFile( "xac/" .. dir .. "/" .. file )
            includeFile( "xac/" .. dir .. "/" .. file  )
        end

        if CLIENT then
           includeFile( "xac/" .. dir .. "/" .. file  )
        end
    elseif part == "cl" then
        if SERVER then
          addCSFile( "xac/" .. dir .. "/" .. file )
        end

        if CLIENT then
           includeFile( "xac/" .. dir .. "/" .. file  )
        end
    end

end

XAC = {}
function XAC:Log( message )
    if SERVER then
        MsgC( Color( 220, 20, 60 ), "| [XAC] ", Color( 255, 255, 255 ), message .. "\n" )
    end
end

if SERVER then
    MsgC( Color( 220, 20, 60 ), XACMessage )
else
    MsgC( Color( 220, 20, 60 ), "| [XAC] ", Color( 255, 255, 255 ), "Server protected by Xilius Anti-Cheat\n" )
end
XAC:Log( "Xilius Anti-Cheat Initializating.." )

for i,v in next, dirs do

    XAC:Log( "Loading " .. v .. " module.." )
	local files = fileFind( "xac/" .. v .. "/*", "LUA" )
	for j,k in next, files do
		loadFile( v, k )
	end

end
XAC:Log( "Protection enabled!" )


