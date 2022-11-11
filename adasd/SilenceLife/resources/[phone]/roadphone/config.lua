ESX = exports['es_extended']:getSharedObject()

--Run the code below if ESX nil is displayed in your console and delete the code above--.

--ESX = nil
--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Config = {}

Config.Locale = 'de' --Change Language ONLY FOR LUA CODE UI LANGUAGE = public/html/static/config -> config.json

Config.RegisterKeyMapping = true --If you set RegisterKeyMapping to false you can only close the phone with ESC.
Config.OpenPhoneKey = 'f1' --Works only with RegisterKeyMapping true / https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

Config.ESXName = "esx" --change if you use different ESX name
Config.ESXVersion = "1.2" --1.1 OR 1.2!!
Config.ESXDeathEvent = "esx:onPlayerDeath" --Trigger when the player dies
Config.ESXSpawnEvent = "esx:onPlayerSpawn" --Trigger when the player spawns

Config.ESXInventoryChecks = false 
Config.ESXonAddInventoryItem = "esx:onAddInventoryItem" --Trigger when the player gets an item
Config.ESXonRemoveInventoryItem = "esx:onRemoveInventoryItem" --Trigger when the player loses an item

Config.Items = {
     "phone"
}

Config.NeedItem = true --Need Item to open the phone


Config.CallNotifPlayerOffline = true --Show notification when person is offline or not reachable

Config.ShowOffNotifications = false --Notifications outside the phone


--Voice Chat ( Configure here your VoiceChat )

Config.MumbleExport = "mumble-voip" --exports["mumble-voip"]
Config.PMAVoiceExport = "pma-voice" --exports["pma-voice"]

Config.UseMumbleVoip = false --We recommend: https://github.com/FrazzIe/mumble-voip-fivem
Config.UseTokoVoip = false
Config.UseSaltyChat = true --Works perfect with SaltyChat 2.6
Config.UsePmaVoice = false



--Jobs App

Config.BossNames = {
     ['police'] = 'chief',
     ['ambulance'] = 'boss',
     ['fbi'] = 'director',
     ['army'] = 'general',
}

Config.unemployedJobName = "unemployed" --Unemployed Job name

--Crypto

Config.Crypto = {
     ['Bitcoin'] = true,
     ['Monero'] = true,
     ['Ethereum'] = true,
     ['Cardano'] = true,
     ['Dogecoin'] = true,
     ['Litecoin'] = true,
     ['Tether'] = true,
     ['VeChain'] = true,
     ['BNB'] = true,
     ['Solana'] = true
}

--Radio App

Config.RadioAnimation = false --Only works with Mumble-Voip & PMA-Voice!
Config.RadioAnimationKey = 217
Config.RemoveFromRadioWhenDead = true
Config.RadioNeedItem = false
Config.RemoveFromRadioWhenNoPhone = false --Config.ESXInventoryChecks must be true

Config.RadioItems = {
     "radio"
}

Config.PhoneProp = true

Config.MessageAppShowLastMessage = true
Config.MaxMusicRange = 1.0 --Adjust music volume RANGE: 0.1 - 1.0

Config.RadioItemName = "radio"

Config.lockedRadioChannels = { --Radio lock
     { frq = 1, jobhasaccess = "police"},
     { frq = 2, jobhasaccess = "ambulance"},
     { frq = 3, jobhasaccess = "FBI"},
     { frq = 4, jobhasaccess = "Army"},
     { frq = 5, jobhasaccess = "DOJ"},
     { frq = 6, jobhasaccess = "police, ambulance, FBI, Army"},

     --[[You can lock a radio for multiple jobs by doing the following:
     { frq = 2, jobhasaccess = "ambulance"},
     { frq = 2, jobhasaccess = "police"}--]]

}


--Network

Config.UseNetworkSystem = true

Config.NoNetwork = {
     {
          location = vector3(445.1293, 5572.6768, 781.1885),
          radius = 100.0,
     }
}

Config.SystemNumber = 99999999 --System Number

--Valet 

Config.ValetPedModel = "s_m_y_valet_01"
Config.ValetRadius = 500.0 --Radius the car spawned and drive to the player
Config.ValetDeliveryPrice = 500 --How much it costs to have your car delivered
Config.OwnedVehiclesTable = "owned_vehicles"
Config.ValetCheckStored = true


Config.CarNamesDebug = false --Debug car names

--Other Scripts ( Support )

Config.VisnAre = false --Set to true if you use Visn-Are Script

--Multichar

Config.myMultichar = false --Set the value to true if you use the script myMultichar
Config.esxMultichar = false --Set the value to true if you use the script esx_multicharacter ( https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D/esx_multicharacter )

--Don't change anything if you don't know what are you doing.
--These tables only change code that is not accessible to you, which means you also have to make changes in ServerAPI.lua.

Config.UserTable = "users" 
Config.JobsTable = "jobs"

Config.ShowServerInfo = true --Show server info from the phone
