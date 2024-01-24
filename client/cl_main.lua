local deliveryPedEntity = nil

CreateThread(function()
    local pedmodel = GetHashKey(Config.Peds.Main.model)
    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        Citizen.Wait(1)
    end

    for _, item in pairs(Config.Peds.Main.coords) do
        if not npcSpawned then
            npcSpawned = true

            local npc = CreatePed(1, pedmodel, item.x, item.y, item.z, item.h, false, true)

            FreezeEntityPosition(npc, true)
            SetEntityHeading(npc, item.h)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)

            if Config.Peds.Main.scenario then
                TaskStartScenarioInPlace(npc, Config.Peds.Main.scenario, 0, true)
            end

            exports.ox_target:addLocalEntity(
                npc,
                {
                    {
                        name = "carthief_ped",
                        icon = "fas fa-car",
                        label = TranslateCap('talk_npc'),
                        distance = 2,
                        onSelect = function()
                            mainMenu()
                        end,
                        canInteract = function(entity)
                            if IsEntityPlayingAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop', 3) then return false end
                            return true
                        end,
                    }
                }
            )
        end
    end
end)

function mainMenu()
    lib.registerContext({
        id = 'carthief_mainmenu',
        title = TranslateCap('title_carthief'),
        options = {
            {
                title = TranslateCap('steal_car_title'),
                description = TranslateCap('start_car_title'),
                icon = 'car',
                onSelect = function()
                    findCarEasy()
                end,
            }
        }
    })
    
    lib.showContext('carthief_mainmenu')
end


