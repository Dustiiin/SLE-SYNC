QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local _menuPool = NativeUI.CreatePool()
local mainMenu = nil
local currentClothesshop

local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0

local isNearShop = false
local isInShop = false
local isPedLoaded = false
local npc = nil
local hasBought = false
local wasInMenu = false

local isNearWardrobe = false
local isAtWardrobe = false
local currentWardrobe

local eventTriggered = false

local LastSkin = nil
local torsoData = {}


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- TriggerServerEvent("qb-clothes:loadPlayerSkin")
    PlayerData = QBCore.Functions.GetPlayerData()
	PlayerLoaded = true
	refreshBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
	refreshBlips()
end)

local ped = Config.NormalShopPed

Citizen.CreateThread(function()

	refreshBlips()

	while true do
		Citizen.Wait(300)

		local playerPed = PlayerPedId()
        local playerloc = GetEntityCoords(playerPed, 0)

		isNearShop = false
		isInShop = false

		isNearWardrobe = false
		isAtWardrobe = false

		for k, loc in pairs(Config.Wardrobes) do
			local distance = Vdist(playerloc, loc.x, loc.y, loc.z)

			if distance < 1.75 then

				isAtWardrobe = true
				isNearWardrobe = true

			elseif distance < 15.0 then

				currentWardrobe = loc
				isNearWardrobe = true

			end

		end

		for k, loc in pairs(Config.Shops) do
			local distance = Vdist(playerloc, loc.x, loc.y, loc.z)

			if distance < 30 then
				isNearShop = true
                if not isPedLoaded then

                    ped = loc.ped
					RequestModel(GetHashKey(ped))
					while not HasModelLoaded(GetHashKey(ped)) do
						Wait(1)
					end
					npc = CreatePed(4, GetHashKey(ped), loc.x, loc.y, loc.z - 1.0, loc.rot, false, true)
					FreezeEntityPosition(npc, true)
					SetEntityHeading(npc, loc.rot)
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)
					isPedLoaded = true
					QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
						LastSkin = data
					end, QBCore.Functions.GetPlayerData().citizenid)
				end
			end

			if distance < 2.0 then
				if loc.requiredJob == nil then
					isInShop = true
					currentClothesshop = loc
				elseif PlayerData ~= nil and PlayerData.job ~= nil and (PlayerData.job.name == loc.requiredJob) then
					isInShop = true
					currentClothesshop = loc
				end
			end

		end

		if (isPedLoaded and not isNearShop) then
            DeleteEntity(npc)
			SetModelAsNoLongerNeeded(GetHashKey(ped))
			isPedLoaded = false
		end

		if (wasInMenu and not isInShop) then
			if not hasBought then
				TriggerServerEvent("qb-clothes:loadPlayerSkin")
			end
			wasInMenu = false
		end

		if cam ~= nil and not _menuPool:IsAnyMenuOpen() then
			DeleteSkinCam()
		end


	end

end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)

		if isInShop then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['press_e_interact'])
			if IsControlJustReleased(1, 38) then
				hasBought = false
                wasInMenu = true
                generateClothesMenu(Config.shopContent[currentClothesshop.type])
			end
		end

		if isNearWardrobe and currentWardrobe ~= nil then
			DrawMarker(27, currentWardrobe.x, currentWardrobe.y, currentWardrobe.z- 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.0, 1.0*1.0, 55.0, 255.0, 255.0, 0, 50, false, false, 2, false, false, false, false)
		end

		if isAtWardrobe then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['press_e_wardrobe'])
			if IsControlJustReleased(0, 38) then
				generateWardrobeMenu()
			end
		end

		if eventTriggered then
			_menuPool:ProcessMenus()
		end

		if _menuPool:IsAnyMenuOpen() and not isAtWardrobe and not isInShop and not eventTriggered then
			_menuPool:CloseAllMenus()
		end

		if isCameraActive then
			if IsControlJustReleased(1, 202) then
				DeleteSkinCam()
			end
        end

        if mainMenu ~= nil and mainMenu:Visible() then
            if IsControlJustReleased(1, 191) then
                mainMenu:Visible(false)
                DeleteSkinCam()
                generateConfirmMenu()
            end
        end

	end

end)

local shopBlips = {}

