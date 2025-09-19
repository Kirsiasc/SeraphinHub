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
    Color = Color3.fromRGB(180, 0, 255)
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

local Info = Window:Tab({ Title = "Info", Icon = "info" })

Info:Section({ 
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Info:Button({
    Title = "Discord",
    Desc = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Info:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

Combat:Section({ 
    Title = "Auto Aim",
    TextXAlignment = "Left",
    TextSize = 17,
})

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

Combat:Section({ 
    Title = "No delay [Need Update]",
    TextXAlignment = "Left",
    TextSize = 17,
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

Combat:Section({ 
    Title = "Attack",
    TextXAlignment = "Left",
    TextSize = 17,
})

Combat:Toggle({
    Title = "Teleport to Enemy",
    Default = false,
    Callback = function(state)
        _G.TeleportEnemy = state
        task.spawn(function()
            while _G.TeleportEnemy do
                task.wait(1)
                local nearest, dist = nil, math.huge
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if mag < dist then
                            dist = mag
                            nearest = plr
                        end
                    end
                end
                if nearest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
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
                for _, plr in pairs(Players:GetPlayers()) do
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
        _G.ESPHighlight = state
        if state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    if not char:FindFirstChild("SeraphinESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "SeraphinESP_HL"
                        hl.FillColor = Color3.fromRGB(180, 0, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = char
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
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
        _G.ESPName = state
        if state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    if not char:FindFirstChild("SeraphinESP_Name") then
                        local billboard = Instance.new("BillboardGui", char)
                        billboard.Name = "SeraphinESP_Name"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.StudsOffset = Vector3.new(0, 3, 0)

                        local nameLabel = Instance.new("TextLabel", billboard)
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(180, 0, 255)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextSize = 14
                        nameLabel.Text = plr.Name
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("SeraphinESP_Name") then
                    plr.Character.SeraphinESP_Name:Destroy()
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Studs",
    Default = false,
    Callback = function(state)
        _G.ESPStuds = state
        if state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    if not char:FindFirstChild("SeraphinESP_Studs") then
                        local billboard = Instance.new("BillboardGui", char)
                        billboard.Name = "SeraphinESP_Studs"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.StudsOffset = Vector3.new(0, 5, 0)

                        local infoLabel = Instance.new("TextLabel", billboard)
                        infoLabel.Size = UDim2.new(1, 0, 1, 0)
                        infoLabel.BackgroundTransparency = 1
                        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        infoLabel.TextStrokeTransparency = 0
                        infoLabel.Font = Enum.Font.SourceSansBold
                        infoLabel.TextSize = 12
                        infoLabel.Text = "0 studs"
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("SeraphinESP_Studs") then
                    plr.Character.SeraphinESP_Studs:Destroy()
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Line",
    Default = false,
    Callback = function(state)
        _G.ESPLine = state
    end
})

Visuals:Toggle({
    Title = "ESP Box",
    Default = false,
    Callback = function(state)
        _G.ESPBox = state
    end
})

local PlayersTab = Window:Tab({ Title = "Players", Icon = "user" })
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

PlayersTab:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(val)
        local spd = tonumber(val)
        if spd and spd >= 16 then Humanoid.WalkSpeed = spd end
    end
})

PlayersTab:Input({
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

PlayersTab:Toggle({
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

PlayersTab:Toggle({
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
                        local errorPrompt = prompt:FindFirstChild("ErrorPrompt")
                        if errorPrompt then
                            local confirmButton = errorPrompt:FindFirstChild("ConfirmButton")
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
    Default = Color3.fromRGB(180, 0, 255),
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
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                end
            end
        end
    end
end)

task.spawn(function()
    local ESPLines = {}
    local ESPBoxes = {}
    
    RunService.RenderStepped:Connect(function()
        if _G.ESPStuds then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("SeraphinESP_Studs") then
                        local studsGui = character:FindFirstChild("SeraphinESP_Studs")
                        if studsGui then
                            local infoLabel = studsGui:FindFirstChild("TextLabel")
                            if infoLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude)
                                infoLabel.Text = dist .. " studs"
                            end
                        end
                    end
                end
            end
        end
        
        if _G.ESPLine then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        if not ESPLines[player] then
                            ESPLines[player] = Drawing.new("Line")
                            ESPLines[player].Color = Color3.fromRGB(180, 0, 255)
                            ESPLines[player].Thickness = 2
                            ESPLines[player].Transparency = 1
                        end
                        
                        local rootPos, visible = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                        if visible then
                            ESPLines[player].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            ESPLines[player].To = Vector2.new(rootPos.X, rootPos.Y)
                            ESPLines[player].Visible = true
                        else
                            ESPLines[player].Visible = false
                        end
                    end
                end
            end
        else
            for player, line in pairs(ESPLines) do
                if line then
                    line:Remove()
                    ESPLines[player] = nil
                end
            end
        end
        
        if _G.ESPBox then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                        if not ESPBoxes[player] then
                            ESPBoxes[player] = {
                                TopLeft = Drawing.new("Line"),
                                TopRight = Drawing.new("Line"),
                                BottomLeft = Drawing.new("Line"),
                                BottomRight = Drawing.new("Line"),
                                Color = Color3.fromRGB(180, 0, 255)
                            }
                            
                            for _, line in pairs(ESPBoxes[player]) do
                                if typeof(line) == "table" then continue end
                                line.Color = ESPBoxes[player].Color
                                line.Thickness = 2
                                line.Transparency = 1
                            end
                        end
                        
                        local rootPos, rootVisible = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                        local headPos, headVisible = Camera:WorldToViewportPoint(character.Head.Position)
                        
                        if rootVisible and headVisible then
                            local height = math.abs(headPos.Y - rootPos.Y) * 2
                            local width = height * 0.6
                            
                            local topLeft = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                            local topRight = Vector2.new(rootPos.X + width/2, rootPos.Y - height/2)
                            local bottomLeft = Vector2.new(rootPos.X - width/2, rootPos.Y + height/2)
                            local bottomRight = Vector2.new(rootPos.X + width/2, rootPos.Y + height/2)
                            
                            ESPBoxes[player].TopLeft.From = topLeft
                            ESPBoxes[player].TopLeft.To = topRight
                            ESPBoxes[player].TopRight.From = topRight
                            ESPBoxes[player].TopRight.To = bottomRight
                            ESPBoxes[player].BottomLeft.From = bottomLeft
                            ESPBoxes[player].BottomLeft.To = bottomRight
                            ESPBoxes[player].BottomRight.From = bottomLeft
                            ESPBoxes[player].BottomRight.To = topLeft
                            
                            for _, line in pairs(ESPBoxes[player]) do
                                if typeof(line) == "table" then continue end
                                line.Visible = true
                            end
                        else
                            for _, line in pairs(ESPBoxes[player]) do
                                if typeof(line) == "table" then continue end
                                line.Visible = false
                            end
                        end
                    end
                end
            end
        else
            for player, box in pairs(ESPBoxes) do
                for _, line in pairs(box) do
                    if typeof(line) == "table" then continue end
                    if line then
                        line:Remove()
                    end
                end
                ESPBoxes[player] = nil
            end
        end
    end)
end)
