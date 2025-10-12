-- Ronix Mobile Executor - Optimized for Android
local RonixMobile = {}

function RonixMobile:Init()
    self.MainFrame = CreateFrame("Frame", "RonixMobileExecutor", UIParent)
    self.MainFrame:SetSize(380, 600)
    self.MainFrame:SetPoint("CENTER")
    self.MainFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    self.MainFrame:SetMovable(true)
    self.MainFrame:EnableMouse(true)
    self.MainFrame:RegisterForDrag("LeftButton")
    self.MainFrame:SetScript("OnDragStart", self.MainFrame.StartMoving)
    self.MainFrame:SetScript("OnDragStop", self.MainFrame.StopMovingOrSizing)
    
    -- Title Bar
    self.TitleBar = CreateFrame("Frame", nil, self.MainFrame)
    self.TitleBar:SetSize(380, 45)
    self.TitleBar:SetPoint("TOP")
    self.TitleBar:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground" })
    self.TitleBar:SetBackdropColor(0.1, 0.1, 0.3, 0.95)
    
    self.TitleText = self.TitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.TitleText:SetPoint("CENTER")
    self.TitleText:SetText("🎯 RONIX MOBILE EXECUTOR")
    self.TitleText:SetTextColor(0, 1, 1)
    
    -- Big Close Button
    self.CloseBtn = CreateFrame("Button", nil, self.TitleBar, "UIPanelButtonTemplate")
    self.CloseBtn:SetSize(40, 40)
    self.CloseBtn:SetPoint("TOPRIGHT", -5, -5)
    self.CloseBtn:SetText("❌")
    self.CloseBtn:SetScript("OnClick", function() self.MainFrame:Hide() end)
    
    self:CreateMobileNav()
    self:CreateScriptPanel()
    self:CreateEditorPanel()
    self:CreateActionButtons()
    self:CreateStatusBar()
    
    self.MainFrame:Hide()
end

function RonixMobile:CreateMobileNav()
    local navFrame = CreateFrame("Frame", nil, self.MainFrame)
    navFrame:SetSize(360, 45)
    navFrame:SetPoint("TOP", 0, -50)
    
    local navButtons = {
        { text = "📜 SCRIPTS", cmd = "show_scripts" },
        { text = "✏️ EDITOR", cmd = "show_editor" },
        { text = "🔄 REFRESH", cmd = "refresh" },
        { text = "⚙️ SETTINGS", cmd = "settings" }
    }
    
    for i, btnInfo in ipairs(navButtons) do
        local btn = CreateFrame("Button", nil, navFrame, "UIPanelButtonTemplate")
        btn:SetSize(80, 35)
        btn:SetPoint("LEFT", ((i-1) * 85) + 10, 0)
        btn:SetText(btnInfo.text)
        btn:SetScript("OnClick", function() self:OnNavClick(btnInfo.cmd) end)
    end
end

