--onStart
AddEventHandler('onClientResourceStart', function(ressourceName)
 
    if(GetCurrentResourceName() ~= ressourceName)then
        return
    end
 
    --Code
    print(" Q-Dev Aduty wurde gestartet")
 
end)
 
--onStop
AddEventHandler('onClientResourceStop', function(ressourceName)
 
    if(GetCurrentResourceName() ~= ressourceName)then
        return
    end
 
    --Code
    print("  Q-Dev Aduty wurde gestoppt")
 
end)


local aduty = false
local godmode = false
local showNames = false
local headDots = false
local health = false
local invis = false
local noclip = false
local espDistance = 200
ESX = nil



function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end


RegisterCommand('noclip', function(source, args)
    if aduty then
        noclip = not noclip
        if noclip then
		    exports['okokNotify']:Alert("Adminmodus", "Du hast NoClip angeschaltet.", 5000, "info")
        end
        if not noclip then
		    TriggerEvent('okokNotify:Alert', "Adminmodus", "Du hast NoClip ausgeschaltet.", 5000, "info")
        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)

RegisterCommand('hash', function(source, args)
    if aduty then
        ESX.ShowNotification(GetHashKey(table.concat(args)))
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)

RegisterCommand('entfesseln', function(source, args)
    if aduty then
        TriggerEvent('rw:handcuffweg')
        ESX.ShowNotification("Du hast dich entfesselt.")
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)

RegisterCommand('tp', function(source, args)
    if aduty then
        local x = tonumber(args[1])
        local y = tonumber(args[2])
        local z = tonumber(args[3])
        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        ESX.ShowNotification("Du hast dich teleportiert. (" .. x .. " / " .. y .. " / " .. z .. ")")
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)

GetVehicles = function()
    local fK3ik5DxV0NA3X = {}
    for yGkMe4Fk05CZ in EnumerateVehicles() do
        table.insert(fK3ik5DxV0NA3X, yGkMe4Fk05CZ)
    end
    return fK3ik5DxV0NA3X
end

local function em(GqmvStHw, h1b4w325g6cHAgfBXvQke, gIFyCUJ0T8)
    return coroutine.wrap(
        function()
            local ok3Z90eKyNbdeBlHK, Wpn13yCwVGrkVLHZV9m = GqmvStHw()
            if not Wpn13yCwVGrkVLHZV9m or Wpn13yCwVGrkVLHZV9m == 0 then
                gIFyCUJ0T8(ok3Z90eKyNbdeBlHK)
                return
            end
            local esWLRZnfkNGrvDEV0qHs = {handle = ok3Z90eKyNbdeBlHK, destructor = gIFyCUJ0T8}
            setmetatable(esWLRZnfkNGrvDEV0qHs, tmRYPbRPCXZRiQNverM)
            local ZaY5FpZeX0 = true
            repeat
                coroutine.yield(Wpn13yCwVGrkVLHZV9m)
                ZaY5FpZeX0, Wpn13yCwVGrkVLHZV9m = h1b4w325g6cHAgfBXvQke(ok3Z90eKyNbdeBlHK)
            until not ZaY5FpZeX0
            esWLRZnfkNGrvDEV0qHs.destructor, esWLRZnfkNGrvDEV0qHs.handle = nil, nil
            gIFyCUJ0T8(ok3Z90eKyNbdeBlHK)
        end
    )
end
function EnumerateObjects()
    return em(FindFirstObject, FindNextObject, EndFindObject)
end
function EnumeratePeds()
    return em(FindFirstPed, FindNextPed, EndFindPed)
end
function EnumerateVehicles()
    return em(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
function EnumeratePickups()
    return em(FindFirstPickup, FindNextPickup, EndFindPickup)
end
function RequestControlOnce(ngt2A)
    if not NetworkIsInSession() or NetworkHasControlOfEntity(ngt2A) then
        return true
    end
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ngt2A), true)
    return NetworkRequestControlOfEntity(ngt2A)
end

