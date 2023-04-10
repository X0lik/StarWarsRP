local lp, ppos, epos
hook.Add( "Tick", "XL:RenderDistance", function()
    
    lp = LocalPlayer()
    if lp:IsValid() then
        ppos = lp:GetPos()
        for i,v in next, ents.GetAll() do
            epos = v:GetPos()
            if ppos:Distance( epos ) >= XL.Config.RenderDistance then
                v:SetNoDraw( true )
            else
                v:SetNoDraw( false )
            end
        end
    end

end)