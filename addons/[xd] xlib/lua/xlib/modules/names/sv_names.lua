hook.Add( 'PlayerInitialSpawn', 'XD:SetName', function( ply )

  timer.Simple( .001, function()
    ply:SetNWString( 'XD:Name', ply:GetName() )
  end)

end)

local meta = FindMetaTable( 'Player' )
function meta:Name()
  return self:GetNWString( 'XD:Name' )
end

function meta:Nick()
  return self:GetNWString( 'XD:Name' )
end

function meta:GetName()
  return self:GetNWString( 'XD:Name' )
end

function meta:GetID()
  return self:GetNWString( 'XD:ID' )
end

function meta:FullName()
  return self:GetNWString( 'XD:Name' ) .. '#' .. self:GetNWString( 'XD:ID' )
end

function meta:SetName( name, admin )
  if admin != nil then
    XD:LogThis( '[' .. XD:GetDate() .. '] ' .. admin:FullName() .. ' (' .. admin:SteamID() .. ')' )
  end

  self:SetNWString( 'XD:Name', name )
  XD:CLog( 'Изменение ника', self:GetName() .. ' (' .. self:SteamID() .. ')', name, Color( 54, 102, 191 ) )
end

function meta:SetID( id, admin )
  if admin != nil then
    XD:LogThis( '[' .. XD:GetDate() .. '] ' .. admin:FullName() .. ' (' .. admin:SteamID() .. ')' )
  end

  self:SetNWString( 'XD:ID', id )
  XD:CLog( 'Изменение ID', self:GetID() .. ' (' .. self:SteamID() .. ')', name, Color( 54, 102, 191 ) )
end
