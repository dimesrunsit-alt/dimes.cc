--// BLOSSOM Console Key Loader
--// Authentic CLI terminal interface matching Mooze design:
--// - Clean dark console aesthetic (no glitch effects)
--// - ASCII art title for BLOSSOM
--// - Interactive terminal prompt "[-] Key: "
--// - CoreGui notification support ("Key" / "Key invalid")
--// - Auto-save / silent login with Firebase Realtime Database

-- ===================================================================
-- CONFIG
-- ===================================================================
local CONFIG = {
    DB_URL = "https://blossom-keys-default-rtdb.firebaseio.com",
    SCRIPT_URL = "",
    HWID_LOCK = true,
    SAVE_KEY = true,
    RECORD_USER = true,
    TITLE = "Blossom",
}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- ===================================================================
-- Roblox core notification
-- ===================================================================
local function notify(title, text)
    task.spawn(function()
        for _ = 1, 12 do
            local ok = pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = title,
                    Text = text,
                    Duration = 5,
                })
            end)
            if ok then break end
            task.wait(0.25)
        end
    end)
end

-- ===================================================================
-- Key server (Firebase Realtime Database over REST)
-- ===================================================================
local function findRequest()
    local fn
    pcall(function()
        local env = (type(getgenv) == "function" and getgenv()) or _G
        fn = (type(request) == "function" and request)
            or (type(http_request) == "function" and http_request)
            or (type(http) == "table" and type(http.request) == "function" and http.request)
            or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
            or (type(fluxus) == "table" and type(fluxus.request) == "function" and fluxus.request)
            or (type(env) == "table" and (env.request or env.http_request))
    end)
    return (type(fn) == "function") and fn or nil
end

local function httpGet(url)
    local req = findRequest()
    if req then
        local ok, res = pcall(req, { Url = url, Method = "GET" })
        if ok and type(res) == "table" then
            local code = tonumber(res.StatusCode) or 0
            if code == 200 then
                return true, tostring(res.Body or ""), code
            end
            return false, tostring(res.Body or ""), code
        end
    end
    local ok, body = pcall(function() return game:HttpGet(url, true) end)
    if ok then return true, tostring(body or ""), 200 end
    return false, nil, 0
end

local function getHwid()
    local id
    pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end)
    if (not id or id == "") and type(gethwid) == "function" then
        pcall(function() id = gethwid() end)
    end
    if id and tostring(id) ~= "" then return tostring(id) end
    return nil
end

local function dbBase()
    return (CONFIG.DB_URL:gsub("/+$", ""))
end

local function cleanKey(raw)
    local k = tostring(raw or ""):match("^%s*(.-)%s*$") or ""
    if #k < 3 or #k > 64 then return nil end
    if not k:match("^[%w_%-]+$") then return nil end
    return k
end

local function verifyKey(raw)
    if CONFIG.DB_URL:find("YOUR%-PROJECT") then
        return false, "config"
    end
    local key = cleanKey(raw)
    if not key then return false, "invalid" end

    local ok, body, code = httpGet(dbBase() .. "/keys/" .. key .. ".json?t=" .. tostring(os.time()))
    if not ok then
        if code == 401 or code == 403 or code == 404 then return false, "invalid" end
        return false, "server"
    end

    local rec
    local okDec = pcall(function() rec = HttpService:JSONDecode(body) end)
    if not okDec or type(rec) ~= "table" then
        return false, "invalid"
    end

    if not (rec.active == true or rec.active == "true") then
        return false, "inactive"
    end

    local exp = tonumber(rec.expires)
    local alreadyStarted = (exp ~= nil and exp > 0)
    if alreadyStarted and os.time() >= exp then
        return false, "expired"
    end

    if CONFIG.HWID_LOCK then
        local hw = getHwid()
        if hw then
            if type(rec.hwid) == "string" and rec.hwid ~= "" then
                if rec.hwid ~= hw then return false, "hwid" end
            else
                local req = findRequest()
                if req then
                    pcall(req, {
                        Url = dbBase() .. "/keys/" .. key .. "/hwid.json",
                        Method = "PUT",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = HttpService:JSONEncode(hw),
                    })
                end
            end
        end
    end

    if CONFIG.RECORD_USER and not (type(rec.user) == "string" and rec.user ~= "") then
        local req = findRequest()
        local lp = Players.LocalPlayer
        if req and lp then
            pcall(req, {
                Url = dbBase() .. "/keys/" .. key .. "/user.json",
                Method = "PUT",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(lp.Name .. " (" .. tostring(lp.UserId) .. ")"),
            })
        end
    end

    if not alreadyStarted then
        local days = tonumber(rec.days)
        if days and days > 0 then
            local req = findRequest()
            if req then
                local okR, res = pcall(req, {
                    Url = dbBase() .. "/keys/" .. key .. "/expires.json",
                    Method = "PUT",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(os.time() + math.floor(days * 86400)),
                })
                if not (okR and type(res) == "table" and tonumber(res.StatusCode) == 200) then
                    return false, "activate"
                end
            end
        end
    end

    return true, key
