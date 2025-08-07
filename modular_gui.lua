-- modular_gui_pro.lua
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptHubProUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle Button (Floating)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -100)
toggleBtn.Text = "📂 Open Script Hub"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = true
toggleBtn.Draggable = true
toggleBtn.Active = true
toggleBtn.Parent = gui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 350)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Topbar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.Text = "🧠 Script Hub Pro"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 18
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.Text = "✖"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

-- Scrollable Container
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -100)
container.Position = UDim2.new(0, 10, 0, 50)
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.ScrollBarThickness = 6
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- Status Console
local statusLog = Instance.new("TextLabel")
statusLog.Size = UDim2.new(1, -20, 0, 30)
statusLog.Position = UDim2.new(0, 10, 1, -35)
statusLog.BackgroundTransparency = 1
statusLog.Text = "⚙️ Ready"
statusLog.TextColor3 = Color3.fromRGB(140, 255, 140)
statusLog.TextSize = 16
statusLog.Font = Enum.Font.Gotham
statusLog.TextXAlignment = Enum.TextXAlignment.Left
statusLog.Parent = mainFrame

-- Toggle UI visibility
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggleBtn.Text = mainFrame.Visible and "📕 Close Script Hub" or "📂 Open Script Hub"
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	toggleBtn.Text = "📂 Open Script Hub"
end)

-- Utility: Create Module Button
local function createModuleButton(name, url)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.BorderSizePixel = 0
	btn.Text = "▶ " .. name
	btn.AutoButtonColor = true
	btn.Parent = container

	local enabled = false

	btn.MouseButton1Click:Connect(function()
		if not enabled then
			local success, result = pcall(function()
				loadstring(game:HttpGet(url))()
			end)
			if success then
				enabled = true
				btn.Text = "✔ " .. name
				btn.BackgroundColor3 = Color3.fromRGB(35, 80, 35)
				statusLog.Text = "✅ Loaded: " .. name
			else
				statusLog.Text = "❌ Error loading " .. name
			end
		else
			-- toggle off logic if module supports it
			enabled = false
			btn.Text = "▶ " .. name
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			statusLog.Text = "🔁 Toggled off: " .. name
		end
	end)
end

-- Your Modules (update with your URLs)
local modules = {
	{ name = "ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua" },
	{ name = "Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua" },
	{ name = "Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua" },
	{ name = "Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua" },
	{ name = "Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua" },
	{ name = "Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua" },
}

-- Load Buttons
for _, mod in ipairs(modules) do
	createModuleButton(mod.name, mod.url)
end
