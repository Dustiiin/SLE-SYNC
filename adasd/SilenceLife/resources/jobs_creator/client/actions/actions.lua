local canDoAnyAction = false

local isBillingEnabled = false
local canRob = false
local canHandcuff = false
local canLockpickCars = false
local canWashVehicles = false
local canRepairVehicles = false
local canImpoundVehicles = false
local canCheckIdentity = false
local canCheckVehicleOwner = false
local canCheckDrivingLicense = false
local canCheckWeaponLicense = false
local canHeal = false
local canRevive = false

local function checkAllowedActions()
    local promise = promise.new()

    TriggerServerCallback(Utils.eventsPrefix .. ':checkAllowedActions', function(data)
        canDoAnyAction = false
        
        for action, enabled in pairs(data) do
            if(enabled and action ~= "whitelisted") then
                canDoAnyAction = true
                break
            end
        end

        isBillingEnabled = data.enableBilling
        canRob = data.canRob
        canHandcuff = data.canHandcuff
        canLockpickCars = data.canLockpickCars
        canWashVehicles = data.canWashVehicles
        canRepairVehicles = data.canRepairVehicles
        canImpoundVehicles = data.canImpoundVehicles
        canCheckIdentity = data.canCheckIdentity
        canCheckVehicleOwner = data.canCheckVehicleOwner
        canCheckDrivingLicense = data.canCheckDrivingLicense
        canCheckWeaponLicense = data.canCheckWeaponLicense
        canHeal = data.canHeal
        canRevive = data.canRevive

        promise:resolve(data)
    end)

    return Citizen.Await(promise)
end

function getClosestPlayerId(maxDistance)
    maxDistance = maxDistance or 2.0

    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    local closestPlayerId, closestDistance = ESX.Game.GetClosestPlayer(plyCoords)

    if(closestPlayerId == PlayerId()) then
        closestPlayerId, closestDistance = ESX.Game.GetClosestPlayer()
    end
    
    if(closestPlayerId ~= -1 and closestDistance and closestDistance < maxDistance) then
        return closestPlayerId
    else
        return false
    end
end

function getClosestPed(maxDistance)
    maxDistance = maxDistance or 2.0

    local closestPlayer, closestDistance = ESX.Game.GetClosestPed()

    if(closestPlayer ~= -1 and closestDistance and closestDistance < maxDistance) then
        return closestPlayer
    else
        return false
    end
end

local function checkLicenses()
    local elements = {}

    if(canCheckDrivingLicense) then
        table.insert(elements, {label = getLocalizedText('actions:driving_license'), value = "driver"})
    end

    if(canCheckWeaponLicense) then
        table.insert(elements, {label = getLocalizedText('actions:weapon_license'), value = "weapon"})
    end    

    Framework.menu().Open('default', GetCurrentResourceName(), 'check_licenses', {
        title = getLocalizedText('actions_menu'),
        align = config.menuPosition,
        elements = elements
    }, 
    function(data, menu) 
        local licenseCategory = data.current.value

        openLicenseMenu(licenseCategory)
    end,
    function(data, menu)
        menu.close()
    end)
end
RegisterNetEvent(Utils.eventsPrefix .. ":actions:licensesMenu", checkLicenses)

