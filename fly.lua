-- fly.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyConn then _G.FlyConn:Disconnect() end
    if _G.BodyGyro then _G.BodyGyro:Destroy() end
    if _G.BodyVel then _G.BodyVel:Destroy() end
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    return
end

_G.FlyEnabled = true

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local BodyGyro = Instance.new("BodyGyro")
BodyGyro.P = 9e4
BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
BodyGyro.cframe = root.CFrame
BodyGyro.Parent = root
_G.BodyGyro = BodyGyro

local BodyVel = Instance.new("BodyVelocity")
BodyVel.velocity = Vector3.zero
BodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)
BodyVel.Parent = root
_G.BodyVel = BodyVel

local UIS = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local speed = 80
local direction = Vector3.zero

_G.FlyConn = game:GetService("RunService").RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end
    direction = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
    BodyVel.velocity = direction.Unit * speed
    BodyGyro.CFrame = cam.CFrame
    plr.Character.Humanoid.PlatformStand = true
end)

