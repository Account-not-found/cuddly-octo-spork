local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local flying = true
local speed = 50
local direction = Vector3.new()

local bodyGyro = Instance.new("BodyGyro", root)
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.CFrame = root.CFrame

local bodyVelocity = Instance.new("BodyVelocity", root)
bodyVelocity.Velocity = Vector3.new()
bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0)
    end
end)

UIS.InputEnded:Connect(function(input)
    direction = Vector3.new()
end)

RunService.RenderStepped:Connect(function()
    if flying then
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        bodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(direction * speed)
    end
end)
