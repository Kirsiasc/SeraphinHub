local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WindHubScript/WindUI/v2/library.lua"))()

local Window = WindUI:CreateWindow({
    Name = "WindHub — Rivals",
    LoadingTitle = "WindHub Premium",
    LoadingSubtitle = "Rivals Edition",
    ConfigurationSaving = {Enabled = true, FolderName = "WindRivals", FileName = "config"},
    Discord = {Enabled = true, Invite = "windhub", RememberJoins = true},
    KeySystem = false
})

local Main = Window:Tab({Name = "Combat", Icon = "crosshair"})
local Visual = Window:Tab({Name = "Visual", Icon = "eye"})
local Player = Window:Tab({Name = "Player", Icon = "user"})
local Teleport = Window:Tab({Name = "Teleport", Icon = "map-pin"})
local Misc = Window:Tab({Name = "Misc", Icon = "settings"})

local Aimbot = Main:Section({Name = "Aimbot", Side = "Left"})
local Combat = Main:Section({Name = "Combat", Side = "Right"})
local ESP = Visual:Section({Name = "ESP", Side = "Left"})
local Visuals = Visual:Section({Name = "Visuals", Side = "Right"})
local Movement = Player:Section({Name = "Movement", Side = "Left"})
local Exploits = Player:Section({Name = "Exploits", Side = "Right"})
local TP = Teleport:Section({Name = "Teleport", Side = "Left"})
local Settings = Misc:Section({Name = "Settings", Side = "Left"})
local Config = Misc:Section({Name = "Config", Side = "Right"})

-- Global Variables
getgenv().WindHub = {
    SilentAim = false,
    FOV = 150,
    TeamCheck = false,
    WallCheck = true,
    Triggerbot = false,
    KillAura = false,
    AutoParry = false,
    OneHit = false,
    RapidFire = false,
    BoxESP = false,
    NameESP = false,
    HitboxExp = false,
    Fly = false,
    Noclip = false,
    AntiRagdoll = false
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Aimbot Section
Aimbot:Toggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(v) 
        getgenv().WindHub.SilentAim = v 
    end
})

Aimbot:Slider({
    Name = "FOV Radius",
    Min = 10,
    Max = 360,
    Default = 150,
    Callback = function(v) 
        getgenv().WindHub.FOV = v 
    end
})

Aimbot:Toggle({
    Name = "Team Check",
    Default = false,
    Callback = function(v) 
        getgenv().WindHub.TeamCheck = v 
    end
})

Aimbot:Toggle({
    Name = "Wall Check",
    Default = true,
    Callback = function(v) 
        getgenv().WindHub.WallCheck = v 
    end
})

Aimbot:Toggle({
    Name = "Triggerbot",
    Default = false,
    Callback = function(v) 
        getgenv().WindHub.Triggerbot = v 
    end
})

-- Combat Section
local KillAuraConnection
Combat:Toggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.KillAura = v
        
        if KillAuraConnection then
            KillAuraConnection:Disconnect()
            KillAuraConnection = nil
        end
        
        if v then
            KillAuraConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().WindHub.KillAura then 
                    KillAuraConnection:Disconnect()
                    return 
                end
                
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (target.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        if distance <= 50 then
                            pcall(function()
                                ReplicatedStorage.Events.Damage:FireServer(target.Character.Humanoid, math.huge)
                            end)
                        end
                    end
                end
            end)
        end
    end
})

local AutoParryConnection
Combat:Toggle({
    Name = "Auto Parry",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.AutoParry = v
        
        if AutoParryConnection then
            AutoParryConnection:Disconnect()
            AutoParryConnection = nil
        end
        
        if v then
            AutoParryConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().WindHub.AutoParry then 
                    AutoParryConnection:Disconnect()
                    return 
                end
                
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Humanoid") then
                        if target.Character.Humanoid.Health > 0 then
                            pcall(function()
                                ReplicatedStorage.Events.Parry:FireServer()
                            end)
                            break
                        end
                    end
                end
            end)
        end
    end
})

local OneHitConnection
Combat:Toggle({
    Name = "Instant Kill",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.OneHit = v
        
        if OneHitConnection then
            OneHitConnection:Disconnect()
            OneHitConnection = nil
        end
        
        if v then
            OneHitConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().WindHub.OneHit then 
                    OneHitConnection:Disconnect()
                    return 
                end
                
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("Humanoid") then
                        pcall(function()
                            target.Character.Humanoid:TakeDamage(999999)
                        end)
                    end
                end
            end)
        end
    end
})

