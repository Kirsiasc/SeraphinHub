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
    Title = "v0.0.0.4",
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

local hitboxEnabled = false
Combat:Toggle({
    Title = "Hitbox Extender",
    Default = false,
    Callback = function(v)
        hitboxEnabled = v
        if v then
            task.spawn(function()
                while hitboxEnabled do
                    task.wait(0.5)
                    for _, enemy in pairs(Players:GetPlayers()) do
                        if enemy.Team ~= LocalPlayer.Team and enemy.Character and enemy.Character:FindFirstChild("Head") then
                            local head = enemy.Character.Head
                            if not head:FindFirstChild("HitboxNeon") then
                                local adorn = Instance.new("BoxHandleAdornment")
                                adorn.Name = "HitboxNeon"
                                adorn.Adornee = head
                                adorn.Parent = head
                                adorn.AlwaysOnTop = true
                                adorn.ZIndex = 5
                                adorn.Size = Vector3.new(5, 5, 5)
                                adorn.Transparency = 0.3
                                adorn.Color3 = Color3.fromRGB(170, 0, 255)
                            end
                            head.Size = Vector3.new(5, 5, 5)
                            head.CanCollide = false
                        end
                    end
                end
                
                for _, enemy in pairs(Players:GetPlayers()) do
                    if enemy.Character and enemy.Character:FindFirstChild("Head") then
                        local head = enemy.Character.Head
                        if head:FindFirstChild("HitboxNeon") then
                            head.HitboxNeon:Destroy()
                        end
                        head.Size = Vector3.new(1, 1, 1)
                    end
                end
            end)
        end
    end
})

_G.KillAura = false

Combat:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(state)
        _G.KillAura = state
    end
})

RunService.Heartbeat:Connect(function()
    if _G.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < 100 then
                    player.Character.Humanoid:TakeDamage(5)
                end
            end
        end
    end
end)

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

local circle = Drawing.new("Circle")
circle.Thickness = 1.5
circle.NumSides = 100
circle.Radius = 70
circle.Filled = false
circle.Color = Color3.fromRGB(170, 0, 255)
circle.Visible = false

Combat:Toggle({
    Title = "Aim Circle",
    Default = false,
    Callback = function(state)
        _G.AimCircle = state
        circle.Visible = state
    end
})

RunService.RenderStepped:Connect(function()
    if _G.AimCircle then
        local mouse = UserInputService:GetMouseLocation()
        circle.Position = Vector2.new(mouse.X, mouse.Y + 36)
    end
end)

_G.TriggerBot = false
local triggerBotRange = 500

