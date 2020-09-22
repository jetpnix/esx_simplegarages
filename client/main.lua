---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil
local currentGarage = {}

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = sourcePlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- GET GARAGES / PUBLIC
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local playerPed = GetPlayerPed(-1)
        local playerPosition = GetEntityCoords(playerPed)

        for k, v in pairs (Config.Garages) do 

            -- STORAGE
            if GetDistanceBetweenCoords(playerPosition, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z) <= 15 then
                DrawMarker(2, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 222, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(playerPosition, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z) <= 1.5 then
                    if not IsPedInAnyVehicle(playerPed) then
                        DrawText3D(v.getVehicle.x, v.getVehicle.y, v.getVehicle.z + 0.25, '~g~E~w~ - Open garage')
                        if IsControlJustReleased(0, 38) then
                            openGarageMenu(k)
                            currentGarage = v
                        end
                    end
                elseif GetDistanceBetweenCoords(playerPosition, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z) <= 5 then
                    DrawText3D(v.getVehicle.x, v.getVehicle.y, v.getVehicle.z + 0.25, v.garageName)
                end
            end

            if IsPedInAnyVehicle(playerPed) then
                if GetDistanceBetweenCoords(playerPosition, v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z) <= 15 then
                    DrawMarker(2, v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(playerPosition, v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z) <= 2.5 then
                        DrawText3D(v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z + 0.25, '~g~E~w~ - Store Vehicle')
                        if IsControlJustReleased(0, 38) then
                            storeVehicle()
                            currentGarage = v
                        end
                    elseif GetDistanceBetweenCoords(playerPosition, v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z) <= 5 then
                        DrawText3D(v.storeVehicle.x, v.storeVehicle.y, v.storeVehicle.z + 0.25, 'Parking spot')
                    end
                end
            end
        end
    end
end)

openGarageMenu = function(garage)
    local elements = {}

    ESX.TriggerServerCallback("esx_simplegarages:callback:GetUserVehicles", function(myCars)
        for k, v in pairs(myCars) do
            local aheadVehName = GetDisplayNameFromVehicleModel(v.vehicle.model)
            local vehicleName = GetLabelText(aheadVehName)
            local labelvehicle
            local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - '):format(v.plate, vehicleName)
            local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | '):format(v.plate, vehicleName)
            if v.stored then
                labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format('In garage')
            else
                labelvehicle = labelvehicle2 .. ('<span style="color:red;">%s</span> |'):format('Impound')
            end

            table.insert(elements, {label = labelvehicle, value = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
			title = garage,
			align = right,
			elements = elements
		}, function(data, menu)
			if data.current.value == nil then
			else
				if data.current.value.stored then
                    menu.close()
					spawnVehicle(data.current.value.vehicle, data.current.value.plate, data.current.value.fuel)
				else
					ESX.ShowNotification('je moeder')
				end
			end
		end, function(data, menu)
			menu.close()
		end)
    end, garage)
end

spawnVehicle = function(vehicle, plate, fuel)
    ESX.Game.SpawnVehicle(vehicle.model, currentGarage.spawnPoint.coords, currentGarage.spawnPoint.heading, function(veh)
		ESX.Game.SetVehicleProperties(veh, vehicle)
        SetEntityAsMissionEntity(veh, true, true)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, fuel)
        SetVehicleEngineOn(veh, true, true)
    end)
    
    TriggerServerEvent('esx_simplegarages:server:updateCarStoredState', plate, true)
end

storeVehicle = function()
    local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local plate = GetVehicleNumberPlateText(currentVehicle)
    local currentFuel = exports['LegacyFuel']:GetFuel(currentVehicle)

    TriggerServerEvent('esx_simplegarages:server:updateCarStoredState', plate, false)
    --TriggerServerEvent('esx_simplegarages:server:updateCarGarageLocation', plate, currentGarage)
    --TriggerServerEvent('esx_simplegarages:server:updateCarState', plate, currentFuel)

    ESX.Game.DeleteVehicle(currentVehicle)
    ESX.ShowNotification("You're vehicle is now stored in " .. currentGarage.garageName)

end

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- CREATE BLIPS
Citizen.CreateThread(function()
    for k, v in pairs(Config.Garages) do
        Garage = AddBlipForCoord(v.getVehicle.x, v.getVehicle.y, v.getVehicle.z)

        SetBlipSprite (Garage, 357)
        SetBlipDisplay(Garage, 4)
        SetBlipScale  (Garage, 0.65)
        SetBlipAsShortRange(Garage, true)
        SetBlipColour(Garage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.garageName)
        EndTextCommandSetBlipName(Garage)
    end

    for k, v in pairs(Config.Impounds) do
        Depot = AddBlipForCoord(v.getVehicle.x, v.getVehicle.y, v.getVehicle.z)

        SetBlipSprite (Depot, 68)
        SetBlipDisplay(Depot, 4)
        SetBlipScale  (Depot, 0.7)
        SetBlipAsShortRange(Depot, true)
        SetBlipColour(Depot, 5)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.garageName)
        EndTextCommandSetBlipName(Depot)
    end
end)