end

local function fetchPayload(key)
    local url = dbBase() .. "/payload.json?orderBy=%22%24key%22&startAt=%22" .. key
        .. "%22&endAt=%22~main%22&t=" .. tostring(os.time())
    local ok, body = httpGet(url)
    if ok and body and body ~= "null" and #body > 2 then
        local dec
        local okDec = pcall(function() dec = HttpService:JSONDecode(body) end)
        if okDec and type(dec) == "table" and type(dec["~main"]) == "string" and #dec["~main"] > 0 then
            return dec["~main"]
        end
    end
    if CONFIG.SCRIPT_URL and CONFIG.SCRIPT_URL ~= "" then
        local ok2, body2 = httpGet(CONFIG.SCRIPT_URL)
        if ok2 and body2 and #body2 > 0 then
            return body2
        end
    end
    return nil
end

local REASONS = {
    invalid  = "Key invalid",
    inactive = "Key inactive",
    expired  = "Key expired",
    hwid     = "Key is locked to another device",
    server   = "Could not reach key server",
    activate = "Could not activate key - check your PC clock",
    config   = "Key server not configured",
}

-- ===================================================================
-- Saved key (Auto-Login)
-- ===================================================================
local KEY_FILE = "blossom_key.txt"

local function readSavedKey()
    if not CONFIG.SAVE_KEY then return nil end
    local okR, v = pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile(KEY_FILE) then
            return readfile(KEY_FILE)
        end
    end)
    if okR and type(v) == "string" then return cleanKey(v) end
    return nil
end

local function saveKey(k)
    if not CONFIG.SAVE_KEY then return end
    pcall(function()
        if type(writefile) == "function" then writefile(KEY_FILE, k) end
    end)
end

local function forgetKey()
    pcall(function()
        if type(isfile) == "function" and isfile(KEY_FILE) then
            if type(delfile) == "function" then
                delfile(KEY_FILE)
            elseif type(writefile) == "function" then
                writefile(KEY_FILE, "")
            end
        end
    end)
end

-- Silent login: if saved key is still good, load payload immediately and skip key UI
do
    local saved = readSavedKey()
    if saved then
        local ok, result = verifyKey(saved)
        if ok then
            local src = fetchPayload(result)
            local fn = src and loadstring(src)
            if fn then
                task.spawn(function()
                    local okRun, runErr = pcall(fn)
                    if not okRun then warn("[BLOSSOM] runtime error: " .. tostring(runErr)) end
                end)
                return
            end
            notify("Key", "Failed to download script")
        else
            if result == "invalid" or result == "inactive" or result == "expired" or result == "hwid" then
                forgetKey()
            end
            notify("Key", REASONS[result] or "Key invalid")
        end
    end
end

-- ===================================================================
-- UI Palette (Mooze / Terminal Style)
-- ===================================================================
local C = {
    winBg       = Color3.fromRGB(10, 10, 11),
    titleBar    = Color3.fromRGB(14, 14, 16),
    titleBrd    = Color3.fromRGB(28, 28, 32),
    winBorder   = Color3.fromRGB(38, 38, 44),
    iconOrange  = Color3.fromRGB(240, 75, 45),
    textWhite   = Color3.fromRGB(235, 235, 240),
    textDim     = Color3.fromRGB(160, 160, 170),
    promptRed   = Color3.fromRGB(230, 60, 60),
    promptGray  = Color3.fromRGB(205, 205, 215),
    success     = Color3.fromRGB(120, 220, 140),
    errorRed    = Color3.fromRGB(240, 85, 85),
    btnHover    = Color3.fromRGB(32, 32, 38),
    closeHover  = Color3.fromRGB(210, 45, 45),
}

