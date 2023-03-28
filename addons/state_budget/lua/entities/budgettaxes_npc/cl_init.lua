include( 'shared.lua' )

local sw, sh = ScrW(), ScrH()
net.Receive( 'SB:TaxesMenu', function()

    local percent
    local nextpage = false
    local bmenu = vgui.Create( 'DFrame' )
    bmenu:SetSize( sw*.4, sh*.7 )
    bmenu:Center()
    bmenu:SetTitle('')
    bmenu:ShowCloseButton( true )
    bmenu:MakePopup()
    bmenu.Paint = function( self, w, h )
      draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
      draw.SimpleText( 'Управление Налогами', 'SB.Title', w/2, h*.06, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local tlist = vgui.Create( 'DScrollPanel', bmenu )
    tlist:SetSize( bmenu:GetWide()*.9, bmenu:GetTall()*.82 )
    tlist:SetPos( bmenu:GetWide()*.05, bmenu:GetTall()*.12 )
    tlist.Paint = function( self, w, h )
      draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10 ) )
    end

    for i,v in pairs( SB.Taxes ) do

      local tbutton = vgui.Create( 'DButton', tlist )
      tbutton:SetText('')
      tbutton:Dock( TOP )
      tbutton:DockMargin( 0, 0, 0, 10 )
      tbutton:SetSize( tlist:GetWide(), tlist:GetTall()*.15 )
      tbutton.Paint = function( self, w, h )
          draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 20, 20 ) )
          draw.SimpleText( v.name, 'SB.Name', w/2, h/2, Color( 116, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      tbutton.DoClick = function()

        local tpanel = vgui.Create( 'EditablePanel' )
        tpanel:SetSize( sw*.25, sh*.3 )
        tpanel:Center()
        tpanel:MakePopup()
        tpanel.Paint = function( self, w, h )
          draw.RoundedBox( 10, 0, 0, w, h, Color( 50, 50, 50 ) )
          draw.RoundedBox( 10, 2, 2, w-4, h-4, Color( 20, 20, 20 ) )
          draw.SimpleText( v.name, 'SB.Name', w/2, h*.1, Color( 116, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          draw.SimpleText( 'Налог:', 'SB.Text', w*.1, h*.45, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

          if v.max > 1 then
            draw.SimpleText( 'Текущий: ' .. v.current, 'SB.Text', w/2, h*.65, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          else
            draw.SimpleText( 'Текущий: ' .. v.current * 100 .. '%', 'SB.Text', w/2, h*.65, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
        end

        local tsalary = vgui.Create( 'DTextEntry', tpanel )
        tsalary:SetSize( tpanel:GetWide()*.65, tpanel:GetTall()*.13 )
        tsalary:SetPos( tpanel:GetWide()*.28, tpanel:GetTall()*.4 )
        if v.max > 1 then
          tsalary:SetPlaceholderText( 'Минимальный: ' .. v.min .. ' | Максимальный: ' .. v.max )
        else
          tsalary:SetPlaceholderText( 'Минимальный: ' .. v.min*100 .. '% | Максимальный: ' .. v.max*100 .. '%' )
        end
        tsalary.OnChange = function( self )
          percent = self:GetValue()
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

          if percent != nil and ( tonumber( percent ) > v.max * 100 or tonumber( percent ) < v.min * 100 ) then
            chat.AddText( Color( 116, 0, 255 ), '[Budget] ', Color( 255, 255, 255 ), 'Один из аргументов превышает максимальное значение или ниже минимального значения ' )
          else
            net.Start( 'SB:UploadTaxValues' )
            net.WriteString( i )
            net.WriteUInt( percent, 15 )
            net.SendToServer()
          end

          tpanel:Remove()

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
