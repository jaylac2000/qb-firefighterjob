QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function DrawText3D(x, y, z, text)
	SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Events

-- RegisterNetEvent('hospital:client:ambulanceAlert', function(coords, text)
--     local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
--     local street1name = GetStreetNameFromHashKey(street1)
--     local street2name = GetStreetNameFromHashKey(street2)
--     QBCore.Functions.Notify({text = text, caption = street1name.. ' ' ..street2name}, 'firefighter')
--     PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--     local transG = 250
--     local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
--     local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
--     local blipText = 'EMS Alert - ' ..text
--     SetBlipSprite(blip, 153)
--     SetBlipSprite(blip2, 161)
--     SetBlipColour(blip, 1)
--     SetBlipColour(blip2, 1)
--     SetBlipDisplay(blip, 4)
--     SetBlipDisplay(blip2, 8)
--     SetBlipAlpha(blip, transG)
--     SetBlipAlpha(blip2, transG)
--     SetBlipScale(blip, 0.8)
--     SetBlipScale(blip2, 2.0)
--     SetBlipAsShortRange(blip, false)
--     SetBlipAsShortRange(blip2, false)
--     PulseBlip(blip2)
--     BeginTextCommandSetBlipName('STRING')
--     AddTextComponentString(blipText)
--     EndTextCommandSetBlipName(blip)
--     while transG ~= 0 do
--         Wait(180 * 4)
--         transG = transG - 1
--         SetBlipAlpha(blip, transG)
--         SetBlipAlpha(blip2, transG)
--         if transG == 0 then
--             RemoveBlip(blip)
--             return
--         end
--     end
-- end)

-- Threads

CreateThread(function()
    for k, station in pairs(Config.Locations["stations"]) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, 436)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.label)
        EndTextCommandSetBlipName(blip)
    end
end)