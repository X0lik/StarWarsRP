XL = XL or {}
XL.Modules = {}
XL.Modules["base"] = true
XL.Modules["database"] = true
XL.Modules["http"] = true
XL.Modules["resource"] = true
XL.Modules["starwars"] = true
XL.Modules["vgui"] = true

XL.Config = {}
XL.Config.DefaultCrouch = .4
XL.Config.DefaultSlowWalk = 80
XL.Config.DefaultWalk = 185
XL.Config.DefaultRun = 250
XL.Config.DefaultJump = 160
XL.Config.DefaultName = "Initializating.."

XL.Config.StartMoney = 1000

XL.Config.GiveAdminWeapons = true
XL.Config.AdminWeapons = {
	"weapon_physgun",
	"gmod_tool"
}
XL.Config.DefaultWeapons = {
	"hands"
}

XL.Config.HTTPStatus = false
XL.Config.HTTPConnections = true
XL.Config.HTTPAdminConnections = false
XL.Config.HTTPLuaHost = "http://localhost:443"
XL.Config.HTTPLogHost = "http://localhost:444"

XL.Config.VehicleRenderDist = 1000
XL.Config.EntityRenderDist = 2000
XL.Config.DoorRenderDist = 9000