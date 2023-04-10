XL = {}
XL.Modules = {}
XL.Modules["base"] = true
XL.Modules["vgui"] = true
XL.Modules["cmd"] = true
XL.Modules["resource"] = false
XL.Modules["http"] = false
XL.Modules["starwars"] = true
XL.Modules["donate"] = false


XL.Config = {}
XL.Config.DefaultCrouch = .4
XL.Config.DefaultSlowWalk = 80
XL.Config.DefaultWalk = 185
XL.Config.DefaultRun = 250
XL.Config.DefaultJump = 160
XL.Config.DefaultName = "Connecting.."

XL.Config.StartMoney = 1000

XL.Config.GiveAdminWeapons = true
XL.Config.AdminWeapons = {
	"weapon_physgun",
	"gmod_tool"
}

XL.Config.HTTPStatus = true
XL.Config.HTTPConnections = true
XL.Config.HTTPAdminConnections = true

XL.Config.HTTPLuaHost = "http://localhost:443"
XL.Config.HTTPLogHost = "http://localhost:444"

XL.Config.RenderDistance = 1000