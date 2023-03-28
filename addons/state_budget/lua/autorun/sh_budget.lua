SB = SB or {}
if SERVER then
  util.AddNetworkString( 'SB:UploadTeamValues' )
  util.AddNetworkString( 'SB:UploadTaxValues' )
end

local team, salary, piecework, tax, percent
net.Receive( 'SB:UploadTeamValues', function( _, ply )
  team = net.ReadUInt(7)
  salary = net.ReadUInt(15)
  piecework = net.ReadUInt(10)

  SB.Teams[team].currentsalary = salary
  SB.Teams[team].currentpiecework = piecework
end)

net.Receive( 'SB:UploadTaxValues', function( _, ply )
  tax = net.ReadString()
  percent = net.ReadUInt(15)

  if SB.Taxes[tax].max > 1 or percent == 0 then
    SB.Taxes[tax].current = percent
    BroadcastLua( 'SB.Taxes["' .. tax .. '"].current = ' .. percent )
  else
    SB.Taxes[tax].current = percent/100
    BroadcastLua( 'SB.Taxes["' .. tax .. '"].current = ' .. percent/100 )
  end
end)

SB.SpecTax = 200 -- Ком. час
SB.Taxes = {

  ['paytax'] = {
    name = 'Налог на зарплату',
    min = 0,
    current = 0.1,
    max = 0.3,
  },

  ['soctax'] = {
    name = 'Налог на соц. обеспечение',
    min = 0,
    current = 0.1,
    max = 0.3,
  },

  ['doortax'] = {
    name = 'Налог на недвижимость',
    min = 10,
    current = 10,
    max = 50,
  },

  ['legaltax'] = {
    name = 'Налоги юр. лиц',
    min = 0,
    current = 0.1,
    max = 1,
  },

  ['existtax'] = {
    name = 'Налог на существование юр. лица',
    min = 0,
    current = 10,
    max = 100,
  },

}

hook.Add( 'PostGamemodeLoaded', 'SB:LoadTeams', function()

  SB.Teams = {

    [TEAM_CITIZEN] = {
      minsalary = 1000, -- Минимальная зарплата
      maxsalary = 2000, -- Максимальная зарплата
      currentsalary = 1500, -- Текущее значение зарплаты
      minpiecework = 0, -- Минимальная Сдельная ЗП
      maxpiecework = 100, -- Максимальная Сдельная ЗП
      currentpiecework = 50, -- Текущная Сдельная ЗП
    },

    [TEAM_POLICE] = {
      minsalary = 1000,
      maxsalary = 2000,
      currentsalary = 1500,
      minpiecework = 0,
      maxpiecework = 100,
      currentpiecework = 50,
    },

    [TEAM_CHIEF] = {
      minsalary = 1000,
      maxsalary = 3000,
      currentsalary = 2500,
      minpiecework = 0,
      maxpiecework = 100,
      currentpiecework = 100,
    },

  }

  SB.TeamsToKill = {
    TEAM_CITIZEN, TEAM_POLICE,
  }

  SB.TeamsToArrest = {
    TEAM_POLICE, TEAM_CHIEF,
  }

end)

hook.Add( 'PlayerDeath', 'SB:KillPiecework', function( v, i, ply )

  if SB.TeamsToKill[ ply:Team() ] then
    ply.HasPiecework = ply.HasPiecework + 1
  end

end)