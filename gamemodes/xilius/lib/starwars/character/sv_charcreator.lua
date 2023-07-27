local strSplit, strFind, strLen = string.Split, string.find, utf8.len
local addNetString, Receive, ReadString, Start, Send = util.AddNetworkString, net.Receive, net.ReadString, net.Start, net.Send
local findMetaTable = FindMetaTable
local mathRandom = math.random


local db = XL.DB
local PLY = findMetaTable( 'Player' )

addNetString( "XL:CharacterMenu" )
addNetString( "XL:CreateCharacter" )

function PLY:CharMenu()
    net.Start( "XL:CharacterMenu" )
    net.Send( self )
end

function PLY:CharCreate( name, id )

    db:Query( 'SELECT * FROM `xilius_characters` WHERE `steamid`=' .. self:SteamID64() .. ';', function( res )
        local data = res[1].data[1]
        if data then
            XL:Log( "Character Creation Error", "Reason: Character Already Created", redColor )
            return false
        else
            db:Query( 'SELECT * FROM `xilius_characters` WHERE name="' .. name .. '";', function( sres )

                local sdata = sres[1].data[1]
                if sdata then
                    XL:Log( "Character Creation Error", "Reason: Name already exists", redColor )
                    return false
                else

                    db:Query( 'INSERT INTO `xilius_characters`( `steamid`, `charid`, `name`, `id`, `money`, `job`, `rank` ) VALUES( ' .. self:SteamID64() .. ', 1, "' .. name ..  '", ' .. id .. ', ' .. XL.Config.StartMoney .. ', 1, 0 )' )
                    self:SetName( name )
                    self:SetID( id )
                    --self:SetMoney( XL.Config.StartMoney )
                    return true

                end

            end)
        end
    end)

end

function PLY:CharRemove( admin, reason )

    if admin == nil then
        admin = "Console"
    else
        admin = admin:Name() .. " (" .. admin:SteamID() ")"
    end

    db:Query( 'DELETE FROM `xilius_characters` WHERE `steamid`=' .. self:SteamID64() .. ';' )

    XL:Log( "Character Removing", admin .. " - " .. reason, redColor )
    XL:SetTeam( self, 1 )

    self:SetName( XL.Config.DefaultName )
    self:SetID( "0" )
    self:CharMenu()
    return true

end

function PLY:CharLoad()

    db:Query( 'SELECT * FROM `xilius_characters` WHERE `steamid`=' .. self:SteamID64() .. ';', function( res )

        local data = res[1].data[1]
        self:SetName( data.name )
        self:SetID( data.id )
        --self:SetMoney( data.money )
        XL:SetTeam( self, data.job, data.rank )

    end)

end

Receive( "XL:CreateCharacter", function( len, pl )

    local name = ReadString()
    local blacklistChars = { "|", "/", "\", %$", ":", ";", "=", "+", "?", "%%", "#", "№", "@", "!", "%[", "%]", "%{", "%}", "*", "'", '"' }
    local blacklistedChar = false
    for i,v in next, blacklistChars do
        if strFind( name:lower(), v ) ~= nil then
            blacklistedChar = true
            return
        end
    end

    if blacklistedChar or name == "Позывной" or strLen( name ) < 4 or strLen( name ) > 16 then
      return false
    end
    
    pl:CharCreate( name, mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) )

end)