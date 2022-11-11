local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168,["F11"] = 344, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }


ESX = nil
local StartSmoke = false
local give = false
local liquid = false
local hand = false
local mouth = false
local propsmoke_net = nil
local mouthsmoke_net = nil
local success = false
local WeedEffect = false
local ReductionEffect = false
local timer = false

local particleDict = "core"
local particleName = "exp_grd_bzgas_smoke"


Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
	  Citizen.Wait(250)
  end
  
  ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)


function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

RegisterNetEvent('devcore_smokev2:client:Smoke')
AddEventHandler('devcore_smokev2:client:Smoke', function(item, size, prop, type, time)
	if StartSmoke == true then
		exports['mythic_notify']:DoHudText('inform', _U('already_smoke'))
	else
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	if type == 'cigarette' then
		playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
		Citizen.Wait(1000)
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		lighter = CreateObject(GetHashKey('ex_prop_exec_lighter_01'), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(lighter, playerPed, GetPedBoneIndex(playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
		playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		timer = true
		StartSmoke = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'cigar' then
		playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
		Citizen.Wait(1000)
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		lighter = CreateObject(GetHashKey('ex_prop_exec_lighter_01'), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(lighter, playerPed, GetPedBoneIndex(playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
		playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		timer = true
		StartSmoke = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'joint' then
		playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
		Citizen.Wait(1000)
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		lighter = CreateObject(GetHashKey('ex_prop_exec_lighter_01'), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(lighter, playerPed, GetPedBoneIndex(playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
		playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		timer = true
		StartSmoke = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'vape' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  18905), 0.13, 0.04, 0.0, 0.0, -140.0, -140.0, true, true, false, true, 1, true)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		StartSmoke = true
		hand = true
	end
	if type == 'bong' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  18905), 0.10, -0.25, 0.0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		StartSmoke = true
		hand = true
	end
			while true do
				Citizen.Wait(1)
				if StartSmoke then
					if Config.DisableCombatButtons then
					DisableControlAction(0,229, true)
					DisableControlAction(0,223, true)
					DisableControlAction(0,142, true)
					DisableControlAction(0,25, true)
					DisableControlAction(0,347, true)
					end
					if hand then
				if give then
				ESX.ShowHelpNotification(_U('give'))
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 2.5 then
					target_id = GetPlayerPed(closestPlayer)
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(target_id))
					DrawMarker(0, playerX, playerY, playerZ+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 10, 255, 0, 100, true, true, 2, true, false, false, false)
					if IsControlJustPressed(0, Config.ConfirmGiveButton) then
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						if type == 'joint' or type == 'cigarette' then
						TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
						end
						Citizen.Wait(100)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
						TriggerServerEvent('devcore_smokev2:server:Receiver', GetPlayerServerId(closestPlayer), item, size, prop, type, time)
						ClearPedTasks(playerPed)
						StartSmoke = false
						mouth = false
						timer = false
						hand = false
						give = false
						playAnim("mp_common","givetake1_a", 1800)
						break
					end
					if IsControlJustPressed(0, Config.CancelGiveButton) then
						give = false
						ClearPedTasks(playerPed)
						Citizen.Wait(200)
					end
				end
					else
				if type == 'vape' then
					ESX.ShowHelpNotification(_U('vape', size))
					else
				if type == 'bong' then
					ESX.ShowHelpNotification(_U('bong', size))
					else
				ESX.ShowHelpNotification(_U('hand'))
				end
			end
		end
	end
				if mouth then
					ESX.ShowHelpNotification(_U('mouth'))
				end

	if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
			if size <= 0 then
				size = 0
				Citizen.Wait(200)
				StartSmoke = false
				if mouth then
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				if type == 'cigar' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
				if type == 'joint' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			end
		end
					TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
					TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
					mouth = false
					hand = false
					timer = false
					give = false
					DetachEntity(NetToObj(propsmoke_net), 1, 1)
					Citizen.Wait(2000)
					DeleteEntity(NetToObj(propsmoke_net))
					propsmoke_net = nil
					--Stress -- here insert trigger for stress system here
					if type == 'joint' and Config.AddArmor then
						SetPedArmour(GetPlayerPed(-1), Config.Armor)
					end
				break
			end
		end
		if IsPedInAnyVehicle(playerPed, true) then
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			RollDownWindow(playerVeh, 0)
		end
		if IsEntityInWater(playerPed) then
			StartSmoke = false
			TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
			if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
			TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
			end
			mouth = false
			hand = false
			timer = false
			give = false
			DetachEntity(NetToObj(propsmoke_net), 1, 1)
			Citizen.Wait(2000)
			DeleteEntity(NetToObj(propsmoke_net))
			propsmoke_net = nil
		end
			if not give and IsControlJustPressed(0, Config.SmokeButton) then
				if multiplier >= 0.9009426647617 then
					if type == 'joint' or type == 'bong' then
					exports['mythic_notify']:DoHudText('inform', _U('enough'))
					end
				else
				if hand then
				mouthsmokeprop = CreateObject(GetHashKey('prop_cigar_01'), x, y, z+0.9,  true,  true, true)
				AttachEntityToEntity(mouthsmokeprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.005, 0.05, 0.003, 30.0, 0.0, 110.0, true, true, false, true, 1, true)
				local netidsmoke = ObjToNet(mouthsmokeprop)
				SetNetworkIdExistsOnAllMachines(netidsmoke, true)
				NetworkSetNetworkIdDynamic(netidsmoke, true)
				SetNetworkIdCanMigrate(netidsmoke, false)
				mouthsmoke_net = netidsmoke
				hand = false
				if type == 'bong' or type == 'vape' then
					if size < 0.5 then
						size = 0
						exports['mythic_notify']:DoHudText('inform', _U('empty'))
						hand = true
						DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
						DeleteEntity(NetToObj(mouthsmoke_net))
						mouthsmoke_net = nil
					else
				if type == 'bong' then
					playAnim('anim@safehouse@bong', 'bong_stage1', 7000)
					Citizen.Wait(7500)
					TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
					size = size - Config.BongSizeRemove
					Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
					hand = true

					TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
					DoScreenFadeOut(250)
					Citizen.Wait(1000)
					DoScreenFadeIn(250)
					if Config.AddArmor then
						SetPedArmour(GetPlayerPed(-1), Config.Armor)
					end
					--Stress -- here insert trigger for stress system here
					WeedEffect = true
					ReductionEffect = true
					multiplier = multiplier + bong
					Citizen.Wait(300)
					DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
					DeleteEntity(NetToObj(mouthsmoke_net))
					else
				playAnim('mp_player_inteat@burger', 'mp_player_int_eat_burger', 1000)
				Citizen.Wait(900)
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - Config.VapeSizeRemove
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				hand = true
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
				DeleteEntity(NetToObj(mouthsmoke_net))
				mouthsmoke_net = nil
					end
				end
				else
				playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a', 2800)
				Citizen.Wait(2800)
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - math.random(Config.SizeRemove.min, Config.SizeRemove.max)
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				hand = true
				if type == 'joint' then
					WeedEffect = true
					ReductionEffect = true
					multiplier = multiplier + joint
				end
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
				DeleteEntity(NetToObj(mouthsmoke_net))
				mouthsmoke_net = nil
				end
			end
				if mouth then
					mouth = false
					Citizen.Wait(1000)
					mouthsmokeprop = CreateObject(GetHashKey('prop_cigar_01'), x, y, z+0.9,  true,  true, true)
					AttachEntityToEntity(mouthsmokeprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
				local netidsmoke = ObjToNet(mouthsmokeprop)
				SetNetworkIdExistsOnAllMachines(netidsmoke, true)
				NetworkSetNetworkIdDynamic(netidsmoke, true)
				SetNetworkIdCanMigrate(netidsmoke, false)
				mouthsmoke_net = netidsmoke
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - math.random(Config.SizeRemove.min, Config.SizeRemove.max)
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				mouth = true
					DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
					DeleteEntity(NetToObj(mouthsmoke_net))
					mouthsmoke_net = nil
			end
		end
			elseif not give and IsControlJustPressed(0, Config.ThrowButton) then
				if mouth then
					ClearPedTasks(playerPed)
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				Citizen.Wait(800)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
				if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
				end
			end
			if type == 'bong' or type == 'vape' then
				StartSmoke = false
				ClearPedTasks(playerPed)
				mouth = false
				hand = false
				timer = false
				give = false
				Citizen.Wait(1500)
				DetachEntity(NetToObj(propsmoke_net), 1, 1)
				DeleteEntity(NetToObj(propsmoke_net))
				propsmoke_net = nil
				break
			else
				ClearPedTasks(playerPed)
				StartSmoke = false
				Citizen.Wait(800)
				DetachEntity(NetToObj(propsmoke_net), 1, 1)
				TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
				TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
				mouth = false
				hand = false
				timer = false
				give = false
				Citizen.Wait(2000)
				DeleteEntity(NetToObj(propsmoke_net))
				propsmoke_net = nil
				break
			end
		elseif not mouth and IsControlJustPressed(0, Config.GiveButton) then
			give = true
			elseif not give and hand and IsControlJustPressed(0, Config.MouthButton) then
				if type == 'vape' then
					if size >= Config.MaxLiquid then
						exports['mythic_notify']:DoHudText('inform', _U('nospace'))
					else
					TriggerServerEvent('devcore_smokev2:server:CheckItem', type)
					Citizen.Wait(1000)
					if liquid then
					playAnim('mp_arresting', 'a_uncuff', 2000)
					Citizen.Wait(1500)
					size = size+ Config.AddLiquidInVape
					liquid = false
					end
				end
				else
					if type == 'bong' then
						if size >= Config.MaxWeed then
							exports['mythic_notify']:DoHudText('inform', _U('nospace'))
						else
							ESX.UI.Menu.CloseAll()
							menuOpen = true
							hand = false
							local playerPed = PlayerPedId()
								local elements = {}
						
							for k, v in pairs(Config.BongReloadItems) do
										local labels = v.ItemsLabel

									table.insert(elements, {
										label = v.ItemsLabel,
										item = v.Items,
										labels = labels
									})
							end

								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug', {
									title    = _U("menu_title"),
									align    = 'right',
									elements = elements
								}, function(data, menu)
									TriggerServerEvent('devcore_smokev2:server:checkbong', data.current.item)
									Citizen.Wait(500)
									if weed then
										menu.close()
										playAnim('mp_arresting', 'a_uncuff', 2000)
										Citizen.Wait(1500)
										size = size+ Config.AddWeedInBong
										weed = false
										hand = true
									end
								end, function(data, menu)
									menu.close()
									hand = true
									menuOpen = false
									end)
								end
				else
				mouth = true
				hand = false
				playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				Citizen.Wait(800)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
					end
					if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.010, 0.0, 0.0, 50.0, 0.0, -80.0, true, true, false, true, 1, true)
					end
					if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.010, 0.0, 0.0, 50.0, 0.0, 80.0, true, true, false, true, 1, true)
				end
			end
			end
			elseif not give and mouth and IsControlJustPressed(0, Config.HandButton) then
				mouth = false
				hand = true
				playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
					Citizen.Wait(1100)
					if type == 'cigarette' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
						if type == 'cigar' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
						end
						if type == 'joint' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
				end
			end
			else
				break
			end
		end
	end
end)



--Receiver
RegisterNetEvent('devcore_smokev2:client:Receiver')
AddEventHandler('devcore_smokev2:client:Receiver', function(item, size, prop, type, time)
	if StartSmoke == true then
		exports['mythic_notify']:DoHudText('inform', _U('already_smoke'))
	else
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	playAnim("mp_common","givetake1_a", 1800)
	TriggerServerEvent('devcore_smokev2:server:AddItem', item, size, prop, type, time)
	if type == 'cigarette' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		StartSmoke = true
		timer = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'cigar' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		StartSmoke = true
		timer = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'joint' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
		Citizen.Wait(800)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		Citizen.Wait(1300)
		DetachEntity(lighter, 1, 1)
		DeleteObject(lighter)
		Citizen.Wait(1000)
		TriggerServerEvent("devcore_smokev2:server:StartPropSmoke", propsmoke_net, type)
		StartSmoke = true
		timer = true
		TriggerEvent('devcore_smokev2:client:RemoveSize', item, size, prop, type, time)
		hand = true
	end
	if type == 'vape' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  18905), 0.13, 0.04, 0.0, 0.0, -140.0, -140.0, true, true, false, true, 1, true)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		StartSmoke = true
		hand = true
	end
	if type == 'bong' then
		mainprop = CreateObject(GetHashKey(prop), x, y, z+0.9,  true,  true, true)
		AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  18905), 0.10, -0.25, 0.0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
		local netid = ObjToNet(mainprop)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		propsmoke_net = netid
		StartSmoke = true
		hand = true
	end
			while true do
				Citizen.Wait(1)
				if StartSmoke then
					if Config.DisableCombatButtons then
					DisableControlAction(0,229, true)
					DisableControlAction(0,223, true)
					DisableControlAction(0,142, true)
					DisableControlAction(0,25, true)
					DisableControlAction(0,347, true)
					end
					if hand then
				if give then
					ESX.ShowHelpNotification(_U('give'))
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 2.5 then
					target_id = GetPlayerPed(closestPlayer)
					playerX, playerY, playerZ = table.unpack(GetEntityCoords(target_id))
					DrawMarker(0, playerX, playerY, playerZ+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 10, 255, 0, 100, true, true, 2, true, false, false, false)
				if IsControlJustPressed(0, Config.ConfirmGiveButton) then
					DetachEntity(NetToObj(propsmoke_net), 1, 1)
					if type == 'joint' or type == 'cigarette' then
					TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
					end
					Citizen.Wait(100)
					DeleteEntity(NetToObj(propsmoke_net))
					propsmoke_net = nil
					TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
					TriggerServerEvent('devcore_smokev2:server:Receiver', GetPlayerServerId(closestPlayer), item, size, prop, type, time)
					ClearPedTasks(playerPed)
					StartSmoke = false
					mouth = false
					timer = false
					hand = false
					give = false
					playAnim("mp_common","givetake1_a", 1800)
					break
				end
				if IsControlJustPressed(0, Config.CancelGiveButton) then
					give = false
					ClearPedTasks(playerPed)
					Citizen.Wait(200)
				end
			end
					else
				if type == 'vape' then
					ESX.ShowHelpNotification(_U('vape', size))
					else
				if type == 'bong' then
					ESX.ShowHelpNotification(_U('bong', size))
					else
						ESX.ShowHelpNotification(_U('hand'))
				end
			end
		end
	end
				if mouth then
					ESX.ShowHelpNotification(_U('mouth'))
				end
		if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
			if size <= 0 then
				size = 0
				if mouth then
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				if type == 'cigar' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
				if type == 'joint' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			end
		end
					StartSmoke = false
					mouth = false
					hand = false
					timer = false
					give = false
					TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
					TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
					DetachEntity(NetToObj(propsmoke_net), 1, 1)
					Citizen.Wait(2000)
					DeleteEntity(NetToObj(propsmoke_net))
					propsmoke_net = nil
					--Stress -- here insert trigger for stress system here
					if type == 'joint' and Config.AddArmor then
						SetPedArmour(GetPlayerPed(-1), Config.Armor)
					end
				break
			end
		end
		if IsPedInAnyVehicle(playerPed, true) then
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			RollDownWindow(playerVeh, 0)
		end
		if IsEntityInWater(playerPed) then
			StartSmoke = false
			TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
			if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
			TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
			end
			mouth = false
			hand = false
			timer = false
			give = false
			DetachEntity(NetToObj(propsmoke_net), 1, 1)
			Citizen.Wait(2000)
			DeleteEntity(NetToObj(propsmoke_net))
			propsmoke_net = nil
		end
			if not give and IsControlJustPressed(0, Config.SmokeButton) then
				if type == 'joint' or type == 'bong' and multiplier > 0.9009426647617 then 
					exports['mythic_notify']:DoHudText('inform', _U('enough'))
				else
				if hand then
				mouthsmokeprop = CreateObject(GetHashKey('prop_cigar_01'), x, y, z+0.9,  true,  true, true)
				AttachEntityToEntity(mouthsmokeprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
				local netidsmoke = ObjToNet(mouthsmokeprop)
				SetNetworkIdExistsOnAllMachines(netidsmoke, true)
				NetworkSetNetworkIdDynamic(netidsmoke, true)
				SetNetworkIdCanMigrate(netidsmoke, false)
				mouthsmoke_net = netidsmoke
				hand = false
				if type == 'bong' or type == 'vape' then
					if size < 0.5 then
						size = 0
						exports['mythic_notify']:DoHudText('inform', _U('empty'))
						hand = true
						DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
						DeleteEntity(NetToObj(mouthsmoke_net))
						mouthsmoke_net = nil
					else
				if type == 'bong' then
					playAnim('anim@safehouse@bong', 'bong_stage1', 7000)
					Citizen.Wait(7500)
					TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
					size = size - Config.BongSizeRemove
					Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
					hand = true

					TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
					DoScreenFadeOut(250)
					Citizen.Wait(1000)
					DoScreenFadeIn(250)
					if Config.AddArmor then
						SetPedArmour(GetPlayerPed(-1), Config.Armor)
					end
					--Stress -- here insert trigger for stress system here
					WeedEffect = true
					ReductionEffect = true
					multiplier = multiplier + bong
					Citizen.Wait(300)
					DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
					DeleteEntity(NetToObj(mouthsmoke_net))
					else
				playAnim('mp_player_inteat@burger', 'mp_player_int_eat_burger', 1000)
				Citizen.Wait(900)
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - Config.VapeSizeRemove
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				hand = true
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
				DeleteEntity(NetToObj(mouthsmoke_net))
				mouthsmoke_net = nil
					end
				end
				else
				playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a', 2800)
				Citizen.Wait(2800)
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - math.random(Config.SizeRemove.min, Config.SizeRemove.max)
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				hand = true
				if type == 'joint' then
					WeedEffect = true
					ReductionEffect = true
					multiplier = multiplier + joint
				end
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
				DeleteEntity(NetToObj(mouthsmoke_net))
				mouthsmoke_net = nil
				end
			end
				if mouth then
					mouth = false
					Citizen.Wait(1000)
					mouthsmokeprop = CreateObject(GetHashKey('prop_cigar_01'), x, y, z+0.9,  true,  true, true)
					AttachEntityToEntity(mouthsmokeprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
				local netidsmoke = ObjToNet(mouthsmokeprop)
				SetNetworkIdExistsOnAllMachines(netidsmoke, true)
				NetworkSetNetworkIdDynamic(netidsmoke, true)
				SetNetworkIdCanMigrate(netidsmoke, false)
				mouthsmoke_net = netidsmoke
				TriggerServerEvent("devcore_smokev2:server:StartMouthSmoke", mouthsmoke_net, type)
				size = size - math.random(Config.SizeRemove.min, Config.SizeRemove.max)
				Citizen.Wait(math.random(Config.ExhaleTime.min, Config.ExhaleTime.max))
				TriggerServerEvent("devcore_smokev2:server:StopMouthSmoke", mouthsmoke_net)
				Citizen.Wait(300)
				mouth = true
					DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
					DeleteEntity(NetToObj(mouthsmoke_net))
					mouthsmoke_net = nil
			end
		end
			elseif not give and IsControlJustPressed(0, Config.ThrowButton) then
				if mouth then
					ClearPedTasks(playerPed)
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				Citizen.Wait(800)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
				if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
				end
			end
			if type == 'bong' or type == 'vape' then
				StartSmoke = false
				ClearPedTasks(playerPed)
				mouth = false
				hand = false
				give = false
				timer = false
				Citizen.Wait(1500)
				DetachEntity(NetToObj(propsmoke_net), 1, 1)
				DeleteEntity(NetToObj(propsmoke_net))
				propsmoke_net = nil
				break
			else
				ClearPedTasks(playerPed)
				StartSmoke = false
				Citizen.Wait(800)
				DetachEntity(NetToObj(propsmoke_net), 1, 1)
				TriggerServerEvent('devcore_smokev2:server:RemoveItem', item, size, prop, type, time)
				TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
				mouth = false
				hand = false
				give = false
				timer = false
				Citizen.Wait(2000)
				DeleteEntity(NetToObj(propsmoke_net))
				propsmoke_net = nil
				break
			end
		elseif not mouth and IsControlJustPressed(0, Config.GiveButton) then
			give = true
			elseif not give and hand and IsControlJustPressed(0, Config.MouthButton) then
				if type == 'vape' then
					if size > Config.MaxLiquid then
						exports['mythic_notify']:DoHudText('inform', _U('nospace'))
					else
					TriggerServerEvent('devcore_smokev2:server:CheckItem', type)
					Citizen.Wait(1000)
					if liquid then
					playAnim('mp_arresting', 'a_uncuff', 2000)
					Citizen.Wait(1500)
					size = size+ Config.AddLiquidInVape
					liquid = false
					end
				end
				else
					if type == 'bong' then
						if size >= Config.MaxWeed then
							exports['mythic_notify']:DoHudText('inform', _U('nospace'))
						else
							ESX.UI.Menu.CloseAll()
							menuOpen = true
							hand = false
							local playerPed = PlayerPedId()
								local elements = {}
						
							for k, v in pairs(Config.BongReloadItems) do
										local labels = v.ItemsLabel

									table.insert(elements, {
										label = v.ItemsLabel,
										item = v.Items,
										labels = labels
									})
							end

								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug', {
									title    = _U("menu_title"),
									align    = 'right',
									elements = elements
								}, function(data, menu)
									TriggerServerEvent('devcore_smokev2:server:checkbong', data.current.item)
									Citizen.Wait(500)
									if weed then
										menu.close()
										playAnim('mp_arresting', 'a_uncuff', 2000)
										Citizen.Wait(1500)
										size = size+ Config.AddWeedInBong
										weed = false
										hand = true
									end
								end, function(data, menu)
									menu.close()
									hand = true
									menuOpen = false
									end)
								end
				else
				mouth = true
				hand = false
				playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
				Citizen.Wait(800)
				if type == 'cigarette' then
					AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
					end
					if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.010, 0.0, 0.0, 50.0, 0.0, -80.0, true, true, false, true, 1, true)
					end
					if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 47419), 0.010, 0.0, 0.0, 50.0, 0.0, 80.0, true, true, false, true, 1, true)
				end
			end
			end
			elseif not give and mouth and IsControlJustPressed(0, Config.HandButton) then
				mouth = false
				hand = true
				playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
					Citizen.Wait(1100)
					if type == 'cigarette' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
						if type == 'cigar' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
						end
						if type == 'joint' then
							AttachEntityToEntity(mainprop, playerPed, GetPedBoneIndex(playerPed,  64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
				end
			end
			else
				break
			end
		end
	end
end)


RegisterCommand('take', function()
	local playerPed = PlayerPedId()
	playAnim("mp_common","givetake1_a", 1800)
end)


RegisterNetEvent('devcore_smokev2:client:CigarettesUnPack')
AddEventHandler('devcore_smokev2:client:CigarettesUnPack', function(source)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))

	playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1000)
	Citizen.Wait(800)
	pack = CreateObject(GetHashKey('prop_cigar_pack_01'), x, y, z+0.9,  true,  true, true)
	AttachEntityToEntity(pack, playerPed, GetPedBoneIndex(playerPed, 64016), 0.020, -0.05, -0.010, 100.0, 0.0, 0.0, true, true, false, true, 1, true)

		playAnim('mp_arresting', 'a_uncuff', 3000)
		Citizen.Wait(3000)
		DetachEntity(pack, 1, 1)
	Citizen.Wait(2000)
	DeleteObject(pack)
