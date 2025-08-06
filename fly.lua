-- fly.lua
if _G.Flying then
    _G.Flying = false
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    if _G.FlyInputBegan then _G.FlyInputBegan:Disconnect() end
    if _G.FlyInputEnded then _G.FlyInputEnded:Disconnect() end
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
local cam = workspace.CurrentCamera

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

-- Input storage
local moveDirection = Vector3.zero
local flyingSpeed = 60

local keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Q = false,
    E = false
}

_G.FlyInputBegan = UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    local name = input.KeyCode.Name
    if keys[name] ~= nil then
        keys[name] = true
    end
end)

_G.FlyInputEnded = UIS.InputEnded:Connect(function(input)
    local name = input.KeyCode.Name
    if keys[name] ~= nil then
        keys[name] = false
    end
end)

_G.FlyConnection = RunService.RenderStepped:Connect(function()
    if not _G.Flying then return end

    local rootCF = hrp.CFrame
    local forward = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local up = Vector3.new(0, 1, 0)
    local moveVec = Vector3.zero

    if UIS.TouchEnabled then
        moveVec = humanoid.MoveDirection
    else
        if keys.W then moveVec += forward end
        if keys.S then moveVec -= forward end
        if keys.A then moveVec -= right end
        if keys.D then moveVec += right end
        if keys.E then moveVec += up end
        if keys.Q then moveVec -= up end
    end

    if moveVec.Magnitude > 0 then
        bodyVelocity.Velocity = moveVec.Unit * flyingSpeed
    else
        bodyVelocity.Velocity = Vector3.zero
    end

    bodyGyro.CFrame = rootCF
end)
