WM = WM or {}

WM.Command = '/weapon' -- Команда для вызова меню

WM.Groups = { -- Группы, имеющие доступ к команде
	['vip'] = true,
	['admin'] = true,
	['superadmin'] = true,
	['developer'] = true,
}

WM.Time = 200 -- Кулдаун

WM.Weapons = {

	{
		name = 'РПГ',
		class = 'weapon_rpg'
	},

	{
		name = 'Револьвер',
		class = 'weapon_357'
	},

	{
		name = 'Автомат',
		class = 'weapon_smg1'
	},

}