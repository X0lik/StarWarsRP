local PANEL = FindMetaTable( 'Panel' )
function PANEL:ARemove( num )

  if num == nil then
    num = 0.3
  end

  self:AlphaTo( 0, num, 0 )
  timer.Simple( num+0.1, function() self:Remove() end)
  
end