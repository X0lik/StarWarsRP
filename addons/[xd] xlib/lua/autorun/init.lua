XD = XD or {}
file.CreateDir( 'xd.logs' )

local initmessage = [[


|  ████╗██╗  ██╗██╗     ██╗██████╗ ████╗
|  ██╔═╝╚██╗██╔╝██║     ██║██╔══██╗╚═██║
|  ██║   ╚███╔╝ ██║     ██║██████╦╝  ██║
|  ██║   ██╔██╗ ██║     ██║██╔══██╗  ██║
|  ████╗██╔╝╚██╗███████╗██║██████╦╝████║
|  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚═══╝

]]

MsgC( Color( 54, 102, 191 ), initmessage )

XD.LogFile = 1
XD.DefaultColor = Color( 54, 102, 191 )
XD.RedColor = Color( 220, 20, 60 )
XD.GreenColor = Color( 0, 255, 170 )

function XD:CLog( prefix, message, submessage, color )

  if SERVER then
    if submessage == nil then
        MsgC( color, '| ', XD.DefaultColor, '[XLib] ', Color( 255, 255, 255 ), prefix .. ': ', Color( 54, 191, 143 ), message .. '\n' )
    else
        MsgC( color, '| ', XD.DefaultColor, '[XLib] ', Color( 255, 255, 255 ), prefix .. ': ', Color( 54, 191, 143 ), message, Color( 255, 255, 255 ), ' - ' .. submessage .. '\n' )
    end
  end

end

local cmsg
function XD:ChatLog( ply, message, submessage, color )

    if submessage == nil then
        cmsg = "chat.AddText( Color(" .. color.r .. ',' .. color.g .. ',' .. color.b .. "), '| ', Color( 54, 102, 191 ), '[XLib] ', Color( 255, 255, 255 ), '" .. message .. "' )"
    else
        cmsg = "chat.AddText( Color(" .. color.r .. ',' .. color.g .. ',' .. color.b .. "), '| ', Color( 54, 102, 191 ), '[XLib] ', Color( 255, 255, 255 ), '" .. message .. " ( " .. submessage .. " )' )"
    end

    ply:SendLua( cmsg )

end

function XD:PChatLog( message, submessage, color )

    if submessage == nil then
        chat.AddText( color, '| ', XD.DefaultColor, '[XLib] ', Color( 255, 255, 255 ), message )
    else
        chat.AddText( color, '| ', XD.DefaultColor, '[XLib] ', Color( 255, 255, 255 ), message, color, ' ( ' .. submessage .. ' )' )
    end

end

function XD:LogThis( log )
  if file.Size( 'xd.logs/' .. XD.LogFile .. '_logfile.txt', 'DATA' ) >= 8192 then
    XD.LogFile = XD.LogFile + 1
    file.Append( 'xd.logs/' .. XD.LogFIle .. '_logfile.txt', log .. '\n' )
  else
    file.Append( 'xd.logs/' .. XD.LogFIle .. '_logfile.txt', log .. '\n' )
  end
end

function XD:LuaInclude( part, dir, file )

    if part == 'sv' then
        if SERVER then
            include( 'xlib/' .. dir .. '/' .. file )
        end
    elseif part == 'sh' then
        if SERVER then
            AddCSLuaFile( 'xlib/' .. dir .. '/' .. file )
            include( 'xlib/' .. dir .. '/' .. file  )
        end

        if CLIENT then
           include( 'xlib/' .. dir .. '/' .. file  )
        end
    elseif part == 'cl' then
        if SERVER then
          AddCSLuaFile( 'xlib/' .. dir .. '/' .. file )
        end

        if CLIENT then
           include( 'xlib/' .. dir .. '/' .. file  )
        end
    end

end

function XD:LuaSubInclude( part, dir, subdir, file )

    if part == 'sv' then
        if SERVER then
            include( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file )
        end
    elseif part == 'sh' then
        if SERVER then
            AddCSLuaFile( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file )
            include( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end

        if CLIENT then
           include( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end
    elseif part == 'cl' then
        if SERVER then
          AddCSLuaFile( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file )
        end

        if CLIENT then
           include( 'xlib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end
    end

end

local func = file.Find( 'xlib/functions/*', 'LUA' )
for _, v in ipairs( func ) do

    if string.StartWith( v, 'sv' ) then
        XD:LuaInclude( 'sv', 'functions', v )
        XD:CLog( 'SV Functions Loaded', v, nil, Color( 54, 102, 191 ) )
    elseif string.StartWith( v, 'sh' ) then
        XD:LuaInclude( 'sh', 'functions', v )
        XD:CLog( 'SH Functions Loaded', v, nil, Color( 54, 102, 191 ) )
    elseif string.StartWith( v, 'cl' ) then
        XD:LuaInclude( 'cl', 'functions', v )
        XD:CLog( 'CL Functions Loaded', v, nil, Color( 54, 102, 191 ) )
    end

end

local mfiles, mdirs = file.Find( 'xlib/modules/*', 'LUA' )
local msdirs
for i, v in ipairs( mdirs ) do

    msdirs = file.Find( 'xlib/modules/' .. v .. '/*', 'LUA' )
    for j, k in ipairs( msdirs ) do
        if string.StartWith( k, 'sv' ) then
            XD:LuaSubInclude( 'sv', 'modules', v, k )
            XD:CLog( 'SV Modules Loaded', v, nil, Color( 54, 102, 191 ) )
        elseif string.StartWith( k, 'sh' ) then
            XD:LuaSubInclude( 'sh', 'modules', v, k )
            XD:CLog( 'SH Modules Loaded', v, nil, Color( 54, 102, 191 ) )
        elseif string.StartWith( k, 'cl' ) then
            XD:LuaSubInclude( 'cl', 'modules', v, k )
            XD:CLog( 'CL Modules Loaded', v, nil, Color( 54, 102, 191 ) )
        end
    end

end
