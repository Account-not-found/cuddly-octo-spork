-- fly.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local flyConnection = nil
local movement = { Forward = 0, Right = 0 }

local isMobile = UIS.TouchEnabled

-- Movement handler (desktop)
local function onInput(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then movement.Forward = 1 end
	if input.KeyCode == Enum.KeyCode.S then movement.Forward = -1 end
	if input.KeyCode == Enum.KeyCode.A then movement.Right = -1 end
	if input.KeyCode == Enum.KeyCode.D then movement.Right = 1 end
end

local function onInputEnded(input)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
		movement.Forward = 0
	elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
		movement.Right = 0
	end
end

-- Start flying
local function startFlying()
	if flying then return end
	flying = true

	if not isMobile then
		UIS.InputBegan:Connect(onInput)
		UIS.InputEnded:Connect(onInputEnded)
	end

	flyConnection = RunService.RenderStepped:Connect(function()
		character = player.Character or player.CharacterAdded:Wait()
		hrp = character:WaitForChild("HumanoidRootPart")

		local camera = workspace.CurrentCamera
		local moveVector = (camera.CFrame.lookVector * movement.Forward + camera.CFrame.RightVector * movement.Right)
		hrp.Velocity = moveVector * 50
	end)
end

-- Stop flying
local function stopFlying()
	flying = false
	movement = { Forward = 0, Right = 0 }

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if hrp then
		hrp.Velocity = Vector3.zero
	end
end

-- Mobile Button UI
local mobileButton
local function createMobileButton()
	if not isMobile then return end

	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "FlyButtonGUI"

	mobileButton = Instance.new("TextButton", screenGui)
	mobileButton.Size = UDim2.new(0, 100, 0, 40)
	mobileButton.Position = UDim2.new(1, -110, 1, -100)
	mobileButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	mobileButton.Text = "🛫 Fly"
	mobileButton.TextColor3 = Color3.new(1, 1, 1)
	mobileButton.TextSize = 18
	mobileButton.Font = Enum.Font.SourceSansBold

	mobileButton.MouseButton1Click:Connect(function()
		if flying then
			stopFlying()
			mobileButton.Text = "🛫 Fly"
		else
			startFlying()
			mobileButton.Text = "🛑 Stop"
		end
	end)
end

-- Public API
local module = {}

function module.Enable()
	startFlying()
	if isMobile and not mobileButton then
		createMobileButton()
	end
end

function module.Disable()
	stopFlying()
	if mobileButton then
		mobileButton.Text = "🛫 Fly"
	end
end

return module
