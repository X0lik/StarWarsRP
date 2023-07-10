my_http = CHTTP

local createDir, fileFind, fileWrite, fileRead, fileDelete, metaTable, hookAdd = file.CreateDir, file.Find, file.Write, file.Read, file.Delete, debug.getregistry(), hook.Add
createDir( "xac" )

function XAC:LogFile( dir, steamid, data )

	createDir( "xac/" .. steamid )
	createDir( "xac/" .. steamid .. "/" .. dir )

	local files = fileFind( "xac/" .. steamid .. "/" .. dir .. "/*", "DATA" ) or {}
	fileWrite( "xac/" .. steamid .. "/" .. dir .. "/" .. #files+1 .. ".txt", data )
	return "data/xac/" .. steamid .. "/" .. dir .. "/" .. #files+1 .. ".txt"

end

function XAC:CacheFiles( dir, steamid )

	local data = {}
	local files = fileFind( "xac/" .. steamid .. "/" .. dir .. "/*", "DATA" )
	for i,v in next, files do
		local fileData = fileRead( "xac/" .. steamid .. "/" .. dir .. "/" .. v )
		data[i] = fileData
	end
	return next(data) ~= nil and data or nil

end

function XAC:RemoveFiles( dir, steamid )

	local files = fileFind( "xac/" .. steamid .. "/" .. dir .. "/*", "DATA" )
	for i,v in next, files do
		fileDelete( "xac/" .. steamid .. "/" .. dir .. "/" .. v )
	end
	XAC:Log( steamid .. " data was erased!" )

end

local PLAYER = metaTable["Player"]
function PLAYER:XACBan( reason )

	if self.XACHasBanned then return end
	local banData = XAC:LogFile( "ban", self:SteamID64(), reason )
	for i,v in next, player.GetAll() do
		v:SendLua( ' chat.AddText( Color( 220, 20, 60 ), "| [XAC] ", Color( 255, 255, 255 ), "' .. self:Nick() .. ' был заблокирован анти-читом" ) ' )
	end

	XAC:Log( self:Nick() .. " был заблокирован анти-читом" )
	XAC:Log( "Причина: " .. reason )
	XAC:Log( "Лог бана: " .. banData )
	XL:DiscordLog( ":shield: XAC | Ban", "**Игрок:** " .. self:Nick() .. " (" .. self:SteamID() .. ")\n**Причина:** " .. reason .. "\n**Лог:** " .. banData , redColor )
	self.XACHasBanned = true
	self:Kick( "XAC Ban: " .. reason )
	

end

hookAdd( "PlayerInitialSpawn", "XAC:BanCheck", function( ply )

	ply.XACFullyLoaded = true
	timer.Simple( 1, function()

		local data = XAC:CacheFiles( "ban", ply:SteamID64() )
		if data then
			ply:Kick( "XAC Ban: " .. data[#data] )
		end

		ply.XACFullyLoaded = true
		ply.XACHasBanned = false
		ply.XACAimDetected = false

	end)

end)