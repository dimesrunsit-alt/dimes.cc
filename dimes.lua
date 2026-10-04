--me wants 2 choose dat a 1
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
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
local rngTitles = {
    "Dimes.cc", "D.cc", "HBSS.cc", "Dimes-est", "Dimes-er",
    "Diiiiimes.cc", "Dimesy.cc", "Dimes.com", "Hi! I'm Dimes.cc",
    "Dimes :3", "DIMES.CC >:D", "holy dimes.cc",
    "DimesDimesDimes.cc", "I like dimes", "Dimes.cheatcheat",
    "Dimes.yes", "Dimes.no", "Dimes.lua", "DIMES DIMES.CC",
    "shiny clean ui", "dimes are not nickels", "are dimes just nickels",
    "dimes cute :3", "dimes go brr", "Gpssickle's child",
    "wallet upgrade 1+", "pocket change simulator", "the dimes experience"
}

-- ===== palette =====
local C = {
    win     = Color3.fromRGB(16, 16, 19),
    panel   = Color3.fromRGB(11, 11, 13),
    stroke  = Color3.fromRGB(38, 38, 44),
    text    = Color3.fromRGB(235, 235, 240),
    sub     = Color3.fromRGB(140, 140, 150),
    red     = Color3.fromRGB(235, 55, 55),
    redLt   = Color3.fromRGB(255, 120, 110),
    redDk   = Color3.fromRGB(190, 25, 30),
    selBg   = Color3.fromRGB(55, 14, 16),
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

-- ===== root =====
local ScreenGui = Instance.new("ScreenGui")
local blur = Instance.new("BlurEffect")
local bg = Instance.new("Frame")
local glitchFrame = Instance.new("Frame")
ScreenGui.Name = "option"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 2147483646
ScreenGui.Parent = CoreGui
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
glitchFrame.ZIndex = 100
glitchFrame.Parent = ScreenGui

-- ===== window =====
local originalPos = UDim2.new(0.5, 0, 0.5, 0)
local win = Instance.new("CanvasGroup")
win.Name = "MainWindow"
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = originalPos
win.Size = UDim2.fromOffset(500, 300)
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
glitchOverlay.ImageColor3 = C.red
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
logo.BackgroundColor3 = C.red
logo.Rotation = 45
logo.ZIndex = 5
logo.Parent = header
corner(logo, 4)
local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new(C.redLt, C.redDk)
logoGrad.Rotation = 90
logoGrad.Parent = logo

local titleLabel = label(header, "dimes.cc", 16, Enum.Font.GothamBold, C.red,
    UDim2.fromOffset(40, 0), UDim2.new(0, 220, 1, 0))
local subtitleLabel = label(header, "choose ur adventure or smth", 11, Enum.Font.Gotham, C.sub,
    UDim2.new(1, -260, 0, 0), UDim2.new(0, 210, 1, 0), Enum.TextXAlignment.Right)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = C.sub
closeBtn.AutoButtonColor = false
closeBtn.BackgroundColor3 = C.red
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

-- sidebar
local sidebar = Instance.new("Frame")
sidebar.BackgroundTransparency = 1
sidebar.Position = UDim2.fromOffset(10, 54)
sidebar.Size = UDim2.fromOffset(140, 236)
sidebar.ZIndex = 2
sidebar.Parent = win
local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 6)
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Parent = sidebar

local function makeSideItem(icon, text, order)
    local b = Instance.new("TextButton")
    b.Text = ""
    b.AutoButtonColor = false
    b.BackgroundColor3 = C.selBg
    b.BackgroundTransparency = 1
    b.Size = UDim2.new(1, 0, 0, 28)
    b.LayoutOrder = order
    b.ZIndex = 4
    b.Parent = sidebar
    corner(b, 14)
    local s = stroke(b, C.red, 1.5, 1)
    local ic = label(b, icon, 12, Enum.Font.GothamBold, C.text,
        UDim2.fromOffset(10, 0), UDim2.new(0, 16, 1, 0), Enum.TextXAlignment.Center)
    local tx = label(b, text, 12, Enum.Font.GothamMedium, C.text,
        UDim2.fromOffset(32, 0), UDim2.new(1, -36, 1, 0))
    return b, s, ic, tx
