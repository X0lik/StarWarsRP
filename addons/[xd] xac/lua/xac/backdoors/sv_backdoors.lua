local addNetString, netReceive, strLower = util.AddNetworkString, net.Receive, string.lower
local badNets = {
	"Sbox_itemstore", "ItemStoreCheck", "EscapeMenu", "SlownLSDate", "strip0",
	"SlownLSPlayer", "IGSInfo", "ServerG", "Splutter", "JOJO", "ItemStore", "idk",
	"_CATS", "FixedULX", "SilentUserAllow", "Context_Open", "sh_spawnprops", "c",
	"gP:PropProtect", "SH_SZ.PlayerInfo", "Sbox_darkrp", "_Defqon", "Sandbox_ArmDupe",
	"Ulib_Message", "ULogs_Info", "ITEM", "fix", "Fix_Keypads", "Remove_Exploiters",
	"noclipcloakaesp_chat_text", "nostrip", "nocheat", "LickMeOut", "ULX_QUERY2", "XSploit",
	"MoonMan", "Im_SOCool", "Sandbox_GayParty", "oldNetReadData", "memeDoor", "random",
	"BackDoor", "OdiumBackDoor", "cucked", "NoNerks", "kek", "ZimbaBackDoor", "something",
	"DarkRP_AdminWeapons", "SessionBackdoor", "ULXQUERY2", "fellosnake", "enablevac",
	"killserver", "fuckserver", "cvaraccess", "rcon", "rconadmin", "web", "jesuslebg",
	"zilnix", "disablebackdoor", "kill", "DefqonBackdoor", "zmlab_GetPlayerInfo", "XDRM",
	"XWarn.DRM", "MetroModelsLoading"
}

for i,v in next, badNets do
	addNetString(v)
	net.Receivers[strLower(v)] = function( len, ply )
		ply:XACBan( "Using Backdoor (" .. v .. ")" )
	end
end