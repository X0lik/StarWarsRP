local PANELS = {}
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

/*PANELS.XFrame = {}
PANELS.XFrame.DefaultColor = Color( 30, 30, 30 )

function PANELS.XFrame:Paint(w, h)

	surface.SetDrawColor( PANELS.XFrame.DefaultColor )
	surface.DrawRect( 0, 0, w, h )

end

vgui.Register( 'xframe', PANELS.XFrame, 'DLabel' )

local function Ban()

  local frame = vgui.Create( 'DFrame' )
  frame:SetSize( 500, 500 )
  frame:Center()

  local button = vgui.Create( 'xyeta', frame )
  button:SetSize( 100, 100 )
  button:Center()
  button.DoClick = function()
    frame:Remove()
  end

end

Ban()*/
