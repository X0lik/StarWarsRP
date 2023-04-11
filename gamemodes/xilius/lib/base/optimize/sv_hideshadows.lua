hook.Add( "PlayerSpawnedRagdoll", "XL:HideRagdollShadows", function( _, __, ent )
    ent:DrawShadow( false )
end)

hook.Add( "PlayerSpawnedVehicle", "XL:HideVehicleShadows", function( _, ent )
    ent:DrawShadow( false )
end)

hook.Add( "PlayerSpawnedSENT", "XL:HideSENTShadows", function( _, ent )
    ent:DrawShadow( false )
end)

hook.Add( "PlayerSpawnedProp", "XL:HidePropShadows", function( _, __, ent )
    ent:DrawShadow( false )
end)