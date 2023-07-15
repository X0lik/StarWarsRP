local webhook = "https://discord.com/api/webhooks/1128106356533104750/F0xnku3O1OiVSZV6U6rd6InKsm9kaZYu7a4N1xMz_KJ0eNEXRcnUOdeWeZ8Ywb8MBKwE"
if pcall(require, "chttp") and CHTTP ~= nil then
	my_http = CHTTP
end

local function colorFormat( col )
	return string.format('%d', col.b + bit.lshift(col.g, 8) + bit.lshift(col.r, 16))
end

function XAC:DiscordLog( title, ply, type, details, logFile )

    title = ":shield: XAC | " .. title
    local msg = "**Player:** " .. ply:Nick() .. " (" .. ply:SteamID() .. ")\n**Type:** " .. type .. "\n**Details: ** " .. details .. "\n\n**Log:** " .. logFile .. "\n" 
	CHTTP({
		method = "POST",
		type = "application/json",
		headers = { ["User-Agent"] = "curl/7.54" },
		url = webhook,
		body  = util.TableToJSON({
			embeds = {
				{
					title = title,
					description = msg,
					color = colorFormat( redColor ),
				},
			}
		}),
		failed = function(err)
		    XL:Log( "Discord Log Failed", err, redColor )
		end,
	})
end