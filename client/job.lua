local statusCheckPed = nil
local PlayerJob = {}
local onDuty = false
local currentGarage = 0
local inDuty = false
local inStash = false
local inArmory = false
local inVehicle = false
local inHeli = false


-- Functions

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, Lang:t('info.fire _plate')..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        if Config.VehicleSettings[vehicleInfo] ~= nil then
            QBCore.Shared.SetDefaultVehicleExtras(veh, Config.VehicleSettings[vehicleInfo].extras)
        end
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function MenuGarage()
    local vehicleMenu = {
        {
            header = Lang:t('menu.fire_vehicles'),
            isMenuHeader = true
        }
    }

    local authorizedVehicles = Config.AuthorizedVehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(authorizedVehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = label,
            txt = "",
            params = {
                event = "firejob:client:TakeOutVehicle",
                args = {
                    vehicle = veh
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = Lang:t('menu.close'),
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

-- Events

RegisterNetEvent('firejob:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    TakeOutVehicle(vehicle)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == 'firefighter' then
        onDuty = PlayerJob.onduty
        if PlayerJob.onduty then
            TriggerServerEvent("firejob:server:AddDoctor", PlayerJob.name)
        else
            TriggerServerEvent("firejob:server:RemoveDoctor", PlayerJob.name)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = PlayerPedId()
    local player = PlayerId()
    CreateThread(function()
        Wait(5000)
        SetEntityMaxHealth(ped, 200)
        SetEntityHealth(ped, 200)
        SetPlayerHealthRechargeMultiplier(player, 0.0)
        SetPlayerHealthRechargeLimit(player, 0.0)
    end)
    CreateThread(function()
        Wait(1000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
            SetPedArmour(PlayerPedId(), PlayerData.metadata["armor"])
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                deathTime = Laststand.ReviveInterval
                OnDeath()
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("firejob:server:SetDeathStatus", false)
                TriggerServerEvent("firejob:server:SetLaststandStatus", false)

            end
        end)
    end)
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    if PlayerJob.name == 'firefighter' and duty ~= onDuty then
        if duty then
            TriggerServerEvent("firejob:server:AddFirefightwe", PlayerJob.name)
        else
            TriggerServerEvent("firejob:server:RemoveFirefighter", PlayerJob.name)
        end
    end

    onDuty = duty
end)

local check = false
 local function EMSControls(variable)
    CreateThread(function()
        check = true
        while check do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed(38)
                if variable == "sign" then
                   TriggerEvent('FireToggle:Duty')
                elseif variable == "stash" then
                    TriggerEvent('qb-firefighterjob:stash')
                elseif variable == "armory" then
                    TriggerEvent('qb-firefighterjob:armory')
                elseif variable == "storeheli" then
                    TriggerEvent('qb-firefighterjob:storeheli')
                elseif variable == "takeheli" then
                    TriggerEvent('qb-firefighterjob:pullheli')
                end
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent('qb-firefighterjob:stash', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "firefighterstash_"..QBCore.Functions.GetPlayerData().citizenid)
        TriggerEvent("inventory:client:SetCurrentStash", "firefighterstash_"..QBCore.Functions.GetPlayerData().citizenid)
    end
end)

RegisterNetEvent('qb-firefighterjob:armory', function()
    if onDuty then
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
    end
end)

local CheckVehicle = false
local function FireVehicle(k)
    CheckVehicle = true
    CreateThread(function()
        while CheckVehicle do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed(38)
                CheckVehicle = false
                local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped, false) then
                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(ped))
                    else
                        currentVehicle = k
                        MenuGarage(currentVehicle)
                        currentGarage = currentVehicle
                    end
                end
            Wait(1)
        end
    end)
end

local CheckHeli = false
local function EMSHelicopter(k)
    CheckHeli = true
    CreateThread(function()
        while CheckHeli do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed(38)
                CheckHeli = false
                local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped, false) then
                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(ped))
                    else
                        currentHelictoper = k
                        local coords = Config.Locations["helicopter"][currentHelictoper]
                        QBCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                            SetVehicleNumberPlateText(veh, Lang:t('info.heli_plate')..tostring(math.random(1000, 9999)))
                            SetEntityHeading(veh, coords.w)
                            SetVehicleLivery(veh, 1) -- Firetruck Livery
                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                            SetVehicleEngineOn(veh, true, true)
                        end, coords, true)
                    end
                end
            Wait(1)
        end
    end)