Combat:Toggle({
    Title = "Trigger Bot",
    Default = false,
    Callback = function(state)
        _G.TriggerBot = state
        if state then
            task.spawn(function()
                while _G.TriggerBot do
                    task.wait(0.05)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local closestPlayer = nil
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                                    local character = player.Character
                                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                        if distance < triggerBotRange then
                                            local screenPoint, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                                            if onScreen then
                                                closestPlayer = player
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if closestPlayer and closestPlayer.Character then
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                task.wait(0.03)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Combat:Input({
    Title = "Trigger Bot Range",
    Value = "500",
    Callback = function(val)
        local num = tonumber(val)
        if num then triggerBotRange = num end
    end
})

Combat:Section({
    Title = "No delay",
    TextXAlignment = "Left",
    TextSize = 17,
})

_G.NoRecoil = false
_G.NoSpread = false

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

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Tool") then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool:FindFirstChild("CameraRecoil") and _G.NoRecoil then
            tool.CameraRecoil.Value = 0
        end
        if tool:FindFirstChild("Spread") and _G.NoSpread then
            tool.Spread.Value = 0
        end
    end
end)

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

local ESP = {
    Enabled = false,
    Highlight = false,
    Name = false,
    Studs = false,
    Box = false,
    Line = false,
    Players = {},
    Drawings = {},
    Connections = {}
}

local function createDrawing(player, type)
    if not ESP.Drawings[player] then
        ESP.Drawings[player] = {}
    end
    
    if type == "Box" then
        ESP.Drawings[player].Box = Drawing.new("Square")
        ESP.Drawings[player].Box.Thickness = 1
        ESP.Drawings[player].Box.Filled = false
        ESP.Drawings[player].Box.Color = Color3.fromRGB(180, 0, 255)
        ESP.Drawings[player].Box.Visible = false
    elseif type == "Line" then
        ESP.Drawings[player].Line = Drawing.new("Line")
        ESP.Drawings[player].Line.Thickness = 1
        ESP.Drawings[player].Line.Color = Color3.fromRGB(180, 0, 255)
        ESP.Drawings[player].Line.Visible = false
    end
end

local function removeDrawing(player, type)
    if ESP.Drawings[player] then
        if type == "Box" and ESP.Drawings[player].Box then
            ESP.Drawings[player].Box:Remove()
            ESP.Drawings[player].Box = nil
        elseif type == "Line" and ESP.Drawings[player].Line then
            ESP.Drawings[player].Line:Remove()
            ESP.Drawings[player].Line = nil
        end
    end
end

local function updateDrawings()
    for player, drawings in pairs(ESP.Drawings) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local char = player.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            if rootPart and head then
                local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                
                if rootVis then
                    if ESP.Box and drawings.Box then
                        local height = (headPos.Y - rootPos.Y)
                        local width = height / 2
                        
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height)
                        drawings.Box.Visible = true
                    else
                        if drawings.Box then
                            drawings.Box.Visible = false
                        end
                    end
                    
                    if ESP.Line and drawings.Line then
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        drawings.Line.From = screenCenter
                        drawings.Line.To = Vector2.new(rootPos.X, rootPos.Y)
                        drawings.Line.Visible = true
                    else
                        if drawings.Line then
                            drawings.Line.Visible = false
                        end
                    end
                else
                    if drawings.Box then drawings.Box.Visible = false end
                    if drawings.Line then drawings.Line.Visible = false end
                end
            else
                if drawings.Box then drawings.Box.Visible = false end
                if drawings.Line then drawings.Line.Visible = false end
            end
        else
            if drawings.Box then drawings.Box.Visible = false end
            if drawings.Line then drawings.Line.Visible = false end
        end
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    if ESP.Players[player] then return end
    
    local espData = {
        Highlight = nil,
        NameBillboard = nil,
        StudsBillboard = nil,
        CharAddedConn = nil,
        CharRemovingConn = nil
    }
    
    ESP.Players[player] = espData
    
    local function setupCharacter(char)
        task.wait(0.5)
        
        if ESP.Highlight and not espData.Highlight then
            espData.Highlight = Instance.new("Highlight")
            espData.Highlight.Name = "SeraphinESP_HL"
            espData.Highlight.FillColor = Color3.fromRGB(180, 0, 255)
            espData.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            espData.Highlight.OutlineTransparency = 0
            espData.Highlight.FillTransparency = 0.3
            espData.Highlight.Parent = char
        end
        
        if ESP.Name and not espData.NameBillboard then
            espData.NameBillboard = Instance.new("BillboardGui")
            espData.NameBillboard.Name = "SeraphinESP_Name"
            espData.NameBillboard.Size = UDim2.new(0, 200, 0, 50)
            espData.NameBillboard.AlwaysOnTop = true
            espData.NameBillboard.StudsOffset = Vector3.new(0, 3, 0)
            espData.NameBillboard.Adornee = char:WaitForChild("Head")
            espData.NameBillboard.Parent = char
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(180, 0, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextSize = 14
            nameLabel.Text = player.Name
            nameLabel.Parent = espData.NameBillboard
        end
        
        if ESP.Studs and not espData.StudsBillboard then
            espData.StudsBillboard = Instance.new("BillboardGui")
            espData.StudsBillboard.Name = "SeraphinESP_Studs"
            espData.StudsBillboard.Size = UDim2.new(0, 200, 0, 50)
            espData.StudsBillboard.AlwaysOnTop = true
            espData.StudsBillboard.StudsOffset = Vector3.new(0, 5, 0)
            espData.StudsBillboard.Adornee = char:WaitForChild("Head")
            espData.StudsBillboard.Parent = char
            
            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(1, 0, 1, 0)
            infoLabel.BackgroundTransparency = 1
            infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            infoLabel.TextStrokeTransparency = 0
            infoLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            infoLabel.Font = Enum.Font.SourceSansBold
            infoLabel.TextSize = 12
            infoLabel.Text = "0 studs"
            infoLabel.Parent = espData.StudsBillboard
        end
        
        if ESP.Box or ESP.Line then
            createDrawing(player, "Box")
            createDrawing(player, "Line")
        end
    end
    
    espData.CharAddedConn = player.CharacterAdded:Connect(function(char)
        setupCharacter(char)
    end)
    
    espData.CharRemovingConn = player.CharacterRemoving:Connect(function()
        if espData.Highlight then
            espData.Highlight:Destroy()
            espData.Highlight = nil
        end
        if espData.NameBillboard then
            espData.NameBillboard:Destroy()
            espData.NameBillboard = nil
        end
        if espData.StudsBillboard then
            espData.StudsBillboard:Destroy()
            espData.StudsBillboard = nil
        end
    end)
    
    if player.Character then
        setupCharacter(player.Character)
    end
end

local function removeESP(player)
    local espData = ESP.Players[player]
    if espData then
        if espData.CharAddedConn then
            espData.CharAddedConn:Disconnect()
        end
        if espData.CharRemovingConn then
            espData.CharRemovingConn:Disconnect()
        end
        if espData.Highlight then
            espData.Highlight:Destroy()
        end
        if espData.NameBillboard then
            espData.NameBillboard:Destroy()
        end
        if espData.StudsBillboard then
            espData.StudsBillboard:Destroy()
        end
        ESP.Players[player] = nil
    end
    
    if ESP.Drawings[player] then
        removeDrawing(player, "Box")
        removeDrawing(player, "Line")
        ESP.Drawings[player] = nil
    end
end

local function updateESP()
    for player, espData in pairs(ESP.Players) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            if espData.StudsBillboard and espData.StudsBillboard.Parent then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                espData.StudsBillboard.TextLabel.Text = math.floor(distance) .. " studs"
            end
        end
    end
    
    if ESP.Box or ESP.Line then
        updateDrawings()
    end
end

local function setupAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end

local function cleanupAllESP()
    for player, _ in pairs(ESP.Players) do
        removeESP(player)
    end
    
    for player, _ in pairs(ESP.Drawings) do
        removeDrawing(player, "Box")
        removeDrawing(player, "Line")
    end
    ESP.Drawings = {}
end

local function toggleESPFeature(feature, state)
    ESP[feature] = state
    
    if ESP.Enabled then
        for player, espData in pairs(ESP.Players) do
            if player ~= LocalPlayer and player.Character then
                if feature == "Highlight" then
                    if state then
                        if not espData.Highlight then
                            espData.Highlight = Instance.new("Highlight")
                            espData.Highlight.Name = "SeraphinESP_HL"
                            espData.Highlight.FillColor = Color3.fromRGB(180, 0, 255)
                            espData.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            espData.Highlight.OutlineTransparency = 0
                            espData.Highlight.FillTransparency = 0.3
                            espData.Highlight.Parent = player.Character
                        end
                    else
                        if espData.Highlight then
                            espData.Highlight:Destroy()
                            espData.Highlight = nil
                        end
                    end
                elseif feature == "Name" then
                    if state then
                        if not espData.NameBillboard then
                            espData.NameBillboard = Instance.new("BillboardGui")
                            espData.NameBillboard.Name = "SeraphinESP_Name"
                            espData.NameBillboard.Size = UDim2.new(0, 200, 0, 50)
                            espData.NameBillboard.AlwaysOnTop = true
                            espData.NameBillboard.StudsOffset = Vector3.new(0, 3, 0)
                            espData.NameBillboard.Adornee = player.Character:WaitForChild("Head")
                            espData.NameBillboard.Parent = player.Character
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.TextColor3 = Color3.fromRGB(180, 0, 255)
                            nameLabel.TextStrokeTransparency = 0
                            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            nameLabel.Font = Enum.Font.SourceSansBold
                            nameLabel.TextSize = 14
                            nameLabel.Text = player.Name
                            nameLabel.Parent = espData.NameBillboard
                        end
                    else
                        if espData.NameBillboard then
                            espData.NameBillboard:Destroy()
                            espData.NameBillboard = nil
                        end
                    end
                elseif feature == "Studs" then
                    if state then
                        if not espData.StudsBillboard then
                            espData.StudsBillboard = Instance.new("BillboardGui")
                            espData.StudsBillboard.Name = "SeraphinESP_Studs"
                            espData.StudsBillboard.Size = UDim2.new(0, 200, 0, 50)
                            espData.StudsBillboard.AlwaysOnTop = true
                            espData.StudsBillboard.StudsOffset = Vector3.new(0, 5, 0)
                            espData.StudsBillboard.Adornee = player.Character:WaitForChild("Head")
                            espData.StudsBillboard.Parent = player.Character
                            
                            local infoLabel = Instance.new("TextLabel")
                            infoLabel.Size = UDim2.new(1, 0, 1, 0)
                            infoLabel.BackgroundTransparency = 1
                            infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            infoLabel.TextStrokeTransparency = 0
                            infoLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            infoLabel.Font = Enum.Font.SourceSansBold
                            infoLabel.TextSize = 12
                            infoLabel.Text = "0 studs"
                            infoLabel.Parent = espData.StudsBillboard
                        end
                    else
                        if espData.StudsBillboard then
                            espData.StudsBillboard:Destroy()
                            espData.StudsBillboard = nil
                        end
                    end
                elseif feature == "Box" then
                    if state then
                        createDrawing(player, "Box")
                    else
                        removeDrawing(player, "Box")
                    end
                elseif feature == "Line" then
                    if state then
                        createDrawing(player, "Line")
                    else
                        removeDrawing(player, "Line")
                    end
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if ESP.Enabled then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    if ESP.Enabled then
        updateESP()
    end
end)

Visuals:Toggle({
    Title = "ESP",
    Default = false,
    Callback = function(state)
        ESP.Enabled = state
        if state then
            setupAllESP()
        else
            cleanupAllESP()
        end
    end
})

Visuals:Toggle({
    Title = "ESP Highlight",
    Default = false,
    Callback = function(state)
        toggleESPFeature("Highlight", state)
    end
})

Visuals:Toggle({
    Title = "ESP Name",
    Default = false,
    Callback = function(state)
        toggleESPFeature("Name", state)
    end
})

Visuals:Toggle({
    Title = "ESP Studs",
    Default = false,
    Callback = function(state)
        toggleESPFeature("Studs", state)
    end
})

Visuals:Toggle({
    Title = "ESP Box",
    Default = false,
    Callback = function(state)
        toggleESPFeature("Box", state)
    end
})

Visuals:Toggle({
    Title = "ESP Line",
    Default = false,
    Callback = function(state)
        toggleESPFeature("Line", state)
    end
})

local PlayersTab = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local walkVal, jumpVal = 16, 50

local function applyStats(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = walkVal
    hum.UseJumpPower = true
    hum.JumpPower = jumpVal
end

applyStats(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.2)
    applyStats(char)
end)

PlayersTab:Input({
    Title = "WalkSpeed",
    Value = tostring(walkVal),
    Callback = function(val)
        local spd = tonumber(val)
        if spd and spd >= 16 then
            walkVal = spd
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = walkVal
            end
        end
    end
})

PlayersTab:Input({
    Title = "JumpPower",
    Value = tostring(jumpVal),
    Callback = function(val)
        local jp = tonumber(val)
        if jp then
            jumpVal = jp
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.UseJumpPower = true
                LocalPlayer.Character.Humanoid.JumpPower = jumpVal
            end
        end
    end
})

PlayersTab:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

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
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if state and hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
            task.spawn(function()
                while _G.Fly and bv.Parent do
                    task.wait()
                    bv.Velocity = Camera.CFrame.LookVector * 50
                end
            end)
        else
            if hrp and hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity:Destroy()
            end
        end
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

Settings:Section({
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Rejoin",
    Desc = "Reconnect to current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Player = game.Players.LocalPlayer
        TeleportService:Teleport(PlaceId, Player)
    end
})

Settings:Button({
    Title = "Server Hop",
    Desc = "Teleport to a different server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = {}
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success and response then
            local data = HttpService:JSONDecode(response)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(Servers, v.id)
                end
            end
        end
        if #Servers > 0 then
            local randomServer = Servers[math.random(1, #Servers)]
            TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, game.Players.LocalPlayer)
        end
    end
})

Settings:Section({
    Title = "Config",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Save Config",
    Desc = "Save your current settings",
    Callback = function()
        WindUI:SaveConfig("Seraphin_Config")
    end
})

Settings:Button({
    Title = "Load Config",
    Desc = "Load your saved settings",
    Callback = function()
        WindUI:LoadConfig("Seraphin_Config")
    end
})

Settings:Button({
    Title = "Delete Config",
    Desc = "Delete saved config",
    Callback = function()
        WindUI:DeleteConfig("Seraphin_Config")
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

Settings:Section({
    Title = "other scripts",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Infinite Yield",
    Desc = "Script Other",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})