----------------------------------------------------------------
-- Server Main

-- Funktion: Basefunktionalität / Globals für Serverscripts
-- Verantwortlicher: Dustin
           
----------------------------------------------------------------



------------------------
sys_init_done = false
local sys_debug = true -- --debug(sys_debug,"penis")

-- Globlas: ESX
ESX = nil

-- Globals: SilenceLife
PlayerInfo = {}
------------------------


TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj

    sys_init_done = true
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
--if GetConvar('debugmode', 'false') then print('triggered:playerConnecting') end --debugging
    PlayerInfo[source] = {
        ped = nil,
        coords = nil,
        
        group = nil,
        permission_level = nil,
    
        firstname = nil,
        lastname = nil,
    }
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    print(GetResourcePath(GetCurrentResourceName()))
end)