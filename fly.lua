-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyBodyVelocity then _G.FlyBodyVelocity:Destroy() end
    if _G.FlyGyro then _G.FlyGyro:Destroy() end
    return
end

_G.FlyEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Create BodyVelocity
local bv = Instance.new("BodyVelocity")
bv.Name = "FlyBodyVelocity"
bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bv.Velocity = Vector3.zero
bv.Parent = hrp
_G.FlyBodyVelocity = bv

-- Create BodyGyro
local gyro = Instance.new("BodyGyro")
gyro.Name = "FlyGyro"
gyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
gyro.CFrame = hrp.CFrame
gyro.Parent = hrp
_G.FlyGyro = gyro

-- Flying speed
local speed = 50

-- Movement input (mobile-compatible)
RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local moveVector = Vector3.zero
    pcall(function()
        moveVector = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():GetMoveVector()
    end)

    -- Re-map move direction properly
    if moveVector.Magnitude > 0 then
        local cf = hrp.CFrame
        local forward = cf.LookVector
        local right = cf.RightVector
        local direction = (forward * moveVector.Z + right * moveVector.X)

        bv.Velocity = direction.Unit * speed
    else
        bv.Velocity = Vector3.zero
    end

    gyro.CFrame = hrp.CFrame
end)
