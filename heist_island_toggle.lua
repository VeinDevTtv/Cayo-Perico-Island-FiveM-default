-- heist_island_toggle.lua
-- Toggles “HeistIsland” population & roads when player enters/exits a radius

-- Configuration
local HeistIslandCenter = vector3(4840.571, -5174.425, 2.0)
local InnerRadius       = 2000.0
local FarWaitMs         = 1000  -- ms between checks when player is outside radius
local NearWaitMs        = 500   -- ms between checks when player is inside radius

-- State tracking
local isInside = false

-- Helper to call natives on state change
local function setHeistIslandState(enabled)
    -- Enable/disable ped population in this script frame
    Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", enabled)
    -- Enable/disable roads globally
    Citizen.InvokeNative(0x5E1460624D194A38, enabled)
end

-- Main thread: poll player distance, toggle on enter/exit
CreateThread(function()
    while true do
        local ped  = PlayerPedId()
        local pos  = GetEntityCoords(ped)
        local dist = #(pos - HeistIslandCenter)

        if dist < InnerRadius then
            if not isInside then
                isInside = true
                setHeistIslandState(true)
            end
            Citizen.Wait(NearWaitMs)
        else
            if isInside then
                isInside = false
                setHeistIslandState(false)
            end
            Citizen.Wait(FarWaitMs)
        end
    end
end)

--[[
-- Optional: PolyZone approach (requires PolyZone installed)

-- local PolyZone = require("polyzone")

-- local heistZone = PolyZone:Create({
--     vector2(HeistIslandCenter.x - InnerRadius, HeistIslandCenter.y - InnerRadius),
--     vector2(HeistIslandCenter.x + InnerRadius, HeistIslandCenter.y - InnerRadius),
--     vector2(HeistIslandCenter.x + InnerRadius, HeistIslandCenter.y + InnerRadius),
--     vector2(HeistIslandCenter.x - InnerRadius, HeistIslandCenter.y + InnerRadius),
-- }, {
--     name = "HeistIslandZone",
--     debugPoly = false
-- })

-- heistZone:onPlayerInOut(function(isPointInside)
--     if isPointInside ~= isInside then
--         isInside = isPointInside
--         setHeistIslandState(isInside)
--     end
-- end)
--]]