Combat:Toggle({
    Name = "Rapid Fire",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.RapidFire = v
        if v then
            task.spawn(function()
                for i, v in pairs(getgc(true)) do
                    if typeof(v) == "function" then
                        local script = getfenv(v).script
                        if script and script == LocalPlayer.PlayerScripts:FindFirstChild("LocalScript") then
                            if debug.getinfo(v).name == "Fire" then
                                for idx, val in pairs(debug.getupvalues(v)) do
                                    if typeof(val) == "number" and val > 0.01 then
                                        debug.setupvalue(v, idx, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- ESP Section
local ESPConnections = {}

local function ClearESP()
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj.Name == "BoxESP" or obj.Name == "NameESP" then
                    obj:Destroy()
                end
            end
        end
    end
end

local BoxESPConnection
ESP:Toggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.BoxESP = v
        
        if BoxESPConnection then
            BoxESPConnection:Disconnect()
            BoxESPConnection = nil
        end
        
        if not v then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local box = player.Character:FindFirstChild("BoxESP")
                    if box then
                        box:Destroy()
                    end
                end
            end
            return
        end
        
        BoxESPConnection = RunService.Heartbeat:Connect(function()
            if not getgenv().WindHub.BoxESP then 
                BoxESPConnection:Disconnect()
                return 
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not player.Character:FindFirstChild("BoxESP") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "BoxESP"
                        box.Adornee = player.Character.HumanoidRootPart
                        box.Size = player.Character.HumanoidRootPart.Size + Vector3.new(2, 3, 2)
                        box.Color3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.3
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Parent = player.Character
                    end
                end
            end
        end)
    end
})

local NameESPConnection
ESP:Toggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.NameESP = v
        
        if NameESPConnection then
            NameESPConnection:Disconnect()
            NameESPConnection = nil
        end
        
        if not v then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local bill = player.Character.Head:FindFirstChild("NameESP")
                    if bill then
                        bill:Destroy()
                    end
                end
            end
            return
        end
        
        NameESPConnection = RunService.Heartbeat:Connect(function()
            if not getgenv().WindHub.NameESP then 
                NameESPConnection:Disconnect()
                return 
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    if not head:FindFirstChild("NameESP") then
                        local bill = Instance.new("BillboardGui")
                        local text = Instance.new("TextLabel")
                        
                        bill.Name = "NameESP"
                        bill.Adornee = head
                        bill.Size = UDim2.new(0, 100, 0, 30)
                        bill.AlwaysOnTop = true
                        bill.ExtentsOffset = Vector3.new(0, 3, 0)
                        bill.Parent = head
                        
                        text.BackgroundTransparency = 1
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.Text = player.Name
                        text.TextColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = false
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 14
                        text.Parent = bill
                    else
                        local bill = head.NameESP
                        local text = bill:FindFirstChildOfClass("TextLabel")
                        if text then
                            text.Text = player.Name .. " [" .. math.floor(player.Character.Humanoid.Health) .. "]"
                            text.TextColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end)
    end
})

-- Visuals Section
local Crosshair
Visuals:Toggle({
    Name = "Custom Crosshair",
    Default = false,
    Callback = function(v)
        if Crosshair then
            Crosshair:Remove()
            Crosshair = nil
        end
        
        if v then
            Crosshair = Drawing.new("Circle")
            Crosshair.Radius = 8
            Crosshair.Color = Color3.fromRGB(255, 0, 0)
            Crosshair.Thickness = 2
            Crosshair.Filled = false
            Crosshair.Visible = true
            Crosshair.ZIndex = 999
            
            local crosshairConnection
            crosshairConnection = RunService.RenderStepped:Connect(function()
                if not Crosshair then
                    crosshairConnection:Disconnect()
                    return
                end
                local mousePos = UserInputService:GetMouseLocation()
                Crosshair.Position = Vector2.new(mousePos.X, mousePos.Y)
            end)
        end
    end
})

local HitboxConnection
Visuals:Toggle({
    Name = "Hitbox Expander",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.HitboxExp = v
        
        if HitboxConnection then
            HitboxConnection:Disconnect()
            HitboxConnection = nil
        end
        
        if not v then
            -- Reset hitboxes
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Size = Vector3.new(2, 2, 2) -- Default size, adjust as needed
                            part.Transparency = 0
                            part.Material = Enum.Material.Plastic
                            part.Color = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end
            return
        end
        
        HitboxConnection = RunService.Heartbeat:Connect(function()
            if not getgenv().WindHub.HitboxExp then 
                HitboxConnection:Disconnect()
                return 
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Size = Vector3.new(10, 10, 10)
                            part.Transparency = 0.7
                            part.Material = Enum.Material.ForceField
                            part.Color = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end)
    end
})

