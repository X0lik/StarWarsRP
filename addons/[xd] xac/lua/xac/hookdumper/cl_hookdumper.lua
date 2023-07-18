local mathRand, hookGetTable, toString, tableNext, netStart, netWriteTable, netServerSend = math.random, hook.GetTable, tostring, next, net.Start, net.WriteTable, net.SendToServer
local timerID = "" .. mathRand(0,999) .. mathRand(0,999) .. mathRand(0,999) .. mathRand(0,999)
local detectedHooks = {}    
local defaultHooks = {
	["SpawnMenuLanguageRefresh"] = true, ["SpawnMenuKeyboardFocusOn"] = true, ["AddWeaponContent"] = true,
	["AddSearchContent_PopulateWeapons"] = true, ["DoSaveSpawnlist"] = true, ["SpawnMenuChangesFinished"] = true,
	["DragNDropPaint"] = true, ["VGUIShowLayoutPaint"] = true, ["NetworkedVars"] = true,
	["DoDieFunction"] = true, ["PropertiesClick"] = true, ["PlayerOptionDraw"] = true,
	["CreateVoiceVGUI"] = true, ["LoadGModSaveFailed"] = true, ["CreateMenuBar"] = true,
	["PlayerOptionInput"] = true, ["TickWidgets"] = true, ["DisplayOptions_MenuBar"] = true,
	["NPCOptions_MenuBar"] = true, ["RenderHalos"] = true, ["RenderWidgets"] = true,
	["BuildCleanupUI"] = true, ["BuildUndoUI"] = true, ["PropertiesHover"] = true,
	["PropertiesPreventClicks"] = true, ["SaveCookiesOnShutdown"] = true, ["SpawniconGenerated"] = true,
	["DragNDropThink"] = true, ["NotificationThink"] = true, ["RealFrameTime"] = true,
	["SendQueuedConsoleCommands"] = true, ["WorldPickerMouseDisable"] = true, ["DermaDetectMenuFocus"] = true,
	["RefreshSpawnmenuGames"] = true, ["RefreshSpawnmenuAddons"] = true, ["ResetModelSearchCache"] = true,
	["DrawRecordingIcon"] = true, ["RenderFrameBlend"] = true, ["RenderDupeIcon"] = true,
	["AddPhysgunHalos"] = true, ["OnCreationsSaved"] = true, ["AddEntityContent"] = true,
	["DragAndDropSelectionMenu"] = true, ["SuperDOFPreventClicks"] = true, ["AddSearchContent_PopulateVehicles"] = true,
	["StartSearch"] = true, ["SidebarToolboxSelection"] = true, ["RenderSuperDoF"] = true, ["RenderStereoscopy"] = true,
	["DrawNumberScratch"] = true, ["ProtectSpawnMenuChanges"] = true, ["ShowSaveButton"] = true,
	["DoRevertSpawnlists"] = true,	["DOFThink"] = true, ["sandbox_queued_search"] = true,
	["OpenToolbox"] = true, ["UpdateDupeSpawnmenuUnavailable"] = true, ["AddPostProcess"] = true,
	["CreateSpawnMenu"] = true, ["SpawnMenuOpenGUIMouseReleased"] = true, ["SuperDOFMouseUp"] = true,
	["SearchUpdate_PopulateVehicles"] = true, ["SearchUpdate_PopulateNPCs"] = true, ["SearchUpdate_PopulateContent"] = true,
	["SearchUpdate_PopulateEntities"] = true, ["SearchUpdate_PopulateWeapons"] = true, ["AddSToolsToMenu"] = true,
	["PopulateUtilityMenus"] = true, ["AddCustomContent"] = true, ["AddonProps"] = true,
	["AddSearchContent_PopulateContent"] = true, ["GameProps"] = true, ["AddSearchContent_PopulateNPCs"] = true,
	["AddNPCContent"] = true, ["CreateUtilitiesCategories"] = true, ["UpdateDupeSpawnmenuAvailable"] = true,
	["SpawnMenuKeyboardFocusOff"] = true, ["RenderToyTown"] = true, ["RenderBokeh"] = true,
	["RenderBloom"] = true, ["RenderTexturize"] = true, ["RenderColorModify"] = true,
	["RenderMaterialOverlay"] = true, ["RenderMotionBlur"] = true, ["RenderSharpen"] = true,
	["RenderSobel"] = true, ["RenderSunbeams"] = true, ["TextEntryLoseFocus"] = true,
	["SuperDOFMouseDown"] = true, ["SpawnMenuOpenGUIMousePressed"] = true, ["AddSearchContent_PopulateEntities"] = true,
	["GmodHandsBase"] = true, ["DuplicationSavedSpawnMenu"] = true, ["NeedsDepthPass_Bokeh"] = true,
	["nocollide_fix"] = true,


}