function refreshBlips()
	if shopBlips ~= nil and #shopBlips > 0 then
		for k, v in pairs(shopBlips) do
			RemoveBlip(v)
		end
	end

	for k, v in pairs(Config.Shops) do
		if v.requiredJob == nil or (PlayerData ~= nil and PlayerData.job ~= nil and (PlayerData.job.name == v.requiredJob)) then
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			local blipInfo = Config.Blips[v.type] or Config.Blips['DEFAULT']

			SetBlipSprite (blip, blipInfo.sprite)
			SetBlipDisplay(blip, blipInfo.display)
			SetBlipScale  (blip, blipInfo.scale)
			SetBlipColour (blip, blipInfo.colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(blipInfo.blipText)
			EndTextCommandSetBlipName(blip)
			table.insert(shopBlips, blip)
		end
	end
end

local wardrobeMenu = nil

function generateWardrobeMenu()
	if wardrobeMenu ~= nil and wardrobeMenu:Visible() then
		wardrobeMenu:Visible(false)
	end
	selectedIndex = 1
	local wardrobeMenu = NativeUI.CreateMenu(Translation[Config.Locale]['wardrobe'], nil)
	_menuPool:Add(wardrobeMenu)

	QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(dressing)
		for i=1, #dressing, 1 do
			local dress = _menuPool:AddSubMenu(wardrobeMenu, dressing[i].outfitname)
			local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
			local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')
			dress.SubMenu:AddItem(takeOn)
			dress.SubMenu:AddItem(remove)

			wardrobeMenu.OnIndexChange = function(sender, index)
				selectedIndex = index
			end

			dress.SubMenu.OnItemSelect = function(sender, item, index)
				if item == takeOn then
					print(selectedIndex)
						dressing[selectedIndex].outfitData = dressing[selectedIndex].skin
						TriggerEvent('qb-clothing:client:loadOutfit',dressing[selectedIndex])

						TriggerEvent("qb-clothes:client:saveskin")
						Wait(100)
						QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
							LastSkin = data
						end, QBCore.Functions.GetPlayerData().citizenid)

						hasBought = true
				elseif item == remove then
					TriggerServerEvent('qb-clothing:server:removeOutfit', dressing[selectedIndex].outfitName, dressing[selectedIndex].outfitId)
					-- TriggerServerEvent('clothes:removeOutfit', dressing[selectedIndex].outfitId)
					ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex].outfitName .. Translation[Config.Locale]['outfit_removed2'])
					_menuPool:CloseAllMenus()
				end
			end
			_menuPool:RefreshIndex()
			_menuPool:MouseEdgeEnabled (false)
		end
	end)

	wardrobeMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

RegisterNetEvent('myClothesshop:openWardrobe')
AddEventHandler('myClothesshop:openWardrobe', function()

	eventTriggered = true
	generateWardrobeMenu()


end)

local confirmMenu = nil

function generateConfirmMenu()

	if confirmMenu ~= nil and confirmMenu:Visible() then
		confirmMenu:Visible(false)
	end

    confirmMenu = NativeUI.CreateMenu(Translation[Config.Locale]['menu_buy_clothes'], nil)
    _menuPool:Add(confirmMenu)
    local buy = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], '~b~')
    buy:RightLabel('~g~' .. currentClothesshop.price .. '.00$')
    local abort = NativeUI.CreateItem(Translation[Config.Locale]['menu_abort'], '~b~')
    abort:SetRightBadge(BadgeStyle.Alert)

    confirmMenu:AddItem(buy)
    confirmMenu:AddItem(abort)

    confirmMenu.OnItemSelect = function(sender, item, index)

        if item == buy then
            TriggerServerEvent('myClothesshop:buy', currentClothesshop.price)
        elseif item == abort then
            _menuPool:CloseAllMenus()
        end

    end

    confirmMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

local variationValues
local Component2ListItem

