
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--
-- SET UP HERE WHETHER YOU USE THE NEWER ESX VERSION WITH LICENSE IDENTIFIERS
-- Set this to true, when you use ESX 1.2 or higher
local useNewESX = false

-- Kleiderschrank
ESX.RegisterServerCallback('clothes:requestData', function(source, cb)
    if source ~= nil then

        local clothesData = {}

		local steamID
        local playerIdentifiers = GetPlayerIdentifiersSorted(source)
        if useNewESX then
            steamID = string.gsub(playerIdentifiers["license"], "license:", "")
        else
            steamID = playerIdentifiers["steam"]
        end

        MySQL.Async.fetchAll('SELECT * from user_clothes WHERE identifier = @identifier', {
            ['@identifier'] = steamID
        },
            function(result)
                if #result > 0 then
                    for k, v in pairs(result) do
                        table.insert(clothesData, {
                            id = result[k].id,
                            identifier = result[k].identifier,
                            name = result[k].name,
                            clothesData = json.decode(result[k].clothesData),
                        })

                    end

                    cb(clothesData)
    
                end
            end
        )
    end

end)

RegisterServerEvent('clothes:saveOutfit')
AddEventHandler('clothes:saveOutfit', function(label, skinRes)

    if source ~= nil then
		if label and skinRes ~= nil then
		
			local steamID
            local playerIdentifiers = GetPlayerIdentifiersSorted(source)
			if useNewESX then
				steamID = string.gsub(playerIdentifiers["license"], "license:", "")
			else
				steamID = playerIdentifiers["steam"]
			end

			MySQL.Async.execute(
				'INSERT INTO user_clothes (identifier, name, clothesData) VALUES (@identifier, @name, @clothesData)', {
				  ['@identifier'] = steamID,
				  ['@name'] = label,
				  ['@clothesData'] = json.encode(skinRes),
			  }
			)
		end
    end

end)

-- Return an array with all identifiers
function GetPlayerIdentifiersSorted(playerServerId)
    local ids = {}
    local identifiers = GetPlayerIdentifiers(playerServerId)
    
    for k, identifier in pairs (identifiers) do
        local i, j = string.find(identifier, ":")
        local idType = string.sub(identifier, 1, i-1)
        
        ids[idType] = identifier
    end
    
    return ids
end

RegisterServerEvent('clothes:removeOutfit')
AddEventHandler('clothes:removeOutfit', function(id)

    MySQL.Async.execute(
        'DELETE FROM user_clothes WHERE id = @id', {
          ['@id'] = id,
      }
    )

end)
