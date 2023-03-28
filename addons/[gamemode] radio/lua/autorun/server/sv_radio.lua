util.AddNetworkString( 'XRadio:Toggle' )
util.AddNetworkString( 'XRadio:SetChannel' )
util.AddNetworkString( 'XRadio:ChangeButton' )
file.CreateDir( 'xradio' )

local buttons = {
  ['a'] = KEY_A,
  ['b'] = KEY_B,
  ['c'] = KEY_C,
  ['d'] = KEY_D,
  ['e'] = KEY_E,
  ['f'] = KEY_F,
  ['g'] = KEY_G,
  ['h'] = KEY_H,
  ['i'] = KEY_I,
  ['j'] = KEY_J,
  ['k'] = KEY_K,
  ['l'] = KEY_L,
  ['m'] = KEY_M,
  ['n'] = KEY_N,
  ['o'] = KEY_O,
  ['p'] = KEY_P,
  ['q'] = KEY_Q,
  ['r'] = KEY_R,
  ['s'] = KEY_S,
  ['t'] = KEY_T,
  ['u'] = KEY_U,
  ['v'] = KEY_V,
  ['w'] = KEY_W,
  ['x'] = KEY_X,
  ['y'] = KEY_Y,
  ['z'] = KEY_Z
}

local btn
net.Receive( 'XRadio:ChangeButton', function( _, ply )

    btn = net.ReadString()
    ply:SetNWString( 'XRadio:Button', string.lower( btn ) )
    file.Write( 'xradio/' .. ply:SteamID64() .. '.txt', string.lower( btn ) )

end)

net.Receive( 'XRadio:Toggle', function( _, ply )

    if ply:GetNWBool( 'XRadio:CanHear' ) then
        ply:SetNWBool( 'XRadio:CanHear', false )
        ply:SetNWBool( 'XRadio:IsTalking', false )
    else
        ply:SetNWBool( 'XRadio:CanHear', true )
    end

end)

local channel
net.Receive( 'XRadio:SetChannel', function( _, ply )

    channel = net.ReadString()
    ply:SetNWString( 'XRadio:Channel', channel )

end)

hook.Add( 'PlayerInitialSpawn', 'XRadio:LoadData', function( ply )
    ply:SetNWBool( 'XRadio:CanHear', false )
    ply:SetNWBool( 'XRadio:IsTalking', false )
    ply:SetNWString( 'XRadio:Channel', '10.0' )

    if file.Exists( 'xradio/' .. ply:SteamID64() .. '.txt', 'DATA' ) then
      ply:SetNWString( 'XRadio:Button', file.Read( 'xradio/' .. ply:SteamID64() .. '.txt', 'DATA' ) )
    else
      ply:SetNWString( 'XRadio:Button', 'b' )
    end
end)

hook.Add( 'PlayerButtonDown', 'XRadio:Status', function( ply, button )

	  if buttons[ ply:GetNWString( 'XRadio:Button' ) ] != nil and button == buttons[ ply:GetNWString( 'XRadio:Button' ) ] then
        if ply:GetNWBool( 'XRadio:IsTalking' ) then
            ply:SetNWBool( 'XRadio:IsTalking', false )
        else
            ply:SetNWBool( 'XRadio:IsTalking', true )
        end
    end

end)

hook.Add( 'PlayerCanHearPlayersVoice', 'XRadio:Radio', function( lis, tal )

    if lis:GetNWString( 'XRadio:Channel' ) == tal:GetNWString( 'XRadio:Channel' ) and lis:GetNWBool( 'XRadio:CanHear' ) and tal:GetNWBool( 'XRadio:IsTalking' ) then
        return true
    end

end)
