if SERVER then
    AddCSLuaFile( "xilius/config.lua" )
    include( "xilius/config.lua" )
end
if CLIENT then
    include( "xilius/config.lua" )
end
DeriveGamemode( "sandbox" )
GM.Name = "Xilius: StarWarsRP"
GM.Author = "X0lik"

defaultColor = Color( 54, 102, 191 )
greenColor = Color( 54, 191, 143 )
orangeColor = Color( 255, 153, 0 )
redColor = Color( 220, 20, 60 )
whiteColor = Color( 255, 255, 255 )

function XL:Log( prefix, message, color, submessage )

    if SERVER then
        local prefixColor = defaultColor
        if color ~= greenColor then
            prefixColor = color
        end
        if submessage == nil then
            MsgC( prefixColor, '| ', defaultColor, '[XLib] ', whiteColor, prefix .. ': ', color, message .. '\n' )
        else
            MsgC( prefixColor, '| ', defaultColor, '[XLib] ', whiteColor, prefix .. ': ', color, message, whiteColor, ' - ' .. submessage .. '\n' )
        end
    end

end

local function LoadFile( part, dir, file )

    if part == 'sv' then
        if SERVER then
            include( 'xilius/lib/' .. dir .. '/' .. file )
        end
    elseif part == 'sh' then
        if SERVER then
            AddCSLuaFile( 'xilius/lib/' .. dir .. '/' .. file )
            include( 'xilius/lib/' .. dir .. '/' .. file  )
        end

        if CLIENT then
           include( 'xilius/lib/' .. dir .. '/' .. file  )
        end
    elseif part == 'cl' then
        if SERVER then
          AddCSLuaFile( 'xilius/lib/' .. dir .. '/' .. file )
        end

        if CLIENT then
           include( 'xilius/lib/' .. dir .. '/' .. file  )
        end
    end

end

local function LoadSubFile( part, dir, subdir, file )

    if part == 'sv' then
        if SERVER then
            include( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file )
        end
    elseif part == 'sh' then
        if SERVER then
            AddCSLuaFile( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file )
            include( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end

        if CLIENT then
           include( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end
    elseif part == 'cl' then
        if SERVER then
          AddCSLuaFile( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file )
        end

        if CLIENT then
           include( 'xilius/lib/' .. dir .. '/' .. subdir .. '/' .. file  )
        end
    end

end

local msdirs
local mfiles, mdirs = file.Find( "xilius/lib/*", "LUA" )
for i, v in next, mdirs do

    mfiles = file.Find( "xilius/lib/" .. v .. "/*", "LUA" )
    for k, j in next, mfiles do


        if not XL.Modules[v] then
            XL:Log( "Module disabled", v, orangeColor )
        else
            if string.StartWith( j, "sv" ) then
                LoadFile( "sv", v, j )
            elseif string.StartWith( j, "sh" ) then
                LoadFile( "sh", v, j )
            elseif string.StartWith( j, "cl" ) then
                LoadFile( "cl", v, j )
            end
        end
    end
    if XL.Modules[v] then
        XL:Log( "Load Module", v, greenColor )
    end

end

mfiles, mdirs = file.Find( "xilius/lib/*", "LUA" )
for i, v in ipairs( mdirs ) do

    mfiles = select( 2, file.Find( "xilius/lib/" .. v .. "/*", "LUA" ) )
    for k, j in ipairs( mfiles ) do

        msdirs = select( 2, file.Find( "xilius/lib/" .. v .. "/" .. "k" .. "/*", "LUA" ) )
        for l, m in next, msdirs do
            
            --[[if not XL.Modules[v.."/"..j] then
                XL:Log( "SubModule disabled", v .. "/" .. j, orangeColor )
                return
            end]]
            if string.StartWith( m, "sv" ) then
                LuaSubFile( "sv", v, j, m )
            elseif string.StartWith( m, "sh" ) then
                LuaSubFile( "sh", v, j, m )
            elseif string.StartWith( m, "cl" ) then
                LuaSubFile( "cl", v, j, m )
            end
        end
        XL:Log( "Load SubModule", v .. "/" .. j, greenColor )

    end

end

function GM:Initialize()
	-- Do stuff
end

function GM:CreateTeams()
    for i,v in next, XL.Teams do
        team.SetUp( i, XL.Teams[i].name, XL.Teams[i].color )
        team.SetClass( XL.TeamsCount, {"player_default"} )
    end
end