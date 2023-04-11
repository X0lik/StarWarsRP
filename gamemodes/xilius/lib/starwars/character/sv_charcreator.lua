file.CreateDir( "characters" )
util.AddNetworkString( "XL:CharacterMenu" )
util.AddNetworkString( "XL:CreateCharacter" )
XL.NamesList = {}
XL.IDList = {}
local fWrite, fRead, fDelete, fAppend, fExist, fCreateDir = file.Write, file.Read, file.Delete, file.Append, file.Exists, file.CreateDir
local strSplit, strFind, strLen = string.Split, string.find, utf8.len
local mathRandom = math.random

function XL:CharsLoad()

  local nametbl, idtbl = fRead( "characters/names_list.txt", "DATA" ), fRead( "characters/id_list.txt", "DATA" )
  if nametbl == nil or idtbl == nil then
    fWrite( "characters/names_list.txt", "" )
    fWrite( "characters/id_list.txt", "" )
  else
    nametbl = strSplit( nametbl, "|" )
    idtbl = strSplit( idtbl, "|" )
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
  XL:Log( "Characters", "Characters list loaded", greenColor )

end
hook.Add( "PostGamemodeLoaded", "XL:LoadAllChars", function() XL:CharsLoad() end)

local meta = FindMetaTable( 'Player' )
function meta:CharMenu()
  net.Start( "XL:CharacterMenu" )
  net.Send( self )
end

function meta:CharCreate( name, id )

  if fExist( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
    return false, "Персонаж уже создан"
  else
    id = tostring( id )
    fCreateDir( "characters/" .. self:SteamID64() )
    fWrite( "characters/" .. self:SteamID64() .. "/character.txt", name .. "|" .. id )
    fAppend( "characters/names_list.txt", name .. "|" )
    fAppend( "characters/id_list.txt", id .. "|" )
    XL.NamesList[#XL.NamesList+1] = name
    XL.IDList[#XL.IDList+1] = id

    self:SetName( name )
    self:SetID( id )
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

  print( data )
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

  if fExist( "characters/" .. self:SteamID64() .. "/character.txt", "DATA" ) then
      fDelete( "characters/" .. self:SteamID64() .. "/character.txt" )
  else
      return false, "Персонажа не существует!"
  end

  local nametbl, idtbl = fRead( "characters/names_list.txt", "DATA" ), fRead( "characters/id_list.txt", "DATA" )
  local nameStart, nameEnd = strFind( nametbl, self:Nick() .. "|" )
  if nameStart then
    local newNameTable = string.sub( nametbl, 1, nameStart - 1 ) .. string.sub( nametbl, nameEnd + 1 )
    print( newNameTable )
    fWrite( "characters/names_list.txt", newNameTable )
  end

  local idStart, idEnd = strFind( idtbl, self:ID() .. "|" )
  if idStart then
    local newIDTable = string.sub( idtbl, 1, idStart - 1 ) .. string.sub( idtbl, idEnd + 1 )
    fWrite( "characters/id_list.txt", newIDTable )
  end

  for i,v in next, XL.NamesList do
      if v == self:Nick() then
          XL.NamesList[i] = nil
      end
  end

  for i,v in next, XL.IDList do
      if v == self:ID() then
          XL.IDList[i] = nil
      end
  end

  self:SetName( XL.Config.DefaultName )
  self:SetID( "0" )
  self:CharMenu()
  return true

end

local function NewID()
  local newID = mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 ) .. mathRandom( 0, 9 )
  for i,v in next, XL.IDList do
      if v == newID then
          NewID()
          break
      end
  end
  return newID
end

net.Receive( "XL:CreateCharacter", function( _, ply )

  local name = net.ReadString()
  local blacklistChars = { "|", "/", "\", %$", ":", ";", "=", "+", "?", "%%", "#", "№", "@", "!", "%[", "%]", "%{", "%}", "*", "'", '"' }
  local blacklistedChar = false
  for i,v in next, blacklistChars do
    if strFind( name:lower(), v ) ~= nil then
      blacklistedChar = true
    end
  end

  if blacklistedChar or name == "Позывной" or strLen( name ) < 4 or strLen( name ) > 16 then
    return false
  end

  for i,v in next, XL.NamesList do
      if v == name then
          return false
      end
  end

  ply:CharCreate( name, NewID() )

end)
