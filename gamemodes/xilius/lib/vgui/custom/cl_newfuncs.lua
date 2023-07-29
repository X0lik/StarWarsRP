function draw.Circle( x, y, radius, seg )
  local cir = {}

  table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
  for i = 0, seg do
    local a = math.rad( ( i / seg ) * -360 )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
  end

  local a = math.rad( 0 ) -- This is needed for non absolute segment counts
  table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

  surface.DrawPoly( cir )
end

// Second Method \\
function draw.SCircle(posx, posy, radius, progress, color)
    local poly = { }
    local v = 220
    poly[1] = {x = posx, y = posy}
    for i = 0, v*progress+0.5 do
        poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
    end
    draw.NoTexture()
    surface.SetDrawColor(color)
    surface.DrawPoly(poly)
end