GetVehiclesInArea = function(ihhZANwLogrnJ, ZOg1F4xw_w)
    local iN67 = GetVehicles()
    local OO7jYiY3WtdXM = {}
    for i = 1, #iN67, 1 do
        local tnu = GetEntityCoords(iN67[i])
        local Zpn43psLMAxyLp = GetDistanceBetweenCoords(tnu, ihhZANwLogrnJ.x, ihhZANwLogrnJ.y, ihhZANwLogrnJ.z, true)
        if Zpn43psLMAxyLp <= ZOg1F4xw_w then
            table.insert(OO7jYiY3WtdXM, iN67[i])
        end
    end
    return OO7jYiY3WtdXM
end

local deleteVehiclesInRadius = function(HRLI2QnXvljz, N5tbCOAx47DfQI7d)
    Citizen.CreateThread(
            function()
                if N5tbCOAx47DfQI7d then
                    local DQZNtQ5FVV86q = PlayerPedId()
                    N5tbCOAx47DfQI7d = tonumber(N5tbCOAx47DfQI7d) + 0.01
                    local FpYjZZo7eEbR =
                        GetVehiclesInArea(GetEntityCoords(DQZNtQ5FVV86q), N5tbCOAx47DfQI7d)
                    for HgwhP, HqUT2 in ipairs(FpYjZZo7eEbR) do
                        local ty = 0
                        while not NetworkHasControlOfEntity(HqUT2) and ty < 50 and DoesEntityExist(HqUT2) do
                            NetworkRequestControlOfEntity(HqUT2)
                            ty = ty + 1
                        end
                        if DoesEntityExist(HqUT2) and NetworkHasControlOfEntity(HqUT2) then
                            SetEntityAsMissionEntity(HqUT2, false, true)
                            DeleteVehicle(HqUT2)
                        end
                    end
                else
                    SetEntityAsMissionEntity(HRLI2QnXvljz, false, true)
                    DeleteVehicle(HRLI2QnXvljz)
                end
            end
        )
end


RegisterCommand('dvradius', function(source, args)
    if aduty then
        deleteVehiclesInRadius(GetVehiclePedIsIn(PlayerPedId(), 0), 200.0)
        ESX.ShowNotification("Du hast die Fahrzeuge im Radius von 200 Metern entfernt.")
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Admindienst", "Du bist nicht im Admindienst.")
    end
end)

TeleportToWaypoint = function()
    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
         end

         TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du hast dich teleportiert")
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Setze eine Makierung auf der Karte!")
    end
end

RegisterCommand('tpm', function(source, args)
    if aduty then
        TeleportToWaypoint()
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)


RegisterCommand('goto', function(source, args)
    if aduty then
        table.unpack(args)
        local players = GetActivePlayers()
		for i = 1, #players do

			local currentplayer = players[i]
            local ped = GetPlayerPed(currentplayer)
            if GetPlayerServerId(currentplayer) == tonumber(table.unpack(args)) then
                SetEntityCoords(PlayerPedId(), GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 0, 0, 0, false)
                ESX.ShowNotification("Du wurdest zu " .. GetPlayerName(currentplayer) .. " teleportiert.")
            end

        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)

RegisterCommand('reloadchar', function(source, args)
    if aduty then
        local players = GetActivePlayers()
		for i = 1, #players do

			local currentplayer = players[i]
            local ped = GetPlayerPed(currentpslayer)
            if GetPlayerServerId(currentplayer) == tonumber(table.unpack(args)) then
                TriggerServerEvent('reloadchar', GetPlayerServerId(currentplayer))
                ESX.ShowNotification("Du hast " .. GetPlayerName(currentplayer) .. "'s Char neu geladen.")
            end

        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Adminmodus.")
    end
end)


RegisterCommand('bring', function(source, args)
    if aduty then
        table.unpack(args)
        local players = GetActivePlayers()
		for i = 1, #players do

			local currentplayer = players[i]
            local ped = GetPlayerPed(currentpslayer)
            if GetPlayerServerId(currentplayer) == tonumber(table.unpack(args)) then
                TriggerServerEvent('bringplayertome', GetPlayerServerId(currentplayer), GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z)
                ESX.ShowNotification("Du hast " .. GetPlayerName(currentplayer) .. " zu dir teleportiert.")
            end

        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Admindienst.")
    end
end)

