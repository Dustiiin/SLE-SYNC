ESX = nil
local adinprogress = false
local serveritems = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function UCPLOG(title, message, color,identifier)
	local connect = {
		{
		  	["color"] = color,
		  	["title"] = "**".. title .."**\n",
			["description"] = message,
			["footer"] = {
				["text"] = "Identifier: " .. identifier,
			},
		  }
	  }
	PerformHttpRequest("https://discord.com/api/webhooks/854482909524000778/EQ5o15A5OyWjxnC-kOqal9fimsz9zN-r6efMWb5N5FlzpqNFOg8QklTbijEgmQy7Fdqj", function(err, text, headers) end, 'POST', json.encode({username = "Velocity | Logs", embeds = connect, avatar_url = "https://cdn.discordapp.com/attachments/666068454284984350/867070033988419614/V_Logo_Static.png"}), { ['Content-Type'] = 'application/json' })
end

UCPLOG(':eyes: dnz_donator', "Das Plugin wurde erfolgreich gestartet", 65535, "Server")

MySQL.ready(function ()
    serveritems = MySQL.Sync.fetchAll('SELECT * from items', {})
end)

ESX.RegisterServerCallback('dnz_donator:getitems', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    cb(serveritems)
end)

ESX.RegisterServerCallback('dnz_donator:getcodes', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
        globalcodes = MySQL.Sync.fetchAll('SELECT * from dnz_donator_codes ORDER BY id DESC', {})
        cb(globalcodes)
    else
        return
    end
end)

ESX.RegisterServerCallback('dnz_donator:getmycodes', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    globalcodes = MySQL.Sync.fetchAll('SELECT * from dnz_donator_codes WHERE usedby = @usedby', {['@usedby'] = xPlayer.identifier})
    cb(globalcodes)
end)


ESX.RegisterServerCallback('dnz_donator:getinitiate', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local darfer = isAuthorized(xPlayer.getGroup())
    cb(darfer)
end)


function isAuthorized(admin)
    for k,xx in pairs(Config.AuthorizedAdmins) do
        if xx == admin then
            return true
        end
    end
    return false
end

ESX.RegisterServerCallback('dnz_donator:getactivecodes', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
        MySQL.Async.fetchAll("SELECT * FROM dnz_donator_codes WHERE used = '0' ORDER by id DESC", {}, function(result)
            cb(result)
        end)
    else
        return
    end
end)

ESX.RegisterServerCallback('dnz_donator:delcode', function(src, cb, id)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
        MySQL.Async.fetchAll("DELETE FROM dnz_donator_codes WHERE id = @id", {["@id"] = id}, function(result)
            UCPLOG(':eyes: Spion', "Der Admin **" .. xPlayer.getName() .. '** hat den Code mit der ID: **' .. id .. '** gelöscht', 65535, xPlayer.identifier)
            cb(result)
        end)
    else
        return
    end
end)



