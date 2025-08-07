-- fly.lua (Shift-lock style + mobile friendly + all direction)
if _G.FlyingEnabled then
    _G.FlyingEnabled = false
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    if _G.FlyHeartbeat then _G.FlyHeartbeat:Disconnect() end
    if _G.BodyGyro then _G.BodyGyro:Destroy() end
    if _G.BodyVelocity then _G.BodyVelocity:Destroy() end
    return
end

_G.FlyingEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local camera = workspace.CurrentCamera

local flyingSpeed = 60
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bodyGyro.P = 1e5
bodyGyro.CFrame = hrp.CFrame
bodyGyro.Parent = hrp
_G.BodyGyro = bodyGyro

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bodyVelocity.Velocity = Vector3.zero
bodyVelocity.Parent = hrp
_G.BodyVelocity = bodyVelocity

local moveDirection = Vector3.zero

-- Mobile or PC control support
local keys = {
    W = false, A = false, S = false, D = false,
    Space = false, Shift = false
}

local function updateDirection()
    local camCF = camera.CFrame
    local forward = camCF.LookVector
    local right = camCF.RightVector
    local up = Vector3.new(0, 1, 0)

    local moveVec = Vector3.zero
    if keys.W then moveVec += forward end
    if keys.S then moveVec -= forward end
    if keys.A then moveVec -= right end
    if keys.D then moveVec += right end
    if keys.Space then moveVec += up end
    if keys.Shift then moveVec -= up end

    moveDirection = moveVec.Unit * flyingSpeed
end

_G.FlyConnection = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then
        keys[k] = true
        updateDirection()
    end
end)

_G.FlyHeartbeat = UIS.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then
        keys[k] = false
        updateDirection()
    end
end)

RunService.RenderStepped:Connect(function()
    if not _G.FlyingEnabled then return end

    if moveDirection.Magnitude > 0 then
        bodyVelocity.Velocity = moveDirection
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + moveDirection)
    else
        bodyVelocity.Velocity = Vector3.zero
    end
end)
