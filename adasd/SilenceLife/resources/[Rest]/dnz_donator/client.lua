local display = false
ESX = nil
local blur = "MenuMGIn"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNUICallback("createmoneycode", function(data, cb)

    if data.amount == '' or tonumber(data.amount) < 1 then
        TriggerEvent('dnz_donator:notify', 'Donator System', 'Du musst eine Zahl eingeben..')
        return
    end

    ESX.TriggerServerCallback('dnz_donator:createmoneycode', function(code)
        local htmlcode = "Deine Codes:"
        for i,k in pairs(code) do

            htmlcode = htmlcode .. "\n" .. k.code
        end
            SendNUIMessage({
                type = "setgeneratedcode",
                code = htmlcode,
            })
    end, data.amount, data.anzahlcode, data.typ)
end)

RegisterNUICallback("initiate", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:getinitiate', function(code)
        if code == false then
            SendNUIMessage({
                type = "delnoadmin",
                code = htmlcode,
            })
        end
    end)    
end)

RegisterNUICallback("createpremiumkey", function(data, cb)
        ESX.TriggerServerCallback('dnz_donator:createpremiumkey', function(code)
            local htmlcode = "Deine Codes:"
            for i,k in pairs(code) do

                htmlcode = htmlcode .. "\n" .. k.code
            end
                SendNUIMessage({
                    type = "setgeneratedcode",
                    code = htmlcode,
                })
        end)
end)

RegisterNUICallback("createfahrzeugcode", function(data, cb)
    if data.vehicle == '' or data.vehicle == nil then
        TriggerEvent('dnz_donator:notify', 'Donator System', 'Du musst ein Auto auswählen..')
        return
    end
        ESX.TriggerServerCallback('dnz_donator:createfahrzeugcode', function(code)
            local htmlcode = "Deine Codes:"
            for i,k in pairs(code) do

                htmlcode = htmlcode .. "\n" .. k.code
            end
                SendNUIMessage({
                    type = "setgeneratedcode",
                    code = htmlcode,
                })
        end, data.vehicle, data.codeanzahl)
end)


RegisterNUICallback("getmycodes", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:getmycodes', function(items)
        used = 0
            for i,k in pairs(items) do

                used = used + 1
                if k.type == 'item' then
                    SendNUIMessage({
                        type = "setmycodes",
                        code = k.code,
                        item = string.upper(k.item) .. ' | x'  ..  k.amount
                    })
                elseif k.type == 'money' then
                    SendNUIMessage({
                        type = "setmycodes",
                        code = k.code,
                        item = string.upper(k.item) .. ' | $'  ..  k.amount
                    })
                elseif k.type == 'vehicle' then
                    SendNUIMessage({
                        type = "setmycodes",
                        code = k.code,
                        item = string.upper(k.item) .. ' | Hash: '  ..  k.amount
                    })
                end
            end
    end)
end)


RegisterNUICallback("getcodes", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:getcodes', function(items)
        used = 0
        unused = 0
            for i,k in pairs(items) do

                if k.used == 0 then
                    unused = unused + 1
                    SendNUIMessage({
                        type = "setunusedcodes",
                        toplinie = string.upper(k.type) .. ' | Generiert von: ' .. k.createdbyname,
                        code = k.code,
                        item = string.upper(k.item),
                        anzahl = k.amount,
                        totalcodes = unused,
                        id = k.id
                    })
                else
                    used = used + 1
                    SendNUIMessage({
                        type = "setusedcodes",
                        toplinie = string.upper(k.type) .. ' | Eingelöst von: ' .. k.usedbyname .. ' | Identifier: ' .. k.usedby,
                        code = k.code,
                        item = string.upper(k.item),
                        anzahl = k.amount,
                        identifier = k.usedby,
                        totalcodes = used,
                        id = k.id
                    })
                end
            end
    end)
end)

RegisterNUICallback("getitems", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:getitems', function(items)
            for i,k in pairs(items) do
                SendNUIMessage({
                    type = "setitems",
                    label = k.label,
                    name = k.name
                })
            end
            for i,k in pairs(Config.Fahrzeuge) do
  
                SendNUIMessage({
                    type = "setfahrzeuge",
                    label = i,
                    name = json.encode(k)
                })
            end
    end)
end)

RegisterNUICallback("createitemcode", function(data, cb)
    amount = tonumber(data.amount)
    if data.amount then
    else
        return
    end
    if data.amount == nil or amount < 1 or data.item == nil then
        TriggerEvent('dnz_donator:notify', 'Donator System', 'Item oder Anzahl falsch..')
        return
    end
    ESX.TriggerServerCallback('dnz_donator:createitemcode', function(code)
        local htmlcode = "Deine Codes:"
        for i,k in pairs(code) do

            htmlcode = htmlcode .. "\n" .. k.code
        end
            SendNUIMessage({
                type = "setgeneratedcode",
                code = htmlcode,
            })
    end, data.amount, data.item, data.codeanzahl)
end)


RegisterNUICallback("redeemcodes", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:redeemcodes', function(xInfo)
    end, data.code)
end)

RegisterNUICallback("notify", function(data, cb)
    TriggerEvent('dnz_donator:notify', data.title, data.message)
end)

RegisterNUICallback("delcode", function(data, cb)
    ESX.TriggerServerCallback('dnz_donator:delcode', function(xInfo)
            SendNUIMessage({
                type = "clearcodess",
            })
    end, data.id)
end)

RegisterCommand("premium", function(source, args)
    ESX.TriggerServerCallback('dnz_donator:isPremium', function(xInfo, time)
        if xInfo then
            TriggerEvent('dnz_donator:notify', 'Premium', "Dein Premium Status ist aktiv <br> " .. time) 
        else
            TriggerEvent('dnz_donator:notify', 'Premium', "Dein Premium Status ist nicht aktiv")
        end
    end)
end)

RegisterCommand("dono", function(source, args)
    SetDisplay(true)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
    if display == true then
        StartScreenEffect(blur, 1, true)
    else
        Citizen.Wait(250)
        StopScreenEffect(blur)
    end
end

RegisterNetEvent('dnz_donator:notify')
AddEventHandler('dnz_donator:notify', function(title, message)
    SendNUIMessage({
        type = "notify",
        title = title,
        message = message,
        time = 3000
    })
end)