ESX.RegisterServerCallback('dnz_donator:createpremiumkey', function(src, cb, amount, type)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
    codesgenerated = {}
        for i = 1, 1 do
                local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local numbers = "0123456789"
                local characterSet = upperCase .. numbers
                local keyLength = 25
                local output = ""
                for	i = 1, keyLength do
                    local rand = math.random(#characterSet)
                    output = output .. string.sub(characterSet, rand, rand)
                end

                MySQL.Async.fetchAll("INSERT INTO dnz_donator_codes (createdby, type, item, amount, code, used, usedby, createdbyname, usedbyname) VALUES (@createdby, @type, @item, @amount, @code, @used, @usedby, @createdbyname, @usedbyname)",
                {
                    ["@createdby"] = xPlayer.identifier, 
                    ["@createdbyname"] = xPlayer.getName(), 
                    ["@type"] = 'premium', 
                    ["@item"] = 'premium',
                    ["@amount"] = '0',
                    ["@code"] = output,
                    ["@used"] = '0',
                    ["@usedby"] = '0',
                    ["@usedbyname"] = 'none'
                }, function (result)
                    table.insert(codesgenerated, {code = output})
                    cb(codesgenerated)
                    UCPLOG(':key: Key erstellung', "Der Admin **" .. xPlayer.getName() .. '** hat einen Key erstellt.\n**Typ:** Premium\n**Anzahl:** 1\n **Code:** ' .. output, 65535, xPlayer.identifier)
            end)
        end
    else
        return
    end
end)


ESX.RegisterServerCallback('dnz_donator:createmoneycode', function(src, cb, amount, codes, type)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
    codesgenerated = {}
        for i = 1, codes do
                local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local numbers = "0123456789"
                local characterSet = upperCase .. numbers
                local keyLength = 25
                local output = ""
                for	i = 1, keyLength do
                    local rand = math.random(#characterSet)
                    output = output .. string.sub(characterSet, rand, rand)
                end

                MySQL.Async.fetchAll("INSERT INTO dnz_donator_codes (createdby, type, item, amount, code, used, usedby, createdbyname, usedbyname) VALUES (@createdby, @type, @item, @amount, @code, @used, @usedby, @createdbyname, @usedbyname)",
                {
                    ["@createdby"] = xPlayer.identifier, 
                    ["@createdbyname"] = xPlayer.getName(), 
                    ["@type"] = 'money', 
                    ["@item"] = type,
                    ["@amount"] = amount,
                    ["@code"] = output,
                    ["@used"] = '0',
                    ["@usedby"] = '0',
                    ["@usedbyname"] = 'none'
                }, function (result)
                    table.insert(codesgenerated, {code = output})
                    UCPLOG(':key: Key erstellung', "Der Admin **" .. xPlayer.getName() .. '** hat einen Key erstellt.\n**Typ:** Geld\n**Anzahl:** '  .. amount .. '\n **Code:** ' .. output, 65535, xPlayer.identifier)
            end)
        end
        Citizen.Wait(3000)
        print("Es wurden " .. codes .. ' Codes erstellt')
       cb(codesgenerated)
    else
        return
    end
end)

ESX.RegisterServerCallback('dnz_donator:createitemcode', function(src, cb, amount, item, codes)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
        codesgenerated = {}
        for i = 1, codes do
            local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            local numbers = "0123456789"
            local characterSet = upperCase .. numbers
            local keyLength = 25
            local output = ""
            for	i = 1, keyLength do
                local rand = math.random(#characterSet)
                output = output .. string.sub(characterSet, rand, rand)
            end
                MySQL.Async.fetchAll("INSERT INTO dnz_donator_codes (createdby, type, item, amount, code, used, usedby, createdbyname, usedbyname) VALUES (@createdby, @type, @item, @amount, @code, @used, @usedby, @createdbyname, @usedbyname)",
                    {
                        ["@createdby"] = xPlayer.identifier, 
                        ["@createdbyname"] = xPlayer.getName(), 
                        ["@type"] = 'item', 
                        ["@item"] = item,
                        ["@amount"] = amount,
                        ["@code"] = output,
                        ["@used"] = '0',
                        ["@usedby"] = '0',
                        ["@usedbyname"] = 'none'
                    }, function (result)
                        table.insert(codesgenerated, {code = output})
                        UCPLOG(':key: Key erstellung', "Der Admin **" .. xPlayer.getName() .. '** hat einen Key erstellt.\n**Typ:** Item\n**Anzahl:** '  .. item ..' x ' .. amount .. '\n **Code:** ' .. output, 65535, xPlayer.identifier)
                end)
            end
            
            Citizen.Wait(3000)
            print("Es wurden " .. codes .. ' Codes erstellt')
            cb(codesgenerated) 
            
    else
        return
    end
end)



ESX.RegisterServerCallback('dnz_donator:redeemcodes', function(src, cb, code)
    local xPlayer = ESX.GetPlayerFromId(src)
    if string.find(code, 'INSERT') or string.find(code, 'DROP') or string.find(code, 'UPDATE') or string.find(code, 'DELETE') then
        return
    end
    MySQL.Async.fetchAll('SELECT * FROM dnz_donator_codes WHERE code = @code AND used = 0', {['@code'] = code}, function(result)
        if json.encode(result) == "[]" then
            TriggerClientEvent('dnz_donator:notify',src,'Fehler..', 'Der Code wurde bereits verwendet oder ist Invalid')
            return
        else
            if result[1].type == 'money' and result[1].used == 0 then
                realstuff = "Geld"
                if result[1].item == 'cash' then
                    --give cash
                    realstuff = "Bargeld"
                    xPlayer.addMoney(result[1].amount)
                elseif result[1].item == 'schwarzgeld' then
                    --give schwarzgeld
                    realstuff = "Schwarzgeld"
                    xPlayer.addAccountMoney('black_money', result[1].amount)
                elseif result[1].item == 'bank' then
                    --give bank
                    realstuff = "Bank Geld"
                    xPlayer.addAccountMoney('bank', result[1].amount)
                end
                MySQL.Sync.execute("UPDATE dnz_donator_codes SET used = @used, usedby = @usedby, usedbyname = @usedbyname WHERE code = @code", {
                    ['@code'] = code,
                    ['@used'] = 1,
                    ['@usedby'] = xPlayer.identifier,
                    ['@usedbyname'] = xPlayer.getName()
                })
                UCPLOG(':key: Key Redeem', "Der Spieler **" .. xPlayer.getName() .. '** hat einen Key eingelöst.\n**Typ:** Geld\n**Anzahl:** '  .. result[1].amount .. '\n **Code:** ' .. code, 65535, xPlayer.identifier)
                TriggerClientEvent('dnz_donator:notify',src,'Herzlichen Glückwunsch', 'Wir haben folgendes auf deinem Account eingelöst: ' .. realstuff .. ' | Wert: $' ..result[1].amount)
            elseif result[1].type == 'vehicle' and result[1].used == 0 then
                local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                
                local characterSet = upperCase
                
                local keyLength = 3
                local output = ""
                
                for	i = 1, keyLength do
                    local rand = math.random(#characterSet)
                    output = output .. string.sub(characterSet, rand, rand)
                end
                plate = output .. " " .. math.random(0,999)
                local tbl = {model = tonumber(result[1].item), plate = plate}
                MySQL.Async.fetchAll("INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, @stored)",
                    {
                        ["@owner"] = xPlayer.identifier, 
                        ["@plate"] = output .. " " .. math.random(0,999), 
                        ["@vehicle"] = json.encode(tbl),
                        ["@type"] = 'car',
                        ["@stored"] = '1'
                    }, function (result)
                        MySQL.Sync.execute("UPDATE dnz_donator_codes SET used = @used, usedby = @usedby WHERE code = @code", {
                            ['@code'] = code,
                            ['@used'] = 1,
                            ['@usedby'] = xPlayer.identifier,
                            ['@usedbyname'] = xPlayer.getName()
                        })
                        --UCPLOG(':key: Key Redeem', "Der Spieler **" .. xPlayer.getName() .. '** hat einen Key eingelöst.\n**Typ:** Fahrzeug\n**HASH:** '  .. result[1].item .. '\n **Code:** ' .. code, 65535, xPlayer.identifier)
                        TriggerClientEvent('dnz_donator:notify',src, 'Herzlichen Glückwunsch' ,'Du hast ein Fahrzeug erhalten')
                end)
            elseif result[1].type == 'item' and result[1].used == 0 then
                xPlayer.addInventoryItem(result[1].item, result[1].amount)
                MySQL.Sync.execute("UPDATE dnz_donator_codes SET used = @used, usedby = @usedby WHERE code = @code", {
                    ['@code'] = code,
                    ['@used'] = 1,
                    ['@usedby'] = xPlayer.identifier,
                    ['@usedbyname'] = xPlayer.getName()
                })
                UCPLOG(':key: Key Redeem', "Der Spieler **" .. xPlayer.getName() .. '** hat einen Key eingelöst.\n**Typ:** Item\n**Anzahl:** '  .. result[1].item .. ' x ' .. result[1].amount.. '\n **Code:** ' .. code, 65535, xPlayer.identifier)
                TriggerClientEvent('dnz_donator:notify', src,'Herzlichen Glückwunsch',  'Item: ' .. xPlayer.getInventoryItem(result[1].item).label .. ' | Anzahl: ' .. result[1].amount, '#2C3530')
            elseif result[1].type == 'premium' and result[1].used == 0 then
                MySQL.Async.fetchAll("SELECT dnzpremium FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = xPlayer.identifier, 
                }, function (result)
                    if (tonumber(result[1].dnzpremium) > os.time()) then
                        TriggerClientEvent('dnz_donator:notify',src,'Fehler..', 'Dein Premium Account ist noch aktiv!')
                        return
                        cb(false)
                    else
                        MySQL.Sync.execute("UPDATE dnz_donator_codes SET used = @used, usedby = @usedby WHERE code = @code", {
                            ['@code'] = code,
                            ['@used'] = 1,
                            ['@usedby'] = xPlayer.identifier,
                            ['@usedbyname'] = xPlayer.getName()
                        })
                        MySQL.Sync.execute("UPDATE users SET dnzpremium = @usetime WHERE identifier = @identifier", {
                            ['@identifier'] = xPlayer.identifier,
                            ['@usetime'] = os.time()+2592000
                        })
                        UCPLOG(':key: Key Redeem', "Der Spieler **" .. xPlayer.getName() .. '** hat einen Premium Key eingelöst.\n **Code:** ' .. code, 65535, xPlayer.identifier)
                        TriggerClientEvent('dnz_donator:notify', src, 'Herzlichen Glückwunsch', 'Du hast den Premium Status für 30 Tage freigeschalten!')
                    end
            end)

            else
                print("Something wrong happend on dnz_donator..... ERROR 11002 - Report to dnz")
            end
        end
    end)
end)

local function SecondsToClock(seconds)
    local days = math.floor(seconds / 86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds / 3600 )
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds / 60) 
    seconds = seconds - minutes * 60
    
    return string.format("%d Tage, %d Stunden, %d Minuten, %d Sekunden.",days,hours,minutes,seconds)
  end

ESX.RegisterServerCallback('dnz_donator:isPremium', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT dnzpremium FROM users WHERE identifier = @identifier",
    {
        ["@identifier"] = xPlayer.identifier, 
    }, function (result)
        if (tonumber(result[1].dnzpremium) > os.time()) then
            cb(true, SecondsToClock(tonumber(result[1].dnzpremium) - os.time()))
        else
            cb(false)
        end
end)
end)


ESX.RegisterServerCallback('dnz_donator:createfahrzeugcode', function(src, cb, vehicle, codes)
    local xPlayer = ESX.GetPlayerFromId(src)
    if isAuthorized(xPlayer.getGroup()) then
        codesgenerated = {}
        for i = 1, codes do
                local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                local numbers = "0123456789"
                local characterSet = upperCase .. numbers
                

                local keyLength = 25
                local output = ""
            
            for	i = 1, keyLength do
                local rand = math.random(#characterSet)
                output = output .. string.sub(characterSet, rand, rand)
            end
            MySQL.Async.fetchAll("INSERT INTO dnz_donator_codes (createdby, type, item, amount, code, used, usedby, createdbyname, usedbyname) VALUES (@createdby, @type, @item, @amount, @code, @used, @usedby, @createdbyname, @usedbyname)",
                {
                    ["@createdby"] = xPlayer.identifier, 
                    ["@createdbyname"] = xPlayer.getName(), 
                    ["@type"] = 'vehicle', 
                    ["@item"] = vehicle,
                    ["@amount"] = '0',
                    ["@code"] = output,
                    ["@used"] = '0',
                    ["@usedby"] = '0',
                    ["@usedbyname"] = 'none'
                }, function (result)
                    table.insert(codesgenerated, {code = output})
                    UCPLOG(':key: Key erstellung', "Der Admin **" .. xPlayer.getName() .. '** hat einen Key erstellt.\n**Typ:** Fahrzeug\n**HASH:** ' .. vehicle .. '\n **Code:** ' .. output, 65535, xPlayer.identifier)
            end)
        end
        Citizen.Wait(3000)
        print("Es wurden " .. codes .. ' Codes erstellt')
        cb(codesgenerated) 
    else
        return
    end
end)

