local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Function to prevent falling and keep the character movable
local function preventFall(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoidRootPart or not humanoid then return end -- Exit if essential parts are missing

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Health > 0 then
            local velocity = humanoidRootPart.Velocity

            -- Neutralize downward velocity to prevent falling
            if velocity.Y < 0 then
                humanoidRootPart.Velocity = Vector3.new(velocity.X, 0, velocity.Z)
                
                -- Prevent "Falling" state
                local currentState = humanoid:GetState()
                if currentState == Enum.HumanoidStateType.Freefall or currentState == Enum.HumanoidStateType.FallingDown then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        else
            if connection then
                connection:Disconnect() -- Disconnect if the character dies
            end
        end
    end)

    -- Ensure connection is cleaned up if character is removed
    character.AncestryChanged:Connect(function(_, parent)
        if not parent and connection then
            connection:Disconnect()
        end
    end)
end

-- Listen for character spawning or respawning
local function onCharacterAdded(character)
    preventFall(character)
end

-- Bind the function to the player
player.CharacterAdded:Connect(onCharacterAdded)

-- Handle the case where the character is already loaded
if player.Character then
    onCharacterAdded(player.Character)
end
