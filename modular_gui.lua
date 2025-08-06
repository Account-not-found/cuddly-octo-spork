-- Custom Modular UI Framework (Rayfield-style layout)
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ScriptHubUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "🌐 Cuddly Octo Spork Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 18

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Padding = UDim.new(0, 5)

-- Button factory
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buttons
local function addModules()
    local mods = {
        {name = "🧲 ESP", script = "esp"},
        {name = "🚀 Fly", script = "fly"},
        {name = "🚪 Noclip", script = "noclip"},
        {name = "🛡️ Anti-AFK", script = "antiafk"},
    }

    for _, mod in ipairs(mods) do
        local btn = createButton(mod.name, function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/main/modules/"..mod.script..".lua"))()
        end)
        btn.Parent = MainFrame
    end
end

addModules()
