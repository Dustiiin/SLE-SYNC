
local Cache = {}
Cache.Blips = {}
Cache.Data = {}



--- Change the state of a specific blip identified by job 
---@param job string The index in the Cache and the job name
---@param toggle boolean colorize or decolorize the blip
local function UpdateBlip(job, index, toggle)
    if not Cache.Blips[job][index] then debug(sys_debug,('^3Warning: Missing blip in Cache: "%s"'):format(job)) return end
    if not DoesBlipExist(Cache.Blips[job][index]) then debug(sys_debug,('^3Warning: Blip does not exists in Cache: "%s"'):format(job)) return end

    if toggle then
        SetBlipColour(Cache.Blips[job][index], Config_Blips.DynamicBlips[job][index].color)
        SetBlipScale(Cache.Blips[job][index], Config_Blips.DynamicBlips[job][index].size)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config_Blips.DynamicBlips[job][index].label .. Config_Blips.DynamicBlips[job][index].labelon)
        EndTextCommandSetBlipName(Cache.Blips[job][index])
    else
        SetBlipColour(Cache.Blips[job][index], Config_Blips.DynamicBlips[job][index].coloroff)
        SetBlipScale(Cache.Blips[job][index], Config_Blips.DynamicBlips[job][index].size )
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config_Blips.DynamicBlips[job][index].label .. Config_Blips.DynamicBlips[job][index].labeloff)
        EndTextCommandSetBlipName(Cache.Blips[job][index])
    end
end

local function IsBlipActive(job, index)
    if Cache.Data[job] and Cache.Data[job][index] then
        return Cache.Data[job][index].status
    else
        return nil
    end
end

local function SetRouteToBlip(key, index)
    if Cache.Blips[key] or Cache.Data[key][index] then
        if index == nil then
            SetBlipRoute(Cache.Blips[key], true)
        else
            SetBlipRoute(Cache.Blips[key][index], true)
        end
    end
end

local function RemoveRouteToBlip(key, index)
    if Cache.Blips[key] or Cache.Data[key][index] then
        if index == nil then
            SetBlipRoute(Cache.Blips[key], false)
        else
            SetBlipRoute(Cache.Blips[key][index], false)
        end
    end
end


Citizen.CreateThread(function()
    while not sys_init_done do
        --debug(sys_debug,"waiting...")
        Wait(500) 
    end

    for job, obj in pairs(Config_Blips.DynamicBlips) do
        for index, blip in pairs(obj) do
            if Cache.Blips[job] == nil then
                Cache.Blips[job] = {}
            end

            if not DoesBlipExist(Cache.Blips[job][index]) and Cache.Blips[job][index] == nil then
                Cache.Blips[job][index] = AddBlipForCoord(blip.coords)
                SetBlipSprite(Cache.Blips[job][index], blip.sprite)
                SetBlipDisplay(Cache.Blips[job][index], 4)
                SetBlipScale(Cache.Blips[job][index], blip.size)
                SetBlipColour(Cache.Blips[job][index], blip.coloroff)
                SetBlipAsShortRange(Cache.Blips[job][index], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(blip.label ..blip.labeloff )
                EndTextCommandSetBlipName(Cache.Blips[job][index])
            end
        end
    end

    for key, blip in pairs(Config_Blips.StaticBlips) do     
        if not DoesBlipExist(Cache.Blips[key]) and Cache.Blips[key] == nil then   
            Cache.Blips[key] = AddBlipForCoord(blip.coords)
            SetBlipSprite(Cache.Blips[key], blip.sprite or 1)
            SetBlipDisplay(Cache.Blips[key], blip.display or 4)
            SetBlipScale(Cache.Blips[key], blip.scale or 0.75)
            SetBlipColour(Cache.Blips[key], blip.color or 4)
            SetBlipAsShortRange(Cache.Blips[key], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip.label)
            EndTextCommandSetBlipName(Cache.Blips[key])
        end
    end

    ESX.TriggerServerCallback('sl_dynamicblips:server:callback', function(data)
        for job, obj in pairs(data) do
            for index, data2 in pairs(obj) do
                UpdateBlip(job, index, data2.status)
            end
        end

        Cache.Data = data
    end)

    loadJobBlips()    
end)

    function loadJobBlips()
        if Config_Blips.DynamicBlips[PlayerInfo.ESX.job.name] then
                for index, blip in pairs(Config_Blips.DynamicBlips[PlayerInfo.ESX.job.name]) do
                        table.insert(markers,{coords = blip.interaction, range = 5.0, size= 1.0, marker = 27, rgb={r=252,g=188,b=0}, job = blip.job, job_grade = 0, text = "Laden öffnen/schließen", 
                        functions = {
                            {
                                text = "zum benutzen",
                                key = Keys["E"], 
                                func = function() 
                                        TriggerServerEvent("sl_dynamicblips:server:toggle", PlayerInfo.ESX.job.name, index)
                                        Citizen.Wait(1000)
                                                         
                                end
                            }
                        }
                        })
                    
                end
        end
    end


RegisterNetEvent("sl:setJob")
AddEventHandler("sl:setJob", function(job)
    Citizen.Wait(3000)
    loadJobBlips()

end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

RegisterNetEvent("sl_dynamicblips:client:sync", function(data)
    for job, obj in pairs(data) do
        for index, data2 in pairs(obj) do
            if job == PlayerInfo.ESX.job.name then
                --debug(sys_debug,"update blip for job: "..job.." index: "..index.." status: "..tostring(data2.status))
                if Cache.Data[job][index].status ~= data2.status then
                    if data2.status then
                        TriggerEvent('sl:showNotification', Config_Blips.DynamicBlips[job][index].label .. " hat nun geöffnet", "success", 5000)
                    else
                        TriggerEvent('sl:showNotification', Config_Blips.DynamicBlips[job][index].label .. " hat nun geschlossen", "error", 5000)
                    end
                end
            end

            UpdateBlip(job, index, data2.status)
        end
    end

    Cache.Data = data
end)


exports("IsBlipActive", IsBlipActive)
exports("SetRouteToBlip", SetRouteToBlip)
exports("RemoveRouteToBlip", RemoveRouteToBlip)