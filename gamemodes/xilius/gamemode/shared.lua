if SERVER then
    AddCSLuaFile( "xilius/lib/config/general.lua" )
    include( "xilius/lib/config/general.lua" )
end

if CLIENT then
    include( "xilius/lib/config/general.lua" )
end

DeriveGamemode( "sandbox" )
GM.Name = "Xilius: StarWarsRP"
GM.Author = "X0lik"

defaultColor = Color( 0, 138, 235 )
greenColor = Color( 54, 191, 143 )
orangeColor = Color( 255, 153, 0 )
redColor = Color( 220, 20, 60 )
whiteColor = Color( 255, 255, 255 )

local msgC = MsgC
function XL:Log( prefix, message, color, submessage )

    if SERVER then
        local prefixColor = defaultColor
        if color ~= greenColor then
            prefixColor = color
        end
        if submessage == nil then
            msgC( prefixColor, "| ", defaultColor, "[XLib] ", whiteColor, prefix .. ": ", color, message .. "\n" )
        else
            msgC( prefixColor, "| ", defaultColor, "[XLib] ", whiteColor, prefix .. ": ", color, message, whiteColor, " - " .. submessage .. "\n" )
        end
    end

end

local includeFile = include
local addCSFile = AddCSLuaFile
local function LoadFile( part, dir, file )

    if part == "sv" then
        if SERVER then
            includeFile( "xilius/lib/" .. dir .. "/" .. file )
        end
    elseif part == "sh" then
        if SERVER then
            addCSFile( "xilius/lib/" .. dir .. "/" .. file )
            includeFile( "xilius/lib/" .. dir .. "/" .. file  )
        end

        if CLIENT then
           includeFile( "xilius/lib/" .. dir .. "/" .. file  )
        end
    elseif part == "cl" then
        if SERVER then
          addCSFile( "xilius/lib/" .. dir .. "/" .. file )
        end

        if CLIENT then
           includeFile( "xilius/lib/" .. dir .. "/" .. file  )
        end
    end

end

function XL:Initialize()

    local strStart = string.StartWith
    local fFind = file.Find
    local mtdirs, msdirs, mtfiles, msfiles
    local mfiles, mdirs = fFind( "xilius/lib/*", "LUA" )
    for i, v in next, mdirs do

        mfiles, msdirs = fFind( "xilius/lib/" .. v .. "/*", "LUA" )
        for k, j in next, mfiles do

            if XL.Modules[v] then
                if strStart( j, "sv" ) then
                    LoadFile( "sv", v, j )
                elseif strStart( j, "sh" ) then
                    LoadFile( "sh", v, j )
                elseif strStart( j, "cl" ) then
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

            msfiles, mtdirs = fFind( "xilius/lib/" .. v .. "/" .. j .. "/*", "LUA" )
            for l, m in next, msfiles do
                if XL.Modules[v] then
                    if strStart( m, "sv" ) then
                        LoadFile( "sv", v.."/"..j, m )
                    elseif strStart( m, "sh" ) then
                        LoadFile( "sh", v.."/"..j, m )
                    elseif strStart( m, "cl" ) then
                        LoadFile( "cl", v.."/"..j, m )
                    end
                end
            end

            for e, g in next, mtdirs do

                mtfiles = fFind( "xilius/lib/" .. v .. "/" .. j .. "/" .. g .. "/*", "LUA" )
                for f, h in next, mtfiles do
                    if XL.Modules[v] then
                        if strStart( h, "sv" ) then
                            LoadFile( "sv", v.."/"..j.."/"..g, h )
                        elseif strStart( h, "sh" ) then
                            LoadFile( "sh", v.."/"..j.."/"..g, h )
                        elseif strStart( h, "cl" ) then
                            LoadFile( "cl", v.."/"..j.."/"..g, h )
                        end
                    end
                end
            end

            --XL:Log( "Load SubModule", v .. "/" .. j, greenColor )
        end

    end
    mfiles, msdirs = fFind( "xilius/config/*", "LUA" )
        for k, j in next, mfiles do
            
            if SERVER then
                addCSFile( "xilius/config/" .. j )
                includeFile( "xilius/config/" .. j )
            end

            if CLIENT then
                includeFile( "xilius/config/" .. j )
            end
            
        end

    XL:Log( "Loading Complete", "Modules", greenColor )
end

function GM:Initialize()
    XL:Initialize()
end

XL:Initialize()

local timerSimple = timer.Simple
local tSetup = team.SetUp
local tSetClass = team.SetClass
function GM:CreateTeams()
    timer.Simple( 0, function()
        for i,v in next, XL.Teams do
            tSetup( i, XL.Teams[i].name, XL.Teams[i].color )
            tSetClass( i, {"player_default"} )
        end
    end)
end