end)



RegisterNetEvent('devcore_smokev2:client:AddLiquid')
AddEventHandler('devcore_smokev2:client:AddLiquid', function(type)
	liquid = true
end)

RegisterNetEvent('devcore_smokev2:client:AddBong')
AddEventHandler('devcore_smokev2:client:AddBong', function(type)
	ESX.UI.Menu.CloseAll()
	weed = true
end)


RegisterNetEvent('devcore_smokev2:client:RemoveSize')
AddEventHandler('devcore_smokev2:client:RemoveSize', function(item, size, prop, type, time)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	while true do
		Citizen.Wait(time)
		if timer then
			ClearPedTasks(playerPed)
			timer = false
			StartSmoke = false
			Citizen.Wait(800)
			DetachEntity(NetToObj(propsmoke_net), 1, 1)
			mouth = false
			hand = false
			Citizen.Wait(2000)
			TriggerServerEvent("devcore_smokev2:server:StopPropSmoke", propsmoke_net)
			Citizen.Wait(500)
			DeleteEntity(NetToObj(propsmoke_net))
			propsmoke_net = nil
			break
		else
			break
		end
	end
end)


-- Prop Smoke
RegisterNetEvent("devcore_smokev2:client:StartPropSmoke")
AddEventHandler("devcore_smokev2:client:StartPropSmoke", function(propsmokeid, type)
    local entity = NetToObj(propsmokeid)
	if type == 'cigarette' then
		
		RequestNamedPtfxAsset(particleDict)
		while not HasNamedPtfxAssetLoaded(particleDict) do
			Citizen.Wait(100)
		end
	
		UseParticleFxAssetNextCall(particleDict)
		local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.CigaretteSmoke, false, false, false)
		end
		if type == 'cigar' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, 0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.CigarSmoke, false, false, false)
		end
		if type == 'joint' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.090, 0.0, 0.0, 0.0, 0.0, 0.0, Config.JointSmoke, false, false, false)
		end
