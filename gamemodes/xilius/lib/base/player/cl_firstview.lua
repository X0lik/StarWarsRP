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

local view = {}
local attachment
hook.Add( "CalcView", "XL:ChangeView", function( ply, _, ang, fov ) 

	if ply:IsValid() && ply:Alive() then
		
		attachment = ply:GetAttachment(1)
		view.origin = attachment.Pos
		view.angles = ang
		view.fov = fov
		return view
	
	end

end)

local hitpos
hook.Add( "HUDPaint", "XL:Crosshair", function()

	ply = LocalPlayer()
	hitpos = ply:GetEyeTrace().HitPos:ToScreen()

	surface.SetDrawColor( 0, 0, 0 )
	draw.Circle( hitpos.x, hitpos.y, 4, 10 )
	surface.SetDrawColor( 255, 255, 255 )
	draw.Circle( hitpos.x, hitpos.y, 3, 10 )

end)
hook.Add( "ShouldDrawLocalPlayer", "XL:DrawLocalPlayer", function() return true end)