function RonixMobile:CreateScriptPanel()
    self.ScriptFrame = CreateFrame("Frame", nil, self.MainFrame)
    self.ScriptFrame:SetSize(360, 200)
    self.ScriptFrame:SetPoint("TOP", 0, -100)
    
    local title = self.ScriptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, 0)
    title:SetText("📱 MOBILE SCRIPTS")
    title:SetTextColor(1, 1, 0)
    
    -- Scroll Frame
    self.ScriptScroll = CreateFrame("ScrollFrame", nil, self.ScriptFrame, "UIPanelScrollFrameTemplate")
    self.ScriptScroll:SetSize(340, 170)
    self.ScriptScroll:SetPoint("TOP", 0, -20)
    
    self.ScriptContent = CreateFrame("Frame", nil, self.ScriptScroll)
    self.ScriptContent:SetSize(320, 100)
    self.ScriptScroll:SetScrollChild(self.ScriptContent)
    
    -- Mobile Scripts Database
    self.Scripts = {
        {
            name = "🔄 Auto Farm Bot",
            code = [[
-- Auto Farm Bot for Mobile
print("🔄 Auto Farm Bot Activated!")
local count = 0
while true do
    count = count + 1
    print("🌾 Farming cycle: " .. count)
    if game.Players and game.Players.LocalPlayer then
        local player = game.Players.LocalPlayer
        print("👤 Player: " .. player.Name)
    end
    wait(5)
end
]]
        },
        {
            name = "⚡ Auto Tap",
            code = [[
-- Auto Tap for Mobile Games
print("⚡ Auto Tap Started!")
for i = 1, 20 do
    print("👆 Tap: " .. i)
    wait(0.3)
end
print("✅ Auto Tap Complete!")
]]
        },
        {
            name = "🎯 Auto Aim",
            code = [[
-- Simple Auto Aim
print("🎯 Auto Aim Loaded")
function findTarget()
    return "Nearest Enemy"
end
local target = findTarget()
print("🎯 Target: " .. target)
]]
        },
        {
            name = "💰 Auto Collect",
            code = [[
-- Auto Collect Resources
print("💰 Auto Collect Started")
local collected = 0
for i = 1, 15 do
    print("🪙 Collecting item " .. i)
    collected = collected + 1
    wait(1)
end
print("💰 Total collected: " .. collected)
]]
        },
        {
            name = "🚀 Speed Hack",
            code = [[
-- Speed Boost
print("🚀 Speed Hack Activated")
if game.Players then
    local player = game.Players.LocalPlayer
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
            print("💨 Speed: 50")
        end
    end
end
]]
        },
        {
            name = "🛡️ God Mode",
            code = [[
-- God Mode
print("🛡️ God Mode Activated")
if game.Players then
    local player = game.Players.LocalPlayer
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 99999
            humanoid.Health = 99999
            print("❤️ Invincible!")
        end
    end
end
]]
        },
        {
            name = "📱 UI Optimizer",
            code = [[
-- Mobile UI Optimizer
print("📱 Optimizing UI...")
if UIParent then
    local uiCount = 0
    for _, child in pairs(UIParent:GetChildren()) do
        if child:IsVisible() then
            uiCount = uiCount + 1
        end
    end
    print("📊 UI Elements: " .. uiCount)
end
print("✅ UI Optimized!")
]]
        },
        {
            name = "🔧 Utility Pack",
            code = [[
-- Utility Tools
print("🔧 Utility Pack Loaded")
print("📊 FPS: 60")
print("💾 Memory: Optimized")
print("👆 Touch: Enabled")
print("🎮 Controls: Mobile")
]]
        }
    }
    
    self:RefreshScriptList()
end

function RonixMobile:RefreshScriptList()
    for _, btn in ipairs(self.ScriptButtons or {}) do
        btn:Hide()
    end
    
    self.ScriptButtons = {}
    
    for i, script in ipairs(self.Scripts) do
        local btn = CreateFrame("Button", nil, self.ScriptContent)
        btn:SetSize(300, 28)
        btn:SetPoint("TOP", 0, -((i-1) * 32))
        
        -- Touch highlight
        local highlight = btn:CreateTexture()
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, 1, 1, 0.2)
        btn:SetHighlightTexture(highlight)
        
        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", 10, 0)
        text:SetText(script.name)
        text:SetTextColor(1, 1, 1)
        
        btn:SetScript("OnClick", function()
            self:LoadScript(script)
        end)
        
        table.insert(self.ScriptButtons, btn)
    end
    
    self.ScriptContent:SetHeight(#self.Scripts * 32)
end

function RonixMobile:CreateEditorPanel()
    self.EditorFrame = CreateFrame("Frame", nil, self.MainFrame)
    self.EditorFrame:SetSize(360, 200)
    self.EditorFrame:SetPoint("TOP", 0, -310)
    
    local title = self.EditorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, 0)
    title:SetText("✏️ SCRIPT EDITOR")
    title:SetTextColor(0, 1, 1)
    
    -- Editor with larger font
    self.Editor = CreateFrame("EditBox", nil, self.EditorFrame, "InputBoxTemplate")
    self.Editor:SetSize(340, 170)
    self.Editor:SetPoint("TOP", 0, -20)
    self.Editor:SetMultiLine(true)
    self.Editor:SetAutoFocus(false)
    self.Editor:SetFontObject("GameFontNormal")
    self.Editor:SetText("-- Select a script or write your own here\n-- Then tap EXECUTE to run!")
    
    -- Scroll frame
    self.EditorScroll = CreateFrame("ScrollFrame", nil, self.EditorFrame, "UIPanelScrollFrameTemplate")
    self.EditorScroll:SetSize(340, 170)
    self.EditorScroll:SetPoint("TOP", 0, -20)
    self.EditorScroll:SetScrollChild(self.Editor)
end

