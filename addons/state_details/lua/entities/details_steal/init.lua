AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

util.AddNetworkString( 'SD:StealMenu' )

function ENT:Initialize()

    self:SetModel( 'models/Eli.mdl' )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetUseType( SIMPLE_USE )

end

function ENT:Use( ply )
    net.Start( 'SD:StealMenu' )
    net.Send( ply )
end
