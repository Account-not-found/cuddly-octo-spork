-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyBodyGyro then _G.FlyBodyGyro:Destroy() end
    if _G.FlyBodyVelocity then _G.FlyBodyVelocity:Destroy() end
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    return
end

_G.FlyEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local bg = Instance.new("BodyGyro")
bg.P = 9e4
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.CFrame = root.CFrame
bg.Parent = root
_G.FlyBodyGyro = bg

local bv = Instance.new("BodyVelocity")
bv.Velocity = Vector3.zero
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Parent = root
_G.FlyBodyVelocity = bv

player.Character.Humanoid.PlatformStand = true

local speed = 60
local moveDirection = Vector3.zero

-- Mobile compatibility
local function getMoveVector()
    local move = Vector3.zero
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
    end
    return move.Unit == move.Unit and move.Unit or Vector3.zero
end

_G.FlyConnection = RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local camCF = workspace.CurrentCamera.CFrame
    moveDirection = getMoveVector()

    bv.Velocity = (camCF:VectorToWorldSpace(moveDirection)) * speed
    bg.CFrame = camCF
end)
