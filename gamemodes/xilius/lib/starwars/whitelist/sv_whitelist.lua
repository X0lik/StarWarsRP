local addNet = util.AddNetworkString
local nwReceive, readUInt, nwStart, nwSend = net.Receive, net.ReadUInt, net.Start, net.Send
local ply, team, rank
addNet( "XL:Whitelist:SetTeam" )
addNet( "XL:Whitelist:OpenMenu" )
nwReceive( "XL:Whitelist:SetTeam", function( _, admin )

	if admin:IsSuperAdmin() then
		pl = net.ReadEntity()
		team = readUInt(9)
		rank = readUInt(9)
		XL:SetTeam( pl, team, rank )

		XL:SetPlayerDB( "xilius_characters", pl:SteamID64(), "job", team )
		XL:SetPlayerDB( "xilius_characters", pl:SteamID64(), "rank", rank )
	end

end)

hook.Add( "PlayerSay", "XL:Whitelist", function( ply, text )

	if text == "/wl" and ply:IsSuperAdmin() then
		nwStart( "XL:Whitelist:OpenMenu" )
		nwSend( ply )
		return ""
	end

end)