local function cleanOld(parent)
    if not parent then return end
    pcall(function()
        for _, ch in ipairs(parent:GetChildren()) do
            if ch:IsA("ScreenGui") and ch.Name == "BlossomKey" then ch:Destroy() end
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlossomKey"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 2147483646
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parented = false
pcall(function()
    if gethui then
        local h = gethui()
        cleanOld(h)
        ScreenGui.Parent = h
        parented = (ScreenGui.Parent ~= nil)
    end
end)
if not parented then
    pcall(function()
        cleanOld(CoreGui)
        ScreenGui.Parent = CoreGui
        parented = (ScreenGui.Parent ~= nil)
    end)
end
if not parented then
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
    cleanOld(pg)
    ScreenGui.Parent = pg
end

-- Background dimmer (subtle)
local bgDim = Instance.new("Frame")
bgDim.Name = "BackgroundDim"
bgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgDim.BackgroundTransparency = 0.45
bgDim.BorderSizePixel = 0
bgDim.Size = UDim2.fromScale(1, 1)
bgDim.ZIndex = 0
bgDim.Parent = ScreenGui

-- Window Container
local WIN_W, WIN_H = 590, 290
local win = Instance.new("Frame")
win.Name = "ConsoleWindow"
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.Size = UDim2.fromOffset(WIN_W, WIN_H)
win.BackgroundColor3 = C.winBg
win.BorderSizePixel = 0
win.ZIndex = 1
win.ClipsDescendants = true
win.Parent = ScreenGui

local winCorner = Instance.new("UICorner")
winCorner.CornerRadius = UDim.new(0, 3)
winCorner.Parent = win

local winStroke = Instance.new("UIStroke")
winStroke.Color = C.winBorder
winStroke.Thickness = 1
winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
winStroke.Parent = win

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.BackgroundColor3 = C.titleBar
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 26)
titleBar.ZIndex = 2
titleBar.Active = true
titleBar.Parent = win

local titleBarSep = Instance.new("Frame")
titleBarSep.BackgroundColor3 = C.titleBrd
titleBarSep.BorderSizePixel = 0
titleBarSep.Position = UDim2.new(0, 0, 1, -1)
titleBarSep.Size = UDim2.new(1, 0, 0, 1)
titleBarSep.ZIndex = 3
titleBarSep.Parent = titleBar

-- Orange-red "B" Logo on the left
local iconLabel = Instance.new("TextLabel")
iconLabel.Name = "LogoIcon"
iconLabel.BackgroundTransparency = 1
iconLabel.Position = UDim2.fromOffset(8, 0)
iconLabel.Size = UDim2.fromOffset(16, 25)
iconLabel.Font = Enum.Font.GothamBlack
iconLabel.Text = "B"
iconLabel.TextSize = 14
iconLabel.TextColor3 = C.iconOrange
iconLabel.TextXAlignment = Enum.TextXAlignment.Center
iconLabel.TextYAlignment = Enum.TextYAlignment.Center
iconLabel.ZIndex = 4
iconLabel.Parent = titleBar

-- Title Text: "Blossom"
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleText"
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.fromOffset(26, 0)
titleLabel.Size = UDim2.new(0, 180, 1, -1)
titleLabel.Font = Enum.Font.GothamMedium
titleLabel.Text = CONFIG.TITLE
titleLabel.TextSize = 12
titleLabel.TextColor3 = C.textWhite
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 4
titleLabel.Parent = titleBar

-- Window Controls (Minimize & Close)
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeBtn"
minBtn.Text = "-"
minBtn.Font = Enum.Font.Code
minBtn.TextSize = 15
minBtn.TextColor3 = C.textWhite
minBtn.AutoButtonColor = false
minBtn.BackgroundColor3 = C.btnHover
minBtn.BackgroundTransparency = 1
minBtn.Size = UDim2.fromOffset(30, 25)
minBtn.Position = UDim2.new(1, -62, 0, 0)
minBtn.ZIndex = 4
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.TextColor3 = C.textWhite
closeBtn.AutoButtonColor = false
closeBtn.BackgroundColor3 = C.closeHover
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.fromOffset(32, 25)
closeBtn.Position = UDim2.new(1, -32, 0, 0)
closeBtn.ZIndex = 4
closeBtn.Parent = titleBar

-- Window Dragging Logic
do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Button Hover Effects
minBtn.MouseEnter:Connect(function() minBtn.BackgroundTransparency = 0 end)
minBtn.MouseLeave:Connect(function() minBtn.BackgroundTransparency = 1 end)
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundTransparency = 0 end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundTransparency = 1 end)

-- Console Body Area
local consoleBody = Instance.new("TextButton")
consoleBody.Name = "ConsoleBody"
consoleBody.Text = ""
consoleBody.AutoButtonColor = false
consoleBody.BackgroundTransparency = 1
consoleBody.Position = UDim2.fromOffset(0, 26)
consoleBody.Size = UDim2.new(1, 0, 1, -26)
consoleBody.ZIndex = 2
consoleBody.Parent = win

