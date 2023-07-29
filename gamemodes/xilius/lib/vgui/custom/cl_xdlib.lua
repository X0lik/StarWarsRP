local PANEL = FindMetaTable( "Panel" )
function PANEL:AnimAlpha( time, delay, callback )

    time = time or .3
    delay = delay or 0
    callback = callback or function() end
    self:SetAlpha(0)
    self:AlphaTo( 255, time, delay, callback )

end

function PANEL:AnimSize( sizeW, sizeH, time, delay, posX, posY )

    local isAnimating = true
    self:SetSize(0,0)
    self:SizeTo( sizeW, sizeH, time, delay, .1, function() isAnimating = false end)

    if posX and posY then
        self.Think = function()
            if isAnimating then
                self:SetPos( posX, posY )
            end
        end
    end

end

function PANEL:ARemove( num, delay )

  num = num or .3
  delay = delay or 0
  self:AlphaTo( 0, num, 0, function() self:Remove() end)
  
end

local drawBox = draw.RoundedBox
function PANEL:BGLerp( boxRound, dColor, lColor, speed )

    --[[if speed == nil then
      speed = 6
    end]]
    speed = speed or 6

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