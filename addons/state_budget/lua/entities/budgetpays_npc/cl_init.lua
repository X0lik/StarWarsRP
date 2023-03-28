include( 'shared.lua' )

surface.CreateFont( 'SB.Title', {
  font = 'Tahoma',
  extended = true,
  weight = 600,
  size = ScreenScale( 12 )
})

surface.CreateFont( 'SB.Name', {
  font = 'Tahoma',
  extended = true,
  weight = 600,
  size = ScreenScale( 10 )
})

surface.CreateFont( 'SB.Text', {
  font = 'Tahoma',
  extended = true,
  weight = 600,
  size = ScreenScale( 8 )
})

surface.CreateFont( 'SB.Close', {
  font = 'Tahoma',
  extended = true,
  weight = 1000,
  size = ScreenScale( 8 )
})

local sw, sh = ScrW(), ScrH()
net.Receive( 'SB:PayMenu', function()

    local salary, piecework
    local nextpage = false
    local bmenu = vgui.Create( 'DFrame' )
    bmenu:SetSize( sw*.4, sh*.7 )
    bmenu:Center()
    bmenu:SetTitle('')
    bmenu:ShowCloseButton( true )
    bmenu:MakePopup()
    bmenu.Paint = function( self, w, h )
      draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
      draw.SimpleText( 'Управление Зарплатами', 'SB.Title', w/2, h*.06, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local tlist = vgui.Create( 'DScrollPanel', bmenu )
    tlist:SetSize( bmenu:GetWide()*.9, bmenu:GetTall()*.82 )
    tlist:SetPos( bmenu:GetWide()*.05, bmenu:GetTall()*.12 )
    tlist.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10 ) ) end

    for i,v in pairs( SB.Teams ) do

      local tbutton = vgui.Create( 'DButton', tlist )
      tbutton:SetText('')
      tbutton:Dock( TOP )
      tbutton:DockMargin( 0, 0, 0, 10 )
      tbutton:SetSize( tlist:GetWide(), tlist:GetTall()*.15 )
      tbutton.Paint = function( self, w, h )
          draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
          draw.SimpleText( team.GetName(i), 'SB.Name', w/2, h/2, team.GetColor(i), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      tbutton.DoClick = function()

        local tpanel = vgui.Create( 'EditablePanel' )
        tpanel:SetSize( sw*.25, sh*.4 )
        tpanel:Center()
        tpanel:MakePopup()
        tpanel.Paint = function( self, w, h )
          draw.RoundedBox( 10, 0, 0, w, h, Color( 50, 50, 50 ) )
          draw.RoundedBox( 10, 2, 2, w-4, h-4, Color( 20, 20, 20 ) )
          draw.SimpleText( team.GetName( i ), 'SB.Name', w/2, h*.1, team.GetColor( i ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          draw.SimpleText( 'Зарплата:', 'SB.Text', w*.07, h*.33, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
          draw.SimpleText( 'Сдельная ЗП:', 'SB.Text', w*.05, h*.48, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local tsalary = vgui.Create( 'DTextEntry', tpanel )
        tsalary:SetSize( tpanel:GetWide()*.6, tpanel:GetTall()*.08 )
        tsalary:SetPos( tpanel:GetWide()*.33, tpanel:GetTall()*.3 )
        tsalary:SetPlaceholderText( 'Минимальная: ' .. SB.Teams[i].minsalary .. ' | Максимальная: ' .. SB.Teams[i].maxsalary )
        tsalary.OnChange = function( self )
          salary = self:GetValue()
        end

        local tpiecework = vgui.Create( 'DTextEntry', tpanel )
        tpiecework:SetSize( tpanel:GetWide()*.571, tpanel:GetTall()*.08 )
        tpiecework:SetPos( tpanel:GetWide()*.36, tpanel:GetTall()*.45 )
        tpiecework:SetPlaceholderText( 'Минимальная: ' .. SB.Teams[i].minpiecework .. ' | Максимальная: ' .. SB.Teams[i].maxpiecework )
        tpiecework.OnChange = function( self )
          piecework = self:GetValue()
        end

        local tsetup = vgui.Create( 'DButton', tpanel )
        tsetup:SetText('')
        tsetup:SetSize( tpanel:GetWide()*.5, tpanel:GetTall()*.1 )
        tsetup:SetPos( tpanel:GetWide()*.25, tpanel:GetTall()*.8 )
        tsetup.Paint = function( self, w, h )
          draw.RoundedBox( 10, 0, 0, w, h, Color( 116, 0, 255 ) )
          draw.SimpleText( 'УСТАНОВИТЬ', 'SB.Text', w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        tsetup.DoClick = function()

          if salary != nil and ( tonumber( salary ) > SB.Teams[i].maxsalary or tonumber( salary ) < SB.Teams[i].minsalary ) then
            chat.AddText( Color( 116, 0, 255 ), '[Budget] ', Color( 255, 255, 255 ), 'Один из аргументов превышает максимальное значение или ниже минимального значения ' )
          elseif piecework != nil and ( tonumber( piecework ) > SB.Teams[i].maxpiecework or tonumber( piecework ) < SB.Teams[i].minpiecework ) then
            chat.AddText( Color( 116, 0, 255 ), '[Budget] ', Color( 255, 255, 255 ), 'Один из аргументов превышает максимальное значение или ниже минимального значения ' )
          else
            net.Start( 'SB:UploadTeamValues' )
            net.WriteUInt( i, 7 )

            if salary != nil then
              net.WriteUInt( salary, 15 )
            end
            if piecework != nil then
              net.WriteUInt( piecework, 10 )
            end
            net.SendToServer()
          end

        end

        local closebtn = vgui.Create( 'DButton', tpanel )
        closebtn:SetText( '' )
        closebtn:SetSize( 26, 26 )
        closebtn:SetPos( tpanel:GetWide()-30, 4 )
        closebtn.Paint = function( self, w, h )
          draw.SimpleText( 'X', 'SB.Close', w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        closebtn.DoClick = function()
          tpanel:Remove()
        end

      end

    end

end)
