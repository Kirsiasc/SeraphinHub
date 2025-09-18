local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
    print("✓ UI loaded successfully")
end

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Arsenal",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.1.0",
    Color = Color3.fromRGB(180,0,255)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Arsenal script loaded!",
    Duration = 3,
    Icon = "bell",
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Tab1 = Window:Tab({ Title = "Home", Icon = "house" })
Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

local Tab2 = Window:Tab({ Title = "Combat", Icon = "sword" })

Tab2:Toggle({
    Title = "Silent Aim",
    Default = false,
    Callback = function(state)
        _G.SilentAim = state
    end
})

Tab2:Toggle({
    Title = "Aimbot",
    Default = false,
    Callback = function(state)
        _G.Aimbot = state
    end
})

RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local nearest, dist = nil, math.huge
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pos,vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                    if mag < dist then
                        dist = mag
                        nearest = plr
                    end
                end
            end
        end
        if nearest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, nearest.Character.HumanoidRootPart.Position)
        end
    end
end)

Tab2:Toggle({
    Title = "Auto Aim",
    Default = false,
    Callback = function(state)
        _G.AutoAim = state
    end
})

Tab2:Toggle({
    Title = "No Recoil",
    Default = false,
    Callback = function(state)
        _G.NoRecoil = state
    end
})

Tab2:Toggle({
    Title = "No Spread",
    Default = false,
    Callback = function(state)
        _G.NoSpread = state
    end
})

Tab2:Toggle({
    Title = "Teleport to Enemy",
    Default = false,
    Callback = function(state)
        _G.TeleportEnemy = state
        task.spawn(function()
            while _G.TeleportEnemy do
                task.wait(1)
                local nearest,dist = nil,math.huge
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if mag < dist then
                            dist = mag
                            nearest = plr
                        end
                    end
                end
                if nearest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                end
            end
        end)
    end
})

local knifeRange = 10
Tab2:Input({
    Title = "Knife Range",
    Value = "10",
    Callback = function(val)
        local num = tonumber(val)
        if num then knifeRange = num end
    end
})

Tab2:Toggle({
    Title = "Auto Knife",
    Default = false,
    Callback = function(state)
        _G.AutoKnife = state
        task.spawn(function()
            while _G.AutoKnife do
                task.wait(0.2)
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if mag <= knifeRange then
                            mouse1click()
                        end
                    end
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({ Title = "Visuals", Icon = "eye" })

local function addESP(player)
    if player == LocalPlayer or player.Team == LocalPlayer.Team then return end
    local char = player.Character or player.CharacterAdded:Wait()

    if not char:FindFirstChild("SeraphinESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "SeraphinESP"
        highlight.FillColor = Color3.fromRGB(180,0,255)
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.Parent = char
    end

    if not char:FindFirstChild("BillboardGui") then
        local billboard = Instance.new("BillboardGui", char)
        billboard.Name = "ESPBillboard"
        billboard.Size = UDim2.new(0,200,0,50)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0,3,0)

        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size = UDim2.new(1,0,0.5,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(180,0,255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 14
        nameLabel.Text = player.Name

        local infoLabel = Instance.new("TextLabel", billboard)
        infoLabel.Size = UDim2.new(1,0,0.5,0)
        infoLabel.Position = UDim2.new(0,0,0.5,0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
        infoLabel.TextStrokeTransparency = 0
        infoLabel.Font = Enum.Font.SourceSansBold
        infoLabel.TextSize = 12

        RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hum = player.Character.Humanoid
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                infoLabel.Text = "HP: "..math.floor(hum.Health).. " | "..dist.." studs"
            end
        end)
    end
end

Tab3:Toggle({
    Title = "ESP",
    Default = false,
    Callback = function(state)
        _G.ESPEnabled = state
        if state then
            for _,plr in pairs(Players:GetPlayers()) do
                addESP(plr)
            end
        else
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("SeraphinESP") then
                    plr.Character.SeraphinESP:Destroy()
                end
                if plr.Character and plr.Character:FindFirstChild("ESPBillboard") then
                    plr.Character.ESPBillboard:Destroy()
                end
            end
        end
    end
})

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if _G.ESPEnabled then
            addESP(plr)
        end
    end)
end)

local Tab4 = Window:Tab({ Title = "Movement", Icon = "move" })
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Tab4:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(val)
        local spd = tonumber(val)
        if spd and spd >= 16 then Humanoid.WalkSpeed = spd end
    end
})

Tab4:Input({
    Title = "JumpPower",
    Value = "50",
    Callback = function(val)
        local jp = tonumber(val)
        if jp then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = jp
        end
    end
})

Tab4:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab4:Toggle({
    Title = "Fly",
    Default = false,
    Callback = function(state)
        _G.Fly = state
        task.spawn(function()
            while _G.Fly do
                task.wait()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * 50
                end
            end
        end)
    end
})

local Tab5 = Window:Tab({ Title = "Settings", Icon = "settings" })

Tab5:Toggle({
    Title = "AntiAFK",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
})

Tab5:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        task.spawn(function()
            while _G.AutoReconnect do
                task.wait(2)
                local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if reconnectUI then
                    local prompt = reconnectUI:FindFirstChild("promptOverlay")
                    if prompt then
                        local button = prompt:FindFirstChild("ButtonPrimary")
                        if button and button.Visible then
                            firesignal(button.MouseButton1Click)
                        end
                    end
                end
            end
        end)
    end
})

Tab5:Colorpicker({
    Title = "UI Color",
    Default = Color3.fromRGB(180,0,255),
    Transparency = 0,
    Callback = function(color)
        print("UI Color changed:", color)
    end
})
