---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_simplegarages:callback:GetUserVehicles", function(source, cb, garage)
    local myCars = {}
    local sourcePlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND garage = @garage AND type = @type', {['@owner'] = sourcePlayer.identifier, ['@garage'] = garage, ['@type'] = 'car'}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                vehicle = json.decode(v.vehicle)
                print(vehicle.model)
                table.insert(myCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
            end
            cb(myCars)
        else
            sourcePlayer.showNotification("You don't have any car parked in this garage...")
        end
    end)
end)

RegisterNetEvent('esx_simplegarages:server:updateCarStoredState')
AddEventHandler('esx_simplegarages:server:updateCarStoredState', function(plate, stored)
    MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate", { ['@stored'] = stored, ['@plate'] = plate })
end)