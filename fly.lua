-- fly.lua (mobile + shift lock + fixed)
if _G.FlyActive then
    _G.FlyActive = false
    if _G.FlyBodyGyro then _G.FlyBodyGyro:Destroy() end
    if _G.FlyBodyVelocity then _G.FlyBodyVelocity:Destroy() end
    return
end

_G.FlyActive = true

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local speed = 60
local direction = Vector3.zero
local flying = true

local bv = Instance.new("BodyVelocity")
bv.Velocity = Vector3.zero
bv.MaxForce = Vector3.new(1, 1, 1) * 1e5
bv.P = 1250
bv.Name = "FlyBodyVelocity"
bv.Parent = hrp

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1, 1, 1) * 1e5
bg.P = 3000
bg.CFrame = hrp.CFrame
bg.Name = "FlyBodyGyro"
bg.Parent = hrp

_G.FlyBodyGyro = bg
_G.FlyBodyVelocity = bv

uis.InputBegan:Connect(function(input)
    if not flying then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then direction = Vector3.new(0, -1, 0) end
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        direction = Vector3.zero
    end
end)

rs:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Input.Value, function()
    if not _G.FlyActive or not char or not hrp then
        rs:UnbindFromRenderStep("FlyUpdate")
        return
    end
    local cf = workspace.CurrentCamera.CFrame
    local moveDir = cf:VectorToWorldSpace(direction)
    bv.Velocity = moveDir.Unit * speed
    bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cf.LookVector)
end)
