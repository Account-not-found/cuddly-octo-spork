-- fly.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- fly.lua
if _G.FlyEnabled then
    _G.FlyEnabled = false
    if _G.FlyConnection then _G.FlyConnection:Disconnect() end
    if _G.FlyBody then _G.FlyBody:Destroy() end
    return
end

_G.FlyEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local flySpeed = 70
local moveDirection = Vector3.zero

-- Create BodyVelocity
local bv = Instance.new("BodyVelocity")
bv.Name = "FlyBodyVelocity"
bv.MaxForce = Vector3.new(1, 1, 1) * 1e6
bv.Velocity = Vector3.zero
bv.Parent = hrp
_G.FlyBody = bv

-- Movement update loop
_G.FlyConnection = RunService.RenderStepped:Connect(function()
    if not _G.FlyEnabled then return end

    local cam = workspace.CurrentCamera
    local direction = Vector3.zero

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        -- Mobile movement (thumbstick)
        local moveVector = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)[1]
        if moveVector and moveVector.Position.Magnitude > 0 then
            direction = cam.CFrame:VectorToWorldSpace(Vector3.new(moveVector.Position.X, 0, -moveVector.Position.Y))
        end
    else
        -- PC movement (WASD / Space / Ctrl)
        local forward = (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
        local right = (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
        local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0)

        direction = Vector3.new(right, up, forward)
        if direction.Magnitude > 0 then
            direction = cam.CFrame:VectorToWorldSpace(direction)
        end
    end

    bv.Velocity = direction.Unit * flySpeed
end)
