ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    local blip = AddBlipForCoord(Config.Vangelico.x, Config.Vangelico.y, Config.Vangelico.z)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 4)
    SetBlipSprite(blip, 617)
	SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Jewelery Shop")
    EndTextCommandSetBlipName(blip)
    local sellblip = AddBlipForCoord(Config.SellCoords.x, Config.SellCoords.y, Config.SellCoords.z)
    SetBlipScale(sellblip, 0.6)
    SetBlipColour(sellblip, 4)
    SetBlipSprite(sellblip, 439)
	SetBlipAsShortRange(sellblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sell Jewells")
    EndTextCommandSetBlipName(sellblip)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local showcases = {
    { handle = nil, coords = vector3(-628.0, -233.92, 38.04), heading = 209.56, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-626.92, -233.08, 38.04), heading = 213.28, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-625.84, -234.6, 38.04), heading = 33.88, breaken = false, dmodel = "des_jewel_cab4_start", smodel = "des_jewel_cab4_end" },
    { handle = nil, coords = vector3(-626.84, -235.36, 38.04), heading = 26.48, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-626.72, -238.6, 38.04), heading = 218.28, breaken = false, dmodel = "des_jewel_cab2_start", smodel = "des_jewel_cab2_end" },
    { handle = nil, coords = vector3(-625.68, -237.76, 38.04), heading = 206.76, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-623.16, -232.96, 38.04), heading = 300.08, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-624.48, -231.12, 38.04), heading = 304.24, breaken = false, dmodel = "des_jewel_cab4_start", smodel = "des_jewel_cab4_end" },
    { handle = nil, coords = vector3(-624.96, -227.8, 38.04), heading = 32.44, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-623.92, -227.08, 38.04), heading = 36.6, breaken = false, dmodel = "des_jewel_cab4_start", smodel = "des_jewel_cab4_end" },
    { handle = nil, coords = vector3(-623.96, -228.16, 38.04), heading = 209.84, breaken = false, dmodel = "des_jewel_cab2_start", smodel = "des_jewel_cab2_end" },
    { handle = nil, coords = vector3(-620.4, -226.56, 38.04), heading = 300.48, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-619.68, -227.56, 38.04), heading = 306.56, breaken = false, dmodel = "des_jewel_cab2_start", smodel = "des_jewel_cab2_end" },
    { handle = nil, coords = vector3(-621.04, -228.52, 38.04), heading = 124.12, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-619.72, -230.4, 38.04), heading = 122.4, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-618.36, -229.56, 38.04), heading = 307.64, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-617.52, -230.56, 38.04), heading = 311.2, breaken = false, dmodel = "des_jewel_cab2_start", smodel = "des_jewel_cab2_end" },
    { handle = nil, coords = vector3(-619.16, -233.64, 38.04), heading = 212.4, breaken = false, dmodel = "des_jewel_cab3_start", smodel = "des_jewel_cab3_end" },
    { handle = nil, coords = vector3(-620.2, -234.44, 38.04), heading = 211.96, breaken = false, dmodel = "des_jewel_cab_start", smodel = "des_jewel_cab_end" },
    { handle = nil, coords = vector3(-620.12, -233.44, 38.04), heading = 23.36, breaken = false, dmodel = "des_jewel_cab4_start", smodel = "des_jewel_cab4_end" },
}


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.TriggerServerCallback("kaves_vrobbery:GetStatus", function(output, output2) 
        Robbery = output
        Breakable = output2
    end)
end)

