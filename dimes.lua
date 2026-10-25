--// BLOSSOM key loader
--// Enter a key -> it is checked against your Firebase Realtime Database -> main script loads (dimes.txt).
--// Invalid / inactive / expired keys show a Roblox core notification ("Key" / "Key invalid").

-- ===================================================================
-- CONFIG  (only thing you need to edit)
-- ===================================================================
local CONFIG = {
    -- Your Realtime Database URL (Firebase console > Build > Realtime Database > Data tab, top of the page).
    -- Looks like  https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com
    -- or          https://YOUR-PROJECT-ID-default-rtdb.europe-west1.firebasedatabase.app
    DB_URL = "https://blossom-keys-default-rtdb.firebaseio.com",

    -- Where the main script (dimes.txt) comes from AFTER the key is accepted.
    --   1) Secure mode (recommended): store it in Firebase at  payload/<KEY>  (see setup guide).
    --      The Firebase rules only let an ACTIVE key read its own payload.
    --   2) Fallback URL: raw link to dimes.txt (GitHub raw, etc). Leave "" to disable.
    SCRIPT_URL = "",

    -- Lock each key to the first device that uses it (stored in keys/<KEY>/hwid).
    HWID_LOCK = true,

    TITLE = "BLOSSOM",
    SUBTITLE = "enter your license key",
}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local normiee = "rbxassetid://107415934558527"
local glitchy = {
    "rbxassetid://126903901230171",
    "rbxassetid://108334175828481",
    "rbxassetid://76083829320576",
    "rbxassetid://77937445438901",
}
local soundhover = "rbxassetid://9120299810"
local soundclick = "rbxassetid://139246456147301"
local glitchsounds = {
    "rbxassetid://131507757356742",
    "rbxassetid://140043289814504",
    "rbxassetid://129687541350237",
}
local random = math.random

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

-- returns ok, body, statusCode
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

-- returns ok, reason   (reason: invalid | inactive | expired | hwid | server | config)
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
        return false, "invalid" -- "null" => key does not exist
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

    -- Timed keys (weekly / monthly / yearly): the clock starts the first time the key is used.
    -- keys/<KEY>/days = length of the key, keys/<KEY>/expires gets written on first use.
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

-- downloads the main script (dimes.txt) after the key was accepted
local function fetchPayload(key)
    local ok, body = httpGet(dbBase() .. "/payload/" .. key .. ".json?t=" .. tostring(os.time()))
    if ok and body and body ~= "null" and #body > 2 then
        local dec
        local okDec = pcall(function() dec = HttpService:JSONDecode('{"v":' .. body .. '}') end)
        if okDec and type(dec) == "table" and type(dec.v) == "string" and #dec.v > 0 then
            return dec.v
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
-- palette (BLOSSOM)
-- ===================================================================
local C = {
    win     = Color3.fromRGB(13, 13, 14),
    panel   = Color3.fromRGB(11, 11, 12),
    field   = Color3.fromRGB(7, 7, 8),
    stroke  = Color3.fromRGB(36, 33, 36),
    text    = Color3.fromRGB(240, 236, 239),
    sub     = Color3.fromRGB(164, 157, 163),
    dim     = Color3.fromRGB(128, 120, 127),
    accent  = Color3.fromRGB(206, 164, 201),
    accentLt = Color3.fromRGB(224, 184, 218),
    accentDk = Color3.fromRGB(149, 118, 145),
    white   = Color3.fromRGB(244, 240, 243),
    ink     = Color3.fromRGB(14, 13, 14),
    bad     = Color3.fromRGB(236, 120, 142),
    good    = Color3.fromRGB(178, 214, 188),
}