end

RegisterNetEvent('FireToggle:Duty', function()
    onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
end)

CreateThread(function()
    for k, v in pairs(Config.Locations["vehicle"]) do
        local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 5, 5, {
            name="vehicle"..k,
            debugPoly = false,
            heading = 70,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="firefighter" and onDuty then
                inVehicle = true
                exports['qb-core']:DrawText(Lang:t('text.veh_button'), 'left')
                FireVehicle(k)
            else
                inVehicle = false
                CheckVehicle = false
                exports['qb-core']:HideText()
            end
        end)
    end

    for k, v in pairs(Config.Locations["helicopter"]) do
        local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 5, 5, {
            name="helicopter"..k,
            debugPoly = false,
            heading = 70,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="firefighter" and onDuty then
                inVehicle = true
                exports['qb-core']:DrawText(Lang:t('text.heli_button'), 'left')
                EMSHelicopter(k)
            else
                inVehicle = false
                CheckHelicopter = false
                exports['qb-core']:HideText()
            end
        end)
    end
end)

-- Convar Turns into strings
if Config.UseTarget == 'true' then
    CreateThread(function()
        for k, v in pairs(Config.Locations["duty"]) do
            exports['qb-target']:AddBoxZone("duty"..k, vector3(v.x, v.y, v.z), 1.5, 1, {
                name = "duty"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "FireToggle:Duty",
                        icon = "fa fa-clipboard",
                        label = "Sign In/Off duty",
                        job = "firefighter"
                    }
                },
                distance = 1.5
            })
        end
        for k, v in pairs(Config.Locations["stash"]) do
            exports['qb-target']:AddBoxZone("stash"..k, vector3(v.x, v.y, v.z), 1, 1, {
                name = "stash"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-firefighterjob:stash",
                        icon = "fa fa-hand",
                        label = "Open Stash",
                        job = "firefighter"
                    }
                },
                distance = 1.5
            })
        end
        for k, v in pairs(Config.Locations["armory"]) do
            exports['qb-target']:AddBoxZone("armory"..k, vector3(v.x, v.y, v.z), 1, 1, {
                name = "armory"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-firefighterjob:armory",
                        icon = "fa fa-hand",
                        label = "Open Armory",
                        job = "firefighter"
                    }
                },
                distance = 1.5
            })
        end
else
    CreateThread(function()
        local signPoly = {}
        for k, v in pairs(Config.Locations["duty"]) do
            signPoly[#signPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1.5, 1, {
                name="sign"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local signCombo = ComboZone:Create(signPoly, {name = "signcombo", debugPoly = false})
        signCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="firefighter" then
                inDuty = true
                if not onDuty then
                    exports['qb-core']:DrawText(Lang:t('text.onduty_button'),'left')
                    EMSControls("sign")
                else
                    exports['qb-core']:DrawText(Lang:t('text.offduty_button'),'left')
                    EMSControls("sign")
                end
            else
                inDuty = false
                check = false
                exports['qb-core']:HideText()
            end
        end)

        local stashPoly = {}
        for k, v in pairs(Config.Locations["stash"]) do
            stashPoly[#stashPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1, 1, {
                name="stash"..k,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local stashCombo = ComboZone:Create(stashPoly, {name = "stashCombo", debugPoly = false})
        stashCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="firefighter" then
                inStash = true
                if onDuty then
                    exports['qb-core']:DrawText(Lang:t('text.pstash_button'),'left')
                    EMSControls("stash")
                end
            else
                inStash = false
                check = false
                exports['qb-core']:HideText()
            end
        end)

        local armoryPoly = {}
        for k, v in pairs(Config.Locations["armory"]) do
            armoryPoly[#armoryPoly+1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 1, 1, {
                name="armory"..k,
                debugPoly = false,
                heading = 70,
                minZ = v.z - 2,
                maxZ = v.z + 2,
            })
        end

        local armoryCombo = ComboZone:Create(armoryPoly, {name = "armoryCombo", debugPoly = false})
        armoryCombo:onPlayerInOut(function(isPointInside)
            if isPointInside and PlayerJob.name =="firefighter" then
                inArmory = true
                if onDuty then
                    exports['qb-core']:DrawText(Lang:t('text.armory_button'),'left')
                    EMSControls("armory")
                end
            else
                inArmory = false
                check = false
                exports['qb-core']:HideText()
            end
        end)