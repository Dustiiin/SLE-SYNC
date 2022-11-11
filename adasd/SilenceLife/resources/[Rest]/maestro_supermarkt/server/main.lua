ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback('maestro_supermarkt:canAfford', function(source, cb, value, warenkorb)
	local s = source
	local x = ESX.GetPlayerFromId(s)

	if x.getMoney() >= value then
		for key, value in pairs(warenkorb) do
			x.addInventoryItem(value.name, 1)
		end

		x.removeMoney(value)

		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('maestro_supermarkt:loadItems', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM maestro_shops', {}, function(shops)
		cb(shops)
	end)
end)