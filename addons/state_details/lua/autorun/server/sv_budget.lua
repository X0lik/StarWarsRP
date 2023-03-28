DB = DB or {}
util.AddNetworkString( 'DB:SellStealedDetails' )
util.AddNetworkString( 'DB:StealingDetails' )
util.AddNetworkString( 'DB:SendDetails' )

net.Receive( 'DB:SellStealedDetails', function( _, ply )

	if ply.StealedDetails > 0 then

		ply.MoneyFromDetails = ply.MoneyFromDetails + DB.StealedDetailsCost * ply.StealedDetails )
		ply.StealedDetails = 0

		for i, v in ipairs( player.GetAll() ) do
			if v:Team() == DB.StealNotifyTeam then
				v:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[Кража] ", Color( 255, 255, 255 ), "Кто-то украл и продал выделенные запчасти" ) ' )
			end
		end

	end

end)

local details
net.Receive( 'DB:StealingDetails', function( _, ply  )

	details = net.ReadUInt(15)
	if DB:AccessTeamToSteal[ ply:Team() ] then
		ply.StealedDetails = details
		ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[Кража] ", Color( 255, 255, 255 ), "Вы украли ' .. details .. ' запчастей" ) ' )
	end

end)

local teamType
net.Receive( 'DB:SendDetails', function( _, ply )

	teamType = net.ReadString()
	details = net.ReadUInt(15)
	if ply:Team() == DB.TeamPresident then

		if teamType == 'army' then
			DB.CurrentDetails = DB.CurrentDetails - details
			DB.ArmyDetails = DB.ArmyDetails + details
			ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[Бюджет] ", Color( 255, 255, 255 ), "Вы выделили ' .. details .. ' запчастей для армии" ) ' )
		elseif teamType == 'police' then
			DB.CurrentDetails = DB.CurrentDetails - details
			DB.PoliceDetails = DB.PoliceDetails + details
			ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[Бюджет] ", Color( 255, 255, 255 ), "Вы выделили ' .. details .. ' запчастей для полиции" ) ' )
		elseif teamType == 'government' then
			DB.CurrentDetails = DB.CurrentDetails - details
			DB.GovernmentDetails = DB.GovernmentDetails + details
			ply:SendLua( ' chat.AddText( Color( 116, 0, 255 ), "[Бюджет] ", Color( 255, 255, 255 ), "Вы выделили ' .. details .. ' запчастей для органов власти" ) ' )
		end

	end

end)

hook.Add( 'PlayerDeath', 'DB:SetDetails', function( ply )

	ply.StealedDetails = 0
	ply.MoneyFromDetails = 0

end)
