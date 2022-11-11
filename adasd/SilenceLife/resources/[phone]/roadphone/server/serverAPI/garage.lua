ESX.RegisterServerCallback("roadphone:getCars", function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return;
    end

   MySQL.query("SELECT * FROM " .. Config.OwnedVehiclesTable .. " WHERE `owner` = @identifier and type = @type", {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = "car"
    }, function(result)
        local cachedvehicles = {}

        for i = 1, #result, 1 do
            table.insert(cachedvehicles, {
                plate = result[i].plate,
                vehicle = json.decode(result[i].vehicle),
                type = result[i].type,
                garage = result[i].garage,
                stored = result[i].stored
            })
        end

        cb(cachedvehicles)

    end)

end)

ESX.RegisterServerCallback('roadphone:loadVehicle', function(source, cb, plate)
    MySQL.query('SELECT * FROM ' .. Config.OwnedVehiclesTable .. ' WHERE `plate` = @plate', {
        ['@plate'] = plate
    }, function(vehicle)
        cb(vehicle)
    end)
end)

ESX.RegisterServerCallback('roadphone:checkValetMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return;
    end

    if xPlayer.getAccount('bank').money > Config.ValetDeliveryPrice then
        xPlayer.removeAccountMoney('bank', Config.ValetDeliveryPrice)        
        TriggerEvent("roadphone:addBankTransaction", getNumberFromIdentifier(xPlayer.identifier), 0, _U('car_delivered'), Config.ValetDeliveryPrice)
        TriggerClientEvent("roadphone:sendNotification", source, {
            title = _U('garageapp'),
            sender = _U('garageonway', Config.ValetDeliveryPrice),
            message = nil,
            img = "/public/html/static/img/icons/app/garage.png"
        })
        discordLog("9807270", "Valet", _U('valet_cardelivered', xPlayer.getName()), "RoadPhone", nil, API.ValetWebhook)
        cb(true)
        return;
    else
        TriggerClientEvent("roadphone:sendNotification", source, {
            title = _U('garageapp'),
            sender = _U('garagenomoney'),
            message = nil,
            img = "/public/html/static/img/icons/app/garage.png"
        })
        cb(false)
        return;
    end

end)

RegisterServerEvent("roadphone:valetCarSetOutside")
AddEventHandler("roadphone:valetCarSetOutside", function(plate)
    local _source = tonumber(source);
    MySQL.query("UPDATE " .. Config.OwnedVehiclesTable .. " SET `stored` = @stored WHERE `plate` = @plate", {["@plate"] = plate, ["@stored"] = 0})
end)