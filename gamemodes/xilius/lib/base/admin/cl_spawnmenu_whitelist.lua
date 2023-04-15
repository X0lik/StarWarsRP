local ply
local hookAdd = hook.Add
hook.Add( "SpawnMenuOpen", "XL:SpawnMenuWhitelist", function()
	ply = LocalPlayer()
	if not ply:IsSuperAdmin() then
		return false
	end
end)