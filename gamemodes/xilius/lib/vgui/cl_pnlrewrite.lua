local PANEL = FindMetaTable( 'Panel' )
function PANEL:GW( num )
  if num == nil then
    return self:GetWide()
  else
    return self:GetWide()*num
  end
end

function PANEL:GT( num )
  if num == nil then
    return self:GetTall()
  else
    return self:GetTall()*num
  end
end