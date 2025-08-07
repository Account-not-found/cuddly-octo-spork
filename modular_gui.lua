-- Modern Script Hub GUI (Savvy Programmer Style)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local accentColor = Color3.fromRGB(0, 170, 255) -- Change for different feel

local Modules = {
	{name = "🔍 ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
	{name = "🚀 Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
	{name = "🕳️ Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
	{name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
	{name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
	{name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ModularScriptHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 360)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 6)

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Thickness = 2
UIStroke.Color = accentColor
UIStroke.Transparency = 0.2

-- Title
local Title = Instance.new("TextLabel", mainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🧠 Modular Script Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = accentColor

-- Container
local ButtonContainer = Instance.new("Frame", mainFrame)
ButtonContainer.Size = UDim2.new(1, 0, 1, -50)
ButtonContainer.Position = UDim2.new(0, 0, 0, 45)
ButtonContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ButtonContainer)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle states
local ToggleStates = {}

-- Button Creator
local function createModuleButton(mod)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -20, 0, 36)
	holder.BackgroundTransparency = 1
	holder.Parent = ButtonContainer

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Text = "▶ " .. mod.name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.AutoButtonColor = true
	button.Parent = holder
	button.BorderSizePixel = 0

	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 4)

	local status = Instance.new("Frame", button)
	status.Size = UDim2.new(0, 6, 1, 0)
	status.Position = UDim2.new(0, 0, 0, 0)
	status.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	status.BorderSizePixel = 0
	Instance.new("UICorner", status).CornerRadius = UDim.new(0, 2)

	ToggleStates[mod.name] = false

	button.MouseButton1Click:Connect(function()
		local toggled = not ToggleStates[mod.name]
		ToggleStates[mod.name] = toggled
		button.Text = (toggled and "✅ " or "▶ ") .. mod.name
		status.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)

		local success, err = pcall(function()
			loadstring(game:HttpGet(mod.url))()
		end)

		if not success then
			status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			warn("Error in " .. mod.name .. ": " .. tostring(err))
		end
	end)
end

-- Create all module buttons
for _, mod in ipairs(Modules) do
	createModuleButton(mod)
end

-- Toggle button
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0.5, -60, 1, -40)
toggleButton.Text = "🧠 Open Script Hub"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BorderSizePixel = 0

Instance.new("UICorner", toggleButton)

local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	mainFrame.Visible = isOpen
	toggleButton.Text = isOpen and "🧠 Close Script Hub" or "🧠 Open Script Hub"
end)
