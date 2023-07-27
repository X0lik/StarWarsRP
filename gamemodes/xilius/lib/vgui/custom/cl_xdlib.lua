local PANEL = FindMetaTable( 'Panel' )
function PANEL:ARemove( num )

  if num == nil then
    num = 0.3
  end

  self:AlphaTo( 0, num, 0, function() self:Remove() end)
  
end

local drawBox = draw.RoundedBox
function PANEL:BGLerp( boxRound, dColor, lColor, speed )

    if speed == nil then
      speed = 6
    end

    self.cr, self.cg, self.cb = dColor.r, dColor.g, dColor.b
    self.Paint = function( self, w, h )

        if self:IsHovered() then
            self.cr = Lerp( FrameTime()*speed, self.cr, lColor.r )
            self.cg = Lerp( FrameTime()*speed, self.cg, lColor.g )
            self.cb = Lerp( FrameTime()*speed, self.cb, lColor.b )
        else
            self.cr = Lerp( FrameTime()*speed, self.cr, dColor.r )
            self.cg = Lerp( FrameTime()*speed, self.cg, dColor.g )
            self.cb = Lerp( FrameTime()*speed, self.cb, dColor.b )
        end

        self.LerpColor( self.cr, self.cg, self.cb )
        drawBox( boxRound, 0, 0, w, h, self.LerpColor )
    end

end

function PANEL:AddPaint( func )

    self.Paint = function( self, w, h )
        self.Paint( self, w, h )
        func( self, w, h )
    end

end

function PANEL:ClearPaint()
    self.Paint = function() end
end

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

--[[function draw.SCircle(posx, posy, radius, progress, color)
    local poly = { }
    local v = 220
    poly[1] = {x = posx, y = posy}
    for i = 0, v*progress+0.5 do
        poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
    end
    draw.NoTexture()
    surface.SetDrawColor(color)
    surface.DrawPoly(poly)
end]]