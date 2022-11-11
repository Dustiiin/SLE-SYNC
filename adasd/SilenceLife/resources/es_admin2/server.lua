ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {
	slay = "mod",
	noclip = "admin",
	crash = "admin",
	freeze = "mod",
	bring = "mod",
	["goto"] = "mod",
	slap = "mod",
	slay = "mod",
	kick = "mod",
	ban = "admin"
}

local banned = ""
local bannedTable = {}

function loadBans()
	banned = LoadResourceFile(GetCurrentResourceName(), "bans.json") or ""
	if banned ~= "" then
		bannedTable = json.decode(banned)
	else
		bannedTable = {}
	end
end

RegisterCommand("refresh_bans", function()
	loadBans()
end, true)

--[[ function loadExistingPlayers()
	TriggerEvent("es:getPlayers", function(curPlayers)
		for k,v in pairs(curPlayers)do
			TriggerClientEvent("es_admin:setGroup", v.get('source'), v.get('group'))
		end
	end)
end

loadExistingPlayers() ]]

function removeBan(id)
	bannedTable[id] = nil
	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

function isBanned(id)
	if bannedTable[id] ~= nil then
		if bannedTable[id].expire < os.time() then
			removeBan(id)
			return false
		else
			return bannedTable[id]
		end
	else
		return false
	end
end

function permBanUser(bannedBy, id)
	bannedTable[id] = {
		banner = bannedBy,
		reason = "Permanently banned from this server",
		expire = 0
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

function banUser(expireSeconds, bannedBy, id, re)
	bannedTable[id] = {
		banner = bannedBy,
		reason = re,
		expire = (os.time() + expireSeconds)
	}

	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bannedTable), -1)
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		local banData = isBanned(v)
		if banData ~= false then
			set("Banned for: " .. banData.reason .. "\nExpires: " .. (os.date("%c", banData.expire)))
			CancelEvent()
			break
		end
	end
end)

RegisterServerEvent('es_admin:all')
AddEventHandler('es_admin:all', function(type)
	local Source = source
	local user = ESX.GetPlayerFromId(Source)
	if user.getGroup() == "admin" then
		if type == "slay_all" then TriggerClientEvent('es_admin:quick', -1, 'slay') end
		if type == "bring_all" then TriggerClientEvent('es_admin:quick', -1, 'bring', Source) end
		if type == "slap_all" then TriggerClientEvent('es_admin:quick', -1, 'slap') end
	else
		TriggerClientEvent('chat:addMessage', Source, {
			args = {"^1SYSTEM", "You do not have permission to do this"}
		})
	end
end)

RegisterServerEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(id, type)
	local Source = source
	local user = ESX.GetPlayerFromId(Source)
	local target = ESX.GetPlayerFromId(id)
	if user.getGroup() == "admin" then
		if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "noclip" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "freeze" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "crash" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "bring" then TriggerClientEvent('es_admin:quick', id, type, Source) end
		if type == "goto" then TriggerClientEvent('es_admin:quick', Source, type, id) end
		if type == "slap" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
		if type == "kick" then DropPlayer(id, 'Kicked by es_admin GUI') end

		if type == "ban" then
			local id
			local ip
			for k,v in ipairs(GetPlayerIdentifiers(Source))do
				if string.sub(v, 1, string.len("steam:")) == "steam:" then
					permBanUser(user.identifier, v)
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					permBanUser(user.identifier, v)
				end
			end

			DropPlayer(id, "You were banned from this server")
		end
	else
		TriggerClientEvent('chat:addMessage', Source, {
			args = {"^1SYSTEM", "You do not have permission to do this"}
		})
	end
end)

RegisterServerEvent('es_admin:requestGroup')
AddEventHandler('es_admin:requestGroup', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('es_admin:setGroup', _source, xPlayer.getGroup())
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	local user = ESX.GetPlayerFromId(Source)
	local target = ESX.GetPlayerFromId(USER)
	if user.getGroup() == 'admin' then
		if t == "group" then
			if(GetPlayerName(USER) == nil)then
				TriggerClientEvent('chatMessage', Source, 'SYSTEM', {255, 0, 0}, "Player not found")
			else
				target.setGroup(GROUP)
				TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Group of ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 has been set to ^2^*" .. GROUP)
			end
		elseif t == "money" then
			if(GetPlayerName(USER) == nil)then
				TriggerClientEvent('chat:addMessage', Source, {
					args = {"^1SYSTEM", "Player not found"}
				})
			else
				GROUP = tonumber(GROUP)
				if(GROUP ~= nil and GROUP > -1)then
					target.setAccountMoney('money', GROUP)
				else
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Invalid integer entered"}
					})
				end
			end
		elseif t == "bank" then
			if(GetPlayerName(USER) == nil)then
				TriggerClientEvent('chat:addMessage', Source, {
					args = {"^1SYSTEM", "Player not found"}
				})
			else
				GROUP = tonumber(GROUP)
				if(GROUP ~= nil and GROUP > -1)then
					target.setAccountMoney('bank', GROUP)
				else
					TriggerClientEvent('chat:addMessage', Source, {
						args = {"^1SYSTEM", "Invalid integer entered"}
					})
				end
			end
		end
	end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

loadBans()
