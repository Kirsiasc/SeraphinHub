-- Android Mobile Executor - Compatible Version
local AndroidExecutor = {}

-- Safe initialization
local function SafeInit()
    -- Check available functions
    if not CreateFrame then
        print("❌ CreateFrame not available")
        return false
    end
    
    if not UIParent then
        print("❌ UIParent not available") 
        return false
    end
    
    return true
end

function AndroidExecutor:CreateUI()
    if not SafeInit() then
        print("📱 Using fallback console mode")
        self:ConsoleMode()
        return
    end

    -- Main Frame
    self.MainFrame = CreateFrame("Frame", "AndroidExecutorFrame", UIParent)
    self.MainFrame:SetSize(380, 600)
    self.MainFrame:SetPoint("CENTER")
    self.MainFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.MainFrame:SetBackdropColor(0.1, 0.1, 0.2, 0.95)
    self.MainFrame:SetMovable(true)
    self.MainFrame:EnableMouse(true)
    self.MainFrame:RegisterForDrag("LeftButton")
    self.MainFrame:SetScript("OnDragStart", self.MainFrame.StartMoving)
    self.MainFrame:SetScript("OnDragStop", self.MainFrame.StopMovingOrSizing)

    -- Title
    self.TitleBar = CreateFrame("Frame", nil, self.MainFrame)
    self.TitleBar:SetSize(380, 40)
    self.TitleBar:SetPoint("TOP")
    self.TitleBar:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground" })
    self.TitleBar:SetBackdropColor(0.2, 0.2, 0.4, 1)

    self.TitleText = self.TitleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.TitleText:SetPoint("CENTER")
    self.TitleText:SetText("📱 ANDROID EXECUTOR")
    self.TitleText:SetTextColor(0, 1, 1)

    -- Close Button
    self.CloseBtn = CreateFrame("Button", nil, self.TitleBar, "UIPanelButtonTemplate")
    self.CloseBtn:SetSize(30, 30)
    self.CloseBtn:SetPoint("TOPRIGHT", -5, -5)
    self.CloseBtn:SetText("X")
    self.CloseBtn:SetScript("OnClick", function() self.MainFrame:Hide() end)

    self:CreateComponents()
    self.MainFrame:Hide()
end

function AndroidExecutor:CreateComponents()
    -- Navigation
    local navFrame = CreateFrame("Frame", nil, self.MainFrame)
    navFrame:SetSize(360, 40)
    navFrame:SetPoint("TOP", 0, -45)

    local navButtons = {
        {"SCRIPTS", "scripts"},
        {"EDITOR", "editor"}, 
        {"RUN", "run"}
    }

    for i, btnInfo in ipairs(navButtons) do
        local btn = CreateFrame("Button", nil, navFrame, "UIPanelButtonTemplate")
        btn:SetSize(100, 30)
        btn:SetPoint("LEFT", (i-1)*110 + 20, 0)
        btn:SetText(btnInfo[1])
        btn:SetScript("OnClick", function() self:OnNavClick(btnInfo[2]) end)
    end

    -- Script List
    self.ScriptFrame = CreateFrame("Frame", nil, self.MainFrame)
    self.ScriptFrame:SetSize(360, 180)
    self.ScriptFrame:SetPoint("TOP", 0, -90)

    local scriptTitle = self.ScriptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scriptTitle:SetPoint("TOP", 0, 0)
    scriptTitle:SetText("Available Scripts")
    scriptTitle:SetTextColor(1, 1, 0)

    self.ScriptScroll = CreateFrame("ScrollFrame", nil, self.ScriptFrame, "UIPanelScrollFrameTemplate")
    self.ScriptScroll:SetSize(340, 150)
    self.ScriptScroll:SetPoint("TOP", 0, -20)

    self.ScriptContent = CreateFrame("Frame", nil, self.ScriptScroll)
    self.ScriptContent:SetSize(320, 100)
    self.ScriptScroll:SetScrollChild(self.ScriptContent)

    -- Editor
    self.EditorFrame = CreateFrame("Frame", nil, self.MainFrame)
    self.EditorFrame:SetSize(360, 200)
    self.EditorFrame:SetPoint("TOP", 0, -280)

    local editorTitle = self.EditorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    editorTitle:SetPoint("TOP", 0, 0)
    editorTitle:SetText("Script Editor")
    editorTitle:SetTextColor(0, 1, 1)

    self.Editor = CreateFrame("EditBox", nil, self.EditorFrame, "InputBoxTemplate")
    self.Editor:SetSize(340, 170)
    self.Editor:SetPoint("TOP", 0, -20)
    self.Editor:SetMultiLine(true)
    self.Editor:SetAutoFocus(false)
    self.Editor:SetFontObject("GameFontNormal")
    self.Editor:SetText("-- Android Script Editor\nprint('📱 Mobile Executor Ready!')\n\n-- Test script\nfor i=1,3 do\n    print('Test '..i)\n    wait(1)\nend")

    self.EditorScroll = CreateFrame("ScrollFrame", nil, self.EditorFrame, "UIPanelScrollFrameTemplate")
    self.EditorScroll:SetSize(340, 170)
    self.EditorScroll:SetPoint("TOP", 0, -20)
    self.EditorScroll:SetScrollChild(self.Editor)

    -- Buttons
    local btnFrame = CreateFrame("Frame", nil, self.MainFrame)
    btnFrame:SetSize(360, 50)
    btnFrame:SetPoint("BOTTOM", 0, 10)

    self.ExecuteBtn = CreateFrame("Button", nil, btnFrame, "UIPanelButtonTemplate")
    self.ExecuteBtn:SetSize(100, 35)
    self.ExecuteBtn:SetPoint("LEFT", 30, 0)
    self.ExecuteBtn:SetText("EXECUTE")
    self.ExecuteBtn:SetScript("OnClick", function() self:ExecuteScript() end)

    self.ClearBtn = CreateFrame("Button", nil, btnFrame, "UIPanelButtonTemplate")
    self.ClearBtn:SetSize(100, 35)
    self.ClearBtn:SetPoint("RIGHT", -30, 0)
    self.ClearBtn:SetText("CLEAR")
    self.ClearBtn:SetScript("OnClick", function() self.Editor:SetText("") end)

    -- Status
    self.StatusBar = CreateFrame("Frame", nil, self.MainFrame)
    self.StatusBar:SetSize(380, 25)
    self.StatusBar:SetPoint("BOTTOM")
    self.StatusBar:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
    self.StatusBar:SetBackdropColor(0, 0.3, 0, 0.8)

    self.StatusText = self.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.StatusText:SetPoint("CENTER")
    self.StatusText:SetText("✅ Ready - Android Executor")
