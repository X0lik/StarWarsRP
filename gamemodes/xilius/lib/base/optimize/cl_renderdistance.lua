local lp, ppos, epos
local doorTable = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}
hook.Add( "Tick", "XL:RenderDistance", function()
    
    lp = LocalPlayer()
    if lp:IsValid() then
        ppos = lp:GetPos()
        for i,v in next, ents.GetAll() do

            epos = v:GetPos()
            if doorTable[v:GetClass()] then
                if ppos:Distance( epos ) >= XL.Config.DoorRenderDist then
                    v:SetNoDraw( true )
                else
                    v:SetNoDraw( false )
                end
            elseif v:IsVehicle() then
                if ppos:Distance( epos ) >= XL.Config.VehicleRenderDist then
                    v:SetNoDraw( true )
                else
                    v:SetNoDraw( false )
                end
            else
                if ppos:Distance( epos ) >= XL.Config.EntityRenderDist then
                    v:SetNoDraw( true )
                else
                    v:SetNoDraw( false )
                end
            end
        end
    end

end)