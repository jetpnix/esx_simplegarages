---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil

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

-- GET GARAGES
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local playerPed = GetPlayerPed(-1)
        local playerPosition = GetEntityCoords(playerPed)

        for k, v in pairs (Config.Garages) do 

            if GetDistanceBetweenCoords(playerPosition, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z) <= 15 then
                DrawMarker(2, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 222, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(playerPosition, v.getVehicle.x, v.getVehicle.y, v.getVehicle.z) <= 1.5 then
                    if not IsPedInAnyVehicle(playerPed) then
                        DrawText3D(v.getVehicle.x, v.getVehicle.y, v.getVehicle.z + 0.25, '~g~E~w~ - Open garage')
                        if IsControlJustReleased(0, 38) then
                            openGarageMenu(k)
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
                            print(k)
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
    ESX.TriggerServerCallback("fx-garage:server:GetUserVehicles", function(myCars)
    --local elements = {
                for k, v in pairs(myCars) do
                    print(v.vehicle[model])
                    local aheadVehName = GetDisplayNameFromVehicleModel(v.vehicle.model)
				    local vehicleName = GetLabelText(aheadVehName)
                    --{label = 'dzsd', value = 'citizen_wear'},
                    
                end
    --}
    end, garage)
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