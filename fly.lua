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

-- BodyVelocity for movement
local bv = Instance.new("BodyVelocity")
bv.Name = "FlyBodyVelocity"
bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bv.Velocity = Vector3.zero
bv.Parent = hrp
_G.FlyBodyVelocity = bv

-- BodyGyro for facing
local gyro = Instance.new("BodyGyro")
gyro.Name = "FlyGyro"
gyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
gyro.CFrame = hrp.CFrame
gyro.Parent = hrp
_G.FlyGyro = gyro

-- Fly movement in the character facing direction
local speed = 50
RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local moveVector = Vector3.new()
    pcall(function()
        moveVector = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():GetMoveVector()
    end)

    if moveVector.Magnitude > 0 then
        local forward = hrp.CFrame.LookVector
        local right = hrp.CFrame.RightVector
        local moveDir = (forward * moveVector.Z + right * moveVector.X).Unit
        bv.Velocity = moveDir * speed
    else
        bv.Velocity = Vector3.zero
    end

    gyro.CFrame = hrp.CFrame
end)
