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

function XL:Initialize()

    local msdirs, msfiles
    local mfiles, mdirs = file.Find( "xilius/lib/*", "LUA" )
    for i, v in next, mdirs do

        mfiles, msdirs = file.Find( "xilius/lib/" .. v .. "/*", "LUA" )
        for k, j in next, mfiles do

            if XL.Modules[v] then
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
        else
            XL:Log( "Module disabled", v, orangeColor )
        end

        for k, j in next, msdirs do

            msfiles = file.Find( "xilius/lib/" .. v .. "/" .. j .. "/*", "LUA" )
            for l, m in next, msfiles do
                if XL.Modules[v] then
                    if string.StartWith( m, "sv" ) then
                        LoadSubFile( "sv", v, j, m )
                    elseif string.StartWith( m, "sh" ) then
                        LoadSubFile( "sh", v, j, m )
                    elseif string.StartWith( m, "cl" ) then
                        LoadSubFile( "cl", v, j, m )
                    end
                end
            end
            --XL:Log( "Load SubModule", v .. "/" .. j, greenColor )
        end

    end

    --[[mfiles, mdirs = file.Find( "xilius/lib/*", "LUA" )
    for i, v in ipairs( mdirs ) do

        mfiles = select( 2, file.Find( "xilius/lib/" .. v .. "/*", "LUA" ) )
        for k, j in ipairs( mfiles ) do


            msdirs = select( 2, file.Find( "xilius/lib/" .. v .. "/" .. j .. "/*", "LUA" ) )
            for l, m in next, msdirs do
                    XL:Log( "Load Sasdasdasasdasdasdas", m, greenColor )
                if string.StartWith( m, "sv" ) then
                    LuaSubFile( "sv", v, j, m )
                elseif string.StartWith( m, "sh" ) then
                    LuaSubFile( "sh", v, j, m )
                elseif string.StartWith( m, "cl" ) then
                    LuaSubFile( "cl", v, j, m )
                end
            end

        end

    end]]

    XL:Log( "Loading Complete", "Modules", greenColor )
end

function GM:Initialize()
    --XL:Initialize()
end

XL:Initialize()

function GM:CreateTeams()
    timer.Simple( 0, function()
        for i,v in next, XL.Teams do
            team.SetUp( i, XL.Teams[i].name, XL.Teams[i].color )
            team.SetClass( i, {"player_default"} )
        end
    end)
end