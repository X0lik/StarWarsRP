local isValid, curTime = IsValid, CurTime
local firstVector, secondVector = Vector( 0, 0, 0 ), Vector( 1, 1, 1 )
local ply, bone
local delay = 0

local hookAdd = hook.Add
hookAdd( "Think", "XL:FirstView", function() 

	if delay < curTime() then
		
		ply = LocalPlayer()
		bone = ply:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			if ply:IsValid() && ply:Alive() then
				ply:ManipulateBoneScale( bone, firstVector )
			else
				ply:ManipulateBoneScale( bone, secondVector )
			end
		end
		delay = curTime() + 0.1
	end

end)

local view = {}
local attachment
hookAdd( "CalcView", "XL:ChangeView", function( ply, _, ang, fov ) 

	if isValid(ply) && ply:Alive() then
		
		attachment = ply:GetAttachment( ply:LookupAttachment("eyes") )
		view.origin = attachment.Pos
		view.angles = ang
		view.fov = fov
		return view
	
	end

end)

local setColor, drawCircle = surface.SetDrawColor, draw.Circle
local hitpos
hookAdd( "HUDPaint", "XL:Crosshair", function()

	ply = LocalPlayer()
	hitpos = ply:GetEyeTrace().HitPos:ToScreen()

	setColor( 0, 0, 0 )
	drawCircle( hitpos.x, hitpos.y, 4, 10 )
	setColor( 255, 255, 255 )
	drawCircle( hitpos.x, hitpos.y, 3, 10 )

end)
hookAdd( "ShouldDrawLocalPlayer", "XL:DrawLocalPlayer", function() return true end)