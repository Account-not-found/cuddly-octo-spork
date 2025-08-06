-- key_system.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "KeySystemUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🔐 Enter Key to Unlock"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local TextBox = Instance.new("TextBox", Frame)
TextBox.PlaceholderText = "Enter your key here"
TextBox.Size = UDim2.new(1, -40, 0, 40)
TextBox.Position = UDim2.new(0, 20, 0, 60)
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 18
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.BorderSizePixel = 0

local Submit = Instance.new("TextButton", Frame)
Submit.Text = "Submit Key"
Submit.Size = UDim2.new(1, -40, 0, 30)
Submit.Position = UDim2.new(0, 20, 0, 110)
Submit.Font = Enum.Font.SourceSansBold
Submit.TextSize = 18
Submit.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Submit.TextColor3 = Color3.new(1, 1, 1)
Submit.BorderSizePixel = 0

local CopyLink = Instance.new("TextButton", Frame)
CopyLink.Text = "📋 Copy Link to Get Key"
CopyLink.Size = UDim2.new(1, -40, 0, 25)
CopyLink.Position = UDim2.new(0, 20, 0, 150)
CopyLink.Font = Enum.Font.SourceSans
CopyLink.TextSize = 16
CopyLink.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CopyLink.TextColor3 = Color3.new(1, 1, 1)
CopyLink.BorderSizePixel = 0

CopyLink.MouseButton1Click:Connect(function()
    setclipboard("https://link-target.net/1378758/zRY17zAZVmKy")
end)

Submit.MouseButton1Click:Connect(function()
    local userKey = TextBox.Text
    local success, response = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/fQrQSBH2")
    end)

    if success and response then
        local verified = false
        for key in response:gmatch("[^\r\n]+") do
            if userKey:lower():gsub("%s+", "") == key:lower():gsub("%s+", "") then
                verified = true
                break
            end
        end

        if verified then
            ScreenGui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/ui/modular_gui.lua"))()
        else
            TextBox.Text = "❌ Invalid key!"
        end
    else
        TextBox.Text = "⚠️ Could not fetch keys!"
    end
end)
