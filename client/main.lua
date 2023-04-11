local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local isOwner = false
local playerIdentifier = ""

local Blips, allData, fData = {}, {}, {}

-- Threads
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end

    ESX.PlayerData = ESX.GetPlayerData()

    playerIdentifier = ESX.PlayerData.identifier
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        pCoords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(allData) do
            fData = {
                options = json.decode(v.options),
                locations = json.decode(v.locations),
                users = json.decode(v.users)
            }

            house_in = vector3(fData.locations.enter.x, fData.locations.enter.y, fData.locations.enter.z)
            enterDist = #(house_in - pCoords)
            if enterDist < 3.0 then
                if isOwner then
                    DrawText3D(house_in.x, house_in.y, house_in.z + 0.2, "~o~[E] ~g~ Enter family house")

                    if enterDist < 1.40 and IsControlJustPressed(0, 38) then
                        Wait(1000)
                        DoScreenFadeOut(400)
                        Wait(500)
                        TriggerServerEvent('family_system:server:setPlayerBucket', v.id,
                            fData.locations.spawn.x, 
                            fData.locations.spawn.y,
                            fData.locations.spawn.z)
                        Wait(500)
                        DoScreenFadeIn(1000)
                        Wait(1000)
                    end
                else
                    DrawText3D(house_in.x, house_in.y, house_in.z + 0.2, "~o~" .. v.name .. "House")
                end
            end

            house_out = Config.mlo[v.mlo].exit
            exitDist = #(house_out - pCoords)
            if exitDist < 3.0 then
                DrawText3D(house_out.x, house_out.y, house_out.z + 0.2, "~o~[E] ~g~ Exit family house")

                if exitDist < 1.40 and IsControlJustPressed(0, 38) then
                    Wait(1000)
                    DoScreenFadeOut(400)
                    Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), house_in)
                    TriggerServerEvent('family_system:server:setPlayerOutBucket')
                    Wait(500)
                    DoScreenFadeIn(1000)
                    Wait(1000)
                end
            end

        end
    end
end)

-- Functions
local function add_blip(data)
    ClearBlips()

    isOwner = false
    local blipColor = 46

    for k, v in pairs(data) do
        if playerIdentifier == v.owner_id then
            blipColor = 2
            isOwner = true
        end

        if isOwner == false then
            for k, v in pairs(fData.users) do
                if v.identifier == playerIdentifier then
                    blipColor = 2
                    isOwner = true
                end
            end
        end

        if fData.options.show_on_map then
            blip = fData.locations.blip
            CreateBlip(vector3(blip.x, blip.y, blip.z), v.name, blipColor, 357)
        end
    end
end

local function family_system_init()
    ESX.TriggerServerCallback('family_system:getAllFamilyData', function(data)
        allData = data
        add_blip(data)
    end)
end

ClearBlips = function() for k, v in pairs(Blips) do RemoveBlip(v) end end

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
