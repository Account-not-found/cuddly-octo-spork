-- fly.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyBody then _G.FlyBody:Destroy() end
    if _G.FlyConn then _G.FlyConn:Disconnect() end
    return
end

_G.FlyEnabled = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local bv = Instance.new("BodyVelocity")
bv.Name = "FlyVelocity"
bv.MaxForce = Vector3.new(1, 1, 1) * 1e5
bv.Velocity = Vector3.zero
bv.Parent = hrp

_G.FlyBody = bv

local moveDirection = Vector3.zero

_G.FlyConn = RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local moveVec = UIS:GetDeviceAcceleration() -- fallback for mobile
    if UIS.KeyboardEnabled then
        moveVec = Vector3.new(
            (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            (UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
            (UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )
    end

    moveDirection = moveVec.Unit * 80
    if moveDirection ~= moveDirection then moveDirection = Vector3.zero end
    bv.Velocity = hrp.CFrame:VectorToWorldSpace(moveDirection)
end)

