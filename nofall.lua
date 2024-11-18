-- File: prevent_fall_damage.lua

-- Constants
local SLOW_FALL_THRESHOLD = -50 -- Velocity at which the fall is slowed
local FALL_SLOW_FACTOR = 0.5   -- Factor to slow down the fall
local CHECK_INTERVAL = 0.05    -- How often to check the player's velocity

-- Function to slow the player's fall
local function slowFall(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Get the current vertical velocity
            local velocity = humanoidRootPart.Velocity
            if velocity.Y < SLOW_FALL_THRESHOLD then
                -- Slow down the vertical velocity
                humanoidRootPart.Velocity = Vector3.new(velocity.X, velocity.Y * FALL_SLOW_FACTOR, velocity.Z)
            end
        end
    end
end

-- Main function to start monitoring the player's fall
local function preventFallDamage(player)
    -- Periodically check and adjust velocity
    while true do
        slowFall(player)
        wait(CHECK_INTERVAL)
    end
end

-- Detect when the local player is added
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Start the fall prevention system for the local player
preventFallDamage(localPlayer)
