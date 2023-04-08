local function CanChangeDefcon( ply )
    return ply:IsAdmin()
end

util.AddNetworkString( "XL:SetDefcon" )
net.Receive( "XL:SetDefcon", function( _, ply )

    if CanChangeDefcon( ply ) then
        local code = net.ReadUInt(3)
        SetGlobal2Int( "XL:Defcon", code )
        BroadcastLua( " chat.AddText( Color( "..defaultColor.r..", ".. defaultColor.g.. ", "..defaultColor.b.."), '[GENERAL] ', Color( 255, 255, 255 ), 'Изменение кода: ', Color( 220, 20, 60 ), 'DEFCON " .. GetGlobal2Int( "XL:Defcon" ) .. "' ) " )
    end

end)