Config = {}

Config.AllLogs = true											-- Enable/Disable All Logs Channel
Config.postal = true  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "SilenceLife Logs" 							-- Bot Username
Config.avatar = "https://cdn.discordapp.com/attachments/949698872257708082/1024506105277186068/logo.png"				-- Bot Avatar
Config.communtiyName = "SilenceLife"					-- Icon top of the embed
Config.communtiyLogo = "https://cdn.discordapp.com/attachments/949698872257708082/1024506105277186068/logo.png"		-- Icon top of the embed
Config.FooterText = "2021 - 2023 © MikeTv#9024"						-- Footer text for the embed
Config.FooterIcon = "https://cdn.discordapp.com/attachments/949698872257708082/1024506105277186068/logo.png"			-- Footer icon for the embed


Config.weaponLog = true  			-- set to false to disable the shooting weapon logs
Config.InlineFields = true			-- set to false if you don't want the player details next to each other

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs
Config.license = true				-- set to false to disable license in the logs
Config.IP = true					-- set to false to disable IP in the logs

-- Change color of the default embeds here
-- It used Decimal or Hex color codes. They will both work.
Config.BaseColors ={		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "#A1A1A1",				-- Chat Message
	joins = "#3AF241",				-- Player Connecting
	leaving = "#F23A3A",			-- Player Disconnected
	deaths = "#000000",				-- Shooting a weapon
	shooting = "#2E66F2",			-- Player Died
	resources = "#EBEE3F",			-- Resource Stopped/Started	
}


Config.webhooks = {		-- For more info have a look at the docs: https://docs.prefech.com
	all = "https://discord.com/api/webhooks/888108770578817034/iAqLhcg2Nb-y3-w4ayezEyTc_uXW-6JvXbob-yybmZIW2nJffcw5zWjJY07GAu8Q7XcW",		-- All logs will be send to this channel
	chat = "https://discord.com/api/webhooks/888108432127852584/uybPRuwKd4cZC_kwd36ii2Rc-1DO5IayBdQxBwUeWUjUS5tLfe5LRAvSgpJrc7oH7_CV",		-- Chat Message
	joins = "https://discord.com/api/webhooks/888104345265135648/rSUfarV5n58yZT_Q8C0h3UFq3zk9u-VNTM9w_zeC2mGu3hHeRs60OxUmC97NutrThVYw",		-- Player Connecting
	leaving = "https://discord.com/api/webhooks/888104345265135648/rSUfarV5n58yZT_Q8C0h3UFq3zk9u-VNTM9w_zeC2mGu3hHeRs60OxUmC97NutrThVYw",	-- Player Disconnected
	deaths = "https://discord.com/api/webhooks/1040122170392727592/0eTJhFaFVES0XwhY-rV9za89N8PwsOab8GwUAu4ocUaenlGdFR9HlLusKq3HtfqCjvd-",		-- Shooting a weapon
	shooting = "https://discord.com/api/webhooks/1040122282443542558/fzAE9FRHdYuKxc-Ygn3j_dVUaVQDIUGi0v8EAdFiTsrxpBE-4NgowOMpTrCf-uY4ujpR",	-- Player Died
	resources = "https://discord.com/api/webhooks/888109137471369276/Miy7NtrT1nOC2bObCBBtWh2ROwu1RIcJ0yXusk1Kf81Wtbit-W8CBny1mc28R-bD-4HW",	-- Resource Stopped/Started	
}

Config.TitleIcon = {		-- For more info have a look at the docs: https://docs.prefech.com
	chat = "💬",				-- Chat Message
	joins = "📥",				-- Player Connecting
	leaving = "📤",			-- Player Disconnected
	deaths = "💀",				-- Shooting a weapon
	shooting = "🔫",			-- Player Died
	resources = "🔧",			-- Resource Stopped/Started	
}

Config.Plugins = {
	--["PluginName"] = {color = "#FFFFFF", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
	["NameChange"] = {color = "#03fc98", icon = "🔗", webhook = "DISCORD_WEBHOOK"},
}


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.3.0"
