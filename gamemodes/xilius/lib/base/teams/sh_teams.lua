XL.Teams = {}
XL.TeamsCount = 1
XL.DefaultTeam = 1

function XL:NewTeam( tbl )

	XL.Teams[XL.TeamsCount] = tbl
	XL.TeamsCount = XL.TeamsCount + 1
	return XL.TeamsCount-1

end

local PLY = FindMetaTable("Player")
function PLY:GetTeam()
	return XL.Teams[self:Team()], self.teamRank
end

TEAM_CITIZEN = XL:NewTeam({
	name = "Citizen",
	color = Color( 0, 255, 0 ),
	salary = 100,
	models = { "models/player/Group02/male_04.mdl", "models/player/Group02/male_06.mdl" },
	weapons = {},
	category = "citizens",
	ranks = {
		[1] = {
			weapons = { "weapon_fists", "weapon_ar2" },
		}
	}
})

TEAM_POLICE = XL:NewTeam({
	name = "Police",
	color = Color( 116, 0, 255 ),
	salary = 500,
	models = { "models/player/swat.mdl" },
	weapons = { "weapon_fists", "weapon_ar2" },
	category = "government"
})