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
local UserInputService = game:GetService("UserInputService")
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
gyro.P = 9e4
gyro.Parent = hrp
_G.FlyGyro = gyro

-- Vertical movement
local vertical = 0
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        vertical = 1
    elseif input.KeyCode == Enum.KeyCode.Q then
        vertical = -1
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q then
        vertical = 0
    end
end)

-- Main fly loop
RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local moveVec = Vector3.zero
    pcall(function()
        moveVec = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():GetMoveVector()
    end)

    local cam = workspace.CurrentCamera
    local camCF = cam.CFrame

    local direction = (camCF.LookVector * moveVec.Z + camCF.RightVector * moveVec.X + Vector3.new(0, vertical, 0))
    if direction.Magnitude > 0 then
        bv.Velocity = direction.Unit * 50
    else
        bv.Velocity = Vector3.zero
    end

    gyro.CFrame = camCF
end)