end)

RegisterNetEvent("devcore_smokev2:client:StopPropSmoke")
AddEventHandler("devcore_smokev2:client:StopPropSmoke", function(propsmokeid)
    local entity = NetToObj(propsmokeid)
    RemoveParticleFxFromEntity(entity)
end)

-- Exhaling smoke
RegisterNetEvent("devcore_smokev2:client:StartMouthSmoke")
AddEventHandler("devcore_smokev2:client:StartMouthSmoke", function(mouthsmokeid, type)
    local entity = NetToObj(mouthsmokeid)

	if type == 'cigarette' then
		
		RequestNamedPtfxAsset(particleDict)
		while not HasNamedPtfxAssetLoaded(particleDict) do
			Citizen.Wait(100)
		end
	
		UseParticleFxAssetNextCall(particleDict)
		local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.CigaretteExhale, false, false, false)
		end
		if type == 'cigar' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, 0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.CigarExhale, false, false, false)
		end
		if type == 'joint' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.JointExhale, false, false, false)
		end
		if type == 'vape' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.VapeExhale, false, false, false)
		end
		if type == 'bong' then
			
			RequestNamedPtfxAsset(particleDict)
			while not HasNamedPtfxAssetLoaded(particleDict) do
				Citizen.Wait(100)
			end
		
			UseParticleFxAssetNextCall(particleDict)
			local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.BongExhale, false, false, false)
		end
