local ranks_recovery = {

    { ['id'] = 'STEAM_0:1:555030832', ['rank'] = 'operator' }, -- | Krya_Kryakin
    { ['id'] = 'STEAM_0:1:439239140', ['rank'] = 'operator' }, -- | JOJO
    { ['id'] = 'STEAM_0:1:572284808', ['rank'] = 'developer' }, -- | X0lik

}

hook.Add( 'PlayerInitialSpawn', 'XD:RankRecovery', function( ply )

    timer.Simple( 0.1, function ()

        for i,v in ipairs( ranks_recovery ) do
            if v.id == ply:SteamID() then
                ply:SetUserGroup( v.rank )
                XD:ChatLog( ply, 'Восстанавливаем ранг', v.rank, Color( 116, 0, 255 ) )
                XD:CLog( 'Rank recovering' , ply:Nick() .. '(' .. ply:SteamID() .. ')', v.rank, Color( 116, 0, 255 ) )
            end
        end

    end)

end)
