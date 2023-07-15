XAC = XAC or {}
XAC.EncryptedHooks = {}

local mathRand = math.random
local encryptSymbols = {
	"A", "B", "C", "D", "E", "F", "G",
	"H", "I", "J", "K", "L", "M", "N",
	"O", "P", "Q", "R", "S", "T", "U",
	"V", "W", "X", "Y", "Z",
	"a", "b", "c", "d", "e", "f", "g",
	"h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u",
	"v", "w", "x", "y", "z"
}
function XAC:EncryptHook( power )

	local hook = ""
	for i=1, power do
		local type = mathRand(0,1)
		if type == 0 then
			hook = hook .. mathRand(0,9)
		else
			hook = hook .. encryptSymbols[mathRand(0,52)]
		end
	end

	XAC.EncryptedHooks[hook] = true
	return hook

end