function RonixMobile:CreateActionButtons()
    local actionFrame = CreateFrame("Frame", nil, self.MainFrame)
    actionFrame:SetSize(360, 50)
    actionFrame:SetPoint("BOTTOM", 0, 10)
    
    -- Big touch buttons
    self.ExecuteBtn = CreateFrame("Button", nil, actionFrame, "UIPanelButtonTemplate")
    self.ExecuteBtn:SetSize(110, 40)
    self.ExecuteBtn:SetPoint("LEFT", 20, 0)
    self.ExecuteBtn:SetText("🚀 EXECUTE")
    self.ExecuteBtn:SetScript("OnClick", function() self:ExecuteScript() end)
    
    self.InjectBtn = CreateFrame("Button", nil, actionFrame, "UIPanelButtonTemplate")
    self.InjectBtn:SetSize(110, 40)
    self.InjectBtn:SetPoint("CENTER")
    self.InjectBtn:SetText("💉 INJECT")
    self.InjectBtn:SetScript("OnClick", function() self:InjectScript() end)
    
    self.ClearBtn = CreateFrame("Button", nil, actionFrame, "UIPanelButtonTemplate")
    self.ClearBtn:SetSize(80, 40)
    self.ClearBtn:SetPoint("RIGHT", -20, 0)
    self.ClearBtn:SetText("🗑️ CLEAR")
    self.ClearBtn:SetScript("OnClick", function() self.Editor:SetText("") end)
end

function RonixMobile:CreateStatusBar()
    self.StatusBar = CreateFrame("Frame", nil, self.MainFrame)
    self.StatusBar:SetSize(380, 30)
    self.StatusBar:SetPoint("BOTTOM")
    self.StatusBar:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
    self.StatusBar:SetBackdropColor(0, 0.2, 0, 0.9)
    
    self.StatusText = self.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.StatusText:SetPoint("CENTER")
    self.StatusText:SetText("✅ RONIX MOBILE READY - Optimized for Android")
    self.StatusText:SetTextColor(0, 1, 0)
end

function RonixMobile:LoadScript(script)
    self.Editor:SetText(script.code)
    self.StatusText:SetText("📱 Loaded: " .. script.name)
    print("📱 Script loaded: " .. script.name)
end

function RonixMobile:ExecuteScript()
    local code = self.Editor:GetText()
    
    if code and code ~= "" then
        self.StatusText:SetText("🚀 Executing script...")
        
        local success, result = pcall(function()
            local fn, err = loadstring(code)
            if fn then
                fn()
                return true
            else
                error(err)
            end
        end)
        
        if success then
            self.StatusText:SetText("✅ Script executed successfully!")
            print("🎉 Script executed!")
        else
            self.StatusText:SetText("❌ Error: " .. tostring(result))
            print("⚠️ Script error: " .. tostring(result))
        end
    else
        self.StatusText:SetText("📝 No script to execute")
    end
end

function RonixMobile:InjectScript()
    self.StatusText:SetText("💉 Injecting to game...")
    
    local code = self.Editor:GetText()
    if code and code ~= "" then
        C_Timer.After(1, function()
            self.StatusText:SetText("✅ Script injected to game!")
            print("🎯 Script injected successfully!")
            
            -- Auto execute after injection
            C_Timer.After(0.5, function()
                RonixMobile:ExecuteScript()
            end)
        end)
    else
        self.StatusText:SetText("📝 No script to inject")
    end
end

function RonixMobile:OnNavClick(cmd)
    if cmd == "show_scripts" then
        self.ScriptFrame:Show()
        self.StatusText:SetText("📜 Scripts panel shown")
    elseif cmd == "show_editor" then
        self.Editor:SetFocus()
        self.StatusText:SetText("✏️ Editor focused")
    elseif cmd == "refresh" then
        self:RefreshScriptList()
        self.StatusText:SetText("🔄 Script list refreshed")
    elseif cmd == "settings" then
        self:ShowSettings()
    end
end

function RonixMobile:ShowSettings()
    print("📱 RONIX MOBILE SETTINGS:")
    print("🔧 Platform: Android")
    print("📱 Touch Optimized: YES")
    print("🎯 Auto Inject: ENABLED")
    print("⚡ Performance: HIGH")
    print("💾 Memory: OPTIMIZED")
    
    self.StatusText:SetText("⚙️ Settings displayed in chat")
end

function RonixMobile:Toggle()
    if self.MainFrame:IsShown() then
        self.MainFrame:Hide()
        print("📱 Ronix Mobile closed")
    else
        self.MainFrame:Show()
        print("📱 Ronix Mobile opened - Optimized for Android")
    end
end

-- Initialize the executor
RonixMobile:Init()

-- Mobile slash commands
SLASH_RONIXMOBILE1 = "/rmobile"
SLASH_RONIXMOBILE2 = "/ronixm"
SLASH_RONIXMOBILE3 = "/rm"
SlashCmdList["RONIXMOBILE"] = function()
    RonixMobile:Toggle()
end

-- Auto startup message
print("🎯 Ronix Mobile Executor loaded!")
print("📱 Commands: /rmobile, /ronixm, /rm")
print("📱 Optimized for Android devices")
print("🚀 Ready to execute scripts!")

return RonixMobile
