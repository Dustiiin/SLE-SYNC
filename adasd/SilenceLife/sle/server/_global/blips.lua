local Cache = {}

RegisterServerCallback("sl_dynamicblips:server:callback", function(source, cb)
    print("Callback to client #" .. source)
    cb(Cache)
end)

RegisterCommand('skincreator', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('updateSkin', xPlayer.skin)
    TriggerClientEvent('okokNotify:Alert', source, 'SUCCESS', 'Der Laden hat nun zu!', 5000, 'success')
end)



RegisterCommand('test', function(source)
    print("test")
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll("SELECT * FROM `outfits` WHERE `idSteam` = @identifier", {['@identifier'] = xPlayer.identifier},
        function(result)
            if #result >= 1 then
                local result = result[1]
                print("GOOD ONE")


            else
                print("DOOF")
            end
    end)
end)





RegisterNetEvent("sl_dynamicblips:server:toggle")
AddEventHandler("sl_dynamicblips:server:toggle", function(job, index)
--if GetConvar('debugmode', 'false') then print('triggered:insel_dynamicblips:server:toggle') end --debugging
    local source = source
    print(index)
    print("Update Blip #" .. index .. " of " .. job)

    Cache[job][index].status = not Cache[job][index].status
    if Cache[job][index].status then
        Cache[job][index].resetAt = os.time() + 30 * 60 * 1000
        TriggerClientEvent('okokNotify:Alert', source, 'SUCCESS', 'Der Laden hat nun offen!', 5000, 'success')   
    else
        Cache[job][index].resetAt = 0
        TriggerClientEvent('okokNotify:Alert', source, 'SUCCESS', 'Der Laden hat nun zu!', 5000, 'success')
    end

    print("Sync updated blips to all clients now")
    TriggerClientEvent("sl_dynamicblips:client:sync", -1, Cache)

end)

local function Tick()
	local timestamp = os.time()

    print("Checking cache for automatic reset")

    for _, obj in pairs(Cache) do
        for _, data in pairs(obj) do
            if data.status then
                if data.reset > 0 and data.reset <= timestamp then
                    data.status = false
                    data.reset = 0
                end
            end
        end
    end

    print("Sync updated blips to all clients now")
    TriggerClientEvent("insel_dynamicblips:client:sync", -1, Cache)
    
	SetTimeout(5 * 60 * 1000, Tick)
end

--- Initialize the system
local function Initialize()
    print("Create serverside cache for Blips")

    for job, obj in pairs(Config_Blips.DynamicBlips) do
        for index, _ in pairs(obj) do
            Cache[job] = Cache[job] or {}
            Cache[job][index] = {}
            Cache[job][index].status = false
            Cache[job][index].reset = 0

            print("Register #" .. index .. " for " .. job)
        end
    end

    Tick()
end

Initialize()