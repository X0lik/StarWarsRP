include( 'shared.lua' )

surface.CreateFont( 'DB.Title', {
  font = 'Tahoma',
  extended = true,
  weight = 600,
  size = ScreenScale( 12 )
})

surface.CreateFont( 'DB.Text', {
  font = 'Tahoma',
  extended = true,
  weight = 600,
  size = ScreenScale( 8 )
})

surface.CreateFont( 'DB.Close', {
  font = 'Tahoma',
  extended = true,
  weight = 1000,
  size = ScreenScale( 8 )
})

local sw, sh = ScrW(), ScrH()
net.Receive( 'SB:PayMenu', function()

    local salary, piecework
    local nextpage = false
    local dsmenu = vgui.Create( 'DFrame' )
    dsmenu:SetSize( sw*.3, sh*.5 )
    dsmenu:Center()
    dsmenu:SetTitle('')
    dsmenu:ShowCloseButton( true )
    dsmenu:MakePopup()
    dsmenu.Paint = function( self, w, h )
      draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
      draw.SimpleText( 'Продать украденные запчасти?', 'DB.Title', w/2, h*.3, Color( 255, 255, 255 ), 1, 1 )
    end

    local closebtn = vgui.Create( 'DButton', dsmenu )
    closebtn:SetText( '' )
    closebtn:SetSize( 26, 26 )
    closebtn:SetPos( dsmenu:GetWide()-30, 4 )
    closebtn.Paint = function( self, w, h )
      draw.SimpleText( 'X', 'DB.Close', w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    closebtn.DoClick = function()
      tpanel:Remove()
    end

    local sellbtn = vgui.Create( 'DButton', dsmenu )
    sellbtn:SetSize( dsmenu:GetWide()*.4, dsmenu:GetTall()*.18 )
    sellbtn:SetPos( dsmenu:GetWide()*.3, dsmenu:GetTall()*.8 )
    sellbtn:SetText('')
    sellbtn.Paint = function( self, w, h )
      draw.RoundedBox( 10, 0, 0, w, h, Color( 116, 0, 255 ) )
      draw.SimpleText( 'Продать запчасти', 'DB:Text', w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
    end

    sellbtn.DoClick = function()
      net.Start( 'DB:SellStealedDetails' )
      net.SendToServer()
    end

end)
