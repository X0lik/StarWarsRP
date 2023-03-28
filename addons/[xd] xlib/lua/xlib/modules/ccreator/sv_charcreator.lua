util.AddNetworkString( 'XD:CharacterMenu' )
util.AddNetworkString( 'XD:CreateCharacter' )
file.CreateDir( 'xd.characters' )
XD = XD or {}
XD.NamesList = string.Split( file.Read( 'xd.characters/names_blacklist.txt', 'DATA' ), '|' )
XD.IDList = string.Split( file.Read( 'xd.characters/id_blacklist.txt', 'DATA' ), '|' )

function XD:ListUpdate()
  PrintTable( XD.NamesList )
  PrintTable( XD.IDList )

  local a, b = '', ''
  for i,v in ipairs( XD.NamesList ) do
    if v != '' then
      a = a .. v .. '|'
    end
  end

  for i,v in ipairs( XD.IDList ) do
    if v != '' then
      b = b .. v .. '|'
    end
  end

  print( a )
  print( b )

  file.Write( 'xd.characters/names_blacklist.txt', a )
  file.Write( 'xd.characters/id_blacklist.txt', b )

end

local meta = FindMetaTable( 'Player' )
function meta:CharacterMenu()
  net.Start( 'XD:CharacterMenu' )
  net.Send( self )
end

function meta:CreateCharacter( name, id )

  if file.Exists( 'xd.characters/' .. self:SteamID64() .. '/1.txt', 'DATA' ) then
    XD:CLog( 'Персонаж уже создан', self:SteamID(), nil, XD.RedColor )
  else
    file.CreateDir( 'xd.characters/' .. self:SteamID64() )
    file.Write( 'xd.characters/' .. self:SteamID64() .. '/1.txt', name .. '|' .. id )
    file.Append( 'xd.characters/names_blacklist.txt', name .. '|' )
    file.Append( 'xd.characters/id_blacklist.txt', id .. '|' )
    table.Add( XD.NamesList, {name} )
    table.Add( XD.IDList, {id} )
    XD:CLog( 'Создание персонажа', name .. ' (' .. id .. ')', self:SteamID(), XD.DefaultColor )

    self:SetName( name, nil )
    self:SetID( id, nil )
  end

end

local data
function meta:LoadCharacter( id )

  if file.Exists( 'xd.characters/' .. self:SteamID64() .. '/' .. id .. '.txt', 'DATA' ) then
    data = file.Read( 'xd.characters/' .. self:SteamID64() .. '/' .. id .. '.txt', 'DATA' )
  else
    XD:CLog( 'Персонажа не существует!', self:SteamID64(), nil, XD.RedColor )
    return
  end

  data = string.Split( data, '|' )
  self:SetName( data[1] )
  self:SetID( data[2] )

end

function meta:RemoveCharacter( id, admin, reason )

  if admin == nil then
    admin = 'Console'
  else
    admin = admin:Name() .. ' (' .. admin:SteamID() ')'
  end

  file.Delete( 'xd.characters/' .. self:SteamID64() .. '/' .. id .. '.txt' )
  table.RemoveByValue( XD.NamesList, self:Name() )
  table.RemoveByValue( XD.IDList, tostring( self:GetID() ) )
  XD:ListUpdate()
  self:CharacterMenu()
  XD:ChatLog( self, 'Ваш персонаж был удален', admin, XD.RedColor )

end

net.Receive( 'XD:CreateCharacter', function( _, ply )

  local name = net.ReadString()
  local blacklist_symbol1 = string.find( name:lower(), '|' )
  local blacklist_symbol2 = string.find( name:lower(), '/' )
  if blacklist_symbol1 or blacklist_symbol2 then
    XD:ChatLog( ply, 'Ошибка: Введен неправильный позывной', 'обнаружен запрещенный символ', XD.RedColor )
    return
  end

  if utf8.len( name ) <= 3 or utf8.len( name ) >= 13 then
      XD:ChatLog( ply, 'Ошибка: Введен неправильный позывной', 'позывной слишком длинный или слишком короткий', XD.RedColor )
      return
  end

  if name == 'Позывной' then
      XD:ChatLog( ply, 'Ошибка: Введен неправильный позывной', 'вы не ввели ваш позывной', XD.RedColor )
      return
  end

  local pid = math.random( 0, 9 ) .. math.random( 0, 9 ) .. math.random( 0, 9 ) .. math.random( 0, 9 )
  ply:CreateCharacter( name, pid )
  XD:ChatLog( ply, 'Вы успешно создали персонажа!', nil, XD.GreenColor )

end)

hook.Add( 'PlayerInitialSpawn', 'XD:LoadPlayerCharacter', function( ply )

  timer.Simple( .1, function()
    ply:LoadCharacter(1)
  end)

end)
