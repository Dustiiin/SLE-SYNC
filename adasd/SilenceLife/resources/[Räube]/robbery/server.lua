ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Robbery = false
local Breakable = false
local LastRob = 0

local showcases = {
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
    { breaken = false },
}

ESX.RegisterServerCallback("kaves_vrobbery:GetStatus", function(source, cb)
    cb(Robbery, Breakable)
end)

ESX.RegisterServerCallback("kaves_vrobbery:CheckBomb", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reqItem = xPlayer.getInventoryItem("gas_bomb").count
    if reqItem >= 1 then
        cb(true)
    else
        cb("You dont have gas bomb!")
    end
end)

ESX.RegisterServerCallback("kaves_vrobbery:StartEvent", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Players = ESX.GetPlayers()
    local copcount = 0
    if (os.time() - Config.NextRobSeconds) > LastRob then
        for i = 1, #Players do
            local ply = ESX.GetPlayerFromId(Players[i])
            if ply.job.name == "police" then
                copcount = copcount + 1
            end 
        end
        if copcount >= Config.RequiredCopsCount then
            local reqItem = xPlayer.getInventoryItem("laptop_h").count
            if reqItem >= 1  then
                cb(true)
            else
                cb("You dont have hack laptop!")
            end
        else
            cb("There aren't enough cops!")
        end
    else
        cb("This place was recently robbed! You have to wait a bit!")
    end
end)

RegisterServerEvent("kaves_vrobbery:ChangeStatus")
AddEventHandler("kaves_vrobbery:ChangeStatus", function()
    Robbery = true
    TriggerClientEvent("kaves_vrobbery:ChangeStatus_CL", -1, Robbery)
end)

RegisterServerEvent("kaves_vrobbery:SellJewells")
AddEventHandler("kaves_vrobbery:SellJewells", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem("jewels").count
    if count > 0 then
        xPlayer.removeInventoryItem("jewels", count)
        xPlayer.addMoney(count*Config.OneJewelPrice)
    end
end)


RegisterServerEvent("kaves_vrobbery:RemoveItem")
AddEventHandler("kaves_vrobbery:RemoveItem", function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if count < 1 then
        return
    end
    xPlayer.removeInventoryItem(item, count)
end)

RegisterServerEvent("kaves_vrobbery:StartStealing")
AddEventHandler("kaves_vrobbery:StartStealing", function()
    Breakable = true
    TriggerClientEvent("kaves_vrobbery:StartStealing_CL", -1, Breakable)
end)

RegisterServerEvent("kaves_vrobbery:Notify")
AddEventHandler("kaves_vrobbery:Notify", function(toggle)
    TriggerClientEvent("kaves_vrobbery:PoliceAlert", -1, toggle)
end)

RegisterServerEvent("kaves_vrobbery:EndRob")
AddEventHandler("kaves_vrobbery:EndRob", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    LastRob = os.time()
    for k,v in pairs(showcases) do
        v.breaken = true
    end
    TriggerClientEvent("kaves_vrobbery:EndRob_CL", -1)
    while true do
        if (os.time() - Config.NextRobSeconds > LastRob) then
            TriggerClientEvent("kaves_vrobbery:Reset", -1)
            Robbery = false
            Breakable = false
            for k,v in pairs(showcases) do
                v.breaken = false
            end
            break
        end
        Citizen.Wait(5000)
    end
end)

RegisterServerEvent("kaves_vrobbery:UpdateRobbery")
AddEventHandler("kaves_vrobbery:UpdateRobbery", function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not showcases[index].breaken then
        showcases[index].breaken = true
        xPlayer.addInventoryItem("jewels", math.random(Config.MinJewel, Config.MaxJewel))
    else
        xPlayer.showNotification("This place has already been looted!")
    end
    TriggerClientEvent("kaves_vrobbery:UpdateRobbery_CL", -1, index)
end)







