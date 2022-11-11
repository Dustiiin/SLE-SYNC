ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for i=1, #Config.Smoke, 1 do

    ESX.RegisterUsableItem(Config.Smoke[i].Item, function(source)
        src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local lighter = xPlayer.getInventoryItem(Config.Lighter)
        
        local item     = Config.Smoke[i].Item
        local prop     = Config.Smoke[i].Prop
        local size    = Config.Smoke[i].Size
        local type    = Config.Smoke[i].Type
        local time    = Config.Smoke[i].Time

        if type == 'vape' or type == 'bong' then
            TriggerClientEvent('devcore_smokev2:client:Smoke', src, item, size, prop, type, time)
        end
    	if type == 'cigar' or type == 'cigarette' or type == 'joint' then
            if lighter.count > 0 then
        TriggerClientEvent('devcore_smokev2:client:Smoke', src, item, size, prop, type, time)
           -- xPlayer.removeInventoryItem(pack, 1)
            --xPlayer.addInventoryItem(item, amount)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U('need_lighter') })
         end
        end
            end)
    end


    for i=1, #Config.CigarettePack, 1 do

        ESX.RegisterUsableItem(Config.CigarettePack[i].PackItem, function(source)
            src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            local pack     = Config.CigarettePack[i].PackItem
            local item     = Config.CigarettePack[i].CigaretteItem
            local amount    = Config.CigarettePack[i].Amount
        
            TriggerClientEvent('devcore_smokev2:client:CigarettesUnPack', src)
            Citizen.Wait(3000)
                xPlayer.removeInventoryItem(pack, 1)
                xPlayer.addInventoryItem(item, amount)
                end)
        end

        ESX.RegisterUsableItem(Config.Rollingpaper, function(source)
            src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            for i=1, #Config.ItemWeed, 1 do
            local weed = xPlayer.getInventoryItem(Config.ItemWeed[i])
            if weed.count > 0 then
                TriggerClientEvent('esx_crafting:OpenMenu', source)
                end
            end
        end)

        RegisterServerEvent("devcore_smokev2:server:RemoveItem")
        AddEventHandler("devcore_smokev2:server:RemoveItem", function(item, size, prop, type, time)
            src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem(item, 1)
        end)
        
        RegisterServerEvent("devcore_smokev2:server:AddItem")
        AddEventHandler("devcore_smokev2:server:AddItem", function(item, size, prop, type, time)
            src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.addInventoryItem(item, 1)
        end)
        

RegisterServerEvent("devcore_smokev2:server:StartPropSmoke")
AddEventHandler("devcore_smokev2:server:StartPropSmoke", function(propsmoke, type)
    TriggerClientEvent("devcore_smokev2:client:StartPropSmoke", -1, propsmoke, type)
end)

RegisterServerEvent("devcore_smokev2:server:CheckItem")
AddEventHandler("devcore_smokev2:server:CheckItem", function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
	local liquid = xPlayer.getInventoryItem(Config.ItemVapeLiquid)
	
		if liquid.count > 0 then
			xPlayer.removeInventoryItem(Config.ItemVapeLiquid, 1)
			TriggerClientEvent('devcore_smokev2:client:AddLiquid', source)
		else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U('need_liquid') })
            
		end
end)



RegisterServerEvent("devcore_smokev2:server:checkbong")
AddEventHandler("devcore_smokev2:server:checkbong", function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)

	if xItem.count < 1 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U('dont_have') })
		return
	end

	xPlayer.removeInventoryItem(xItem.name, 1)
	TriggerClientEvent('devcore_smokev2:client:AddBong', source)
end)


RegisterServerEvent('devcore_smokev2:server:Receiver')
AddEventHandler('devcore_smokev2:server:Receiver', function(target, item, size, prop, type, time)
    local _source 	 = ESX.GetPlayerFromId(target).source
    TriggerClientEvent("devcore_smokev2:client:Receiver", _source, item, size, prop, type, time)
end)

--Effect
RegisterServerEvent("devcore_smokev2:server:StopPropSmoke")
AddEventHandler("devcore_smokev2:server:StopPropSmoke", function(propsmoke)
    TriggerClientEvent("devcore_smokev2:client:StopPropSmoke", -1, propsmoke)
end)
-- mouth particle
RegisterServerEvent("devcore_smokev2:server:StartMouthSmoke")
AddEventHandler("devcore_smokev2:server:StartMouthSmoke", function(mouthsmoke, type)
    TriggerClientEvent("devcore_smokev2:client:StartMouthSmoke", -1, mouthsmoke, type)
end)

RegisterServerEvent("devcore_smokev2:server:StopMouthSmoke")
AddEventHandler("devcore_smokev2:server:StopMouthSmoke", function(mouthsmoke)
    TriggerClientEvent("devcore_smokev2:client:StopMouthSmoke", -1, mouthsmoke)
end)