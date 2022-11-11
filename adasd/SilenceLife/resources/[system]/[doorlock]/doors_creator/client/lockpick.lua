local lockpickTime = 5000

local function lockpickDoor(doorsId)
    local plyPed = PlayerPedId()
    
    TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)

    Citizen.Wait(lockpickTime)

    ClearPedTasks(plyPed)

    TriggerServerEvent("doors_creator:doorLockpicked", doorsId)
end

RegisterNetEvent("doors_creator:startLockpick", function() 
    local closestDoor, closestDist = DoorsCreator.getClosestActiveDoor()

    if(closestDoor and closestDist < 5.0) then

        if(DoorsCreator.allDoors[closestDoor.id].canBeLockpicked) then
            lockpickDoor(closestDoor.id)
        else
            notifyClient( getLocalizedText("you_cant_lockpick_this_door") )
        end
    else
        notifyClient(getLocalizedText("no_close_door"))
    end
end)