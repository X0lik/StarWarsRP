local PLY = FindMetaTable("Player")
function PLY:SetName( newName )
	self:SetNWString( "XL:Name", newName )
end

function PLY:Name()
    return self:GetNWString( "XL:Name" ) or XL.Config.DefaultName
end
PLY.SteamName = PLY.Name
PLY.GetName = PLY.Name
PLY.Nick = PLY.Name