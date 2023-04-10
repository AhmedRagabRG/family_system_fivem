local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local isOwner = false

-- Functions
local function add_blip(data, v)
    isOwner = false

    local blipColor = 46
    local playerIdentifier = ESX.PlayerData.identifier

    local fData = {
        options = json.decode(v.options),
        locations = json.decode(v.locations),
        users = json.decode(v.users),
    }

    for k,v in pairs(fData.users) do
        if v.identifier == playerIdentifier then 
            blipColor = 2 
            isOwner = true
        end
    end

    if playerIdentifier == v.owner_id then 
        blipColor = 2 
        isOwner = true
    end

    if fData.options.show_on_map then
        CreateBlip(vector3(fData.locations.blip.x, fData.locations.blip.y,
                           fData.locations.blip.z), v.name, blipColor, 357)
    end

    local playerPed = GetPlayerPed(PlayerId())

    Citizen.CreateThread(function()
        while true do
            Wait(0)
            DrawMarker(1, 
                fData.locations.enter.x,
                fData.locations.enter.y,                       
                fData.locations.enter.z - 1,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                1.1, 0.7, 1.1, 50, 200, 50, 200, 
                false, true, 2, false,
                nil, nil, false
            )
            if IsControlJustReleased(0, 38) and isOwner then
                local currentMlo = v.mlo
                TriggerServerEvent('family_system:server:setPlayerBucket', 0, Config.mlo[currentMlo].exit.x, Config.mlo[currentMlo].exit.y, Config.mlo[currentMlo].exit.z)
			end
        end
    end)
end

local function family_system_init()
    ESX.TriggerServerCallback('family_system:server:getAllFamilyData', function(data)
        for k, v in pairs(data) do
            Wait(0)
            add_blip(data, v)
            -- add_marker(data, v)
        end
    end)
end

-- Events
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    TriggerEvent('family_system:client:init')
end)

RegisterNetEvent("family_system:client:init")
AddEventHandler("family_system:client:init", family_system_init())

-- Callbacks

-- Commands