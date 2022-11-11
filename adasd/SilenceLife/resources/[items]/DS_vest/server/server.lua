ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(config.itemname, function(source)
    print("Item wurde benutzt!")
    TriggerClientEvent('dsvest:use', source)

end)

RegisterServerEvent('dsvest:removeVest')
AddEventHandler('dsvest:removeVest', function()

    local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(config.itemname, 1)

end)