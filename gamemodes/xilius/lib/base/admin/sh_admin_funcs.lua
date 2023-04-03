local admins = {
	["helper"] = true,
	["moder"] = true,
	["admin"] = true,
	["stadmin"] = true,
	["curator"] = true,
	["operator"] = true,
	["developer"] = true
}

local headAdmins = {
	["stadmin"] = true,
	["curator"] = true,
	["operator"] = true,
	["developer"] = true
}

local PLY = FindMetaTable("Player")
function PLY:IsAdmin()
	return admins[self:GetUserGroup()]
end

function PLY:IsSuperAdmin()
	return headAdmins[self:GetUserGroup()]
end