end

function AndroidExecutor:LoadScripts()
    self.Scripts = {
        {
            name = "Test Print",
            code = "print('📱 Android Test Successful!')\nfor i=1,5 do\n    print('Count: '..i)\n    wait(1)\nend"
        },
        {
            name = "Simple Loop", 
            code = "for i=1,10 do\n    print('Loop: '..i)\n    wait(0.5)\nend"
        },
        {
            name = "Math Test",
            code = "local a = 10\nlocal b = 20\nprint('Math: '..a..' + '..b..' = '..(a+b))"
        },
        {
            name = "Function Test",
            code = "local function test()\n    return 'Function Working!'\nend\nprint(test())"
        }
    }
    
    self:RefreshScriptList()
end

function AndroidExecutor:RefreshScriptList()
    for _, btn in ipairs(self.ScriptButtons or {}) do
        btn:Hide()
    end

    self.ScriptButtons = {}

    for i, script in ipairs(self.Scripts) do
        local btn = CreateFrame("Button", nil, self.ScriptContent)
        btn:SetSize(300, 25)
        btn:SetPoint("TOP", 0, -((i-1)*30))

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", 10, 0)
        text:SetText(script.name)
        text:SetTextColor(1, 1, 1)

        btn:SetScript("OnClick", function() self:LoadScript(script) end)

        table.insert(self.ScriptButtons, btn)
    end

    self.ScriptContent:SetHeight(#self.Scripts * 30)
end

function AndroidExecutor:LoadScript(script)
    self.Editor:SetText(script.code)
    self.StatusText:SetText("Loaded: " .. script.name)
end

function AndroidExecutor:ExecuteScript()
    local code = self.Editor:GetText()
    
    if not code or code == "" then
        self.StatusText:SetText("No script to execute")
        return
    end

    self.StatusText:SetText("Executing...")

    -- Safe execution
    local success, result = pcall(function()
        if not loadstring then
            return "loadstring not available"
        end
        
        local fn, err = loadstring(code)
        if not fn then
            return "Compile error: " .. tostring(err)
        end
        
        return fn()
    end)

    if success then
        self.StatusText:SetText("Execution complete!")
        print("✅ Script executed successfully!")
    else
        self.StatusText:SetText("Error: " .. tostring(result))
        print("❌ Execution error: " .. tostring(result))
    end
end

function AndroidExecutor:OnNavClick(action)
    if action == "scripts" then
        self.StatusText:SetText("Scripts panel")
    elseif action == "editor" then
        self.Editor:SetFocus()
        self.StatusText:SetText("Editor focused")
    elseif action == "run" then
        self:ExecuteScript()
    end
end

function AndroidExecutor:ConsoleMode()
    print("📱 ANDROID CONSOLE EXECUTOR")
    print("Commands: /android, /exec")
    print("Type your scripts directly in console!")
    
    self.ConsoleMode = true
end

function AndroidExecutor:Toggle()
    if self.ConsoleMode then
        print("📱 Android Console Executor Active")
        print("Paste your scripts in the console")
        return
    end

    if self.MainFrame:IsShown() then
        self.MainFrame:Hide()
        print("📱 Executor closed")
    else
        self.MainFrame:Show()
        print("📱 Android Executor opened")
    end
end

-- Initialize
local success, err = pcall(function()
    AndroidExecutor:CreateUI()
    AndroidExecutor:LoadScripts()
end)

if not success then
    print("❌ UI Creation failed: " .. tostring(err))
    AndroidExecutor:ConsoleMode()
else
    print("✅ Android Executor UI created successfully!")
end

-- Simple slash commands (no SAFEMOBILE reference)
SLASH_ANDROID1 = "/android"
SLASH_ANDROID2 = "/exec"
SLASH_ANDROID3 = "/ae"
SlashCmdList["ANDROID"] = function()
    AndroidExecutor:Toggle()
end

print("📱 ANDROID EXECUTOR LOADED!")
print("📱 Commands: /android, /exec, /ae")
print("📱 Optimized for mobile devices")

return AndroidExecutor
