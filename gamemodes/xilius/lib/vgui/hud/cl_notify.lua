XL = XL or {}
local drawBox, drawText = draw.RoundedBox, draw.SimpleText
local uiCreate = vgui.Create
local createFont, mat, setMat, setDrawColor = surface.CreateFont, Material, surface.SetMaterial, surface.SetDrawColor
local Receive, readString, readUInt = net.Receive, net.ReadString, net.ReadUInt
local sw, sh = ScrW(), ScrH()
local function addNotify( title, msg, type )

	local notifyFrame = uiCreate( "DFrame" )
	notifyFrame:SetSize( sw*.2, sh*.25 )
	notifyFrame:SetPos( sw*.4, sh*.1 )
	notifyFrame:MakePopup()
	notifyFrame:AnimAlpha()

end

Receive( "XL:PlayerNotify", function( _, pl )
	if pl == nil or pl:IsSuperAdmin() then
		local title = readString()
		local msg = readString()
		local type = readUInt(4)
		addNotify( title, msg, type )
	end
end)

XL:Notify = addNotify 