hook.Add( 'SpawnMenuOpen', 'XD:SpawnMenuAccess', function()
	if not LocalPlayer():CanSpawn() then
		return false
	end
end)
