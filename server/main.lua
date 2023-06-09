local ESX = nil

ESX = exports["es_extended"]:getSharedObject()

-- Events
RegisterServerEvent('family_system:server:setPlayerBucket')
AddEventHandler('family_system:server:setPlayerBucket', function(bucket, x, y, z)
    SetEntityCoords(GetPlayerPed(source), vector3(x, y, z + 1.0))
    playerBucket = SetPlayerRoutingBucket(source, bucket)
end)

RegisterServerEvent('family_system:server:setPlayerOutBucket')
AddEventHandler('family_system:server:setPlayerBucket', function()
    SetPlayerRoutingBucket(source, 0)
end)

-- Callbacks
ESX.RegisterServerCallback('family_system:getAllFamilyData', function(source, cb)
    MySQL.query('SELECT * FROM family_data', function(result)
        if result then
            cb(result)
        end
    end)
end)

-- Commands