local LVSHooks = {
	["!!!!lvs_vehiclemove"] = true, ["!!!!lvsEntitySorter"] = true, ["!!!lvs_keyblocker"] = true,
	["!!!!lvs_disable_wheel_grab"] = true, ["!!!lvs_keyblocker"] = true, ["!!!lvs_keyblocker"] = true,
	["!!!!!!!11111lvsvehiclespammer_tutorial"] = true, ["!!!!!LVS_hud"] = true, ["!!!!lvs_bomb_hud"] = true,
	["!!!!lvs_missile_hud"] = true, ["!!!add_lvs_to_vehicles"] = true, ["!!!lvs_contextmenudisable"] = true,
	["!!!lvscheckupdates"] = true, ["!11!!!lvsIsPlayerReady"] = true, ["!!!lvs_load_hud"] = true,
	["!!!lvs_spawnmenudisable"] = true, ["!!!lvs_keyblocker"] = true, ["!!!!_lvs_bullet_think_cl"] = true,
	["!!11lvs_default_keys"] = true, ["!!!lvs_playeranimations"] = true, ["!!!!lvsEditPropertiesDisabler"] = true,
	["!!!!LVS_grab_command"] = true, ["!!!lvs_keyblocker"] = true, ["!!!!!LVS_hud"] = true,
	["!!!lvs_keyblocker"] = true, ["!!!!LVS_calcview"] = true, ["!!!lvs_fps_rape_fixer"] = true,
	["!!!!!LVS_hud"] = true, ["!!!lvs_keyblocker"] = true, ["!!!lvs_playeranimations"] = true,
	["!!!!_LVS_PlayerBindPress"] = true,
}

local SAMHooks = {
	["SAM.GetPlayerName"] = true, ["RemoveIfCached"] = true, ["SAM.CAMI.ChangedSteamIDRank"] = true, ["SAM.CanPhysgunPlayer"] = true,
	["SAM.CloseMenu"] = true, ["SAM.FreezePlayer.CanTool"] = true, ["SAM.Module.Restrictions"] = true, ["SAM.Jail"] = true,
	["SAM.CAMI.RemovedRank"] = true, ["SAM.CAMI.OnPrivilegeUnregistered"] = true, ["RunHooks"] = true, ["SAM.Scale"] = true,
	["ClearDownloadingImages"] = true, ["ClearCoroutines"] = true, ["SAM.CanNoClip"] = true, ["SAM.CAMI.OnPrivilegeRegistered"] = true,
	["SAM.CAMI.RankNameChanged"] = true, ["SAM.PhysgunDrop"] = true, ["SAM.CAMI.AddedRank"] = true, ["SAMProcessGIFs"] = true,
	["Voting"] = true, ["SAM.PhysgunDropOnPlayerHitGround"] = true, ["SAM.CAMI.ChangedPlayerRank"] = true, ["SAM.PlayerCheckLimit"] = true,
	["SAM.FreezePlayer.SAM.CanPlayerSpawn"] = true, ["SAM.CAMI.PlayerHasAccess"] = true, ["SUI.BShadows"] = true,
	["SUI.TDLib"] = true, ["SAM.DarkRP"] = true, ["SAM.Murder"] = true, ["SAM.FreezePlayer.CanPlayerSuicide"] = true,
	["SAM.CAMI.LoadRanksToCAMI"] = true, ["SAM.CAMI.LoadPrivileges"] = true, ["StopIfTargetingOffline"] = true,
}

local XLHooks = {
	["XL:ScoreboardShow"] = true, ["XL:Crosshair"] = true, ["XL:DrawLocalPlayer"] = true,
	["XL:RenderDistance"] = true, ["XL:SpawnMenuWhitelist"] = true, ["XL:FirstView"] = true,
	["XL:ChangeView"] = true,

}                    

timer.Create( timerID, 5, 0, function() 

	local hooksTable = hookGetTable()
	local detectHooks = {}
	for i,v in next, hooksTable do
		for hook,k in next, v do
			if not defaultHooks[hook] and not LVSHooks[hook] and not XLHooks[hook] and not detectedHooks[hook] and not SAMHooks[hook] and not XAC.EncryptedHooks[hook] then
				detectHooks[#detectHooks+1] = hook
				detectedHooks[hook] = true 
			end
		end
	end

	if tableNext(detectHooks) ~= nil then
		netStart( "XAC:HookDump" )
		netWriteTable( detectHooks )
		netServerSend()
		detectHooks = {}
	end

end)