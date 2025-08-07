-- Modular GUI Script Hub (v3.1) - Savant Coded Edition
-- Includes single-click toggles, shift-lock fly, modular system, and mobile support

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- MAIN UI SETUP
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModularScriptHub"
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://77339698"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 460, 0, 340)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🧠 Modular Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 22

local ButtonContainer = Instance.new("ScrollingFrame", MainFrame)
ButtonContainer.Size = UDim2.new(1, -20, 1, -65)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 4
ButtonContainer.BackgroundTransparency = 1

local UIGrid = Instance.new("UIGridLayout", ButtonContainer)
UIGrid.CellSize = UDim2.new(0, 200, 0, 40)
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.SortOrder = Enum.SortOrder.LayoutOrder

-- Module states
local activeModules = {}

-- BUTTON CREATION FUNCTION
local function createModuleToggle(name, url)
	local button = Instance.new("TextButton", ButtonContainer)
	button.Text = name
	button.Font = Enum.Font.Gotham
	button.TextSize = 17
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.BorderSizePixel = 0
	button.AutoButtonColor = true

	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 6)

	local highlight = Instance.new("Frame", button)
	highlight.Size = UDim2.new(0, 6, 1, 0)
	highlight.Position = UDim2.new(1, -6, 0, 0)
	highlight.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	highlight.Visible = false
	local corner2 = Instance.new("UICorner", highlight)
	corner2.CornerRadius = UDim.new(0, 3)

	button.MouseButton1Click:Connect(function()
		local isEnabled = activeModules[url]
		if isEnabled then
			activeModules[url] = false
			highlight.Visible = false
			if _G.Modules and _G.Modules[url] and _G.Modules[url].Disable then
				pcall(_G.Modules[url].Disable)
			end
		else
			activeModules[url] = true
			highlight.Visible = true
			task.spawn(function()
				local success, err = pcall(function()
					local scriptFunc = loadstring(game:HttpGet(url))()
					_G.Modules = _G.Modules or {}
					_G.Modules[url] = scriptFunc or {}
				end)
				if not success then
					warn("[Module Error] "..name..": "..err)
				end
			end)
		end
	end)
end

-- MODULES
local Modules = {
	{name = "👁️ ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
	{name = "🕊️ Fly (Shift-Lock)", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
	{name = "🪞 Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
	{name = "🔁 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
	{name = "🌀 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
	{name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
	{name = "🎮 Game Script", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/games/default.lua"},
}

for _, mod in ipairs(Modules) do
	createModuleToggle(mod.name, mod.url)
end

-- TOGGLE BUTTON LOGIC
local open = true
ToggleButton.MouseButton1Click:Connect(function()
	open = not open
	MainFrame.Visible = open
	local tween = TweenService:Create(
		ToggleButton,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Rotation = open and 0 or 180}
	)
	tween:Play()
end)