function findCarEasy()
    local selectedVehicle = easycar()

    if lib[Config.progresstype]({
        duration = 5000,
        position = 'bottom',
        label = TranslateCap('talk_label'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'misscarsteal4@actor',
            clip = 'actor_berating_loop',
        },
    }) then
        local deliveryPeds = Config.Peds.DeliveryPeds
        local randomIndex = math.random(1, #deliveryPeds)
        local deliveryPed = deliveryPeds[randomIndex]
        local deliveryCoords = deliveryPed.coords[1]

        lib.notify({
            title = TranslateCap('Robert'),
            description = TranslateCap('find_car') ..selectedVehicle.label.. TranslateCap('find_car_info'),
            type = 'inform',
        })
        lib.showTextUI(TranslateCap('find_car') ..selectedVehicle.label)

        local selectedVehicleModel = GetHashKey(selectedVehicle.model)
        local hasDelivered = false
        local isWrongVehicle = false
        local deliveryBlip = nil

        while true do
            Citizen.Wait(0)
            local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if IsEntityAVehicle(playerVehicle) then
                if GetEntityModel(playerVehicle) == selectedVehicleModel then
                    if not hasDelivered then
                        lib.notify({
                            title = TranslateCap('Robert'),
                            description = TranslateCap('delivery1') ..selectedVehicle.label.. TranslateCap('delivery2'),
                            type = 'inform',
                        })
                        lib.hideTextUI()
                        hasDelivered = true
                        deliveryBlip = AddBlipForCoord(deliveryCoords.x, deliveryCoords.y, deliveryCoords.z)
                        SetBlipSprite(deliveryBlip, 1)
                        SetBlipColour(deliveryBlip, 3)
                        SetBlipRoute(deliveryBlip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(TranslateCap('GPS')..selectedVehicle.label)
                        EndTextCommandSetBlipName(deliveryBlip)
                    end

                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local distance = GetDistanceBetweenCoords(playerCoords, deliveryCoords.x, deliveryCoords.y, deliveryCoords.z, true)
                    if distance < 10.0 then
                        lib.notify({
                            title = TranslateCap('Robert'),
                            description = TranslateCap('good_job'),
                            type = 'success',
                        })
                        RemoveBlip(deliveryBlip)
                        deliveryPedEntity = CreatePed(4, GetHashKey(deliveryPed.model), deliveryCoords.x, deliveryCoords.y, deliveryCoords.z, deliveryCoords.h, false, true)
                        SetPedRandomComponentVariation(deliveryPedEntity, true)
                        SetPedDefaultComponentVariation(deliveryPedEntity)
                        SetEntityAsMissionEntity(deliveryPedEntity, true, true)
                        SetBlockingOfNonTemporaryEvents(deliveryPedEntity, true)
                        exports.ox_target:addLocalEntity(
                            deliveryPedEntity,
                            {
                                {
                                    name = "carthief_ped",
                                    icon = "fas fa-car",
                                    label = TranslateCap('talk_buyer'),
                                    distance = 5,
                                    onSelect = function()
                                        DeliveryCarEasy(selectedVehicle, selectedVehicleModel)
                                    end,
                                    canInteract = function(entity)
                                        if IsEntityPlayingAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop', 3) then return false end
                                        return true
                                    end,
                                }
                            }
                        )
                        break
                    end
                else
                    if not isWrongVehicle then
                        lib.notify({
                            title = TranslateCap('buyer'),
                            description = TranslateCap('wrong_car1')..selectedVehicle.label..TranslateCap('wrong_car2'),
                            type = 'error',
                        })
                        break
                    end
                end
            end
        end
    end
end

function DeliveryCarEasy(selectedVehicle, selectedVehicleModel)
    local isWrongVehicle = false
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        lib.notify({
            title = TranslateCap('buyer'),
            description = TranslateCap('need_in_car'),
            type = 'error',
        })
        return
    end

    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetEntityModel(playerVehicle) == selectedVehicleModel then
        if lib[Config.progresstype]({
            duration = 5000,
            position = 'bottom',
            label = TranslateCap('talk2_buyer'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'misscarsteal4@actor',
                clip = 'actor_berating_loop',
            },
        }) then
            local reward = nil
            
            for index, vehicle in pairs(Config.Menu.vehicle.easy) do
                local cleanedModelName = string.gsub(vehicle.model, "[^%w_]", "")
                
                if Config.debug == true then 
                    print("Checking:", vehicle.label, "Model:", cleanedModelName)
                end
            
                local selectedModelLower = string.lower(selectedVehicle.model)
                local cleanedModelNameLower = string.lower(cleanedModelName)
            
                if cleanedModelNameLower == selectedModelLower then
                    reward = vehicle.payout
                    if Config.debug == true then 
                    print("Found reward for", vehicle.label, ":", reward)
                    end

                    break
                else
                    if Config.debug == true then 
                    print("Model mismatch. Expected:", selectedVehicle.model, "Actual:", cleanedModelName)
                    end
                end
            
                if index == #Config.Menu.vehicle.easy then
                    if Config.debug == true then 
                    print("Reached end of vehicle list. No matching model found.")
                    end
                end
            end

            if reward then
                local closestVehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
                
                if DoesEntityExist(closestVehicle) and GetEntityModel(closestVehicle) == GetHashKey(selectedVehicle.model) then
                    SetEntityAsMissionEntity(closestVehicle, true, true)
                    DeleteVehicle(closestVehicle)
                end
    
                if DoesEntityExist(deliveryPedEntity) then
                    SetEntityAsMissionEntity(deliveryPedEntity, true, true)
                    DeletePed(deliveryPedEntity)
                    deliveryPedEntity = nil
                end
    
                TriggerServerEvent('t3_easycar:reward', reward)
                DespawnVehicle()
            end
        end
    else
        if not isWrongVehicle then
            lib.notify({
                title = TranslateCap('buyer'),
                description = TranslateCap('wrong_car1')..selectedVehicle.label..TranslateCap('wrong_car2'),
                type = 'error',
            })
            isWrongVehicle = true
        end
    end
end

function DespawnVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end


function easycar()
    local easyVehicles = Config.Menu.vehicle.easy
    local randomIndex = math.random(1, #easyVehicles)
    local selectedVehicle = easyVehicles[randomIndex]

    return selectedVehicle
end

--------------------------
--       bye <3         --
--------------------------