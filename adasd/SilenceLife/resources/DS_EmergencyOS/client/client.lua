ESX = nil
local whitelistedJobs = {"police", "ambulance", "fib", "doj"}
local tabletStatus = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1);
			if (tabletStatus) then
				local ped = GetPlayerPed(-1)
                DisableControlAction(0, 1, tabletStatus)
                DisableControlAction(0, 2, tabletStatus)
                DisableControlAction(0, 24, tabletStatus)
                DisablePlayerFiring(ped, tabletStatus)
                DisableControlAction(0, 142, tabletStatus)
                DisableControlAction(0, 106, tabletStatus)
			end
		end
	end
)

RegisterCommand("openAncomoxTablet", function(source, args, rawCommand)
	for k,v in pairs(whitelistedJobs) do
		if ESX.PlayerData.job.name == v then
			tabletStatus = not tabletStatus
			SetNuiFocus(tabletStatus, tabletStatus)
			SendNUIMessage({show = tabletStatus, name = GetCurrentResourceName()})
			playAnimation()
		end
	end
end, false)

RegisterKeyMapping('openAncomoxTablet', 'Open Ancomox Tablet', 'keyboard', 'M')

RegisterNUICallback('close', function(data, cb)
	tabletStatus = false
	SetNuiFocus(false, false)
	SendNUIMessage({show = false})
	ClearPedTasks(PlayerPedId())
	DestroyProps()
end)

function playAnimation ()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		return
	end
	local dict = "amb@world_human_tourist_map@male@base"   -- Change this for other Animations  
	local anim = "base"

	RequestAnimDict(dict)

	Citizen.CreateThread(function ()

		local Prop = 'prop_cs_tablet'				   	-- Change this for other Items in Hand
		local PropBone = 28422
		AddPropToPlayer(Prop, PropBone, 0.0, -0.05, 0.0, 20.0, 280.0, 20.0)
		
		TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 1, 0, false, false, false)
	end)
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

function LoadPropDict(model)
  while not HasModelLoaded(GetHashKey(model)) do
    RequestModel(GetHashKey(model))
    Wait(10)
  end
end

local PlayerProp = false
local PlayerProps = {}
function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
  local Player = PlayerPedId()
  local x,y,z = table.unpack(GetEntityCoords(Player))

  if not HasModelLoaded(prop1) then
    LoadPropDict(prop1)
  end

  prop = CreateObject(GetHashKey(prop1), x, y, z+0.1,  true,  true, true)
  AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
  table.insert(PlayerProps, prop)
  PlayerProp = true
  SetModelAsNoLongerNeeded(prop1)
end

function DestroyProps()
  for _,v in pairs(PlayerProps) do
    DeleteEntity(v)
  end
  PlayerProp = false
end