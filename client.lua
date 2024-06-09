Citizen.CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local distance = #(pCoords - vector3(4840.571, -5174.425, 2.0))
        if distance < 2000.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)
            Citizen.InvokeNative("0x5E1460624D194A38", true)
        else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
        end
        Citizen.Wait(500) -- Adjust the wait time according to your needs
    end
end)
