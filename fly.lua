-- fly.lua
if _G.Flying then
    _G.Flying = false
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    if _G.FlyBodyGyro then _G.FlyBodyGyro:Destroy() end
    if _G.FlyBodyVelocity then _G.FlyBodyVelocity:Destroy() end
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    return
end

_G.Flying = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

humanoid.PlatformStand = true

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.CFrame = hrp.CFrame
bodyGyro.Parent = hrp
_G.FlyBodyGyro = bodyGyro

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.Velocity = Vector3.zero
bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bodyVelocity.Parent = hrp
_G.FlyBodyVelocity = bodyVelocity

-- Movement input
local moveDirection = Vector3.zero
local flyingSpeed = 60

-- Mobile joystick compatibility (touch input)
local function updateMoveDirection()
    if UIS.TouchEnabled then
        moveDirection = player:GetMoveDirection()
    end
end

-- Desktop input handling
local keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Q = false, -- down
    E = false  -- up
}

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode.Name
    if keys[key] ~= nil then keys[key] = true end
end)

UIS.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name
    if keys[key] ~= nil then keys[key] = false end
end)

-- Fly loop
_G.FlyConnection = RunService.RenderStepped:Connect(function()
    if not _G.Flying then return end
    updateMoveDirection()

    local rootCF = hrp.CFrame
    local forward = rootCF.LookVector
    local right = rootCF.RightVector
    local up = rootCF.UpVector
    local moveVec = Vector3.zero

    -- Desktop movement vector
    if not UIS.TouchEnabled then
        if keys.W then moveVec += forward end
        if keys.S then moveVec -= forward end
        if keys.A then moveVec -= right end
        if keys.D then moveVec += right end
        if keys.E then moveVec += up end
        if keys.Q then moveVec -= up end
    else
        -- Mobile uses humanoid movement input
        moveVec = moveDirection
    end

    bodyVelocity.Velocity = moveVec.Unit * flyingSpeed
    if moveVec.Magnitude == 0 then
        bodyVelocity.Velocity = Vector3.zero
    end

    bodyGyro.CFrame = hrp.CFrame
end)