local Robbery = false
local working = false
local exploded = false
local notify, notify2 = false, false
local planted = 0
local count = 0
local looted = 0
local pressed = false
local sended = false
local gas = false
local text
local Breakable = false
local alarmblip = nil
InHack = false
HackSuccess = false


Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(500)
    end
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local hackdst = #(playerCoords - Config.HackCoords.coords)
        if PlayerData.job ~= nil and PlayerData.job.name ~= "police" then
            if hackdst < 60 then
                sleep = 1
                if hackdst < 2 then
                    if not Robbery then
                        text = "[~r~E~w~] Start Hack"
                    elseif Robbery then
                        text = "~y~This place is being robbed now!"
                    end
                    if not InHack then
                        DrawText3D(Config.HackCoords.coords.x, Config.HackCoords.coords.y, Config.HackCoords.coords.z+0.60, 0.35, text)
                    end
                    if IsControlJustPressed(0, 38) and not Robbery then
                        ESX.TriggerServerCallback("kaves_vrobbery:StartEvent", function(output) 
                            if output == true then
                                Robbery = true
                                InHack = true
                                TriggerServerEvent("kaves_vrobbery:RemoveItem", "laptop_h", 1)
                                TriggerServerEvent("kaves_vrobbery:ChangeStatus")
                                BeforeHacking()
                            elseif output ~= true then
                                ESX.ShowNotification(output)
                            end
                        end)
                    end
                end
            end
        end
        if HackSuccess and Robbery then
            for a,b in pairs(Config.Vents) do
                local ventsdst = #(playerCoords - b.coords)
                if ventsdst < 2 then
                    if not b.planted then
                        DrawText3D(b.coords.x, b.coords.y, b.coords.z, 0.35, "[~r~E~w~] Insert sleeping gas bomb")
                        if IsControlJustPressed(0, 38) and not working then
							ESX.TriggerServerCallback("kaves_vrobbery:CheckBomb", function(output)
								if output == true then
                                    TriggerServerEvent("kaves_vrobbery:RemoveItem", "gas_bomb", 1)
									working = true
									InsertGasBomb(b.coords, b.heading, b.px, b.py, a)
								elseif output ~= true then
									ESX.ShowNotification(output)
								end
							end)
                        end
                    end
                end
            end
            if planted == 2 and not exploded then
                if not sended then
                    sended = true
                    ESX.ShowNotification("Step away from the area!")
                end 
                local awaydst = #(playerCoords - Config.HackCoords.coords)
                if awaydst > 15 then
                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z+0.20, 0.35, "[~g~E~w~] Explode Sleeping Gas")
                    if IsControlJustPressed(0, 38) and not exploded then
                        exploded = true
                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE", 0.0, true)
                        Citizen.Wait(3000)
                        local sceneCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	                    RenderScriptCams(true, false, 0, 1, 0)
	                    SetCamCoord(sceneCam, -632.68, -233.64, 40.72)
                        SetCamRot(sceneCam, -15.0,0.0, 277.7)
                        gas = true
                        TriggerServerEvent("kaves_vrobbery:Notify", 1)
                    end
                end
            end
            if gas and count < 3 then
                SetPtfxAssetNextCall("core")
                Gas = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", -622.92, -225.64, 40.28, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                SetPtfxAssetNextCall("core")
                Gas2 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", -623.44, -227.84, 40.28, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                SetPtfxAssetNextCall("core")
                Gas3 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", -617.56, -233.2, 40.4, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                SetPtfxAssetNextCall("core")
                Gas4 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", -618.6, -233.24, 40.4, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                SetPtfxAssetNextCall("core")
                Gas5 = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", -625.52, -237.32, 40.28, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
                count = count + 1
                if count >= 3 then
                    Citizen.Wait(5000)
                    StopParticleFxLooped(Gas)
                    StopParticleFxLooped(Gas2)
                    StopParticleFxLooped(Gas3)
                    StopParticleFxLooped(Gas4)
                    StopParticleFxLooped(Gas5)
                    ClearPedTasks(playerPed)
                    ClearPedTasksImmediately(playerPed)
                    ClearFocus()
	                RenderScriptCams(false, false, 0, 1, 0)
	                DestroyCam(sceneCam, false)
                    ESX.ShowNotification("The electricity went out and the sleeping gas leaked inside! Start stealing the jewels! You have ~g~100 ~y~seconds~w~!")
                    TriggerEvent("kaves_vrobbery:StartTimer")
                    TriggerServerEvent("kaves_vrobbery:StartStealing")
                end
            end
        end
        if Robbery and Breakable then
            for kaves,kavo in pairs(showcases) do
                local dst = #(playerCoords - kavo.coords)
                if dst < 1 then
                    if not kavo.breaken and PlayerData.job ~= nil and PlayerData.job.name ~= "police" then
                        DrawText3D(kavo.coords.x, kavo.coords.y, kavo.coords.z+0.20, 0.35, "[~y~E~w~] Break the glass")
                    end
                        local _, hash = GetCurrentPedWeapon(playerPed)
			            local weapon = tostring(GetWeapontypeGroup(hash))
                    if IsControlJustPressed(0, 38) and not kavo.breaken and Config.AllowedWeapons[weapon] and PlayerData.job ~= nil and PlayerData.job.name ~= "police" then
                        kavo.breaken = true
                        TriggerServerEvent("kaves_vrobbery:UpdateRobbery", kaves)
                        SetEntityCoords(playerPed, kavo.coords.x, kavo.coords.y, kavo.coords.z-1.0)
                        SetEntityHeading(playerPed, kavo.heading)
                        PlaySoundFromCoord(-1, "Glass_Smash", kavo.coords.x, kavo.coords.y, kavo.coords.z, 0, 0, 0, 0)
                        RequestNamedPtfxAsset("scr_jewelheist")
					    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do Citizen.Wait(10) end
					    SetPtfxAssetNextCall("scr_jewelheist")
					    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", kavo.x, kavo.y, kavo.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        while not HasAnimDictLoaded("missheist_jewel") do RequestAnimDict("missheist_jewel") Citizen.Wait(10) end
						TaskPlayAnim(playerPed, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
                        --CreateModelSwap(kavo.coords.x, kavo.coords.y, kavo.coords.z,  0.1, GetHashKey(kavo.dmodel), GetHashKey(kavo.smodel), false)
					    Citizen.Wait(5000)
					    ClearPedTasksImmediately(playerPed)
					    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        looted = looted + 1
                        if looted >= 20 then
                            TriggerServerEvent("kaves_vrobbery:EndRob")
                            TriggerServerEvent("kaves_vrobbery:Notify", 2)
                        end
                    elseif IsControlJustPressed(0, 38) and not kavo.breaken and not Config.AllowedWeapons[weapon] then
                        ESX.ShowNotification("You must have a gun!")
                    end
                end
            end
        end
        if Breakable then
			if PlayerData.job ~= nil and PlayerData.job.name ~= "police" then
				for t,y in pairs(showcases) do
					if y.handle == nil then
						y.handle = AddBlipForCoord(y.coords)
						SetBlipScale(y.handle, 0.6)
						SetBlipColour(y.handle, 5)
						SetBlipDisplay(y.handle, 5)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Steal")
						EndTextCommandSetBlipName(y.handle)
					end
				end
			end
			local vdst = #(playerCoords - Config.Vangelico)
			if vdst < 55 then
				SetArtificialLightsState(true)
			else
				SetArtificialLightsState(false)
			end
        end
		if Robbery and Breakable and HackSuccess then
			local vdst2 = #(playerCoords - Config.Vangelico)
			if vdst2 > 100 then
				TriggerServerEvent("kaves_vrobbery:EndRob")
				TriggerServerEvent("kaves_vrobbery:Notify", 2)
				if not notify then
					notify = true
					ESX.ShowNotification("Robbery canceled because you moved too far from the area!")
				end
			end
			if IsEntityDead(playerPed) or IsPedDeadOrDying(playerPed) then
				if not notify2 then
					notify2 = true
					TriggerServerEvent("kaves_vrobbery:EndRob")
					TriggerServerEvent("kaves_vrobbery:Notify", 2)
					ESX.ShowNotification("Heist canceled because you died")
				end
			end
		end
        local selldst = #(playerCoords - Config.SellCoords)
        if selldst < 50 then
            sleep = 1
            if selldst < 3 then
                DrawText3D(Config.SellCoords.x, Config.SellCoords.y, Config.SellCoords.z+0.20, 0.35, "[~y~E~w~] Laptop")
                if IsControlJustPressed(0, 38) and not pressed then
                    pressed = true
                    TriggerServerEvent("kaves_vrobbery:SellJewells")
                    pressed = false
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function BeforeHacking()
    local loc = Config.HackCoords.coords
    local playerPed = PlayerPedId()
    local animDict = "anim@heists@ornate_bank@hack"
    RequestAnimDict(animDict)
    RequestModel("hei_prop_heist_card_hack_02")
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded(animDict) or not HasModelLoaded("hei_prop_hst_laptop") or not  HasModelLoaded("hei_prop_heist_card_hack_02") or not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
        Citizen.Wait(100)
    end
    local targetPosition, targetRotation = (vec3(GetEntityCoords(playerPed))), vec3(GetEntityRotation(playerPed))
    SetEntityCoords(playerPed, -622.97, -215.99, 52.54)
    FreezeEntityPosition(playerPed, true)
    SetEntityHeading(playerPed, Config.HackCoords.heading)
    local netScene = NetworkCreateSynchronisedScene(loc.x-0.35, loc.y-0.21, loc.z+0.40, -1.01656, -1.690573, 114.7264, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(playerPed, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(loc.x-0.35, loc.y-0.21, loc.z+0.40, -1.01656, -1.690573, 114.7264, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(playerPed, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(loc.x-0.35, loc.y-0.21, loc.z+0.40, -1.01656, -1.690573, 114.7264, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(playerPed, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)

    SetPedComponentVariation(playerPed, 5, 0, 0, 0)
    Citizen.Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Citizen.Wait(2000)
    StartHack()
    ESX.ShowNotification("Open My Computer and navigate to HackConnect.exe")
    Citizen.Wait(1500)
    NetworkStartSynchronisedScene(netScene3)
    Citizen.Wait(4600)
    NetworkStopSynchronisedScene(netScene3)
    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(playerPed, false)
    SetPedComponentVariation(playerPed, 5, 45, 0, 0)
end

function InsertGasBomb(crds, heading, px, py, index)
    local loc = crds
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("prop_bomb_01")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasModelLoaded("prop_bomb_01")do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, heading)
    Citizen.Wait(100)
    local rot = vec3(GetEntityRotation(ped))
    local bagscene = NetworkCreateSynchronisedScene(loc.x+px, loc.y+py, loc.z, rot, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z,  true,  true, false)

    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    Config.Vents[index].bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)

    AttachEntityToEntity(Config.Vents[index].bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(3000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(Config.Vents[index].bomba, 1, 1)
    FreezeEntityPosition(Config.Vents[index].bomba, true)
    NetworkStopSynchronisedScene(bagscene)
    Config.Vents[index].planted = true
	if DoesBlipExist(Config.Vents[index].handle) then
		RemoveBlip(Config.Vents[index].handle)
	end
    working = false
    planted = planted + 1
end

RegisterNetEvent("kaves_vrobbery:ChangeStatus_CL")
AddEventHandler("kaves_vrobbery:ChangeStatus_CL", function(output)
    Robbery = output
end)

RegisterNetEvent("kaves_vrobbery:PoliceAlert")
AddEventHandler("kaves_vrobbery:PoliceAlert", function(toggle)
    local player = ESX.GetPlayerData()
    if player.job.name == "police" then
        if toggle == 1 then
            ESX.ShowNotification("Vangelico Jewellery Store alarms are triggered!")
            if not DoesBlipExist(alarmblip) then
                alarmblip = AddBlipForCoord(Config.Vangelico.x, Config.Vangelico.y, Config.Vangelico.z)
                SetBlipSprite(alarmblip, 161)
	            SetBlipScale(alarmblip, 2.0)
	            SetBlipColour(alarmblip, 1)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Vangelico Jewellery Alarm")
                EndTextCommandSetBlipName(alarmblip)
	            PulseBlip(alarmblip)
            end
        elseif toggle == 2 then
            if DoesBlipExist(alarmblip) then
                RemoveBlip(alarmblip)
            end
        end
    end
end)

RegisterNetEvent("kaves_vrobbery:StartTimer")
AddEventHandler("kaves_vrobbery:StartTimer", function()
    Citizen.Wait(70000)
    ESX.ShowNotification("30 seconds left!")
    Citizen.Wait(30000)
    for k,v in pairs(showcases) do
        v.breaken = true
    end 
	ESX.ShowNotification("Time's up!")
    TriggerServerEvent("kaves_vrobbery:EndRob")
    TriggerServerEvent("kaves_vrobbery:Notify", 2)
end)

RegisterNetEvent("kaves_vrobbery:EndRob_CL")
AddEventHandler("kaves_vrobbery:EndRob_CL", function()
    StopAlarm("JEWEL_STORE_HEIST_ALARMS", -1)
	for a,b in pairs(Config.Vents) do
		if DoesEntityExist(b.bomba) then
			DeleteObject(b.bomba)
		end
	end
    for k,v in pairs(showcases) do
        v.breaken = true
		if DoesBlipExist(v.handle) then
			RemoveBlip(v.handle)
		end
    end 
	SetArtificialLightsState(false)
end)

RegisterNetEvent("kaves_vrobbery:UpdateRobbery_CL")
AddEventHandler("kaves_vrobbery:UpdateRobbery_CL", function(output)
    showcases[output].breaken = true
	if DoesBlipExist(showcases[output].handle) then
		RemoveBlip(showcases[output].handle)
	end
    CreateModelSwap(showcases[output].coords.x, showcases[output].coords.y, showcases[output].coords.z,  0.1, GetHashKey(showcases[output].dmodel), GetHashKey(showcases[output].smodel), false)
end)

RegisterNetEvent("kaves_vrobbery:Reset")
AddEventHandler("kaves_vrobbery:Reset", function()
    for k,v in pairs(showcases) do
        v.breaken = false
        RemoveModelSwap(v.coords.x, v.coords.y, v.coords.z, 0.1, GetHashKey(v.dmodel), GetHashKey(v.smodel), false )
    end
    Robbery = false
    working = false
    exploded = false
    planted = 0
    count = 0
    looted = 0
    sended = false
    gas = false
    Breakable = false
    InHack = false
    HackSuccesss = false
	notify2 = false
	notify = false
end)

RegisterNetEvent("kaves_vrobbery:StartStealing_CL")
AddEventHandler("kaves_vrobbery:StartStealing_CL", function(output)
    Breakable = output
    while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do
		Citizen.Wait(0)
	end
    StartAlarm("JEWEL_STORE_HEIST_ALARMS", 1)
end)

function DrawText3D(x, y, z, scale, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 300
        DrawRect(_x, _y + 0.0120, 0.0 + factor, 0.025, 41, 11, 41, 100)
    end
end