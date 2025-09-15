local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FakeExecutor"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Text = "Seraphin Executor"

local Editor = Instance.new("TextBox", Main)
Editor.Size = UDim2.new(1, -20, 1, -70)
Editor.Position = UDim2.new(0, 10, 0, 40)
Editor.MultiLine = true
Editor.ClearTextOnFocus = false
Editor.TextXAlignment = Enum.TextXAlignment.Left
Editor.TextYAlignment = Enum.TextYAlignment.Top
Editor.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Editor.TextColor3 = Color3.fromRGB(200, 200, 200)
Editor.Font = Enum.Font.Code
Editor.TextSize = 14
Editor.Text = "-- Ketik script di sini"

local RunBtn = Instance.new("TextButton", Main)
RunBtn.Size = UDim2.new(0, 80, 0, 28)
RunBtn.Position = UDim2.new(1, -90, 1, -35)
RunBtn.Text = "Execute"
RunBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.Font = Enum.Font.SourceSansBold
RunBtn.TextSize = 16

RunBtn.MouseButton1Click:Connect(function()
    local code = Editor.Text
    print("Test")
    print(code)

    local s = Instance.new("LocalScript")
    s.Source = code
    s.Parent = Player.PlayerGui
end)
