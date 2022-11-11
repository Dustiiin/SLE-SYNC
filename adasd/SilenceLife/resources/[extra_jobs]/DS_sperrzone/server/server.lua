ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--lSPD
RegisterCommand('pd', function(source, args, rawCommand)
    local xPlayers = ESX.GetPlayers()
    local radius = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "police" then
        for i=1, #xPlayers, 1 do 
		TriggerClientEvent("grv_sperrzone:setSperrzoneLSPD", -1, source, radius)
        TriggerClientEvent('grv_notifyrundruf:displayrundruf', xPlayers[i], "LSPD Rundruf:", table.concat(args, " "), 6000, false)
        end
	end
end)

RegisterCommand('pdrm', function(source, args, rawCommand)
    local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "police" then
        for i=1, #xPlayers, 1 do 
        TriggerClientEvent("grv_sperrzone:clearSperrzoneLSPD", -1, source)
        TriggerClientEvent('grv_notifyrundruf:displayrundruf', xPlayers[i], "LSPD Rundruf:", table.concat(args, " "), 6000, false)
        end
	end
end)

--FIB
RegisterCommand('fib', function(source, args, rawCommand)
    local xPlayers = ESX.GetPlayers()
    local radius = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "fib" then
        for i=1, #xPlayers, 1 do 
		TriggerClientEvent("grv_sperrzone:setSperrzoneFIB", -1, source, radius)
        TriggerClientEvent('grv_notifyrundruf:displayrundruf', xPlayers[i], "FIB Rundruf:", table.concat(args, " "), 6000, false)
        end
	end
end)

RegisterCommand('fibrm', function(source, args, rawCommand)
    local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "fib" then
        for i=1, #xPlayers, 1 do 
        TriggerClientEvent("grv_sperrzone:clearSperrzoneFIB", -1, source)
        TriggerClientEvent('grv_notifyrundruf:displayrundruf', xPlayers[i], "FIB Rundruf:", table.concat(args, " "), 6000, false)
        end
	end
end)

--Mechaniker
RegisterCommand('mh', function(source, args, rawCommand)
    local xPlayers = ESX.GetPlayers()
    local radius = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "mechanic" then
        for i=1, #xPlayers, 1 do 
        TriggerClientEvent('grv_notifyrundruf:displayrundruf', xPlayers[i], "Mechaniker Rundruf:", table.concat(args, " "), 6000, false)
        end
	end
end)