ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

function sendToDiscord(name,message,color,pwebhook)
	local DiscordWebHook = Config.WebHook
	if pwebhook ~= "Your_Costum_Webhook" and pwebhook ~= nil and pwebhook then
		DiscordWebHook = pwebhook
	end
	local embeds = {
		{
		  ["title"] = message,
		  ["type"] = "rich",
		  ["color"] = color,
		}
	}

	if message == nil or message == '' then return false end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers)end, 'POST', json.encode({ username = name,embeds = embeds}), {['Content-Type'] = 'application/json'})
end

ESX.RegisterServerCallback('TunningSystem:Used', function(source,cb,id,netid)
	local enviar = false
	if not Config.TunningLocations[id].used then
		enviar = true
		if SendUsed then
			SendUsed(id,source)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	end
    cb(enviar)
	while Config.TunningLocations[id].used do
		Wait(10000)
		if GetPlayerPing(source) <= 0 then
			DeleteEntity(NetworkGetEntityFromNetworkId(netid))
			if SendUsed then
				SendUsed(id,false)
			else
				print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
			end
		end
	end
end)

RegisterServerEvent('TunningSystem:Used')
AddEventHandler('TunningSystem:Used', function(id)
	local _source = source
	if Config.TunningLocations[id].used == _source then
		if SendUsed then
			SendUsed(id,false)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	else
		--cheateeer
	end
end)

RegisterServerEvent('TunningSystem:PayModifications')
AddEventHandler('TunningSystem:PayModifications', function(preco,id,vehprops)
    local config = Config.TunningLocations[id]
    local _source = source
    local pago = false
    local xPlayer = ESX.GetPlayerFromId(_source)
    local whyisitasync = false
    if config.used == _source then
        local permitido = true
        if config.job then
            permitido = false
            if xPlayer.getJob().name == config.job then
                permitido = true
            end
        end
        if permitido then
            if config.society and config.job then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..config.job, function(account)
                    if account.money >= preco then
                        account.removeMoney(preco)
                        if config.societypercentage then
                            if config.societypercentage >= 0 or config.societypercentage < 100 then
                                local playerpercentage = 1.0-(config.societypercentage/100)
                                local playerwin = playerpercentage*preco
                                if playerwin > 0 then
                                    xPlayer.addAccountMoney("bank",playerwin)
                                    --you won playerwin €
                                end
                            end
                        end
                        pago = true
						whyisitasync = true
                    else
                        --The society don't have money
						whyisitasync = true
                    end
                    
                end)
            else
                if xPlayer.getAccount("bank").money >= preco then
                    pago = true
                    xPlayer.removeAccountMoney("bank",preco)
					whyisitasync = true
                else
                    --You don't have moneyyyyy
					whyisitasync = true
                end
                
            end
        else
            --cheater
            whyisitasync = true
        end
    else
        whyisitasync = true
        --cheater probably
    end
    while not whyisitasync do
        Wait(100)
	end
    if pago then
        SaveVehicle(vehprops)
        if (Config.WebHook and Config.WebHook ~= "") or (config.WebHook ~= "Your_Costum_Webhook" and config.WebHook ~= nil and config.WebHook) then
            sendToDiscord(config.name..' Logs', "[Upgrade/Tuning Logs]\n\nTotal: ".. preco .."\n\nVehicle Plate Number: [".. vehprops.plate .."]\nMechanic that worked on the vehicle: " .. xPlayer.name, 11750815,config.WebHook)
        end
    end
    TriggerClientEvent("TunningSystem:PayAfter",_source,pago)
end)

if Config.MysqlAsync then
	function SaveVehicle(vehprops)	
		MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = vehprops.plate
		}, function(result)
			if result[1] then
				local vehicle = json.decode(result[1].vehicle)

				if vehprops.model == vehicle.model then
					MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
						['@plate'] = vehprops.plate,
						['@vehicle'] = json.encode(vehprops)
					})
					TriggerEvent("esx_lscustom:refreshOwnedVehicle",vehprops)
				else
					--cheateeeer
				end
			end
		end)
	end
else
	function SaveVehicle(vehprops)	
		exports.ghmattimysql:execute('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = vehprops.plate
		}, function(result)
			if result[1] then
				local vehicle = json.decode(result[1].vehicle)

				if vehprops.model == vehicle.model then
					exports.ghmattimysql:execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
						['@plate'] = vehprops.plate,
						['@vehicle'] = json.encode(vehprops)
					})
					TriggerEvent("esx_lscustom:refreshOwnedVehicle",vehprops)
				else
					--cheateeeer
				end
			end
		end)
	end
end

function SendUsed(id,type)
	Config.TunningLocations[id].used = type
	TriggerClientEvent("TunningSystem:Used",-1,id, type)
end