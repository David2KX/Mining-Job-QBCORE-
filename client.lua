local QBCore = exports['qb-core']:GetCoreObject()

local miningProps = {}

function CreateMiningProps()
    local miningCoords = Config.MiningLocation 

    for i = 1, 10 do  
        local offset = math.random(-Config.MiningRadius, Config.MiningRadius)  
        local x = miningCoords.x + offset
        local y = miningCoords.y + offset
        local z = miningCoords.z

        local propModel = 'prop_rock_2_a'

        local prop = CreateObject(GetHashKey(propModel), x, y, z, true, true, true)
        SetEntityAsMissionEntity(prop, true, true)  
        SetEntityInvincible(prop, true)  
        FreezeEntityPosition(prop, true)  

        exports['qb-target']:AddTargetEntity(prop, {
            options = {
                {
                    event = "rudar:startMining",  
                    icon = "fas fa-pickaxe",
                    label = "Mine",
                    action = function(entity)
                        if not HasPickaxe() then
                            TriggerEvent('QBCore:Notify', "You need a pickaxe to mine!", "error")
                            return
                        end

                        TriggerServerEvent("rudar:startMining", entity)
                    end
                }
            },
            distance = 2.5  
        })

        table.insert(miningProps, {prop = prop, coords = vector3(x, y, z)})
    end
end

function HasPickaxe()
    local player = QBCore.Functions.GetPlayerData()
    for _, item in pairs(player.items) do
        if item.name == "pickaxe" then
            return true
        end
    end
    return false
end

function MoveMiningProp()
    local newCoords = vector3(
        Config.MiningLocation.x + math.random(-Config.MiningRadius, Config.MiningRadius),
        Config.MiningLocation.y + math.random(-Config.MiningRadius, Config.MiningRadius),
        Config.MiningLocation.z
    )

    local propModel = 'prop_rock_2_a'  
    local prop = CreateObject(GetHashKey(propModel), newCoords.x, newCoords.y, newCoords.z, true, true, true)

    SetEntityAsMissionEntity(prop, true, true)
    SetEntityInvincible(prop, true)
    FreezeEntityPosition(prop, true)

    exports['qb-target']:AddTargetEntity(prop, {
        options = {
            {
                event = "rudar:startMining",
                icon = "fas fa-pickaxe",
                label = "Mine",
                action = function(entity)
                    if not HasPickaxe() then
                        TriggerEvent('QBCore:Notify', "You need a pickaxe to mine!", "error")
                        return
                    end
                    
                    TriggerServerEvent("rudar:startMining", entity)
                end
            }
        },
        distance = 2.5
    })
end

CreateMiningProps()

RegisterNetEvent('rudar:startMining', function(entity)
    local playerPed = PlayerPedId()

    RequestAnimDict("melee@hatchet@streamed_core")
    while not HasAnimDictLoaded("melee@hatchet@streamed_core") do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, "melee@hatchet@streamed_core", "plyr_rear_takedown_b", 8.0, -8.0, -1, 2, 0, false, false, false)

    exports['progressbar']:Progress({
        name = "mining_task",
        duration = 3000, 
        label = "Mining Rock...",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = true,
            disableCombat = true,
        },
        animation = {
            animDict = "melee@hatchet@streamed_core",
            anim = "plyr_rear_takedown_b",
            flags = 49,
        },
        prop = {
            model = 'prop_tool_pickaxe',  
            bone = 57005,
            coords = vector3(0.15, 0.03, 0.05),
            rotation = vector3(0.0, 0.0, 0.0),
        }
    }, function(cancelled)
        if not cancelled then
            local randomItem = Config.MiningItems[math.random(1, #Config.MiningItems)]
            TriggerServerEvent("rudar:giveItem", randomItem.name, randomItem.amount)
            TriggerEvent('QBCore:Notify', "You mined " .. randomItem.label, "success")
        else
            TriggerEvent('QBCore:Notify', "Mining interrupted!", "error")
        end
        
        DeleteEntity(entity)

        MoveMiningProp()

        StopAnimTask(playerPed, "melee@hatchet@streamed_core", "plyr_rear_takedown_b", 1.0)
    end)
end)
-- BLIP
Citizen.CreateThread(function()
    local x, y, z = 8672.25, -1548.61, 20.50

    local blip = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip, 1) 
    SetBlipColour(blip, 2) 
    SetBlipScale(blip, 1.0) 

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Miner Job")
    EndTextCommandSetBlipName(blip)
end)



