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
    Author = "KirsiaSC | Fish It",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(270, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromHex("#9b4dff")
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

local Section = Tab1:Section({ 
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/cdsRC8XFyR")
        end
    end
})

local Section = Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local value = tonumber(input)
        if value then
            _G.CustomJumpPower = value
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
            print("🔼 Jump Power diatur ke: " .. value)
        else
            warn("⚠️ Harus angka, bukan teks!")
        end
    end
})

local Button = Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "balikkan Jump Power ke default (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Jump Power di-reset ke 50")
    end
})

local Player = game:GetService("Players").LocalPlayer
Player.CharacterAdded:Connect(function(char)
    local Humanoid = char:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab2:Button({
    Title = "Reset Speed",
    Description = "Return speed to normal (16)",
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset ke default (16)")
    end
})

local Toggle = Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Aktif")
        else
            print("❌ Infinite Jump Nonaktif")
        end
    end
})

local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

local Toggle = Tab3:Toggle({
    Title = "Infinite Oxygen Safe (beta)",
    Desc = "Bar oksigen selalu penuh & tidak kena damage",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.InfiniteOxygen = state
        local player = game.Players.LocalPlayer
        
        if state then
            -- Simpan fungsi asli untuk restore nanti
            local char = player.Character or player.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and not _G.OriginalTakeDamage then
                _G.OriginalTakeDamage = hum.TakeDamage
            end
            
            -- Mulai loop untuk infinite oxygen
            _G.InfiniteOxygenLoop = task.spawn(function()  
                while _G.InfiniteOxygen do  
                    task.wait(0.2)  
                    local char = player.Character  
                    if char then  
                        local hum = char:FindFirstChildOfClass("Humanoid")  
                        if hum then  
                            -- Block semua damage  
                            hum.TakeDamage = function() end  
                            hum.Health = hum.MaxHealth -- backup, supaya selalu full  
                        end  

                        -- Simulasi bar oksigen penuh  
                        local oxygen = char:FindFirstChild("Oxygen") or char:FindFirstChild("Breath")  
                        if oxygen then  
                            oxygen.Value = oxygen.MaxValue or 100  
                        end  

                        -- Kalau bar oksigen game pakai GUI sendiri  
                        local guiOxygen = player.PlayerGui:FindFirstChild("OxygenGui") -- contoh  
                        if guiOxygen then  
                            local bar = guiOxygen:FindFirstChild("Bar") or guiOxygen:FindFirstChild("Frame")
                            if bar and bar:IsA("Frame") then  
                                bar.Size = UDim2.new(1, 0, 1, 0) -- full bar  
                            end  
                        end  
                    end  
                end
                
                -- Restore fungsi asli ketika toggle dimatikan
                if _G.OriginalTakeDamage then
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.TakeDamage = _G.OriginalTakeDamage
                        end
                    end
                end
            end)
        else
            -- Hentikan loop jika toggle dimatikan
            if _G.InfiniteOxygenLoop then
                task.cancel(_G.InfiniteOxygenLoop)
                _G.InfiniteOxygenLoop = nil
            end
        end
    end
})

local Toggle = Tab3:Toggle({
    Title = "Walk/Run On Water",
    Desc = "Jalan atau lari di atas air otomatis",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        _G.WalkOnWater = state

        task.spawn(function()
            local player = game.Players.LocalPlayer
            while _G.WalkOnWater do
                task.wait(0.1)
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if root and hum then
                        -- Raycasting ke bawah untuk deteksi air
                        local ray = Ray.new(root.Position, Vector3.new(0, -50, 0))
                        local hit, pos = workspace:FindPartOnRay(ray, char)
                        if hit and hit.Material == Enum.Material.Water then
                            -- Naikkan sedikit di atas air tapi biarkan Humanoid bisa jalan/lari
                            local newY = math.max(root.Position.Y, pos.Y + 2)
                            root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
                        end
                    end
                end
            end
        end)
    end
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Dropdown = Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Spawn", "Konoha", "Coral Refs", "Volcano", "Sysyphus Statue"},
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = Vector3.new(33, 9, 2810),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Volcano"] = Vector3.new(-632, 55, 197),
            ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
        }

        local Player = game.Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})


myConfig:Load()
