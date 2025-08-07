-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    if _G.BodyGyro then _G.BodyGyro:Destroy() end
    if _G.BodyVelocity then _G.BodyVelocity:Destroy() end
    return
end

_G.FlyEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local camera = workspace.CurrentCamera
local flying = true

local BodyGyro = Instance.new("BodyGyro")
BodyGyro.P = 9e4
BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BodyGyro.CFrame = root.CFrame
BodyGyro.Parent = root
_G.BodyGyro = BodyGyro

local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity = Vector3.zero
BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
BodyVelocity.Parent = root
_G.BodyVelocity = BodyVelocity

local moveVec = Vector3.zero

-- input handling
local keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

local function onInput(input, isProcessed)
    if isProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then keys.W = input.UserInputState == Enum.UserInputState.Begin end
    if key == Enum.KeyCode.A then keys.A = input.UserInputState == Enum.UserInputState.Begin end
    if key == Enum.KeyCode.S then keys.S = input.UserInputState == Enum.UserInputState.Begin end
    if key == Enum.KeyCode.D then keys.D = input.UserInputState == Enum.UserInputState.Begin end
    if key == Enum.KeyCode.Space then keys.Space = input.UserInputState == Enum.UserInputState.Begin end
    if key == Enum.KeyCode.LeftShift then keys.Shift = input.UserInputState == Enum.UserInputState.Begin end
end

UserInputService.InputBegan:Connect(onInput)
UserInputService.InputEnded:Connect(onInput)

local SPEED = 70

_G.FlyConnection = RunService.RenderStepped:Connect(function()
    if not flying then return end

    local camCF = camera.CFrame
    local dir = Vector3.zero

    if keys.W then dir += camCF.LookVector end
    if keys.S then dir -= camCF.LookVector end
    if keys.A then dir -= camCF.RightVector end
    if keys.D then dir += camCF.RightVector end
    if keys.Space then dir += camCF.UpVector end
    if keys.Shift then dir -= camCF.UpVector end

    dir = dir.Unit == dir.Unit and dir.Unit or Vector3.zero
    BodyVelocity.Velocity = dir * SPEED
    BodyGyro.CFrame = CFrame.new(root.Position, root.Position + dir)
end)
