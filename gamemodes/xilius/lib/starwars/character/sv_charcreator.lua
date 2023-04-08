file.CreateDir( "characters" )
util.AddNetworkString( "XL:CharacterMenu" )
util.AddNetworkString( "XL:CreateCharacter" )
XL.NamesList = {}
XL.IDList = {}
local fWrite, fAppend, fExist, fCreateDir = file.Write, file.Append, file.Exists, file.CreateDir
local strSplit, strFind, strLen = string.Split, string.find
local mathRandom = math.random
local function fRead( path, gamePath )

  file.AsyncRead( path, gamePath, function( fileName, gamePath, status, data )
    if ( status == FSASYNC_OK ) then
      return data
    else
      XL:Log( "Can't read file!", fileName, redColor, tostring( status ) )
      return ""
    end
  end)

end

function XL:CharsLoad()

  local nametbl, idtbl = strSplit( fRead( "characters/names_list.txt", "DATA" ), "|" ), strSplit( fRead( "characters/id_list.txt", "DATA" ), "|" )
  local names, id = '', ''
  for i,v in next, nametbl do
      names = names .. v .. '|'
      XL.NamesList[i] = name
  end

  for i,v in next, idtbl do
      id = id .. v .. '|'
      XL.IDList[i] = id
  end

  fWrite( "characters/names_list.txt", names )
  fWrite( "characters/id_list.txt", id )

end

local meta = FindMetaTable( 'Player' )
function meta:CharMenu()
  net.Start( "XL:CharacterMenu" )
  net.Send( self )
end

function meta:CharCreate( name, id )

  if fExists( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
    return false, "Персонаж уже создан"
  else
    fCreateDir( "characters/" .. self:SteamID64() )
    fWrite( "characters/" .. self:SteamID64() .. "/character.txt", name .. "|" .. id )
    fAppend( "characters/names_blacklist.txt", name .. "|" )
    fAppend( "characters/id_blacklist.txt", id .. "|" )
    XL.NamesList[#XL.NamesList+1] = name
    XL.IDList[#XL.IDList+1] = id

    self:SetName( name )
    self:SetID( tostring( id ) )
    return true
  end

end

local data
function meta:CharLoad()

  if fExist( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
    data = fRead( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" )
  else
    return false, "Персонажа не существует!"
  end

  data = strSplit( data, "|" )
  self:SetName( data[1] )
  self:SetID( data[2] )
  return true

end

function meta:CharGet()

  if fExist( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
    return strSplit( fRead( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ), "|" )
  else
    return false, "Персонаж не найден!"
  end

end

function meta:CharRemove( admin, reason )

  if admin == nil then
      admin = "Console"
  else
      admin = admin:Name() .. " (" .. admin:SteamID() ")"
  end

  if fileExist( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
      file.Delete( "characters/" .. self:SteamID64() .. "/character.txt" )
  else
      return false, "Персонажа не существует!"
  end

  local nameStart, nameEnd = string.find( text, self:GetName() .. "|" )
  if nameStart then
    local newNameTable = string.sub( text, 1, nameStart - 1 ) .. string.sub( text, nameEnd + 1 )
    fWrite( "characters/names_blacklist.txt", newNameTable )
  end

  local idStart, idEnd = string.find( text, self:GetID() .. "|" )
  if idStart then
    local newIDTable = string.sub( text, 1, idStart - 1 ) .. string.sub( text, idEnd + 1 )
    fWrite( "characters/id_blacklist.txt", newIDTable )
  end

  for i,v in next, XL.NamesList do
      if v == self:GetName() then
          XL.NamesList[i] = nil
      end
  end

  for i,v in next, XL.IDList do
      if v == self:GetID() then
          XL.IDList[i] = nil
      end
  end

  self:SetName( XL.Config.DefaultName )
  self:SetID( 0 )
  self:CharMenu()
  return true

end

local function NewID()
  local newID = mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 )
  for i,v in next, XL.IDList do
      if v == newID then
          NewID()
      end
  end
  return newID
end

net.Receive( "XL:CreateCharacter", function( _, ply )

  local name = net.ReadString()
  local blacklistChars = { "|", "/", "\", %$", ":", ";", "=", "+", "?", "%%", "#", "№", "@", "!", "[", "]", "{", "}", "*", "'", '"' }
  local blacklistedChar = false
  for i,v in next, blacklistChars do
    if string.find( name:lower(), v ) ~= nil then
      blacklistedChar = true
    end
  end

  if blacklistedChar or name == "Позывной" or utf8.len( name ) < 4 or utf8.len( name ) > 16 then
    return false
  end

  for i,v in next, XL.NamesList do
      if v == name then
          return false
      end
  end

  ply:CharCreate( name, NewID() )

end)
