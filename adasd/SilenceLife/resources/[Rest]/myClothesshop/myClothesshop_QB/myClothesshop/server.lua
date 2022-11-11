QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('myClothesshop:buy')
AddEventHandler('myClothesshop:buy', function(price)

    local xPlayer = QBCore.Functions.GetPlayer(source)

    local currentCash = xPlayer.Functions.GetMoney('cash')

    if currentCash >= price then

        TriggerClientEvent('myClothesshop:confirm', source, true)
        xPlayer.Functions.RemoveMoney('cash',price)

    else
        TriggerClientEvent('myClothesshop:confirm', source, false)
    end

end)