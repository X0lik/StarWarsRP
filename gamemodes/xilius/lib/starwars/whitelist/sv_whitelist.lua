local addNet = util.AddNetworkString
local nwReceive, readUInt, nwStart, nwSend = net.Receive, net.ReadUInt, net.Start, net.Send
local ply, team, rank
addNet( "XL:Whitelist:SetTeam" )
addNet( "XL:Whitelist:OpenMenu" )
nwReceive( "XL:Whitelist:SetTeam", function( _, admin )

	if admin:IsSuperAdmin() then
		ply = net.ReadEntity()
		team = readUInt(9)
		rank = readUInt(9)
		XL:SetTeam( ply, team, rank )
	end

end)

hook.Add( "PlayerSay", "XL:Whitelist", function( ply, text )

	if text == "/wl" and ply:IsSuperAdmin() then
		nwStart( "XL:Whitelist:OpenMenu" )
		nwSend( ply )
		return ""
	end

end)