local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p; return c
end
local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col; s.Thickness = th or 1; s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
end
local function label(parent, text, size, font, color, pos, sz, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size
    l.Font = font
    l.TextColor3 = color
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Position = pos
    l.Size = sz
    l.ZIndex = 5
    l.Parent = parent
    return l
end

-- ===================================================================
-- root
-- ===================================================================
local function cleanOld(parent)
    if not parent then return end
    pcall(function()
        for _, ch in ipairs(parent:GetChildren()) do
            if ch:IsA("ScreenGui") and ch.Name == "BlossomKey" then ch:Destroy() end
        end
    end)
end
pcall(function()
    for _, ef in ipairs(Lighting:GetChildren()) do
        if ef:IsA("BlurEffect") and ef.Name == "BlossomKeyBlur" then ef:Destroy() end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
local blur = Instance.new("BlurEffect")
local bg = Instance.new("Frame")
local glitchFrame = Instance.new("Frame")
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

blur.Name = "BlossomKeyBlur"
blur.Size = 0
blur.Parent = Lighting
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BackgroundTransparency = 0.35
bg.BorderSizePixel = 0
bg.ZIndex = 0
bg.Parent = ScreenGui
glitchFrame.Size = UDim2.fromScale(1, 1)
glitchFrame.BackgroundColor3 = Color3.new(0, 0, 0)
glitchFrame.BackgroundTransparency = 1
glitchFrame.BorderSizePixel = 0
glitchFrame.ZIndex = 100
glitchFrame.Parent = ScreenGui

-- ===================================================================
-- window
-- ===================================================================
local WIN_W, WIN_H = 500, 272
local originalPos = UDim2.new(0.5, 0, 0.5, 0)
local win = Instance.new("CanvasGroup")
win.Name = "MainWindow"
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = originalPos
win.Size = UDim2.fromOffset(WIN_W, WIN_H)
win.BackgroundColor3 = C.win
win.BorderSizePixel = 0
win.GroupTransparency = 1
win.ZIndex = 1
win.Parent = ScreenGui
corner(win, 10)
stroke(win, C.stroke, 1)

-- glitch overlay (uses ur glitch images)
local glitchOverlay = Instance.new("ImageLabel")
glitchOverlay.BackgroundTransparency = 1
glitchOverlay.Size = UDim2.fromScale(1, 1)
glitchOverlay.ScaleType = Enum.ScaleType.Stretch
glitchOverlay.Image = normiee
glitchOverlay.ImageTransparency = 1
glitchOverlay.ImageColor3 = C.accent
glitchOverlay.ZIndex = 50
glitchOverlay.Parent = win

-- header
local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 42)
header.ZIndex = 2
header.Parent = win

local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(16, 16)
logo.Position = UDim2.fromOffset(14, 13)
logo.BackgroundColor3 = C.accent
logo.Rotation = 45
logo.ZIndex = 5
logo.Parent = header
corner(logo, 4)
local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new(C.accentLt, C.accentDk)
logoGrad.Rotation = 90
logoGrad.Parent = logo

local titleLabel = label(header, CONFIG.TITLE, 16, Enum.Font.GothamBold, C.text,
    UDim2.fromOffset(40, 0), UDim2.new(0, 220, 1, 0))
local subtitleLabel = label(header, CONFIG.SUBTITLE, 11, Enum.Font.Gotham, C.sub,
    UDim2.new(1, -260, 0, 0), UDim2.new(0, 210, 1, 0), Enum.TextXAlignment.Right)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.sub
closeBtn.AutoButtonColor = false
closeBtn.BackgroundColor3 = C.accentDk
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.ZIndex = 6
closeBtn.Parent = header
corner(closeBtn, 6)

local divider = Instance.new("Frame")
divider.BackgroundColor3 = C.stroke
divider.BorderSizePixel = 0
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.fromOffset(0, 42)
divider.ZIndex = 2
divider.Parent = win

-- ===================================================================
-- key panel
-- ===================================================================
local content = Instance.new("Frame")
content.BackgroundColor3 = C.panel
content.BorderSizePixel = 0
content.Position = UDim2.fromOffset(12, 54)
content.Size = UDim2.new(1, -24, 1, -66)
content.ZIndex = 2
content.Parent = win
corner(content, 8)
stroke(content, C.stroke, 1)

local keyTitle = label(content, "LICENSE KEY", 10, Enum.Font.GothamBold, C.text,
    UDim2.fromOffset(16, 14), UDim2.fromOffset(200, 14))

local inputWrap = Instance.new("Frame")
inputWrap.BackgroundColor3 = C.field
inputWrap.BorderSizePixel = 0
inputWrap.Position = UDim2.fromOffset(16, 36)
inputWrap.Size = UDim2.new(1, -32, 0, 52)
inputWrap.ZIndex = 3
inputWrap.Parent = content
corner(inputWrap, 11)
local inputStroke = stroke(inputWrap, C.stroke, 1)

local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyBox"
keyBox.BackgroundTransparency = 1
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.PlaceholderText = "paste your key"
keyBox.PlaceholderColor3 = C.dim
keyBox.TextColor3 = C.text
keyBox.Font = Enum.Font.GothamMedium
keyBox.TextSize = 14
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.TextTruncate = Enum.TextTruncate.AtEnd
keyBox.Position = UDim2.fromOffset(20, 0)
keyBox.Size = UDim2.new(1, -40, 1, 0)
keyBox.ZIndex = 5
keyBox.Parent = inputWrap

-- verify button (white pill with dark arrow chip)
local verifyBtn = Instance.new("TextButton")
verifyBtn.Name = "Verify"
verifyBtn.Text = ""
verifyBtn.AutoButtonColor = false
verifyBtn.BackgroundColor3 = C.white
verifyBtn.BorderSizePixel = 0
verifyBtn.Position = UDim2.fromOffset(16, 104)
verifyBtn.Size = UDim2.new(1, -32, 0, 54)
verifyBtn.ZIndex = 3
verifyBtn.Parent = content
corner(verifyBtn, 11)

local verifyLbl = label(verifyBtn, "VERIFY AND LOAD", 13, Enum.Font.GothamBold, C.ink,
    UDim2.fromOffset(0, 0), UDim2.new(1, -52, 1, 0), Enum.TextXAlignment.Center)

local arrowChip = Instance.new("Frame")
arrowChip.BackgroundColor3 = C.ink
arrowChip.BorderSizePixel = 0
arrowChip.AnchorPoint = Vector2.new(1, 0.5)
arrowChip.Position = UDim2.new(1, -7, 0.5, 0)
arrowChip.Size = UDim2.fromOffset(44, 40)
arrowChip.ZIndex = 5
arrowChip.Parent = verifyBtn
corner(arrowChip, 9)

local function arrowPart(pos, size, rot, anchored)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = Color3.new(1, 1, 1)
    f.BorderSizePixel = 0
    if anchored then f.AnchorPoint = Vector2.new(0.5, 0.5) end
    f.Position = pos
    f.Size = size
    f.Rotation = rot or 0
    f.ZIndex = 6
    f.Parent = arrowChip
    corner(f, 1)
    return f
end
arrowPart(UDim2.fromOffset(14, 19), UDim2.fromOffset(15, 2), 0, false)
arrowPart(UDim2.fromOffset(27, 17), UDim2.fromOffset(8, 2), 45, true)
arrowPart(UDim2.fromOffset(27, 23), UDim2.fromOffset(8, 2), -45, true)

local statusLbl = label(content, "", 11, Enum.Font.GothamMedium, C.sub,
    UDim2.fromOffset(16, 168), UDim2.new(1, -32, 0, 16))

-- ===================================================================
-- glitch / sounds (same vibe as the old picker)
-- ===================================================================
local function glitch(offset)
    if offset and offset > 0 then
        win.Position = UDim2.new(
            0.5, (random(0, 1) == 0 and -offset or offset),
            0.5, (random(0, 1) == 0 and -offset or offset)
        )
        glitchOverlay.Image = glitchy[random(1, #glitchy)]
        glitchOverlay.ImageTransparency = 0.7
    else
        win.Position = originalPos
        glitchOverlay.ImageTransparency = 1
    end
end

local soundPool = {}
for i, id in ipairs(glitchsounds) do
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 0.12
    s.Parent = ScreenGui
    soundPool[i] = s
end
local function playGlitch()
    local s = soundPool[random(1, #soundPool)]
    if s then s:Play() end
end
local hoverSoundPool = {}
for i, id in ipairs(glitchsounds) do
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 0.04
    s.Parent = ScreenGui
    hoverSoundPool[i] = s
end
local hoverIndex = 0
local function playHoverGlitch()
    hoverIndex = hoverIndex + 1
    if hoverIndex > #hoverSoundPool then hoverIndex = 1 end
    local s = hoverSoundPool[hoverIndex]
    if s then s:Stop(); s:Play() end
end
local function playSound(id, vol)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.2
    s.Parent = ScreenGui
    s:Play()
    task.delay(3, function() s:Destroy() end)
end

local fast = TweenInfo.new(0.15)
local function hoverFx()
    playSound(soundhover, 0.15)
    playHoverGlitch()
    glitch(random(2, 6))
    task.delay(0.1, function() glitch(0) end)
end

-- ===================================================================
-- hover / focus states
-- ===================================================================
keyBox.Focused:Connect(function()
    TweenService:Create(inputStroke, fast, { Color = C.accent }):Play()
end)
keyBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke, fast, { Color = C.stroke }):Play()
end)

verifyBtn.MouseEnter:Connect(function()
    hoverFx()
    TweenService:Create(verifyBtn, fast, { BackgroundColor3 = C.accentLt }):Play()
    TweenService:Create(arrowChip, fast, { Position = UDim2.new(1, -5, 0.5, 0) }):Play()
end)
verifyBtn.MouseLeave:Connect(function()
    TweenService:Create(verifyBtn, fast, { BackgroundColor3 = C.white }):Play()
    TweenService:Create(arrowChip, fast, { Position = UDim2.new(1, -7, 0.5, 0) }):Play()
end)

closeBtn.MouseEnter:Connect(function()
    hoverFx()
    TweenService:Create(closeBtn, fast, { BackgroundTransparency = 0, TextColor3 = Color3.new(1, 1, 1) }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, fast, { BackgroundTransparency = 1, TextColor3 = C.sub }):Play()
end)

-- ===================================================================
-- open / close
-- ===================================================================
local function idk()
    blur.Size = 24
    glitchFrame.BackgroundTransparency = 0
    task.wait(0.05)
    for _ = 1, 6 do
        glitch(random(4, 12))
        playGlitch()
        task.wait(0.05)
        glitch(0)
        task.wait(0.03)
    end
    TweenService:Create(glitchFrame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    task.wait(0.2)
    win.Size = UDim2.fromOffset(WIN_W - 30, WIN_H - 20)
    TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        GroupTransparency = 0,
        Size = UDim2.fromOffset(WIN_W, WIN_H),
    }):Play()
end

local function fadeOut(t)
    local info = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(blur, info, { Size = 0 }):Play()
    TweenService:Create(bg, info, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(win, info, { GroupTransparency = 1, Size = UDim2.fromOffset(WIN_W - 30, WIN_H - 20) }):Play()
    task.wait(t + 0.1)
    ScreenGui:Destroy()
    blur:Destroy()
end

local function shake()
    task.spawn(function()
        for i = 1, 6 do
            local d = (i % 2 == 0) and 7 or -7
            win.Position = UDim2.new(0.5, d, 0.5, 0)
            task.wait(0.04)
        end
        win.Position = originalPos
    end)
end

-- ===================================================================
-- verify flow
-- ===================================================================
local busy = false
local fails, lockUntil = 0, 0

local function setStatus(txt, col)
    statusLbl.Text = txt or ""
    statusLbl.TextColor3 = col or C.sub
end

local function resetButton()
    busy = false
    verifyLbl.Text = "VERIFY AND LOAD"
end

local function submit()
    if busy then return end
    if tick() < lockUntil then
        local left = math.ceil(lockUntil - tick())
        setStatus("too many attempts - wait " .. left .. "s", C.bad)
        notify("Key", "Too many attempts, wait " .. left .. "s")
        return
    end
    busy = true
    verifyLbl.Text = "VERIFYING..."
    setStatus("checking key...", C.sub)

    local raw = keyBox.Text
    local ok, result = verifyKey(raw)
    if not ok then
        local msg = REASONS[result] or "Key invalid"
        notify("Key", msg)
        setStatus(msg:lower(), C.bad)
        shake()
        if result == "invalid" or result == "inactive" or result == "expired" or result == "hwid" then
            fails = fails + 1
            if fails >= 5 then
                fails = 0
                lockUntil = tick() + 10
            end
        end
        resetButton()
        return
    end

    local key = result
    fails = 0
    setStatus("key accepted - loading...", C.good)
    verifyLbl.Text = "LOADING..."
    playSound(soundclick, 0.3)

    local src = fetchPayload(key)
    if not src then
        notify("Key", "Failed to download script")
        setStatus("failed to download script", C.bad)
        resetButton()
        return
    end

    local fn, err = loadstring(src)
    if not fn then
        warn("[BLOSSOM] compile error: " .. tostring(err))
        notify("Key", "Script failed to load")
        setStatus("script failed to load", C.bad)
        resetButton()
        return
    end

    fadeOut(0.4)
    task.spawn(function()
        local okRun, runErr = pcall(fn)
        if not okRun then
            warn("[BLOSSOM] runtime error: " .. tostring(runErr))
        end
    end)
end

verifyBtn.MouseButton1Click:Connect(function()
    playSound(soundclick, 0.3)
    task.spawn(submit)
end)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        task.spawn(submit)
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    playSound(soundclick, 0.3)
    fadeOut(0.3)
end)

-- ===================================================================
-- loops
-- ===================================================================
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if random() < 0.55 then
            glitch(random(2, 8))
            playGlitch()
            task.wait(random(1, 4) / 10)
            glitch(0)
        end
        task.wait(1.5)
    end
end)

idk()