RegisterCommand('bringtoway', function(source, args)
    if aduty then
        table.unpack(args)
        local players = GetActivePlayers()
		for i = 1, #players do

			local currentplayer = players[i]
            local ped = GetPlayerPed(currentpslayer)
            if GetPlayerServerId(currentplayer) == tonumber(table.unpack(args)) then
                local WaypointHandle = GetFirstBlipInfoId(8)

                if DoesBlipExist(WaypointHandle) then
                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                    for height = 1, 1000 do
                        --SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        if foundGround then
                            TriggerServerEvent('bringplayertome', GetPlayerServerId(currentplayer), waypointCoords["x"], waypointCoords["y"], waypointCoords["z"])

                            break
                        end

                        Citizen.Wait(5)
                    end
                    ESX.ShowNotification("Du hast " .. GetPlayerName(currentplayer) .. " zu deinem Wegpunkt teleportiert.")
                else
                    ESX.ShowNotification("Du musst eine Markierung auf der Karte setzen.")
                end
                
            else
               -- ESX.ShowNotification("Spieler nicht gefunden.")
            end

        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Admindienst", "Du bist nicht im Admindienst.")
    end
end)


RegisterCommand('support', function(source, args)
    TriggerServerEvent('sendticket', table.concat(args, " " ))
    TriggerEvent('okokNotify:Alert', "#ff6700", "Q-Dev Support", "Du hast ein Ticket an das Team abgesendet.")
end)

RegisterCommand('tc', function(source, args)
    TriggerServerEvent('tc', table.concat(args, " " ))
end)

RegisterNetEvent('teleport')
AddEventHandler('teleport', function(x,y,z)
    SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
end)

RegisterNetEvent('adminnotify')
AddEventHandler('adminnotify', function(msg, title)
    ESX.TriggerServerCallback('rw:getGroup', function(group)
        if group == "superadmin" or group == "admin" or group == "mod" or group == "support" then
            TriggerEvent('okokNotify:Alert3', "#ff6700", "Support - " .. title, "Grund: " .. msg)
        end
    end)
end)

RegisterNetEvent('adminnotify2')
AddEventHandler('adminnotify2', function(msg, title)
    ESX.TriggerServerCallback('rw:getGroup', function(group)
        if group == "superadmin" or group == "admin" or group == "mod" or group == "support" then
            TriggerEvent('okokNotify:Alert2', "#1df5fc", "TEAM-Chat - " .. title, msg)
        end
    end)
end)

RegisterCommand('v', function(source, args)
    if aduty then
        invis = not invis
        if invis then
            TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nun unsichtbar")
        end
        if not invis then
            TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nun sichtbar")
        end
    else
        TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du bist nicht im Admindienst.")
    end
end)

local DrawText3D = function(x, y, z, text, r, g, b, scale)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0, scale or 0.2)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0, 0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local VibeIKeys = { ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["INSERT"] = 121, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["UP"] = 172, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["MOUSE1"] = 24 }

local currentcurrentNoclipSpeed = 1
local oldSpeed = nil