-- Movement Section
local FlyConnection
Movement:Toggle({
    Name = "Fly [F]",
    Keybind = "F",
    Callback = function(v)
        getgenv().WindHub.Fly = v
        
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        if v then
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = character.HumanoidRootPart
            local bodyGyro = Instance.new("BodyGyro")
            local bodyVelocity = Instance.new("BodyVelocity")
            
            bodyGyro.P = 9e4
            bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = rootPart.CFrame
            bodyGyro.Parent = rootPart
            
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = rootPart
            
            local speed = 50
            
            FlyConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().WindHub.Fly or not character or not rootPart then
                    bodyGyro:Destroy()
                    bodyVelocity:Destroy()
                    FlyConnection:Disconnect()
                    return
                end
                
                character.Humanoid:ChangeState(11) -- PhysicsNone
                bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
                
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + Workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - Workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + Workspace.CurrentCamera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - Workspace.CurrentCamera.CFrame.RightVector
                end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                if direction.Magnitude > 0 then
                    direction = direction.Unit * speed
                end
                
                bodyVelocity.Velocity = direction
            end)
        end
    end
})

Movement:Slider({
    Name = "Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

local NoclipConnection
Movement:Toggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.Noclip = v
        
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        
        if v then
            NoclipConnection = RunService.Stepped:Connect(function()
                if not getgenv().WindHub.Noclip then 
                    NoclipConnection:Disconnect()
                    return 
                end
                
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- Teleport Section
TP:Button({
    Name = "Teleport to Random Player",
    Callback = function()
        local plrs = {}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(plrs, v)
            end
        end
        
        if #plrs > 0 then
            local target = plrs[math.random(1, #plrs)]
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        else
            WindUI:Notify({
                Title = "Teleport",
                Content = "No players found to teleport to!",
                Duration = 3
            })
        end
    end
})

-- Settings Section
Settings:Toggle({
    Name = "Anti Ragdoll",
    Default = false,
    Callback = function(v)
        getgenv().WindHub.AntiRagdoll = v
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end
})

-- Config Section
Config:Button({
    Name = "Save Config",
    Callback = function() 
        WindUI:SaveConfig()
        WindUI:Notify({
            Title = "Config",
            Content = "Configuration saved successfully!",
            Duration = 3
        })
    end
})

Config:Button({
    Name = "Load Config",
    Callback = function() 
        WindUI:LoadConfig()
        WindUI:Notify({
            Title = "Config",
            Content = "Configuration loaded successfully!",
            Duration = 3
        })
    end
})

-- Silent Aim System
local SilentAimConnection
SilentAimConnection = RunService.RenderStepped:Connect(function()
    if not getgenv().WindHub.SilentAim then return end
    
    local closest = nil
    local closestDistance = getgenv().WindHub.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- Team Check
            if getgenv().WindHub.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            -- Wall Check
            if getgenv().WindHub.WallCheck then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local origin = Workspace.CurrentCamera.CFrame.Position
                local direction = (player.Character.Head.Position - origin).Unit * 1000
                local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
                
                if raycastResult then
                    continue
                end
            end
            
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
            
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < closestDistance then
                    closest = player.Character.Head
                    closestDistance = distance
                end
            end
        end
    end
    
    if closest and getgenv().WindHub.Triggerbot then
        -- Simulate mouse click for triggerbot
        mouse1click()
    end
end)

-- Auto-Cleanup on player leaving
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        for _, obj in pairs(player.Character:GetDescendants()) do
            if obj.Name == "BoxESP" or obj.Name == "NameESP" then
                obj:Destroy()
            end
        end
    end
end)

-- Initialization
WindUI:Notify({
    Title = "WindHub",
    Content = "Rivals script loaded successfully!",
    Duration = 5
})

-- Cleanup when script is stopped
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Reset settings when character respawns
    task.wait(1) -- Wait for character to fully load
    if getgenv().WindHub.Noclip then
        -- Re-enable noclip
        getgenv().WindHub.Noclip = false
        Movement:Toggle({Name = "Noclip"}):Set(true)
    end