end

-- content panel
local content = Instance.new("Frame")
content.BackgroundColor3 = C.panel
content.BorderSizePixel = 0
content.Position = UDim2.fromOffset(160, 54)
content.Size = UDim2.fromOffset(330, 236)
content.ZIndex = 2
content.Parent = win
corner(content, 8)
stroke(content, C.stroke, 1)

local scrollBar = Instance.new("Frame")
scrollBar.BackgroundColor3 = C.red
scrollBar.BorderSizePixel = 0
scrollBar.Position = UDim2.new(1, -7, 0, 10)
scrollBar.Size = UDim2.new(0, 3, 1, -20)
scrollBar.ZIndex = 3
scrollBar.Parent = content
corner(scrollBar, 2)

local function makeCard(title, desc, yPos)
    local card = Instance.new("TextButton")
    card.Text = ""
    card.AutoButtonColor = false
    card.BackgroundColor3 = Color3.new(1, 1, 1)
    card.Position = UDim2.fromOffset(10, yPos)
    card.Size = UDim2.new(1, -28, 0, 103)
    card.ZIndex = 3
    card.Parent = content
    corner(card, 4)
    local st = stroke(card, Color3.fromRGB(0, 0, 0), 2, 0)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.redLt),
        ColorSequenceKeypoint.new(0.5, C.red),
        ColorSequenceKeypoint.new(1, C.redDk),
    })
    g.Rotation = 25
    g.Parent = card

    -- lil halftone dots
    local dots = Instance.new("Frame")
    dots.BackgroundTransparency = 1
    dots.Size = UDim2.fromScale(1, 1)
    dots.ZIndex = 4
    dots.Parent = card
    for x = 0, 13 do
        for y = 0, 4 do
            local d = Instance.new("Frame")
            local sz = math.max(2, 9 - x * 0.55)
            d.Size = UDim2.fromOffset(sz, sz)
            d.AnchorPoint = Vector2.new(0.5, 0.5)
            d.Position = UDim2.fromOffset(170 + x * 10, 12 + y * 20)
            d.BackgroundColor3 = Color3.new(1, 1, 1)
            d.BackgroundTransparency = 0.8
            d.BorderSizePixel = 0
            d.ZIndex = 4
            d.Parent = dots
            corner(d, 99)
        end
    end

    label(card, "#", 10, Enum.Font.GothamBold, Color3.fromRGB(30, 10, 10),
        UDim2.fromOffset(6, 4), UDim2.fromOffset(10, 10))
    local t = label(card, title, 15, Enum.Font.GothamBlack, Color3.new(1, 1, 1),
        UDim2.fromOffset(14, 20), UDim2.new(1, -28, 0, 20))
    local d = label(card, desc, 11, Enum.Font.GothamMedium, Color3.fromRGB(255, 230, 230),
        UDim2.fromOffset(14, 44), UDim2.new(1, -28, 0, 30))
    d.TextWrapped = true
    d.TextYAlignment = Enum.TextYAlignment.Top
    local hint = label(card, "click to load  >", 10, Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255),
        UDim2.new(1, -120, 1, -20), UDim2.fromOffset(110, 14), Enum.TextXAlignment.Right)
    hint.TextTransparency = 0.4
    return card, st, hint
end

local legacyCard, legacyStroke, legacyHint = makeCard(
    "LEGACY VERSION",
    "Good old days, won't be updated\n(bad injectors work here)", 10)
local newCard, newStroke, newHint = makeCard(
    "NEW VERSION",
    "New bs & updated regularly\n(bad injectors NOT recommended)", 123)

local legacySide, lsStroke, lsIcon, lsText = makeSideItem("◷", "Legacy", 1)
local newSide, nsStroke, nsIcon, nsText = makeSideItem("✦", "New", 2)
local closeSide, csStroke, csIcon, csText = makeSideItem("✕", "Close", 3)

-- ===== glitch =====
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

-- ===== sounds =====
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