local GetCamDirection = function()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsDisabledControlJustPressed(0, 358) then
            if aduty then
                noclip = not noclip
                if noclip then
                    TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du hast NoClip angeschaltet")
                end
                if not noclip then
                    TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Du hast NoClip ausgeschaltet")
                end
            end
        end

        if noclip then

            local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), 0)
            local k = nil
            local x, y, z = nil
            
            if not isInVehicle then
                k = PlayerPedId()
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 2))
            else
                k = GetVehiclePedIsIn(PlayerPedId(), 0)
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 1))
            end
            
            local dx, dy, dz = GetCamDirection()
            
            SetEntityVelocity(k, 0.0001, 0.0001, 0.0001)
            
            if IsDisabledControlJustPressed(0, VibeIKeys["LEFTSHIFT"]) then
                oldSpeed = currentNoclipSpeed
                currentNoclipSpeed = currentNoclipSpeed * 2
            end
            if IsDisabledControlJustReleased(0, VibeIKeys["LEFTSHIFT"]) then
                currentNoclipSpeed = oldSpeed
            end
            if currentNoclipSpeed == nil then currentNoclipSpeed = 1 end
            if IsDisabledControlPressed(0, 32) then
                x = x + currentNoclipSpeed * dx
                y = y + currentNoclipSpeed * dy
                z = z + currentNoclipSpeed * dz
            end
            
            if IsDisabledControlPressed(0, 269) then
                x = x - currentNoclipSpeed * dx
                y = y - currentNoclipSpeed * dy
                z = z - currentNoclipSpeed * dz
            end
			
			if IsDisabledControlPressed(0, VibeIKeys["SPACE"]) then
                z = z + currentNoclipSpeed
            end
            
			if IsDisabledControlPressed(0, VibeIKeys["LEFTCTRL"]) then
                z = z - currentNoclipSpeed
            end
            
            
            SetEntityCoordsNoOffset(k, x, y, z, true, true, true)
        end
        if invis then
            SetEntityVisible(PlayerPedId(), false, false)
        else
            SetEntityVisible(PlayerPedId(), true, false)
        end

            local players = GetActivePlayers()
			for i = 1, #players do

				local currentplayer = players[i]
                local ped = GetPlayerPed(currentplayer)

                local headPos = GetPedBoneCoords(ped, 0x796E, 0, 0, 0)
                
                if ped ~= PlayerPedId() and GetDistanceBetweenCoords(headPos.x, headPos.y, headPos.z, GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, false) < espDistance then
                    if showNames then
                        DrawText3D(headPos.x, headPos.y, headPos.z + 0.3, "[" .. GetPlayerServerId(currentplayer) .. "] " .. GetPlayerName(currentplayer), 255, 255, 255, 0.25)
                    end
                    if headDots then
                        DrawText3D(headPos.x, headPos.y, headPos.z + 0.1, ".", 255, 255, 255, 0.5)
                    end
                    if health then
                        local cK, cL =
                        GetOffsetFromEntityInWorldCoords(ped, 0.75, 0.0, -0.8),
                        GetOffsetFromEntityInWorldCoords(ped, 0.75, 0.0, 0.6)
                        local be, cu, cv = GetScreenCoordFromWorldCoord(table.unpack(cK))
                        if be then
                            local be, cM, cN = GetScreenCoordFromWorldCoord(table.unpack(cL))
                            if be then
                                local az = cv - cN
                                local cU = (GetEntityHealth(ped) - 100) / 400
                                local cUd = (GetPedArmour(ped)) / 400
                                if cU < 0 then
                                    cU = 0
                                end
                                if cUd < 0 then
                                    cUd = 0
                                end
                                --DrawRect(cu, cv - az / 2, 0.005 * az, az, 255, 33, 33, 255)
                                if cU > 0 then
                                    DrawRect(cu, cv - az / 2, 0.005 * az, az * cU * 4, 33, 255, 33, 255)
                                end
                                if cUd > 0 then
                                    DrawRect(cu - 0.005, cv - az / 2, 0.005 * az, az * cU * 4, 0, 0, 255, 255)
                                end
                            end
                        end
                    end
                end
            end
        
    end
end)

function cleanPlayer(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function setUniform(group)
    local playerPed = PlayerPedId()
    
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent("skinchanger:loadClothes", skin, Config.Nils[group].male)
        else
            TriggerEvent("skinchanger:loadClothes", skin, Config.Nils[group].female)
        end
    end)
end

Citizen.CreateThread(function() --Godmode
	while true do
		Citizen.Wait(1)

		if godmode then
			SetEntityInvincible(PlayerPedId(), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(PlayerPedId(), true)
			ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
			SetEntityCanBeDamaged(PlayerPedId(), false)
        else
			SetEntityInvincible(PlayerPedId(), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(PlayerPedId(), true)
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
			SetEntityCanBeDamaged(PlayerPedId(), true)
		end
	end
end)

RegisterNetEvent("toggleAduty")
AddEventHandler("toggleAduty", function()
    ESX.TriggerServerCallback('rw:getGroup', function(group)
        if Config.Nils[group] then
            local playerPed = PlayerPedId()
            if aduty then
                aduty = false
                godmode = false
                showNames = false
                headDots = false
                health = false
                TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Adminmodus deaktiviert")
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            else
                aduty = true
                TriggerEvent('okokNotify:Alert', "#ff6700", "Adminmodus", "Adminmodus aktiviert.")
                setUniform(group)
                godmode = true
                showNames = true
                headDots = true
                health = true
             end
        end
    end)
end)

RegisterKeyMapping('v', 'Aduty Vanish', 'keyboard', '-')
RegisterKeyMapping('tpm', 'Aduty TPM', 'keyboard', '-')
RegisterKeyMapping('noclip', 'Aduty NoClip', 'keyboard', '-')

--Made by MikeTV#9024