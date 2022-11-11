ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback('ps_impound:loadVehicles', function(source, cb)
	
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND stored = 0', {['@owner'] = x.identifier}, function(vehicles)
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('ps_impound:loadVehicle', function(source, cb, plate)
	
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate}, function(vehicle)
		cb(vehicle)
	end)
end)

ESX.RegisterServerCallback('ps_impound:isOwned', function(source, cb, plate)
	
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {['@plate'] = plate, ['@owner'] = x.identifier}, function(vehicle)
		if next(vehicle) then
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterNetEvent('ps_impound:changeState')
AddEventHandler('ps_impound:changeState', function(plate, state)
	MySQL.Sync.execute("UPDATE owned_vehicles SET stored=@state WHERE plate=@plate", {['@state'] = state, ['@plate'] = plate})
end)

RegisterNetEvent('ps_impound:saveProps')
AddEventHandler('ps_impound:saveProps', function(plate, props)
	local xProps = json.encode(props)
	MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@props WHERE plate=@plate", {['@plate'] = plate, ['@props'] = xProps})
end)