-- ===== hover / select states =====
local fast = TweenInfo.new(0.15)
local function setSide(b, s, ic, tx, on)
    TweenService:Create(b, fast, {BackgroundTransparency = on and 0 or 1}):Play()
    TweenService:Create(s, fast, {Transparency = on and 0 or 1}):Play()
    TweenService:Create(ic, fast, {TextColor3 = on and C.redLt or C.text}):Play()
    TweenService:Create(tx, fast, {TextColor3 = on and C.redLt or C.text}):Play()
end
local function setCard(st, hint, on)
    TweenService:Create(st, fast, {Color = on and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)}):Play()
    TweenService:Create(hint, fast, {TextTransparency = on and 0 or 0.4}):Play()
end
local function hoverFx()
    playSound(soundhover, 0.15)
    playHoverGlitch()
    glitch(random(2, 6))
    task.delay(0.1, function() glitch(0) end)
end

local function selectLegacy(on)
    setSide(legacySide, lsStroke, lsIcon, lsText, on)
    setCard(legacyStroke, legacyHint, on)
end
local function selectNew(on)
    setSide(newSide, nsStroke, nsIcon, nsText, on)
    setCard(newStroke, newHint, on)
end

for _, b in ipairs({legacyCard, legacySide}) do
    b.MouseEnter:Connect(function() selectNew(false); selectLegacy(true); hoverFx() end)
    b.MouseLeave:Connect(function() selectLegacy(false) end)
end
for _, b in ipairs({newCard, newSide}) do
    b.MouseEnter:Connect(function() selectLegacy(false); selectNew(true); hoverFx() end)
    b.MouseLeave:Connect(function() selectNew(false) end)
end
closeSide.MouseEnter:Connect(function() setSide(closeSide, csStroke, csIcon, csText, true); hoverFx() end)
closeSide.MouseLeave:Connect(function() setSide(closeSide, csStroke, csIcon, csText, false) end)
closeBtn.MouseEnter:Connect(function()
    hoverFx()
    TweenService:Create(closeBtn, fast, {BackgroundTransparency = 0, TextColor3 = Color3.new(1, 1, 1)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, fast, {BackgroundTransparency = 1, TextColor3 = C.sub}):Play()
end)

-- ===== loops =====
task.spawn(function()
    local last = 0
    while ScreenGui and ScreenGui.Parent do
        if tick() - last > random(4, 9) then
            local t = TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
            t:Play()
            t.Completed:Wait()
            titleLabel.Text = rngTitles[random(1, #rngTitles)]
            TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            last = tick()
        end
        task.wait(0.5)
    end
end)
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

-- ===== open / close =====
local function idk()
    blur.Size = 24
    glitchFrame.BackgroundTransparency = 0
    task.wait(0.05)
    for i = 1, 6 do
        glitch(random(4, 12))
        playGlitch()
        task.wait(0.05)
        glitch(0)
        task.wait(0.03)
    end
    TweenService:Create(glitchFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    win.Size = UDim2.fromOffset(470, 280)
    TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        GroupTransparency = 0,
        Size = UDim2.fromOffset(500, 300),
    }):Play()
end

local function fadeOut(t)
    local info = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(blur, info, {Size = 0}):Play()
    TweenService:Create(bg, info, {BackgroundTransparency = 1}):Play()
    TweenService:Create(win, info, {GroupTransparency = 1, Size = UDim2.fromOffset(470, 280)}):Play()
    task.wait(t + 0.1)
    ScreenGui:Destroy()
    blur:Destroy()
end

local function get(url)
    fadeOut(0.4)
    loadstring(game:HttpGet(url))()
end
local function closeGui()
    fadeOut(0.3)
end

local LEGACY = "https://raw.githubusercontent.com/dimesrunsit-alt/dimes.cc/refs/heads/main/old.lua"
local NEW = "https://raw.githubusercontent.com/hm5650/HBSS/refs/heads/main/HBSS_New.lua"
for _, b in ipairs({legacyCard, legacySide}) do
    b.MouseButton1Click:Connect(function() playSound(soundclick, 0.3); get(LEGACY) end)
end
for _, b in ipairs({newCard, newSide}) do
    b.MouseButton1Click:Connect(function() playSound(soundclick, 0.3); get(NEW) end)
end
for _, b in ipairs({closeBtn, closeSide}) do
    b.MouseButton1Click:Connect(function() playSound(soundclick, 0.3); closeGui() end)
end

idk()
