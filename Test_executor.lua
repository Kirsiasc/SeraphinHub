-- RONIX ANDROID STYLE EXECUTOR UI by Kirsia
-- Full Custom UI System (No External Library)

local RonixUI = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonixAndroidUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 400)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- UICorner
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Drop shadow (Glow effect)
local shadow = Instance.new("ImageLabel", MainFrame)
shadow.ZIndex = -1
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.fromRGB(80, 80, 150)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Left Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Sidebar Title
local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "RONIX\nANDROID"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Sidebar Buttons
local buttons = {"Search", "Editor", "Folder", "Config", "Close"}
local selectedButton = nil

for i, name in ipairs(buttons) do
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, -30, 0, 40)
	btn.Position = UDim2.new(0, 15, 0, 70 + (i - 1) * 50)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 16
	btn.Font = Enum.Font.Gotham
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		if btn ~= selectedButton then
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		end
	end)
	btn.MouseLeave:Connect(function()
		if btn ~= selectedButton then
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		end
	end)
	btn.MouseButton1Click:Connect(function()
		if selectedButton then
			selectedButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		end
		selectedButton = btn
		btn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
		RonixUI:ShowTab(name)
	end)
end

-- Right Content Panel
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -200, 1, -20)
Content.Position = UDim2.new(0, 190, 0, 10)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

-- Tabs Row
local TabRow = Instance.new("Frame", Content)
TabRow.Size = UDim2.new(1, -20, 0, 40)
TabRow.Position = UDim2.new(0, 10, 0, 10)
TabRow.BackgroundTransparency = 1

local Tabs = {"Server", "Auto Execute", "Console"}
local ActiveTab = nil
local TabContents = {}

for i, tabName in ipairs(Tabs) do
	local tabBtn = Instance.new("TextButton", TabRow)
	tabBtn.Size = UDim2.new(0, 120, 1, 0)
	tabBtn.Position = UDim2.new(0, (i - 1) * 130, 0, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	tabBtn.Text = tabName
	tabBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
	tabBtn.Font = Enum.Font.GothamSemibold
	tabBtn.TextSize = 14
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

	local tabFrame = Instance.new("Frame", Content)
	tabFrame.Size = UDim2.new(1, -20, 1, -60)
	tabFrame.Position = UDim2.new(0, 10, 0, 50)
	tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	tabFrame.Visible = false
	Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 10)

	TabContents[tabName] = tabFrame

	tabBtn.MouseButton1Click:Connect(function()
		for _, f in pairs(TabContents) do f.Visible = false end
		tabFrame.Visible = true
		if ActiveTab then
			ActiveTab.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
		end
		tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
		ActiveTab = tabBtn
	end)
end

-- Example content: Server Tab
local serverTab = TabContents["Server"]
local title = Instance.new("TextLabel", serverTab)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Server Hop"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Position = UDim2.new(0, 10, 0, 10)
title.TextXAlignment = Enum.TextXAlignment.Left

local desc = Instance.new("TextLabel", serverTab)
desc.Size = UDim2.new(1, -20, 0, 40)
desc.Position = UDim2.new(0, 10, 0, 40)
desc.TextWrapped = true
desc.Text = "Starts a New Session, switches Servers."
desc.TextColor3 = Color3.fromRGB(180, 180, 180)
desc.BackgroundTransparency = 1
desc.Font = Enum.Font.Gotham
desc.TextSize = 14
desc.TextXAlignment = Enum.TextXAlignment.Left

local btn1 = Instance.new("TextButton", serverTab)
btn1.Size = UDim2.new(0, 200, 0, 35)
btn1.Position = UDim2.new(0, 10, 0, 90)
btn1.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
btn1.Text = "Server Hop"
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.Font = Enum.Font.GothamBold
btn1.TextSize = 14
Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 6)
btn1.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local btn2 = btn1:Clone()
btn2.Parent = serverTab
btn2.Text = "Rejoin Server"
btn2.Position = UDim2.new(0, 10, 0, 135)
btn2.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

-- Default Tab
TabContents["Server"].Visible = true

function RonixUI:ShowTab(name)
	print("Opened sidebar tab:", name)
end

print("✅ Ronix Android UI Loaded Successfully.")