end)

RegisterNetEvent("devcore_smokev2:client:StopMouthSmoke")
AddEventHandler("devcore_smokev2:client:StopMouthSmoke", function(mouthsmokeid)
    local entity = NetToObj(mouthsmokeid)
	Citizen.Wait(2000)
    RemoveParticleFxFromEntity(entity)
end)


------------EFFECT----------------------
multiplier = 0.0
joint = 0.1159949
bong = 0.5359949
minusphase4 = 0.014048
maxhighdone = 0.8309426647617
maxhigh = 0.9309426647617
minhigh = 0.1249949


Citizen.CreateThread(function(source)
while true do
	Wait(100)

if WeedEffect then
	local playerPed = PlayerPedId()
	if multiplier > maxhigh then
		multiplier = 0.9309426647617
		RequestAnimSet("move_m@business@a")
		SetPedMovementClipset(GetPlayerPed(-1), "move_m@business@a", true)
		SetFacialIdleAnimOverride(playerPed, 'mood_sulk_1')
	if multiplier < 0.4309426647617 then
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
	end
		else
			SetTimecycleModifier("spectator9")
			SetPedIsDrunk(GetPlayerPed(-1), true)
			SetPedMotionBlur(GetPlayerPed(-1), true)
			SetTimecycleModifierStrength(multiplier)
		end
		end
	end
end)

Citizen.CreateThread(function(source)
	while true do
		Citizen.Wait(15000)
		local player = PlayerId()
	
		if ReductionEffect then
	
			  if multiplier > minhigh then
					SetTimecycleModifier("spectator9")
					SetTimecycleModifierStrength(multiplier)
					multiplier = multiplier - minusphase4
				if multiplier < minhigh	then
					WeedEffect = false
					ReductionEffect = false
					ClearFacialIdleAnimOverride(player)
					ResetPedMovementClipset(GetPlayerPed(-1), 0)
					ClearTimecycleModifier()
					ResetScenarioTypesEnabled()
					SetPedIsDrunk(GetPlayerPed(-1), false)
					SetPedMotionBlur(GetPlayerPed(-1), false)
						end
					end
				end
			end
	end)