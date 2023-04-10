local _GT = debug.getregistry()
local drawShadow = _GT.Entity.DrawShadow
hook.Add( "PlayerSpawnedRagdoll", "XL:HideRagdollShadows", function( _, __, ent )
    ent:drawShadow( false )
end)

hook.Add( "PlayerSpawnedVehicle", "XL:HideVehicleShadows", function( _, ent )
    ent:drawShadow( false )
end)

hook.Add( "PlayerSpawnedSENT", "XL:HideSENTShadows", function( _, ent )
    ent:drawShadow( false )
end)

hook.Add( "PlayerSpawnedProp", "XL:HidePropShadows", function( _, __, ent )
    ent:drawShadow( false )
end)