-- ASCII Art Header for "BLOSSOM"
local asciiLines = {
    "oooooooooo.   ooooo          .oooooo.    .oooooo..o  .oooooo..o   .oooooo.   ooo        ooooo",
    "`888'   `Y8b  `888'         d8P'  `Y8b  d8P'    `Y8 d8P'    `Y8  d8P'  `Y8b  `88.       .888'",
    " 888     888   888         888      888 Y88bo.      Y88bo.      888      888  888b     d'888 ",
    " 888oooo888'   888         888      888  `'Y8888o.   `'Y8888o.  888      888  8 Y88   .P 888 ",
    " 888    `88b   888         888      888      `\"Y88b      `\"Y88b 888      888  8  `888'   888 ",
    " 888    .88P   888       o `88b    d88' oo     .d8P oo     .d8P `88b    d88'  8    Y     888 ",
    "o888bood8P'   o888ooooood8  `Y8bood8P'  8\"\"88888P'  8\"\"88888P'   `Y8bood8P'  o8o        o888o"
}
local asciiText = table.concat(asciiLines, "\n")

local asciiLabel = Instance.new("TextLabel")
asciiLabel.Name = "AsciiBanner"
asciiLabel.BackgroundTransparency = 1
asciiLabel.Position = UDim2.fromOffset(18, 14)
asciiLabel.Size = UDim2.new(1, -36, 0, 115)
asciiLabel.Font = Enum.Font.Code
asciiLabel.Text = asciiText
asciiLabel.TextSize = 9.5
asciiLabel.TextColor3 = C.textWhite
asciiLabel.TextXAlignment = Enum.TextXAlignment.Left
asciiLabel.TextYAlignment = Enum.TextYAlignment.Top
asciiLabel.LineHeight = 1.05
asciiLabel.ZIndex = 3
asciiLabel.Parent = consoleBody

-- Interactive Terminal Prompt Row: "[-] Key: "
local promptRow = Instance.new("Frame")
promptRow.Name = "PromptRow"
promptRow.BackgroundTransparency = 1
promptRow.Position = UDim2.fromOffset(20, 160)
promptRow.Size = UDim2.new(1, -40, 0, 24)
promptRow.ZIndex = 3
promptRow.Parent = consoleBody

-- "[-]" Tag
local promptTag = Instance.new("TextLabel")
promptTag.Name = "PromptTag"
promptTag.BackgroundTransparency = 1
promptTag.Position = UDim2.fromOffset(0, 0)
promptTag.Size = UDim2.fromOffset(26, 24)
promptTag.Font = Enum.Font.Code
promptTag.Text = "[-]"
promptTag.TextSize = 13
promptTag.TextColor3 = C.promptRed
promptTag.TextXAlignment = Enum.TextXAlignment.Left
promptTag.ZIndex = 4
promptTag.Parent = promptRow

-- "Key: " Tag
local promptKeyLabel = Instance.new("TextLabel")
promptKeyLabel.Name = "KeyLabel"
promptKeyLabel.BackgroundTransparency = 1
promptKeyLabel.Position = UDim2.fromOffset(28, 0)
promptKeyLabel.Size = UDim2.fromOffset(45, 24)
promptKeyLabel.Font = Enum.Font.Code
promptKeyLabel.Text = "Key: "
promptKeyLabel.TextSize = 13
promptKeyLabel.TextColor3 = C.promptGray
promptKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
promptKeyLabel.ZIndex = 4
promptKeyLabel.Parent = promptRow

-- Key TextBox
local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyInput"
keyBox.BackgroundTransparency = 1
keyBox.ClearTextOnFocus = false
keyBox.Position = UDim2.fromOffset(74, 0)
keyBox.Size = UDim2.new(1, -110, 1, 0)
keyBox.Font = Enum.Font.Code
keyBox.Text = ""
keyBox.PlaceholderText = ""
keyBox.TextColor3 = C.textWhite
keyBox.TextSize = 13
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.TextYAlignment = Enum.TextYAlignment.Center
keyBox.ZIndex = 4
keyBox.Parent = promptRow

-- Blinking Console Underscore Cursor
local cursorLabel = Instance.new("TextLabel")
cursorLabel.Name = "BlinkCursor"
cursorLabel.BackgroundTransparency = 1
cursorLabel.Position = UDim2.fromOffset(74, 0)
cursorLabel.Size = UDim2.fromOffset(12, 24)
cursorLabel.Font = Enum.Font.Code
cursorLabel.Text = "_"
cursorLabel.TextSize = 14
cursorLabel.TextColor3 = C.textWhite
cursorLabel.TextXAlignment = Enum.TextXAlignment.Left
cursorLabel.ZIndex = 4
cursorLabel.Parent = promptRow

