SB = SB or {}
file.CreateDir( 'statebudget' )

function SB:LoadBudget()

	if file.Exists( 'statebudget/budget.txt', 'DATA' ) then
		SB.Budget = tonumber( file.Read( 'statebudget/budget.txt', 'DATA' ) )
	else
		SB.Budget = 10000
		file.Write( 'statebudget/budget.txt', 10000 )
	end

end

function SB:AddMoney( amount )

	SB.Budget = SB.Budget + amount
	file.Write( 'statebudget/budget.txt', SB.Budget )

end

hook.Add( 'PostGamemodeLoaded', 'SB:LoadBudgetMoney', function() SB:LoadBudget() end)
hook.Add( 'PlayerInitialSpawn', 'SB:LoadPlayer', function( ply )

	ply.OwnedNumz = 0
	ply.HasPiecework = 0
	ply.LegalTax = false

end)