-- 📱 Roblox Android Executor (Fixed & Optimized)
local RobloxExecutor = {}

-- Check environment
function RobloxExecutor:IsRoblox()
    return typeof(game) == "Instance" and game:GetService("Players") ~= nil
end

function RobloxExecutor:Init()
    if not self:IsRoblox() then
        warn("❌ Not in Roblox environment!")
        return
    end

    print("📱 Initializing Roblox Android Executor...")
    self:CreateGUI()
    self:LoadScripts()
    self.ScreenGui.Enabled = true
end

function RobloxExecutor:CreateGUI()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AndroidExecutor"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 400, 0, 550)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    self.MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    self.MainFrame.BorderSizePixel = 2
    self.MainFrame.Parent = self.ScreenGui

    -- Drag Function
    local dragging, dragInput, dragStart, startPos
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)

    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    self.MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.Parent = self.MainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "📱 ROBLOX ANDROID EXECUTOR"
    titleText.TextColor3 = Color3.fromRGB(0, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 16
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = false
    end)

    -- Script Editor
    self.Editor = Instance.new("TextBox")
    self.Editor.Size = UDim2.new(1, -20, 0, 200)
    self.Editor.Position = UDim2.new(0, 10, 0, 60)
    self.Editor.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    self.Editor.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Editor.TextSize = 14
    self.Editor.MultiLine = true
    self.Editor.TextWrapped = true
    self.Editor.Font = Enum.Font.Code
    self.Editor.TextYAlignment = Enum.TextYAlignment.Top
    self.Editor.Text = "-- Roblox Android Executor Ready!\nprint('📱 Hello Mobile User!')"
    self.Editor.Parent = self.MainFrame

    -- Execute Button
    self.ExecuteBtn = Instance.new("TextButton")
    self.ExecuteBtn.Size = UDim2.new(0.45, 0, 0, 40)
    self.ExecuteBtn.Position = UDim2.new(0.05, 0, 0, 280)
    self.ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    self.ExecuteBtn.Text = "🚀 EXECUTE"
    self.ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
    self.ExecuteBtn.TextSize = 16
    self.ExecuteBtn.Parent = self.MainFrame
    self.ExecuteBtn.MouseButton1Click:Connect(function()
        self:ExecuteScript()
    end)

    -- Clear Button
    self.ClearBtn = Instance.new("TextButton")
    self.ClearBtn.Size = UDim2.new(0.45, 0, 0, 40)
    self.ClearBtn.Position = UDim2.new(0.5, 0, 0, 280)
    self.ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    self.ClearBtn.Text = "🗑️ CLEAR"
    self.ClearBtn.TextColor3 = Color3.new(1, 1, 1)
    self.ClearBtn.TextSize = 16
    self.ClearBtn.Parent = self.MainFrame
    self.ClearBtn.MouseButton1Click:Connect(function()
        self.Editor.Text = ""
    end)

    -- Status
    self.StatusBar = Instance.new("TextLabel")
    self.StatusBar.Size = UDim2.new(1, -20, 0, 25)
    self.StatusBar.Position = UDim2.new(0, 10, 0, 330)
    self.StatusBar.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
    self.StatusBar.Text = "✅ Executor Ready!"
    self.StatusBar.TextColor3 = Color3.fromRGB(0, 255, 0)
    self.StatusBar.TextSize = 14
    self.StatusBar.Font = Enum.Font.Gotham
    self.StatusBar.Parent = self.MainFrame
end

function RobloxExecutor:LoadScripts()
    -- (you can add your script list here later)
end

function RobloxExecutor:ExecuteScript()
    local code = self.Editor.Text
    if code == "" then
        self.StatusBar.Text = "⚠️ No script to execute!"
        return
    end

    local success, result = pcall(function()
        local fn = loadstring(code)
        if fn then return fn() end
    end)

    if success then
        self.StatusBar.Text = "✅ Script executed successfully!"
    else
        self.StatusBar.Text = "❌ Error: " .. tostring(result)
    end
end

function RobloxExecutor:Toggle()
    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
end

-- Initialize
if RobloxExecutor:IsRoblox() then
    RobloxExecutor:Init()
    getgenv().ToggleExecutor = function()
        RobloxExecutor:Toggle()
    end
    print("📱 ROBLOX ANDROID EXECUTOR LOADED! Use ToggleExecutor() to open/close.")
else
    warn("❌ This script can only run in Roblox environment.")
end
