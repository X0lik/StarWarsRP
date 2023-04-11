local PLAYER = FindMetaTable("Player")
function PLAYER:Nick()
	return self:GetNW2String( "XL:Name", XL.Config.DefaultName )
end

function PLAYER:ID()
	return self:GetNW2String( "XL:ID", "0" )
end

function PLAYER:SetName( newName )
	self:SetNW2String( "XL:Name", newName )
end

function PLAYER:SetID( newID )
	self:SetNW2String( "XL:ID", newID )
end