local function updateCursorPos()
    local textLen = #keyBox.Text
    cursorLabel.Position = UDim2.fromOffset(74 + math.floor(textLen * 7.8), 0)
    cursorLabel.Visible = true
end
keyBox:GetPropertyChangedSignal("Text"):Connect(updateCursorPos)

-- Blinking loop
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if keyBox:IsFocused() or #keyBox.Text == 0 then
            cursorLabel.Visible = not cursorLabel.Visible
        else
            cursorLabel.Visible = false
        end
        task.wait(0.5)
    end
end)

-- Click anywhere inside console to focus key box
consoleBody.MouseButton1Click:Connect(function()
    keyBox:CaptureFocus()
end)

-- Status / Output Console Line
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLine"
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.fromOffset(20, 196)
statusLabel.Size = UDim2.new(1, -40, 0, 20)
statusLabel.Font = Enum.Font.Code
statusLabel.Text = "[*] Enter your key and press Enter"
statusLabel.TextSize = 12
statusLabel.TextColor3 = C.textDim
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 3
statusLabel.Parent = consoleBody

local function setStatus(msg, col)
    statusLabel.Text = msg or ""
    statusLabel.TextColor3 = col or C.textDim
end

-- Close / FadeOut
local function fadeOut(dur)
    local t = dur or 0.25
    local info = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(win, info, { BackgroundTransparency = 1 }):Play()
    for _, ch in ipairs(win:GetDescendants()) do
        if ch:IsA("TextLabel") or ch:IsA("TextBox") or ch:IsA("TextButton") then
            TweenService:Create(ch, info, { TextTransparency = 1 }):Play()
        end
        if ch:IsA("Frame") then
            TweenService:Create(ch, info, { BackgroundTransparency = 1 }):Play()
        end
        if ch:IsA("UIStroke") then
            TweenService:Create(ch, info, { Transparency = 1 }):Play()
        end
    end
    task.wait(t + 0.05)
    ScreenGui:Destroy()
end

closeBtn.MouseButton1Click:Connect(function()
    fadeOut(0.2)
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    consoleBody.Visible = not minimized
    win.Size = minimized and UDim2.fromOffset(WIN_W, 26) or UDim2.fromOffset(WIN_W, WIN_H)
end)

-- ===================================================================
-- Submission & Verification Logic
-- ===================================================================
local busy = false
local fails, lockUntil = 0, 0

local function submit()
    if busy then return end
    if tick() < lockUntil then
        local left = math.ceil(lockUntil - tick())
        setStatus("[-] Too many attempts. Please wait " .. left .. "s", C.errorRed)
        notify("Key", "Too many attempts, wait " .. left .. "s")
        return
    end

    local raw = keyBox.Text
    if #raw == 0 then
        setStatus("[-] Please enter a key", C.errorRed)
        return
    end

    busy = true
    setStatus("[*] Verifying key with server...", C.promptGray)

    local ok, result = verifyKey(raw)
    if not ok then
        local msg = REASONS[result] or "Key invalid"
        notify("Key", msg)
        setStatus("[-] " .. msg, C.errorRed)
        if result == "invalid" or result == "inactive" or result == "expired" or result == "hwid" then
            fails = fails + 1
            if fails >= 5 then
                fails = 0
                lockUntil = tick() + 10
            end
        end
        busy = false
        return
    end

    local key = result
    fails = 0
    saveKey(key)
    setStatus("[+] Key accepted! Loading BLOSSOM...", C.success)

    local src = fetchPayload(key)
    if not src then
        notify("Key", "Failed to download script")
        setStatus("[-] Failed to download script payload", C.errorRed)
        busy = false
        return
    end

    local fn, err = loadstring(src)
    if not fn then
        warn("[BLOSSOM] compile error: " .. tostring(err))
        notify("Key", "Script failed to load")
        setStatus("[-] Script compile error: " .. tostring(err), C.errorRed)
        busy = false
        return
    end

    fadeOut(0.3)
    task.spawn(function()
        local okRun, runErr = pcall(fn)
        if not okRun then
            warn("[BLOSSOM] runtime error: " .. tostring(runErr))
        end
    end)
end

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        task.spawn(submit)
    end
end)

-- Auto focus keyBox on launch
task.defer(function()
    keyBox:CaptureFocus()
end)
