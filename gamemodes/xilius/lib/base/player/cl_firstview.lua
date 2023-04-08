local firstVector, secondVector = Vector( 0, 0, 0 ), Vector( 1, 1, 1 )
local ply, bone
local delay = 0
hook.Add( "Think", "XL:FirstView", function() 

	if delay < CurTime() then
		
		ply = LocalPlayer()
		bone = ply:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			if ply:IsValid() && ply:Alive() then
				ply:ManipulateBoneScale( bone, firstVector )
			else
				ply:ManipulateBoneScale( bone, secondVector )
			end
		end
		delay = CurTime() + 0.1
	end

end)

local eyeview = {}
local attachment
hook.Add( "CalcView", "XL:ChangeView", function( ply, _, ang, fov ) 

	if ply:IsValid() && ply:Alive() && not ply:Crouching() then
		
		attachment = ply:GetAttachment( 1 )
		eyeview.origin = attachment.Pos
		eyeview.angles = ang
		eyeview.fov = fov
		return eyeview
	
	end

end)

local hitpos
hook.Add( "HUDPaint", "XL:Crosshair", function()

	ply = LocalPlayer()
	hitpos = ply:GetEyeTrace().HitPos:ToScreen()

	surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
	surface.DrawRect( hitpos.x - 2, hitpos.y - 2, 6, 6 )

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.DrawRect( hitpos.x - 1, hitpos.y - 1, 4, 4 )

end)
hook.Add( "ShouldDrawLocalPlayer", "XL:DrawLocalPlayer", function() return true end)