local function openActionsMenu()
    if(canDoAnyAction and (config.canUseActionsMenuWhileOffDuty or isOnDuty) and (not exports[ GetCurrentResourceName() ]:isPlayerHandcuffed()) ) then
        local elements = {}

        if(isBillingEnabled) then
            table.insert(elements, {label = getLocalizedText('actions_billing'), value = "billing"})
        end

        if(canRob) then
            table.insert(elements, {label = getLocalizedText('actions_search'), value = "search"})
        end

        if(canHandcuff) then
            table.insert(elements, {label = getLocalizedText('actions_put_handcuffs'), value = "handcuff"})
            table.insert(elements, {label = getLocalizedText('actions_start_dragging'), value = "drag"})
            table.insert(elements, {label = getLocalizedText('actions_put_in_car'), value = "putincar"})
            table.insert(elements, {label = getLocalizedText('actions_take_from_car'), value = "takefromcar"})
        end

        if(canLockpickCars) then
            table.insert(elements, {label = getLocalizedText('actions_lockpick_car'), value = "lockpickcar"})
        end

        if(canWashVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:wash_vehicle'), value = "washvehicle"})
        end
        
        if(canRepairVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:repair_vehicle'), value = "repairvehicle"})
        end

        if(canImpoundVehicles) then
            table.insert(elements, {label = getLocalizedText('actions:impound_vehicle'), value = "impoundvehicle"})
        end

        if(canCheckIdentity) then
            table.insert(elements, {label = getLocalizedText('actions:check_identity'), value = "checkidentity"})
        end

        if(canCheckVehicleOwner) then
            table.insert(elements, {label = getLocalizedText('actions:check_vehicle_owner'), value = "checkvehicleowner"})
        end

        if(canCheckDrivingLicense or canCheckWeaponLicense) then
            table.insert(elements, {label = getLocalizedText('actions:check_licenses'), value = "checklicenses"})
        end

        if(canHeal) then
            table.insert(elements, {label = getLocalizedText('actions:heal_small'), value = "heal_small"})
            table.insert(elements, {label = getLocalizedText('actions:heal_big'), value = "heal_big"})
        end

        if(canRevive) then
            table.insert(elements, {label = getLocalizedText('actions:revive'), value = "revive"})
        end

        Framework.menu().CloseAll()

        Framework.menu().Open('default', GetCurrentResourceName(), 'actions_menu', {
            title = getLocalizedText('actions_menu'),
            align = config.menuPosition,
            elements = elements
        }, 
        function(data, menu) 
            local action = data.current.value

            if(action == "billing") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:createBilling')
            elseif(action == "search") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:search')
            elseif(action == "handcuff") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:handcuff')
            elseif(action == "drag") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:drag')
            elseif(action == "putincar") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:putInCar')
            elseif(action == "takefromcar") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:takeFromCar')
            elseif(action == "lockpickcar") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:lockpickCar')
            elseif(action == "washvehicle") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:washVehicle')
            elseif(action == "repairvehicle") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:repairVehicle')
            elseif(action == "impoundvehicle") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:impoundVehicle')
            elseif(action == "checkidentity") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:checkIdentity')
            elseif(action == "checkvehicleowner") then
                TriggerEvent(Utils.eventsPrefix .. ':actions:checkVehicleOwner')
            elseif(action == "checklicenses") then
                checkLicenses()
            elseif(action == "heal_small") then
                TriggerEvent(Utils.eventsPrefix .. ":actions:healSmall")
            elseif(action == "heal_big") then
                TriggerEvent(Utils.eventsPrefix .. ":actions:healBig")
            elseif(action == "revive") then
                TriggerEvent(Utils.eventsPrefix .. ":actions:revive")
            end
        end,
        function(data, menu)
            menu.close()
        end
        )
    end
end

RegisterNetEvent(Utils.eventsPrefix .. ':openActionsMenu', openActionsMenu)

AddEventHandler(Utils.eventsPrefix .. ":clientConfigLoaded", function()
    local message = getLocalizedText('open_actions_menu') or "Open actions menu"
    
    registerAdvancedKeymap("_jobcreator_openactionsmenu", config.actionsMenuKey, "action_key", message, openActionsMenu)
end)

-- Reload allowed actions
RegisterNetEvent('esx:setJob', checkAllowedActions)
RegisterNetEvent('QBCore:Client:OnJobUpdate', checkAllowedActions)

RegisterNetEvent(Utils.eventsPrefix .. ':framework:ready', checkAllowedActions)

-- To refresh manually the allowed actions
RegisterNetEvent(Utils.eventsPrefix .. ':checkAllowedActions', checkAllowedActions)

-- Retrieve player allowed actions from anywhere
exports('getAllowedActions', checkAllowedActions)