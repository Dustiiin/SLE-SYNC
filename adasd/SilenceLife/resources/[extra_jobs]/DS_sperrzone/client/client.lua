blipRadius = 150.0 
lspdCol = 3
fibCol = 3
lspdBlip = "LSPD: Sperrzone"
fibBlip = "FIB: Sperrzone"


local lspdBlip = nil
local radiusBlipLSPD = nil
local fibBlip = nil
local radiusBlipFIB = nil



RegisterNetEvent("grv_sperrzone:setSperrzoneLSPD")
AddEventHandler("grv_sperrzone:setSperrzoneLSPD", function(s, lspdRadius)
    RemoveBlip(lspdBlip)
    RemoveBlip(radiusBlipLSPD)

    if lspdRadius == nil then
        lspdRadius = blipRadius
    end

    local src = s
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    lspdBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    radiusBlipLSPD = AddBlipForRadius(coords.x, coords.y, coords.z, lspdRadius)
    SetBlipSprite(lspdBlip, 161)
    SetBlipAsShortRange(lspdBlip, true)
    SetBlipColour(lspdBlip, lspdCol)
    SetBlipScale(lspdBlip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sperrzone')
    EndTextCommandSetBlipName(lspdBlip)

    
    SetBlipAlpha(radiusBlipLSPD, 80)
    SetBlipColour(radiusBlipLSPD, lspdCol)

end)

RegisterNetEvent('grv_sperrzone:clearSperrzoneLSPD')
AddEventHandler("grv_sperrzone:clearSperrzoneLSPD", function()
    RemoveBlip(lspdBlip)
    RemoveBlip(radiusBlipLSPD)
end)

local lspdBlip = nil
local radiusBlipLSPD = nil


--FIB
RegisterNetEvent("grv_sperrzone:setSperrzoneFIB")
AddEventHandler("grv_sperrzone:setSperrzoneFIB", function(s, lspdRadius)
    RemoveBlip(fibBlip)
    RemoveBlip(radiusBlipFIB)

    if fibRadius == nil then
        fibRadius = blipRadius
    end

    local src = s
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    fibBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    radiusBlipFIB = AddBlipForRadius(coords.x, coords.y, coords.z, fibRadius)
    SetBlipSprite(fibBlip, 161)
    SetBlipAsShortRange(fibBlip, true)
    SetBlipColour(fibBlip, fibCol)
    SetBlipScale(fibBlip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sperrzone')
    EndTextCommandSetBlipName(fibBlip)

    
    SetBlipAlpha(radiusBlipFIB, 80)
    SetBlipColour(radiusBlipFIB, fibCol)

end)

RegisterNetEvent('grv_sperrzone:clearSperrzoneFIB')
AddEventHandler("grv_sperrzone:clearSperrzoneFIB", function()
    RemoveBlip(fibBlip)
    RemoveBlip(radiusBlipFIB)
end)

local fibBlip = nil
local radiusBlipFIB = nil