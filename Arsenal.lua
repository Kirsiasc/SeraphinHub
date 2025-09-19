local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
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
    Title = "v0.0.1",
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
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Home = Window:Tab({ Title = "Home", Icon = "house" })

Home:Button({
    Title = "Discord",
    Desc = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

local Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

Combat:Toggle({
    Title = "Silent Aim",
    Default = false,
    Callback = function(state)
        _G.SilentAim = state
    end
})

Combat:Toggle({
    Title = "Aimbot",
    Default = false,
    Callback = function(state)
        _G.Aimbot = state
    end
})

Combat:Toggle({
    Title = "Auto Aim (Head)",
    Default = false,
    Callback = function(state)
        _G.AutoAim = state
        if state then
            task.spawn(function()
                while _G.AutoAim do
                    task.wait()
                    local closestPlayer, closestDistance = nil, math.huge
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                    
                    if closestPlayer and closestPlayer.Character then
                        local targetHead = closestPlayer.Character:FindFirstChild("Head")
                        if targetHead then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                        end
                    end
                end
            end)
        end
    end
})

Combat:Toggle({
    Title = "No Recoil",
    Default = false,
    Callback = function(state)
        _G.NoRecoil = state
    end
})

Combat:Toggle({
    Title = "No Spread",
    Default = false,
    Callback = function(state)
        _G.NoSpread = state
    end
})

Combat:Toggle({
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

Combat:Input({
    Title = "Knife Range",
    Value = "10",
    Callback = function(val)
        local num = tonumber(val)
        if num then knifeRange = num end
    end
})

Combat:Toggle({
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
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end
                end
            end
        end)
    end
})

local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })

Visuals:Toggle({
    Title = "ESP Highlight",
    Default = false,
    Callback = function(state)
        if state then
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    if not char:FindFirstChild("SeraphinESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "SeraphinESP_HL"
                        hl.FillColor = Color3.fromRGB(180,0,255)
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        hl.Parent = char
                    end
                end
            end
        else
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("SeraphinESP_HL") then
                    plr.Character.SeraphinESP_HL:Destroy()
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Name",
    Default = false,
    Callback = function(state)
        if state then
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    if not char:FindFirstChild("SeraphinESP_Name") then
                        local billboard = Instance.new("BillboardGui", char)
                        billboard.Name = "SeraphinESP_Name"
                        billboard.Size = UDim2.new(0,200,0,50)
                        billboard.AlwaysOnTop = true
                        billboard.StudsOffset = Vector3.new(0,3,0)

                        local nameLabel = Instance.new("TextLabel", billboard)
                        nameLabel.Size = UDim2.new(1,0,1,0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(180,0,255)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextSize = 14
                        nameLabel.Text = plr.Name
                    end
                end
            end
        else
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("SeraphinESP_Name") then
                    plr.Character.SeraphinESP_Name:Destroy()
                end
            end
        end
    end
})

local Movement = Window:Tab({ Title = "Movement", Icon = "move" })

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Movement:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(val)
        local spd = tonumber(val)
        if spd and spd >= 16 then Humanoid.WalkSpeed = spd end
    end
})

Movement:Input({
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

Movement:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Movement:Toggle({
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

local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

Settings:Toggle({
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

Settings:Toggle({
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
                        local button = prompt:FindFirstChild("ErrorPrompt")
                        if button then
                            local confirmButton = button:FindFirstChild("ConfirmButton")
                            if confirmButton then
                                firesignal(confirmButton.MouseButton1Click)
                            end
                        end
                    end
                end
            end
        end)
    end
})

Settings:Colorpicker({
    Title = "UI Color",
    Default = Color3.fromRGB(180,0,255),
    Transparency = 0,
    Callback = function(color)
        print("UI Color changed:", color)
    end
})

task.spawn(function()
    while true do
        task.wait()
        if _G.Aimbot then
            local closestPlayer, closestDistance = nil, math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character then
                local targetHead = closestPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    local mouse = LocalPlayer:GetMouse()
                    if mouse then
                        mouse.TargetFilter = targetHead
                    end
                end
            end
        end
    end
end)
