XL.Teams = {}
XL.TeamsCount = 1
XL.DefaultTeam = 1

function XL:NewTeam( tbl )

	XL.Teams[XL.TeamsCount] = tbl
	XL.TeamsCount = XL.TeamsCount + 1
	return XL.TeamsCount-1

end

function XL:GetTeamName( ply )
	local team = XL.Teams[ply:Team()]
	if ply.teamRank ~= nil and team.ranks ~= nil and team.ranks[ply.teamRank] ~= nil then
		return team.ranks[ply.teamRank].name
	else
		return team.name
	end
end

local PLY = FindMetaTable("Player")
function PLY:GetTeam()
	if self.teamRank ~= nil and team.ranks ~= nil and team.ranks[self.teamRank] ~= nil then
		return XL.Teams[self:Team()].ranks[self.teamRank]
	else
		return XL.Teams[self:Team()]
	end
end

TEAM_CITIZEN = XL:NewTeam({
	name = "Citizen",
	color = Color( 0, 255, 0 ),
	salary = 100,
	models = { "models/player/Group02/male_04.mdl", "models/player/Group02/male_06.mdl" },
	weapons = {},
	ammo = {},
	category = "citizens",
	ranks = {

		[1] = {
			name = "Big Citizen",
			models = { "models/player/Group02/male_04.mdl", "models/player/Group02/male_06.mdl" },
			weapons = { "weapon_fists", "weapon_ar2" },
			ammo = {
				["357"] = 50
			},
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