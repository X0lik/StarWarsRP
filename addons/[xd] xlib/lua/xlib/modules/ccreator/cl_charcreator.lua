XD:CreateFont( 'CC:Button', 'Verdana', ScreenScale(8), 1000 )
XD:CreateFont( 'CC:TextEntry', 'Verdana', ScreenScale(10), 1000 )

local function CharCreate()

  local sw, sh = ScrW(), ScrH()
  local name = 'Позывной'

  local frame = vgui.Create( 'DFrame' )
  frame:SetSize( sw, sh )
  frame:Center()
  frame:SetTitle('')
  frame:SetDraggable( false )
  frame:ShowCloseButton( false )
  frame:SetAlpha(0)
  frame:AlphaTo( 255, 0.3, 0 )
  frame:MakePopup()
  frame.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
  end

  local enter_name = vgui.Create( 'DTextEntry', frame )
  enter_name:SetSize( frame:GW(.3), frame:GT(.08) )
  enter_name:SetPos( frame:GW(.1), frame:GT(.3) )
  enter_name.lerp = 0
  enter_name.OnChange = function( self )
    name = self:GetValue()
  end
  enter_name.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
    draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( 100, 0, 255 ) )
    draw.SimpleText( name, 'CC:TextEntry', w*.07, h/2, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if self:IsHovered() then
      self.lerp = Lerp( FrameTime() * 6, self.lerp, w*.05 )
    else
      self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
    end
  end

  local create = vgui.Create( 'DButton', frame )
  create:SetSize( frame:GW(.2), frame:GT(.07) )
  create:SetPos( frame:GW(.15), frame:GT(.4) )
  create:SetText('')
  create.lerp = 0
  create.rblerp = 0
  create.bblerp = 0
  create.rtlerp = 0
  create.gtlerp = 0
  create.btlerp = 0
  create.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
    draw.RoundedBox( 0, 0, 0, self.lerp, h, Color( self.rblerp, 0, self.bblerp ) )
    draw.SimpleText( 'СОЗДАТЬ', 'CC:Button', w/2, h/2, Color( self.rtlerp, self.gtlerp, self.btlerp ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if self:IsHovered() then
      self.lerp = Lerp( FrameTime() * 6, self.lerp, w+1 )
      self.rblerp = Lerp( FrameTime() * 4, self.rblerp, 100 )
      self.bblerp = Lerp( FrameTime() * 4, self.bblerp, 255 )

      self.rtlerp = Lerp( FrameTime() * 4, self.rtlerp, 255 )
      self.gtlerp = Lerp( FrameTime() * 4, self.btlerp, 255 )
      self.btlerp = Lerp( FrameTime() * 4, self.btlerp, 255 )
    else
      self.lerp = Lerp( FrameTime() * 6, self.lerp, 0 )
      self.rblerp = Lerp( FrameTime() * 4, self.rblerp, 0 )
      self.bblerp = Lerp( FrameTime() * 4, self.bblerp, 0 )

      self.rtlerp = Lerp( FrameTime() * 4, self.rtlerp, 0 )
      self.gtlerp = Lerp( FrameTime() * 4, self.gtlerp, 0 )
      self.btlerp = Lerp( FrameTime() * 4, self.btlerp, 0 )
    end

  end

  create.DoClick = function()
    local blacklist_symbol1 = string.find( name:lower(), '|' )
    local blacklist_symbol2 = string.find( name:lower(), '/' )
    if blacklist_symbol1 or blacklist_symbol2 then
      XD:PChatLog( 'Ошибка: Введен неправильный позывной', 'обнаружен запрещенный символ', XD.RedColor )
      return
    end

    if utf8.len( name ) <= 3 or utf8.len( name ) >= 13 then
        XD:PChatLog( 'Ошибка: Введен неправильный позывной', 'позывной слишком длинный или слишком короткий', XD.RedColor )
        return
    end

    if name == 'Позывной' then
        XD:PChatLog( 'Ошибка: Введен неправильный позывной', 'вы не ввели ваш позывной', XD.RedColor )
        return
    end

    net.Start( 'XD:CreateCharacter' )
    net.WriteString( name )
    net.SendToServer()

    frame:AlphaTo( 0, 0.3, 0 )
    timer.Simple( 0.4, function() frame:Remove() end )
  end

  local model = vgui.Create( 'DModelPanel', frame )
  model:SetSize( frame:GW(.4), frame:GT(.8) )
  model:SetPos( frame:GW(.55), frame:GT(.1) )
  model:SetModel( 'models/501st/fives/fives.mdl' )
  model:SetCamPos( Vector( 90, 50, 50 ) )
  model:SetLookAt( Vector( 0, 0, 40 ) )
  model:SetFOV( 42 )
  function model:LayoutEntity( Entity ) return end

  local close = vgui.Create( 'DButton', frame )
  close:SetSize( 25, 25 )
  close:SetPos( frame:GW()-25, 0 )
  close:SetText('X')
  close.DoClick = function()
    frame:Remove()
  end

end

net.Receive( 'XD:CharacterMenu', CharCreate )

concommand.Add( 'charcreate', CharCreate )