function generateClothesMenu(content)

	if mainMenu ~= nil and mainMenu:Visible() then
		mainMenu:Visible(false)
	end

	selectedIndex = 1

    _menuPool:Remove()
    _menuPool:RefreshIndex()
    mainMenu = NativeUI.CreateMenu(nil, nil, nil)

    if currentClothesshop.banner ~= 'default' then
        local background = Sprite.New(currentClothesshop.banner, currentClothesshop.banner, 0, 0, 431, 38)
        mainMenu:SetBannerSprite(background, true)
    else
        mainMenu = NativeUI.CreateMenu(Translation[Config.Locale]['title_haters'], nil, nil)
    end
    _menuPool:Add(mainMenu)


	local playerData = QBCore.Functions.GetPlayerData()
    if playerData.charinfo.gender == 0 then
		torsoData = Config.MaleTorsoData
    else
		torsoData = Config.FemaleTorsoData
    end

    if Config.enableSavedOutfits then
        local savedOutfits_sub = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['saved_outfits'])
        local background = Sprite.New(currentClothesshop.banner, currentClothesshop.banner, 0, 0, 431, 38)
		if currentClothesshop.banner ~= 'default' then
			savedOutfits_sub.SubMenu:SetBannerSprite(background, true)
		end
		QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(dressing)
			for i=1, #dressing, 1 do
				local dress = _menuPool:AddSubMenu(savedOutfits_sub.SubMenu, dressing[i].outfitname)
				local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
				local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')
				dress.SubMenu:AddItem(takeOn)
				dress.SubMenu:AddItem(remove)

				savedOutfits_sub.SubMenu.OnIndexChange = function(sender, index)
					selectedIndex = index
				end

				dress.SubMenu.OnItemSelect = function(sender, item, index)
					if item == takeOn then
						dressing[selectedIndex].outfitData = dressing[selectedIndex].skin
						TriggerEvent('qb-clothing:client:loadOutfit',dressing[selectedIndex])

						TriggerEvent("qb-clothes:client:saveskin")
						Wait(100)
						QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
							LastSkin = data
						end, QBCore.Functions.GetPlayerData().citizenid)

						hasBought = true
					elseif item == remove then
						TriggerServerEvent('qb-clothing:server:removeOutfit', dressing[selectedIndex].outfitname, dressing[selectedIndex].outfitId)
						ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex].outfitname .. Translation[Config.Locale]['outfit_removed2'])
						_menuPool:CloseAllMenus()
					end
				end
				_menuPool:RefreshIndex()
				_menuPool:MouseEdgeEnabled (false)
			end
		end)
    end

    local menuItems = {}
    local componentValues = {}
    for k, v in pairs(content) do
        componentValues[v.name] = {}

        local amountOfComponents
        if v.type == 1 then
            amountOfComponents = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), v.componentID)
        else
            amountOfComponents = GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), v.componentID)
        end

        if v.name == 'ears_1' or v.name == 'helmet_1' then
            table.insert(componentValues[v.name], -1)
        end

        --print('amount of comp:' .. amountOfComponents)

        for i2=0, amountOfComponents-1, 1 do
			--print(#v.blockedParts[LastSkin.sex])
            if v.blockedParts[LastSkin.sex] ~= nil and #v.blockedParts[LastSkin.sex] > 0 then
                for j2, blockedNumber in pairs(v.blockedParts[LastSkin.sex]) do
                    if i2 == blockedNumber then

                        --print(i2 .. ' is blocked')
                        break
                    elseif j2 == #v.blockedParts[LastSkin.sex] then
                        table.insert(componentValues[v.name], i2)
                        --print(i2 .. ' is free')
                    end
                end
            else
                table.insert(componentValues[v.name], i2)
            end

        end

        --print('after block: ' .. #componentValues[v.name])
        local finalIndex = LastSkin[v.name]
        for findIndexCount, findIndexData in pairs(componentValues[v.name] ) do
            if findIndexData == LastSkin[v.name] then
                finalIndex = findIndexCount
                break
            end
        end
		local newValues = {}
		for i=1, #componentValues[v.name], 1 do
			table.insert(newValues, i)
		end
        local Component1ListItem = NativeUI.CreateListItem('~o~→ ~s~' .. v.label, componentValues[v.name], finalIndex)
        mainMenu:AddItem(Component1ListItem)
        table.insert(menuItems, {
            item = Component1ListItem,
            type = 1,
            data = v})


        if v.name2 ~= nil then
            variationValues = {}
            local amountOfVariations
            if v.type == 1 then
                amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v.componentID, LastSkin[v.name])
            else
                amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v.componentID, LastSkin[v.name])
            end
			-- -1 here?
            for i2=0, amountOfVariations, 1 do
                table.insert(variationValues, i2)
            end
            --print(amountOfVariations)
            Component2ListItem = NativeUI.CreateListItem(Translation[Config.Locale]['change_colour'], variationValues, LastSkin[v.name2])
            mainMenu:AddItem(Component2ListItem)

            menuItems[#menuItems].parent = Component2ListItem
            table.insert(menuItems, {
                item = Component2ListItem,
                type = 2,
                data = v})

        end
        mainMenu.OnListChange = function(sender, item, index)
            local selectedIndex = index

            --local selectedIndex = index - 1

            for k2, v2 in pairs(menuItems) do

                if v2.item == item then
                    --[[if v2.data.name == 'ears_1' or v2.data.name == 'helmet_1' then
                        selectedIndex = selectedIndex - 1
                    end--]]
                    if v2.type == 1 then
                        if v2.data.name ~= "arms" then
							local data = {
								clothingType = v2.data.qb,
								type = 'texture',
								articleNumber = 0
							}
							TriggerEvent('qb-clothes:client:ChangeVariation', data)
						end

						local data = {
							clothingType = v2.data.qb,
							type = 'item',
							articleNumber = componentValues[v2.data.name][selectedIndex]
						}
						TriggerEvent('qb-clothes:client:ChangeVariation', data)
                        CreateSkinCam()
                        zoomOffset = v2.data.zoomOffset
                        camOffset = v2.data.camOffset

                        if v2.parent ~= nil then

                            variationValues = {}
                            local amountOfVariations
                            if v2.data.type == 1 then
                                amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                            else
                                amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                            end
                            for i3=0, amountOfVariations, 1 do
                                table.insert(variationValues, i3)
                            end
                            v2.parent._Index = 1
                            v2.parent.Items = variationValues
                           -- print('Variation Values updated to ' .. #variationValues)
                        end

                        if v2.data.componentID == 11 then
                            if torsoData[componentValues[v2.data.name][selectedIndex]] ~= nil then
								print("server updated")
								local data = {
									clothingType = 'arms',
									type = 'item',
									articleNumber = torsoData[componentValues[v2.data.name][selectedIndex]].arms
								}
								TriggerEvent('qb-clothes:client:ChangeVariation', data)

								local data = {
									clothingType = 't-shirt',
									type = 'texture',
									articleNumber = 0
								}
								TriggerEvent('qb-clothes:client:ChangeVariation', data)

								local data = {
									clothingType = 't-shirt',
									type = 'item',
									articleNumber = torsoData[componentValues[v2.data.name][selectedIndex]].validShirts[1]
								}
								TriggerEvent('qb-clothes:client:ChangeVariation', data)
                            end
                        end
                    elseif v2.type == 2 then
						local data = {
							clothingType = v2.data.qb,
							type = 'texture',
							articleNumber = selectedIndex-1
						}
						TriggerEvent('qb-clothes:client:ChangeVariation', data)
                    end

                    break
                end
            end

        end
    end

    mainMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

function CreateSkinCam()
	local playerPed = GetPlayerPed(-1)

	if not isCameraActive then
		if not DoesCamExist(cam) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		end
		SetCamActive(cam, true)
		RenderScriptCams(true, true, 500, true, true)
		isCameraActive = true
		SetCamRot(cam, 0.0, 0.0, 270.0, true)
		SetEntityHeading(playerPed, 90.0)
	end
end

function DeleteSkinCam()
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

RegisterNetEvent('myClothesshop:confirm')
AddEventHandler('myClothesshop:confirm', function(enoughMoney)

	_menuPool:CloseAllMenus()

	if enoughMoney then
		TriggerEvent('qb-clothes:client:saveskin')
		Wait(500)
			local citizen = QBCore.Functions.GetPlayerData().citizenid
			QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
				LastSkin = data
				local outfitname = CreateDialog('Name des Outfits eingeben')
				if tostring(outfitname) then
					ShowNotification(Translation[Config.Locale]['saved'] .. outfitname .. Translation[Config.Locale]['saved_2'])
					local ped = PlayerPedId()
					local model = GetEntityModel(ped)
					TriggerServerEvent('qb-clothes:saveOutfit', tostring(outfitname), model, LastSkin)
				end
			end, citizen)
        _menuPool:CloseAllMenus()
        hasBought = true
        ShowNotification(Translation[Config.Locale]['buy_complete'])

	else
		ShowNotification(Translation[Config.Locale]['not_enough_money'])
		TriggerServerEvent("qb-clothes:loadPlayerSkin")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive then
		DisableControlAction(2, 30, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(2, 33, true)
		DisableControlAction(2, 34, true)
		DisableControlAction(2, 35, true)

		DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 24,   true) -- Input Attack

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		local angle = heading * math.pi / 180.0
		local theta = {
			x = math.cos(angle),
			y = math.sin(angle)
		}
		local pos = {
			x = coords.x + (zoomOffset * theta.x),
			y = coords.y + (zoomOffset * theta.y),
		}

		local angleToLook = heading - 140.0
		if angleToLook > 360 then
			angleToLook = angleToLook - 360
		elseif angleToLook < 0 then
			angleToLook = angleToLook + 360
		end
		angleToLook = angleToLook * math.pi / 180.0
		local thetaToLook = {
			x = math.cos(angleToLook),
			y = math.sin(angleToLook)
		}
		local posToLook = {
			x = coords.x + (zoomOffset * thetaToLook.x),
			y = coords.y + (zoomOffset * thetaToLook.y),
		}

		SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
		PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

		--SetTextComponentFormat("STRING")
		--AddTextComponentString(_U('use_rotate_view'))
		--DisplayHelpTextFromStringLabel(0, 0, 0, -1)
		end
	end
end)

Citizen.CreateThread(function()
	local angle = 90
	while true do
		Citizen.Wait(0)
		if isCameraActive then
		if IsControlPressed(0, 108) then
			angle = angle - 1
		elseif IsControlPressed(0, 109) then
			angle = angle + 1
		end
		if angle > 360 then
			angle = angle - 360
		elseif angle < 0 then
			angle = angle + 360
		end
		heading = angle + 0.0
		end
	end
end)