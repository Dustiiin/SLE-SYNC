RegisterNetEvent("sysTimerTick_0")
RegisterNetEvent("sysTimerTick_100")
RegisterNetEvent("sysTimerTick_250")
RegisterNetEvent("sysTimerTick_500")
RegisterNetEvent("sysTimerTick_1000")
RegisterNetEvent("sysTimerTick_5000")

local flip250 = true
local flip1000 = true
Citizen.CreateThread(function()
    while true do

        PlayerInfo.playerPed = PlayerPedId()
        PlayerInfo.playerCoords = GetEntityCoords(PlayerInfo.playerPed)

        FreezeEntityPosition(PlayerInfo.playerPed, PlayerInfo.isFrozen)
        
        checkHandCuffed()

        if keysblocked == 0 then
            -- für E gibts schon ein Keybind. Event: lf:keyPressed
            -- muss in if/else statt loop weil performance
            checkKeys(18)                
            checkKeys(24) 
            checkKeys(175) 
            checkKeys(174) 
            checkKeys(179) 
            checkKeys(Keys["~"]) 
            checkKeys(Keys["E"]) 
            checkKeys(Keys["F"]) 
            checkKeys(Keys["ESC"]) 
            checkKeys(Keys["LEFTSHIFT"]) 
            checkKeys(Keys["F6"]) 
            checkKeys(Keys["BACKSPACE"]) 
            checkKeys(Keys["N4"])
            checkKeys(Keys["N6"])
            checkKeys(Keys["H"])
            checkKeys(Keys["ENTER"])
            
        end
        TriggerEvent("sysTimerTick_0")        
        Citizen.Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        TriggerEvent("sysTimerTick_100")        
        Citizen.Wait(100)
    end
end)
Citizen.CreateThread(function()
    while true do
        
        if IsPedOnFoot(PlayerInfo.playerPed) then
            PlayerInfo.isAllowedToUse = true
        else
            PlayerInfo.isAllowedToUse = false
        end
        
        TriggerEvent("sysTimerTick_250")

        if flip250 then
            flip250 = false
        else
            flip250 = true

            if keysblocked > 0 then
                keysblocked = keysblocked - 1
            end

            TriggerEvent("sysTimerTick_500")
        end

        Citizen.Wait(250)
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerEvent("sysTimerTick_1000")
        if flip1000 then
            flip1000 = false
        else
            flip1000 = true
            TriggerEvent("sysTimerTick_2000")
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerEvent("sysTimerTick_5000")
        Citizen.Wait(5000)
    end
end)