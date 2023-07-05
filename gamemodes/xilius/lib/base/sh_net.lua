nw = {}
function nw.Receive( name, timeout, func )

    net.Receivers[name:lower()] = function( len, ply )
        if nw.IsTimedOut( ply, name ) then return end

        if func == nil then
            timeout( len, ply )
            nw.Timeout( ply, name, .1 )
        else
            func( len, ply )
            nw.Timeout( ply, name, timeout )
        end
    end

end
_G.net.Receive = nw.Receive

function nw.Timeout(ply, name, time)
    if ply == nil then return end
    ply.NetTimedOut[name] = true
    timer.Simple( time, function()
        if IsValid( ply ) then ply.NetTimedOut[name] = false end
    end)
end

function nw.IsTimedOut(ply, name)
    if ply == nil then return false end
    if ply.NetTimedOut[name] ~= nil and ply.NetTimedOut[name] then
        XL:Log( ply:Name() .. " (" .. ply:SteamID() .. ") trying to use exploit", name, redColor )
        XL:HTTPLog( ply:Name() .. " (" .. ply:SteamID() .. ") trying to use exploit: " .. name )
        return true
    end
    return false
end

--[[util.AddNetworkString( "TestNet" )
net.Receive( "TestNet", 5, function(_,ply) 

    print(ply)

end)]]