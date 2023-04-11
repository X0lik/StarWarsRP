local createFont = surface.CreateFont
createFont( "XL:Char:Button", { font = "Inter Extra Light", size = ScreenScale(14), weigth = 5000, extended = true } )
createFont( "XL:Char:TextEntry", { font = "Inter Extra Light", size = ScreenScale(12), weigth = 2000, extended = true } )
createFont( "XL:Char:Title", { font = "Inter Extra Light", size = ScreenScale(25), weigth = 2000, extended = true } )

local createDir, fWrite = file.CreateDir, file.Write
local httpFetch = http.Fetch
local mat = Material
createDir( "defblade_republic" )
createDir( "defblade_republic/char" )
httpFetch( "https://i.ibb.co/dkDCNCT/char-background.png", function( body ) fWrite( "defblade_republic/char/background.png", body ) end)

local function CharCreate()

  local background = mat( "data/defblade_republic/char/background.png", "smooth" )
  local setDrawColor, setMat, drawTRect = surface.SetDrawColor, surface.SetMaterial, surface.DrawTexturedRect

  local lp = LocalPlayer()
  local sw, sh = ScrW(), ScrH()
  local name = "Позывной"

  local frame = vgui.Create( "DFrame" )
  frame:SetSize( sw, sh )
  frame:Center()
  frame:SetTitle("")
  frame:SetDraggable( false )
  frame:ShowCloseButton( false )
  frame:SetAlpha(0)
  frame:AlphaTo( 255, 0.3, 0 )
  frame:MakePopup()
  frame.Paint = function( self, w, h )
    setDrawColor( 255, 255, 255 )
    setMat( background )
    drawTRect( -10, -10, w+20, h+20 )
    draw.SimpleText( "Создайте Вашего персонажа", "XL:Char:Title", w*.3, h*.37, Color( 255, 255, 255 ), 1, 1 )
  end

  local close = vgui.Create( "DButton", frame )
  close:SetSize( 25, 25 )
  close:SetPos( frame:GW()-25, 0 )
  close:SetText("X")
  close.DoClick = function()
    frame:ARemove()
  end

  local enterName = vgui.Create( "DTextEntry", frame )
  enterName:SetSize( frame:GW(.3), frame:GT(.08) )
  enterName:SetPos( frame:GW(.145), frame:GT(.45) )
  enterName.lerp = 0
  enterName.OnChange = function( self )
    name = self:GetValue()
  end
  enterName.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
    draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 100, 0, 255 ) )
    draw.SimpleText( name, "XL:Char:TextEntry", w*.07, h/2, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if self:IsHovered() then
      self.lerp = Lerp( FrameTime() * 6, self.lerp, w*.05 )
    else
      self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
    end
  end

  local create = vgui.Create( "DButton", frame )
  create:SetSize( frame:GW(.2), frame:GT(.06) )
  create:SetPos( frame:GW(.195), frame:GT(.57) )
  create:SetText("")
  create.lerp = 0
  create.rblerp = 0
  create.rglerp = 0
  create.bblerp = 0
  create.rtlerp = 0
  create.gtlerp = 0
  create.btlerp = 0
  create.Paint = function( self, w, h )
    draw.RoundedBox( 40, 0, 0, w, h, Color( self.rblerp, self.rglerp, self.bblerp ) )
    --draw.RoundedBox( 40, -1, 3, self.lerp-6, h-6, Color( self.rblerp, 0, self.bblerp ) )
    draw.SimpleText( "СОЗДАТЬ", "XL:Char:Button", w/2, h/2, Color( self.rtlerp, self.gtlerp, self.btlerp ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if self:IsHovered() then
      --self.lerp = Lerp( FrameTime() * 6, self.lerp, w )
      self.rblerp = Lerp( FrameTime() * 6, self.rblerp, 100 )
      self.rglerp = Lerp( FrameTime() * 6, self.rglerp, 0 )
      self.bblerp = Lerp( FrameTime() * 6, self.bblerp, 255 )

      self.rtlerp = Lerp( FrameTime() * 4, self.rtlerp, 255 )
      self.gtlerp = Lerp( FrameTime() * 4, self.btlerp, 255 )
      self.btlerp = Lerp( FrameTime() * 4, self.btlerp, 255 )
    else
      --self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
      self.rblerp = Lerp( FrameTime() * 6, self.rblerp, 255 )
      self.rglerp = Lerp( FrameTime() * 6, self.rglerp, 255 )
      self.bblerp = Lerp( FrameTime() * 6, self.bblerp, 255 )

      self.rtlerp = Lerp( FrameTime() * 4, self.rtlerp, 0 )
      self.gtlerp = Lerp( FrameTime() * 4, self.gtlerp, 0 )
      self.btlerp = Lerp( FrameTime() * 4, self.btlerp, 0 )
    end

  end

  create.DoClick = function()
    local blacklistChars = { "|", "/", "\", %$", ":", ";", "=", "+", "?", "%%", "#", "№", "@", "!", "%[", "%]", "%{", "%}", "*", "'", '"' }
    local blacklistedChar = false
    for i,v in next, blacklistChars do
      if string.find( name:lower(), v ) ~= nil then
        print( v )
        blacklistedChar = true
      end
    end

    if blacklistedChar or name == "Позывной" or utf8.len( name ) < 4 or utf8.len( name ) > 16 then
      return
    end

    net.Start( "XL:CreateCharacter" )
    net.WriteString( name )
    net.SendToServer()
    frame:ARemove()
  end

  local model = vgui.Create( "DModelPanel", frame )
  model:SetSize( frame:GW(.4), frame:GT(.8) )
  model:SetPos( frame:GW(.55), frame:GT(.1) )
  --model:SetModel( "models/501st/fives/fives.mdl" )
  model:SetModel( lp:IsValid() and lp:GetModel() or XL.Teams[XL.DefaultTeam].models[1] )
  model:SetCamPos( Vector( 90, 50, 50 ) )
  model:SetLookAt( Vector( 0, 0, 40 ) )
  model:SetFOV( 42 )
  function model:LayoutEntity() return end

end

net.Receive( "XL:CharacterMenu", CharCreate )
concommand.Add( "debug.char", CharCreate )
