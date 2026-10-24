-- This is a full recovery version of the script it wouldn't contain any updates
-- Gravel.cc Legacy
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = {}

local config = {
    Enabled = false,
    fovsize = 120,
    predic = 1,
    espc = Color3.fromRGB(255, 182, 193),
    esptargetc = Color3.fromRGB(255, 255, 0),
    espteamc = Color3.fromRGB(0, 255, 0),
    rfd = false,
    eme = true,
    wallc = false,
    bodypart = "Head",
    espEnabled = false,
    prefTextESP = false,
    highlightesp = false,
    prefHighlightESP = false,
    prefBoxESP = false,
    prefHealthESP = false,
    prefColorByHealth = false,
    espMasterEnabled = false,
    prefHeadDotESP = false,
    originalSizes = {},
    activeApplied = {},
    espData = {},
    highlightData = {},
    currentTarget = nil,
    targethbSizes = {},
    fovc = Color3.fromRGB(100, 0, 0),
    fovct = Color3.fromRGB(255, 255, 0),
    playerConnections = {},
    characterConnections = {},
    looprfd = false,
    targetMode = "Enemies",
    centerLocked = {},
    hitchance = 100,
    hotkeyConnection = nil,
    maxExpansion = math.huge,
    aimbotEnabled = false,
    aimbotFOVSize = 100,
    aimbotFOVTransparency = 0.3,
    aimbotStrength = 0.5,
    aimbotWallCheck = false,
    aimbotTargetPart = "Head",
    aimbotTeamTarget = "Enemies",
    aimbotCurrentTarget = nil,
    aimbotFOVRing = nil,
    hitboxEnabled = false,
    hitboxSize = 10,
    hitboxTeamTarget = "Enemies",
    hitboxExpandedParts = {},
    hitboxOriginalSizes = {},
    hitboxLastSize = {},
    antiAimEnabled = false,
    raycastAntiAim = false,
    antiAimTPDistance = 3,
    antiAimAbovePlayer = false,
    antiAimAboveHeight = 10,
    antiAimBehindPlayer = false,
    antiAimBehindDistance = 5,
    originalPosition = nil,
    isTeleported = false,
    currentAntiAimTarget = nil,
    antiAimOrbitEnabled = false,
    antiAimOrbitSpeed = 5,
    antiAimOrbitRadius = 5,
    antiAimOrbitHeight = 0,
    masterTeamTarget = "Enemies",
    autoFarmEnabled = false,
    autoFarmDistance = 10,
    autoFarmSpeed = 1,
    autoFarmTargets = {},
    currentAutoFarmTarget = nil,
    autoFarmLoop = nil,
    autoFarmIndex = 1,
    autoFarmCompleted = {},
    autoFarmGroup = {},
    autoFarmGroupSize = 3,
    autoFarmSpacing = 4,
    aimviewEveryone = false, -- added setting
    autoFarmTargetPart = "Head",
    autoFarmAlignToCrosshair = true,
    autoFarmVerticalOffset = 0,
    autoFarmOriginalPositions = {}, 
    autoFarmRagdoll = true,
    aimbot360Enabled = false,
    aimbot360OriginalFOV = 100,
    gp = math.huge,
    aimbot360Omnidirectional = true,
    aimbot360BehindRange = 180,
    masterTarget = "Players",
    clientMasterEnabled = false,
    clientWalkSpeed = 16,
    clientJumpPower = 50,
    clientNoclip = false,
    clientCFrameWalkEnabled = false,
    clientCFrameSpeed = 1,
    clientConnections = {},
    clientOriginals = {},
    _tpwalking = false,
    clientWalkEnabled = false,
    clientJumpEnabled = false,
    clientNoclipEnabled = false,
    clientCFrameWalkToggle = false,
    masterGetTarget = "Closest",
    aimbotGetTarget = "Closest",
    silentGetTarget = "Closest",
    antiAimGetTarget = "Closest",
    streamProof = false,
    aimviewSegments = {},
}

-- Notifications disabled
local function safeNotify(opts) end

local lib
do
    local success, result = pcall(function()
        local C = {
            winBg        = Color3.fromRGB(23, 31, 42),
            winBorder    = Color3.fromRGB(12, 17, 24),
            rowBg        = Color3.fromRGB(28, 38, 50),
            rowHover     = Color3.fromRGB(33, 45, 59),
            rowBorder    = Color3.fromRGB(21, 29, 39),
            dropBg       = Color3.fromRGB(21, 29, 39),
            dropHover    = Color3.fromRGB(30, 43, 58),
            tabLine      = Color3.fromRGB(54, 73, 98),
            tabSep       = Color3.fromRGB(32, 43, 56),
            text         = Color3.fromRGB(238, 242, 248),
            textDim      = Color3.fromRGB(190, 198, 210),
            accent       = Color3.fromRGB(6, 108, 208),
            toggleOffBg  = Color3.fromRGB(4, 8, 16),
            toggleOnBg   = Color3.fromRGB(12, 42, 76),
            knobOff      = Color3.fromRGB(128, 130, 134),
            knobOn       = Color3.fromRGB(6, 108, 208),
            inputBg      = Color3.fromRGB(33, 57, 89),
            inputBorder  = Color3.fromRGB(42, 70, 108),
            sliderTrack  = Color3.fromRGB(54, 64, 76),
            sliderKnob   = Color3.fromRGB(2, 104, 200),
            whiteBtn     = Color3.fromRGB(236, 240, 245),
            whiteBtnBrd  = Color3.fromRGB(35, 62, 90),
            scrollGroove = Color3.fromRGB(14, 18, 25),
            scrollThumb  = Color3.fromRGB(80, 80, 82),
            kbStroke     = Color3.fromRGB(142, 148, 158),
            kbKey        = Color3.fromRGB(172, 178, 188),
        }

        local function clampVal(x, a, b)
            if x < a then return a end
            if x > b then return b end
            return x
        end

        local function addCorner(parent, radius)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, radius)
            c.Parent = parent
            return c
        end

        local function addRoundCorner(parent)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = parent
            return c
        end

        local function addStroke(parent, color, thickness, transparency)
            local s = Instance.new("UIStroke")
            s.Color = color
            s.Thickness = thickness or 1
            s.Transparency = transparency or 0
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Parent = parent
            return s
        end

        local Lighting = game:GetService("Lighting")

        local function cleanOldGui(parent)
            if not parent then return end
            pcall(function()
                for _, ch in ipairs(parent:GetChildren()) do
                    if ch:IsA("ScreenGui") and (ch.Name == "DimesCC_UI" or ch.Name == "MatrixHub_UI") then
                        ch:Destroy()
                    end
                end
            end)
        end
        pcall(function()
            for _, ef in ipairs(Lighting:GetChildren()) do
                if ef:IsA("BlurEffect") and ef.Name == "DimesCC_MotionBlur" then
                    ef:Destroy()
                end
            end
        end)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DimesCC_UI"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 999999

        local parented = false
        pcall(function()
            if gethui then
                local h = gethui()
                cleanOldGui(h)
                screenGui.Parent = h
                parented = true
            end
        end)
        if not parented then
            pcall(function()
                local cg = game:GetService("CoreGui")
                cleanOldGui(cg)
                screenGui.Parent = cg
                parented = true
            end)
        end
        if not parented then
            local pg = localPlayer:WaitForChild("PlayerGui")
            cleanOldGui(pg)
            screenGui.Parent = pg
        end

        local mlib = {
            _screenGui = screenGui,
            _motionBlur = nil,
            _snowEnabled = true,
            _motionBlurEnabled = true,
            _streamProof = false,
            _spGhostCloak = false,
            _spMenuVisible = true,
            _hasDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function"),
            _spNativeHook = false,
            _spSyncVisuals = nil,
            _connections = {},
            _tabs = {},
            _tabList = {},
            _currentBuildTab = nil,
            _activeTab = nil,
            _toggleKey = Enum.KeyCode.RightShift,
            _listeningMenuKey = false,
            _toggleWatchers = {},
        }

        local function trackConn(conn)
            table.insert(mlib._connections, conn)
            return conn
        end

        -- Background Falling Snow (Bokeh + Directional Motion Blur) & Smooth Camera Motion Blur
        local snowLayer = Instance.new("Frame")
        snowLayer.Name = "SnowBackground"
        snowLayer.BackgroundTransparency = 1
        snowLayer.BorderSizePixel = 0
        snowLayer.Position = UDim2.fromScale(0, 0)
        snowLayer.Size = UDim2.fromScale(1, 1)
        snowLayer.ClipsDescendants = true
        snowLayer.Active = false
        snowLayer.ZIndex = 0
        pcall(function() snowLayer.Interactable = false end)
        snowLayer.Parent = screenGui

        local motionBlur = Instance.new("BlurEffect")
        motionBlur.Name = "DimesCC_MotionBlur"
        motionBlur.Size = 0
        pcall(function() motionBlur.Parent = Lighting end)
        mlib._motionBlur = motionBlur

        do
            local flakes = {}
            local rng = Random.new()

            local function addMotionTailGradient(frame, topTr, midTr, botTr)
                local g = Instance.new("UIGradient")
                g.Rotation = 90
                g.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, topTr),
                    NumberSequenceKeypoint.new(0.45, midTr),
                    NumberSequenceKeypoint.new(0.80, midTr),
                    NumberSequenceKeypoint.new(1.00, botTr),
                })
                g.Parent = frame
            end

            -- 1) Far layer: tiny crisp-soft snow specks
            for _ = 1, 54 do
                local sz = rng:NextNumber(3, 5.2)
                local baseTr = rng:NextNumber(0.42, 0.64)
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5)
                f.BackgroundColor3 = Color3.fromRGB(246, 250, 255)
                f.BackgroundTransparency = baseTr
                f.BorderSizePixel = 0
                f.Size = UDim2.fromOffset(math.floor(sz + 0.5), math.floor(sz * 1.12 + 0.5))
                f.Active = false
                f.ZIndex = 0
                pcall(function() f.Interactable = false end)
                f.Parent = snowLayer
                addRoundCorner(f)

                local softRim = Instance.new("UIStroke")
                softRim.Color = Color3.fromRGB(235, 244, 255)
                softRim.Thickness = 1
                softRim.Transparency = 0.80
                softRim.Parent = f

                table.insert(flakes, {
                    frame = f,
                    x = rng:NextNumber(-0.04, 1.04),
                    y = rng:NextNumber(-0.06, 1.04),
                    fallSpeed = rng:NextNumber(0.055, 0.095),
                    swayAmp = rng:NextNumber(0.012, 0.026),
                    swayFreq = rng:NextNumber(0.70, 1.40),
                    phase = rng:NextNumber(0, math.pi * 2),
                    windMult = 0.55,
                    baseTr = baseTr,
                    twinkle = true,
                    rotate = false,
                })
            end

            -- 2) Mid layer: soft feathered flakes with directional motion-blur elongation
            for _ = 1, 28 do
                local sz = rng:NextNumber(7.5, 13.5)
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5)
                f.BackgroundColor3 = Color3.fromRGB(244, 248, 255)
                f.BackgroundTransparency = rng:NextNumber(0.82, 0.87)
                f.BorderSizePixel = 0
                f.Size = UDim2.fromOffset(math.floor(sz + 0.5), math.floor(sz * 1.16 + 0.5))
                f.Active = false
                f.ZIndex = 0
                pcall(function() f.Interactable = false end)
                f.Parent = snowLayer
                addRoundCorner(f)
                addMotionTailGradient(f, 0.55, 0.0, 0.18)

                local core = Instance.new("Frame")
                core.AnchorPoint = Vector2.new(0.5, 0.5)
                core.Position = UDim2.fromScale(0.5, 0.54)
                core.Size = UDim2.fromScale(0.60, 0.58)
                core.BackgroundColor3 = Color3.fromRGB(248, 251, 255)
                core.BackgroundTransparency = rng:NextNumber(0.68, 0.76)
                core.BorderSizePixel = 0
                core.Active = false
                core.ZIndex = 0
                pcall(function() core.Interactable = false end)
                core.Parent = f
                addRoundCorner(core)

                table.insert(flakes, {
                    frame = f,
                    x = rng:NextNumber(-0.04, 1.04),
                    y = rng:NextNumber(-0.06, 1.04),
                    fallSpeed = rng:NextNumber(0.105, 0.175),
                    swayAmp = rng:NextNumber(0.020, 0.038),
                    swayFreq = rng:NextNumber(0.85, 1.60),
                    phase = rng:NextNumber(0, math.pi * 2),
                    windMult = 0.92,
                    twinkle = false,
                    rotate = true,
                })
            end

            -- 3) Foreground bokeh layer: large out-of-focus soft blurred snow orbs
            for _ = 1, 12 do
                local sz = rng:NextNumber(22, 36)
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5)
                f.BackgroundColor3 = Color3.fromRGB(242, 246, 252)
                f.BackgroundTransparency = 0.92
                f.BorderSizePixel = 0
                f.Size = UDim2.fromOffset(math.floor(sz + 0.5), math.floor(sz * 1.18 + 0.5))
                f.Active = false
                f.ZIndex = 0
                pcall(function() f.Interactable = false end)
                f.Parent = snowLayer
                addRoundCorner(f)
                addMotionTailGradient(f, 0.62, 0.0, 0.22)

                local midRing = Instance.new("Frame")
                midRing.AnchorPoint = Vector2.new(0.5, 0.5)
                midRing.Position = UDim2.fromScale(0.5, 0.53)
                midRing.Size = UDim2.fromScale(0.75, 0.73)
                midRing.BackgroundColor3 = Color3.fromRGB(245, 249, 255)
                midRing.BackgroundTransparency = 0.90
                midRing.BorderSizePixel = 0
                midRing.Active = false
                midRing.ZIndex = 0
                pcall(function() midRing.Interactable = false end)
                midRing.Parent = f
                addRoundCorner(midRing)

                local innerCore = Instance.new("Frame")
                innerCore.AnchorPoint = Vector2.new(0.5, 0.5)
                innerCore.Position = UDim2.fromScale(0.5, 0.54)
                innerCore.Size = UDim2.fromScale(0.48, 0.46)
                innerCore.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
                innerCore.BackgroundTransparency = 0.89
                innerCore.BorderSizePixel = 0
                innerCore.Active = false
                innerCore.ZIndex = 0
                pcall(function() innerCore.Interactable = false end)
                innerCore.Parent = f
                addRoundCorner(innerCore)

                table.insert(flakes, {
                    frame = f,
                    x = rng:NextNumber(-0.05, 1.05),
                    y = rng:NextNumber(-0.08, 1.05),
                    fallSpeed = rng:NextNumber(0.175, 0.260),
                    swayAmp = rng:NextNumber(0.028, 0.050),
                    swayFreq = rng:NextNumber(0.65, 1.25),
                    phase = rng:NextNumber(0, math.pi * 2),
                    windMult = 1.25,
                    twinkle = false,
                    rotate = true,
                })
            end

            local elapsed = 0
            local currentBlur = 0
            local lastLook = nil

            trackConn(RunService.RenderStepped:Connect(function(rawDt)
                local dt = clampVal(rawDt, 0.0005, 0.05)
                elapsed = elapsed + dt

                local cam = workspace.CurrentCamera
                local vpX, vpY = 1920, 1080
                if cam then
                    vpX = math.max(1, cam.ViewportSize.X)
                    vpY = math.max(1, cam.ViewportSize.Y)
                end

                -- Smooth Falling Snow Update (sub-pixel Scale coordinates)
                if mlib._snowEnabled and not mlib._streamProof then
                    if not snowLayer.Visible then snowLayer.Visible = true end
                    local globalWind = math.sin(elapsed * 0.42) * 0.022 + math.sin(elapsed * 0.17) * 0.014

                    for i = 1, #flakes do
                        local p = flakes[i]
                        local sway = math.sin(elapsed * p.swayFreq + p.phase) * p.swayAmp
                        local vx = (globalWind * p.windMult) + sway
                        local vy = p.fallSpeed * (1 + 0.07 * math.cos(elapsed * p.swayFreq * 0.7 + p.phase))

                        p.x = p.x + vx * dt
                        p.y = p.y + vy * dt

                        if p.y > 1.07 then
                            p.y = -0.06
                            p.x = rng:NextNumber(-0.04, 1.04)
                        end
                        if p.x > 1.06 then
                            p.x = -0.05
                        elseif p.x < -0.06 then
                            p.x = 1.05
                        end

                        p.frame.Position = UDim2.fromScale(p.x, p.y)

                        if p.rotate then
                            local vxPx = vx * vpX
                            local vyPx = vy * vpY
                            p.frame.Rotation = -math.deg(math.atan2(vxPx, vyPx))
                        elseif p.twinkle then
                            p.frame.BackgroundTransparency = p.baseTr + math.sin(elapsed * 2.1 + p.phase) * 0.06
                        end
                    end
                elseif snowLayer.Visible then
                    snowLayer.Visible = false
                end

                -- Smooth Camera Angular Motion Blur
                if mlib._motionBlur and mlib._motionBlur.Parent then
                    if mlib._motionBlurEnabled and not mlib._streamProof and cam then
                        local look = cam.CFrame.LookVector
                        local targetBlur = 0
                        if lastLook then
                            local angVel = (look - lastLook).Magnitude / math.max(dt, 0.001)
                            targetBlur = clampVal((angVel - 0.35) * 2.4, 0, 14)
                        end
                        lastLook = look
                        local blend = 1 - math.exp(-14 * dt)
                        currentBlur = currentBlur + (targetBlur - currentBlur) * blend
                        mlib._motionBlur.Size = (currentBlur > 0.05) and currentBlur or 0
                    else
                        lastLook = nil
                        currentBlur = 0
                        if mlib._motionBlur.Size ~= 0 then
                            mlib._motionBlur.Size = 0
                        end
                    end
                end
            end))
        end

        local defaultCenterPos = UDim2.new(0.5, 0, 0.5, 0)
        local win = Instance.new("Frame")
        win.Name = "MainWindow"
        win.AnchorPoint = Vector2.new(0.5, 0.5)
        win.Position = defaultCenterPos
        win.Size = UDim2.fromOffset(602, 514)
        win.BackgroundColor3 = C.winBg
        win.BorderSizePixel = 0
        win.ZIndex = 1
        win.Parent = screenGui
        addCorner(win, 2)
        addStroke(win, C.winBorder, 1, 0)

        -- Header
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.BackgroundTransparency = 1
        header.Position = UDim2.fromOffset(0, 0)
        header.Size = UDim2.new(1, 0, 0, 50)
        header.ZIndex = 5
        header.Active = true
        header.Parent = win

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.fromOffset(14, 10)
        titleLabel.Size = UDim2.fromOffset(240, 30)
        titleLabel.Font = Enum.Font.Arcade
        titleLabel.Text = "dimes.cc"
        titleLabel.TextSize = 23
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        titleLabel.ZIndex = 6
        titleLabel.Parent = header

        local titleGrad = Instance.new("UIGradient")
        titleGrad.Rotation = 0
        titleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 96, 178)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(68, 138, 198)),
            ColorSequenceKeypoint.new(0.78, Color3.fromRGB(172, 206, 224)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(218, 234, 244)),
        })
        titleGrad.Parent = titleLabel

        -- Vector Discord Clyde Icon (top-right)
        local discordBtn = Instance.new("TextButton")
        discordBtn.Name = "DiscordBtn"
        discordBtn.Text = ""
        discordBtn.AutoButtonColor = false
        discordBtn.BackgroundTransparency = 1
        discordBtn.Position = UDim2.new(1, -58, 0, 12)
        discordBtn.Size = UDim2.fromOffset(24, 24)
        discordBtn.ZIndex = 7
        discordBtn.Parent = header

        local dcWrap = Instance.new("Frame")
        dcWrap.BackgroundTransparency = 1
        dcWrap.AnchorPoint = Vector2.new(0.5, 0.5)
        dcWrap.Position = UDim2.fromScale(0.5, 0.5)
        dcWrap.Size = UDim2.fromOffset(20, 15)
        dcWrap.ZIndex = 8
        dcWrap.Parent = discordBtn

        local dcParts = {}
        local function makeDcPart(pos, sz, rot, rad)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = Color3.fromRGB(242, 245, 250)
            f.BorderSizePixel = 0
            f.Position = pos
            f.Size = sz
            f.Rotation = rot or 0
            f.ZIndex = 8
            f.Parent = dcWrap
            if rad then addCorner(f, rad) end
            table.insert(dcParts, f)
            return f
        end
        makeDcPart(UDim2.fromOffset(1, 2), UDim2.fromOffset(18, 10), 0, 4)
        makeDcPart(UDim2.fromOffset(2, 0), UDim2.fromOffset(5, 4), -12, 2)
        makeDcPart(UDim2.fromOffset(13, 0), UDim2.fromOffset(5, 4), 12, 2)
        makeDcPart(UDim2.fromOffset(1, 10), UDim2.fromOffset(6, 4), 14, 2)
        makeDcPart(UDim2.fromOffset(13, 10), UDim2.fromOffset(6, 4), -14, 2)

        for _, ex in ipairs({5, 12}) do
            local eye = Instance.new("Frame")
            eye.BackgroundColor3 = C.winBg
            eye.BorderSizePixel = 0
            eye.Position = UDim2.fromOffset(ex, 5)
            eye.Size = UDim2.fromOffset(3, 3)
            eye.ZIndex = 9
            eye.Parent = dcWrap
            addRoundCorner(eye)
        end

        local dcHovering = false
        local function refreshDiscordIconColor()
            local col
            if mlib._streamProof then
                col = dcHovering and Color3.fromRGB(122, 140, 255) or Color3.fromRGB(88, 101, 242)
            else
                col = dcHovering and Color3.fromRGB(130, 190, 255) or Color3.fromRGB(242, 245, 250)
            end
            for _, p in ipairs(dcParts) do
                p.BackgroundColor3 = col
            end
        end

        discordBtn.MouseEnter:Connect(function()
            dcHovering = true
            refreshDiscordIconColor()
        end)
        discordBtn.MouseLeave:Connect(function()
            dcHovering = false
            refreshDiscordIconColor()
        end)
        discordBtn.MouseButton1Click:Connect(function()
            if mlib.SetStreamProof then
                mlib:SetStreamProof(not mlib._streamProof)
            end
        end)

        -- Vector 8-tooth Gear Icon (top-right)
        local gearBtn = Instance.new("TextButton")
        gearBtn.Name = "SettingsBtn"
        gearBtn.Text = ""
        gearBtn.AutoButtonColor = false
        gearBtn.BackgroundTransparency = 1
        gearBtn.Position = UDim2.new(1, -30, 0, 12)
        gearBtn.Size = UDim2.fromOffset(24, 24)
        gearBtn.ZIndex = 7
        gearBtn.Parent = header

        local gearWrap = Instance.new("Frame")
        gearWrap.BackgroundTransparency = 1
        gearWrap.AnchorPoint = Vector2.new(0.5, 0.5)
        gearWrap.Position = UDim2.fromScale(0.5, 0.5)
        gearWrap.Size = UDim2.fromOffset(18, 18)
        gearWrap.ZIndex = 8
        gearWrap.Parent = gearBtn

        local gearParts = {}
        for _, rot in ipairs({0, 45, 90, 135}) do
            local tooth = Instance.new("Frame")
            tooth.AnchorPoint = Vector2.new(0.5, 0.5)
            tooth.Position = UDim2.fromScale(0.5, 0.5)
            tooth.Size = UDim2.fromOffset(4, 18)
            tooth.Rotation = rot
            tooth.BackgroundColor3 = Color3.fromRGB(242, 245, 250)
            tooth.BorderSizePixel = 0
            tooth.ZIndex = 8
            tooth.Parent = gearWrap
            addCorner(tooth, 1)
            table.insert(gearParts, tooth)
        end
        local gearDisk = Instance.new("Frame")
        gearDisk.AnchorPoint = Vector2.new(0.5, 0.5)
        gearDisk.Position = UDim2.fromScale(0.5, 0.5)
        gearDisk.Size = UDim2.fromOffset(13, 13)
        gearDisk.BackgroundColor3 = Color3.fromRGB(242, 245, 250)
        gearDisk.BorderSizePixel = 0
        gearDisk.ZIndex = 8
        gearDisk.Parent = gearWrap
        addRoundCorner(gearDisk)
        table.insert(gearParts, gearDisk)

        local gearHole = Instance.new("Frame")
        gearHole.AnchorPoint = Vector2.new(0.5, 0.5)
        gearHole.Position = UDim2.fromScale(0.5, 0.5)
        gearHole.Size = UDim2.fromOffset(6, 6)
        gearHole.BackgroundColor3 = C.winBg
        gearHole.BorderSizePixel = 0
        gearHole.ZIndex = 9
        gearHole.Parent = gearWrap
        addRoundCorner(gearHole)

        gearBtn.MouseEnter:Connect(function()
            for _, p in ipairs(gearParts) do p.BackgroundColor3 = Color3.fromRGB(130, 190, 255) end
        end)
        gearBtn.MouseLeave:Connect(function()
            for _, p in ipairs(gearParts) do p.BackgroundColor3 = Color3.fromRGB(242, 245, 250) end
        end)

        -- Gear Settings Popup
        local settingsPopup = Instance.new("Frame")
        settingsPopup.Name = "SettingsPopup"
        settingsPopup.Visible = false
        settingsPopup.Position = UDim2.new(1, -214, 0, 42)
        settingsPopup.Size = UDim2.fromOffset(204, 158)
        settingsPopup.BackgroundColor3 = C.winBg
        settingsPopup.BorderSizePixel = 0
        settingsPopup.ZIndex = 60
        settingsPopup.Parent = win
        addCorner(settingsPopup, 3)
        addStroke(settingsPopup, C.tabLine, 1, 0)

        local mkRow = Instance.new("Frame")
        mkRow.BackgroundColor3 = C.rowBg
        mkRow.BorderSizePixel = 0
        mkRow.Position = UDim2.fromOffset(6, 6)
        mkRow.Size = UDim2.new(1, -12, 0, 26)
        mkRow.ZIndex = 61
        mkRow.Parent = settingsPopup
        addCorner(mkRow, 2)

        local mkLbl = Instance.new("TextLabel")
        mkLbl.BackgroundTransparency = 1
        mkLbl.Position = UDim2.fromOffset(8, 0)
        mkLbl.Size = UDim2.new(1, -92, 1, 0)
        mkLbl.Font = Enum.Font.GothamBold
        mkLbl.Text = "Menu Key"
        mkLbl.TextSize = 11
        mkLbl.TextColor3 = C.text
        mkLbl.TextXAlignment = Enum.TextXAlignment.Left
        mkLbl.ZIndex = 62
        mkLbl.Parent = mkRow

        local mkBtn = Instance.new("TextButton")
        mkBtn.AutoButtonColor = false
        mkBtn.BackgroundColor3 = C.whiteBtn
        mkBtn.BorderSizePixel = 0
        mkBtn.Position = UDim2.new(1, -80, 0.5, -9)
        mkBtn.Size = UDim2.fromOffset(74, 18)
        mkBtn.Font = Enum.Font.GothamBold
        mkBtn.Text = "RightShift"
        mkBtn.TextSize = 10
        mkBtn.TextColor3 = Color3.fromRGB(16, 22, 30)
        mkBtn.ZIndex = 62
        mkBtn.Parent = mkRow
        addCorner(mkBtn, 1)
        addStroke(mkBtn, C.whiteBtnBrd, 1, 0)

        mkBtn.MouseButton1Click:Connect(function()
            mlib._listeningMenuKey = true
            mkBtn.Text = "..."
        end)

        local function makePopupToggle(labelText, yOffset, initVal, onToggle)
            local pRow = Instance.new("Frame")
            pRow.BackgroundColor3 = C.rowBg
            pRow.BorderSizePixel = 0
            pRow.Position = UDim2.fromOffset(6, yOffset)
            pRow.Size = UDim2.new(1, -12, 0, 26)
            pRow.ZIndex = 61
            pRow.Parent = settingsPopup
            addCorner(pRow, 2)

            local pLbl = Instance.new("TextLabel")
            pLbl.BackgroundTransparency = 1
            pLbl.Position = UDim2.fromOffset(8, 0)
            pLbl.Size = UDim2.new(1, -52, 1, 0)
            pLbl.Font = Enum.Font.GothamBold
            pLbl.Text = labelText
            pLbl.TextSize = 11
            pLbl.TextColor3 = C.text
            pLbl.TextXAlignment = Enum.TextXAlignment.Left
            pLbl.ZIndex = 62
            pLbl.Parent = pRow

            local st = initVal
            local pPill = Instance.new("TextButton")
            pPill.Text = ""
            pPill.AutoButtonColor = false
            pPill.AnchorPoint = Vector2.new(1, 0.5)
            pPill.Position = UDim2.new(1, -6, 0.5, 0)
            pPill.Size = UDim2.fromOffset(32, 15)
            pPill.BackgroundColor3 = st and C.toggleOnBg or C.toggleOffBg
            pPill.BorderSizePixel = 0
            pPill.ZIndex = 62
            pPill.Parent = pRow
            addRoundCorner(pPill)
            addStroke(pPill, Color3.fromRGB(36, 46, 58), 1, 0)

            local pKnob = Instance.new("Frame")
            pKnob.AnchorPoint = Vector2.new(0, 0.5)
            pKnob.Position = st and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            pKnob.Size = UDim2.fromOffset(11, 11)
            pKnob.BackgroundColor3 = st and C.knobOn or C.knobOff
            pKnob.BorderSizePixel = 0
            pKnob.ZIndex = 63
            pKnob.Parent = pPill
            addRoundCorner(pKnob)

            local tw = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local function setVisual(newSt)
                st = newSt
                TweenService:Create(pPill, tw, { BackgroundColor3 = st and C.toggleOnBg or C.toggleOffBg }):Play()
                TweenService:Create(pKnob, tw, {
                    Position = st and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = st and C.knobOn or C.knobOff,
                }):Play()
            end
            pPill.MouseButton1Click:Connect(function()
                setVisual(not st)
                onToggle(st)
            end)
            return setVisual
        end

        makePopupToggle("Snow Effect", 36, true, function(v) mlib._snowEnabled = v end)
        makePopupToggle("Motion Blur", 66, true, function(v) mlib._motionBlurEnabled = v end)
        local setSpPopupVisual = makePopupToggle("StreamProof (F8)", 96, false, function(v)
            if mlib.SetStreamProof then
                mlib:SetStreamProof(v)
            end
        end)
        mlib._spSyncVisuals = function(v)
            refreshDiscordIconColor()
            setSpPopupVisual(v)
        end

        local centerRow = Instance.new("TextButton")
        centerRow.AutoButtonColor = false
        centerRow.BackgroundColor3 = C.rowBg
        centerRow.BorderSizePixel = 0
        centerRow.Position = UDim2.fromOffset(6, 126)
        centerRow.Size = UDim2.new(1, -12, 0, 26)
        centerRow.Font = Enum.Font.GothamBold
        centerRow.Text = "Center Window"
        centerRow.TextSize = 11
        centerRow.TextColor3 = C.text
        centerRow.ZIndex = 61
        centerRow.Parent = settingsPopup
        addCorner(centerRow, 2)
        centerRow.MouseButton1Click:Connect(function()
            win.Position = defaultCenterPos
            settingsPopup.Visible = false
        end)

        gearBtn.MouseButton1Click:Connect(function()
            settingsPopup.Visible = not settingsPopup.Visible
        end)

        -- Window Dragging (Header only)
        do
            local dragging = false
            local dragStart = nil
            local startPos = nil

            header.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = win.Position
                end
            end)

            header.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            trackConn(UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    win.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end))
        end

        -- Horizontal Tab Bar
        local tabBar = Instance.new("Frame")
        tabBar.Name = "TabBar"
        tabBar.BackgroundTransparency = 1
        tabBar.Position = UDim2.fromOffset(8, 50)
        tabBar.Size = UDim2.new(1, -16, 0, 28)
        tabBar.ZIndex = 5
        tabBar.Parent = win

        -- Body Wrapper & Right Scrollbar Groove
        local bodyWrap = Instance.new("Frame")
        bodyWrap.Name = "Body"
        bodyWrap.BackgroundTransparency = 1
        bodyWrap.Position = UDim2.fromOffset(10, 86)
        bodyWrap.Size = UDim2.new(1, -14, 1, -94)
        bodyWrap.ZIndex = 2
        bodyWrap.Parent = win

        local scrollGroove = Instance.new("Frame")
        scrollGroove.Name = "ScrollGroove"
        scrollGroove.BackgroundColor3 = C.scrollGroove
        scrollGroove.BorderSizePixel = 0
        scrollGroove.Position = UDim2.new(1, -7, 0, 0)
        scrollGroove.Size = UDim2.new(0, 7, 1, 0)
        scrollGroove.ZIndex = 2
        scrollGroove.Parent = bodyWrap
        addCorner(scrollGroove, 2)

        local preferredTabOrder = {
            Visuals = 1,
            Aimbot = 2,
            SilentAim = 3,
            Hitbox = 4,
            AntiAim = 5,
            Main = 6,
            Client = 7,
        }

        local function relayoutTabBar()
            table.sort(mlib._tabList, function(a, b)
                local oa = preferredTabOrder[a.name] or (100 + a.createdIndex)
                local ob = preferredTabOrder[b.name] or (100 + b.createdIndex)
                return oa < ob
            end)
            local total = #mlib._tabList
            if total == 0 then return end
            local wScale = 1 / total
            for idx, t in ipairs(mlib._tabList) do
                t.btn.Position = UDim2.new(wScale * (idx - 1), 0, 0, 0)
                t.btn.Size = UDim2.new(wScale, 0, 1, 0)
                t.sep.Visible = (idx < total)
            end
        end

        function mlib:ShowTab(name)
            local target = mlib._tabs[name]
            if not target then return end
            mlib._activeTab = target
            for _, t in ipairs(mlib._tabList) do
                local isSel = (t == target)
                t.page.Visible = isSel
                t.underline.Visible = isSel
                t.label.TextColor3 = isSel and C.text or C.textDim
                t.btn.BackgroundTransparency = isSel and 0.65 or 1
            end
        end

        local function rebalanceTabColumns(tab)
            local n = #tab.items
            local half = math.ceil(n / 2)
            for i, itemFrame in ipairs(tab.items) do
                itemFrame.LayoutOrder = i
                if i <= half then
                    itemFrame.Parent = tab.leftCol
                else
                    itemFrame.Parent = tab.rightCol
                end
            end
            tab.updateCanvas()
        end

        local function makeRowTextLabel(parent, text, rightReserve, height, yPos)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.fromOffset(10, yPos or 0)
            lbl.Size = UDim2.new(1, -(10 + rightReserve), 0, height or 28)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = text
            lbl.TextColor3 = C.text
            lbl.TextSize = 12
            local needsScale = (#tostring(text) > 25)
            lbl.TextScaled = needsScale
            lbl.TextWrapped = false
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.ZIndex = 6
            lbl.Parent = parent
            local tc = Instance.new("UITextSizeConstraint")
            tc.MaxTextSize = 12
            tc.MinTextSize = 8
            tc.Parent = lbl
            return lbl
        end

        local configToggleGetters = {
            ["Enable ESP (Ctrl+'Z')"] = function() return config.espMasterEnabled end,
            ["Toggle Highlight ESP"] = function() return config.prefHighlightESP end,
            ["Toggle Text ESP"] = function() return config.prefTextESP end,
            ["Toggle Box ESP"] = function() return config.prefBoxESP end,
            ["Toggle Health ESP"] = function() return config.prefHealthESP end,
            ["Toggle Head Dot ESP"] = function() return config.prefHeadDotESP end,
            ["ESP Colour Based On Health"] = function() return config.prefColorByHealth end,
            ["Toggle AntiAim (Ctrl+'L')"] = function() return config.antiAimEnabled end,
            ["Raycast AntiAim"] = function() return config.raycastAntiAim end,
            ["Above Player"] = function() return config.antiAimAbovePlayer end,
            ["Behind Player"] = function() return config.antiAimBehindPlayer end,
            ["Orbit Players"] = function() return config.antiAimOrbitEnabled end,
            ["Toggle Aimbot ('Q')"] = function() return config.aimbotEnabled end,
            ["WallCheck AB (Ctrl+'B')"] = function() return config.aimbotWallCheck end,
            ["360° Aimbot"] = function() return config.aimbot360Enabled end,
            ["Toggle Hitbox (Ctrl+'G')"] = function() return config.hitboxEnabled end,
            ["Toggle SilentAim (Ctrl+'E')"] = function() return config.Enabled end,
            ["WallCheck SA (B)"] = function() return config.wallc end,
            ["Enable Client Configuration (Ctrl+'V')"] = function() return config.clientMasterEnabled end,
            ["Noclip"] = function() return config.clientNoclipEnabled end,
            ["Enable WalkSpeed"] = function() return config.clientWalkEnabled end,
            ["Enable JumpPower"] = function() return config.clientJumpEnabled end,
            ["CFrame Walk"] = function() return config.clientCFrameWalkToggle end,
            ["Toggle AutoFarm ('V')"] = function() return config.autoFarmEnabled end,
            ["Ragdoll on Elimination (Autofarm)"] = function() return config.autoFarmRagdoll end,
            ["AimView Everyone"] = function() return config.aimviewEveryone end,
        }

        function mlib:SetTitle(t)
            if type(t) == "string" and #t > 0 then
                titleLabel.Text = t
            end
        end
        function mlib:SetIcon() end
        function mlib:SetBackgroundColor() end
        function mlib:SetCloseBtnColor() end
        function mlib:SetTitleColor() end
        function mlib:SetButtonsColor() end
        function mlib:SetTheme() end

        function mlib:CreateTab(name)
            if mlib._tabs[name] then
                return mlib._tabs[name]
            end

            local btn = Instance.new("TextButton")
            btn.Name = "Tab_" .. name
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.BackgroundColor3 = Color3.fromRGB(28, 38, 52)
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel = 0
            btn.ZIndex = 6
            btn.Parent = tabBar

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = name
            lbl.TextSize = 11
            lbl.TextColor3 = C.textDim
            lbl.ZIndex = 7
            lbl.Parent = btn

            local underline = Instance.new("Frame")
            underline.BackgroundColor3 = C.tabLine
            underline.BorderSizePixel = 0
            underline.Position = UDim2.new(0, 4, 1, -2)
            underline.Size = UDim2.new(1, -8, 0, 2)
            underline.Visible = false
            underline.ZIndex = 8
            underline.Parent = btn

            local sep = Instance.new("Frame")
            sep.BackgroundColor3 = C.tabSep
            sep.BorderSizePixel = 0
            sep.AnchorPoint = Vector2.new(1, 0.5)
            sep.Position = UDim2.new(1, 0, 0.5, 0)
            sep.Size = UDim2.fromOffset(1, 14)
            sep.ZIndex = 7
            sep.Parent = btn

            local page = Instance.new("ScrollingFrame")
            page.Name = "Page_" .. name
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.Position = UDim2.fromOffset(0, 0)
            page.Size = UDim2.new(1, -1, 1, 0)
            page.CanvasSize = UDim2.fromOffset(0, 0)
            page.ScrollBarThickness = 5
            page.ScrollBarImageColor3 = C.scrollThumb
            page.ScrollingDirection = Enum.ScrollingDirection.Y
            page.Visible = false
            page.ZIndex = 3
            page.Parent = bodyWrap

            local leftCol = Instance.new("Frame")
            leftCol.Name = "LeftCol"
            leftCol.BackgroundTransparency = 1
            leftCol.Position = UDim2.fromOffset(0, 0)
            leftCol.Size = UDim2.new(0.5, -8, 0, 0)
            leftCol.AutomaticSize = Enum.AutomaticSize.Y
            leftCol.ZIndex = 4
            leftCol.Parent = page

            local leftLayout = Instance.new("UIListLayout")
            leftLayout.Padding = UDim.new(0, 5)
            leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
            leftLayout.Parent = leftCol

            local rightCol = Instance.new("Frame")
            rightCol.Name = "RightCol"
            rightCol.BackgroundTransparency = 1
            rightCol.Position = UDim2.new(0.5, -1, 0, 0)
            rightCol.Size = UDim2.new(0.5, -11, 0, 0)
            rightCol.AutomaticSize = Enum.AutomaticSize.Y
            rightCol.ZIndex = 4
            rightCol.Parent = page

            local rightLayout = Instance.new("UIListLayout")
            rightLayout.Padding = UDim.new(0, 5)
            rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
            rightLayout.Parent = rightCol

            local function updateCanvas()
                local h = math.max(leftLayout.AbsoluteContentSize.Y, rightLayout.AbsoluteContentSize.Y)
                page.CanvasSize = UDim2.fromOffset(0, h + 14)
            end
            leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
            rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

            local tabObj = {
                name = name,
                createdIndex = #mlib._tabList + 1,
                btn = btn,
                label = lbl,
                underline = underline,
                sep = sep,
                page = page,
                leftCol = leftCol,
                rightCol = rightCol,
                items = {},
                itemMeta = {},
                scrollY = 0,
                maxScroll = 0,
                updateCanvas = updateCanvas,
            }

            btn.MouseButton1Click:Connect(function()
                mlib:ShowTab(name)
            end)

            mlib._tabs[name] = tabObj
            table.insert(mlib._tabList, tabObj)
            relayoutTabBar()

            if not mlib._activeTab then
                mlib:ShowTab(name)
            end
            if not mlib._currentBuildTab then
                mlib._currentBuildTab = tabObj
            end

            return tabObj
        end

        function mlib:Tab(name)
            local t = mlib._tabs[name] or mlib:CreateTab(name)
            mlib._currentBuildTab = t
            mlib:ShowTab(name)
        end

        function mlib:AddToggle(name, callback, default)
            local tab = mlib._currentBuildTab or mlib:CreateTab("Main")
            local state = (default == true)

            local row = Instance.new("Frame")
            row.Name = "Toggle_" .. tostring(name)
            row.BackgroundColor3 = C.rowBg
            row.BorderSizePixel = 0
            row.Size = UDim2.new(1, 0, 0, 28)
            row.ZIndex = 5
            addCorner(row, 3)
            addStroke(row, C.rowBorder, 1, 0)

            makeRowTextLabel(row, tostring(name), 50, 28, 0)

            local pill = Instance.new("TextButton")
            pill.Text = ""
            pill.AutoButtonColor = false
            pill.AnchorPoint = Vector2.new(1, 0.5)
            pill.Position = UDim2.new(1, -8, 0.5, 0)
            pill.Size = UDim2.fromOffset(34, 16)
            pill.BackgroundColor3 = state and C.toggleOnBg or C.toggleOffBg
            pill.BorderSizePixel = 0
            pill.ZIndex = 7
            pill.Parent = row
            addRoundCorner(pill)
            addStroke(pill, Color3.fromRGB(36, 46, 58), 1, 0)

            local knob = Instance.new("Frame")
            knob.AnchorPoint = Vector2.new(0, 0.5)
            knob.Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            knob.Size = UDim2.fromOffset(12, 12)
            knob.BackgroundColor3 = state and C.knobOn or C.knobOff
            knob.BorderSizePixel = 0
            knob.ZIndex = 8
            knob.Parent = pill
            addRoundCorner(knob)

            local fastTween = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local function renderState(newState)
                state = newState
                TweenService:Create(pill, fastTween, {
                    BackgroundColor3 = state and C.toggleOnBg or C.toggleOffBg
                }):Play()
                TweenService:Create(knob, fastTween, {
                    Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = state and C.knobOn or C.knobOff
                }):Play()
            end

            local function triggerToggle()
                renderState(not state)
                if callback then
                    pcall(callback, state)
                end
            end

            local rowClick = Instance.new("TextButton")
            rowClick.Text = ""
            rowClick.AutoButtonColor = false
            rowClick.BackgroundTransparency = 1
            rowClick.Size = UDim2.new(1, -46, 1, 0)
            rowClick.ZIndex = 6
            rowClick.Parent = row

            rowClick.MouseButton1Click:Connect(triggerToggle)
            pill.MouseButton1Click:Connect(triggerToggle)

            row.MouseEnter:Connect(function() row.BackgroundColor3 = C.rowHover end)
            row.MouseLeave:Connect(function() row.BackgroundColor3 = C.rowBg end)

            local getter = configToggleGetters[tostring(name)]
            if getter then
                table.insert(mlib._toggleWatchers, function()
                    local ok, actual = pcall(getter)
                    if ok and type(actual) == "boolean" and actual ~= state then
                        renderState(actual)
                    end
                end)
            end

            table.insert(tab.itemMeta, {
                kind = "toggle",
                name = tostring(name),
                getState = function() return state end,
                trigger = triggerToggle,
            })
            table.insert(tab.items, row)
            rebalanceTabColumns(tab)
        end

        function mlib:AddComboBox(name, options, callback)
            local tab = mlib._currentBuildTab or mlib:CreateTab("Main")
            local opts = (type(options) == "table" and #options > 0) and options or {"None"}
            local selected = tostring(opts[1])
            local expanded = false

            local card = Instance.new("Frame")
            card.Name = "Combo_" .. tostring(name)
            card.BackgroundColor3 = C.rowBg
            card.BorderSizePixel = 0
            card.Size = UDim2.new(1, 0, 0, 28)
            card.AutomaticSize = Enum.AutomaticSize.Y
            card.ZIndex = 5
            addCorner(card, 3)
            addStroke(card, C.rowBorder, 1, 0)

            local topBtn = Instance.new("TextButton")
            topBtn.Text = ""
            topBtn.AutoButtonColor = false
            topBtn.BackgroundTransparency = 1
            topBtn.Size = UDim2.new(1, 0, 0, 28)
            topBtn.ZIndex = 6
            topBtn.Parent = card

            makeRowTextLabel(topBtn, tostring(name), 108, 28, 0)

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(1, -116, 0, 0)
            valLbl.Size = UDim2.fromOffset(106, 28)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.Text = selected
            valLbl.TextSize = 12
            valLbl.TextScaled = (#selected > 16)
            valLbl.TextColor3 = Color3.fromRGB(225, 232, 240)
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex = 7
            valLbl.Parent = topBtn
            local vtc = Instance.new("UITextSizeConstraint")
            vtc.MaxTextSize = 12
            vtc.MinTextSize = 8
            vtc.Parent = valLbl

            local dropWrap = Instance.new("Frame")
            dropWrap.Visible = false
            dropWrap.BackgroundColor3 = C.dropBg
            dropWrap.BorderSizePixel = 0
            dropWrap.Position = UDim2.fromOffset(0, 28)
            dropWrap.Size = UDim2.new(1, 0, 0, #opts * 24)
            dropWrap.ZIndex = 8
            dropWrap.Parent = card
            addCorner(dropWrap, 2)

            local dropLayout = Instance.new("UIListLayout")
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropWrap

            local optBtns = {}
            local function refreshOptColors()
                for _, ob in ipairs(optBtns) do
                    ob.btn.TextColor3 = (ob.val == selected) and Color3.fromRGB(68, 158, 248) or C.textDim
                end
            end

            local function selectOption(opt)
                selected = tostring(opt)
                valLbl.Text = selected
                valLbl.TextScaled = (#selected > 16)
                expanded = false
                dropWrap.Visible = false
                refreshOptColors()
                tab.updateCanvas()
                if callback then
                    pcall(callback, opt)
                end
            end

            for idx, opt in ipairs(opts) do
                local optStr = tostring(opt)
                local ob = Instance.new("TextButton")
                ob.AutoButtonColor = false
                ob.BackgroundColor3 = C.dropBg
                ob.BorderSizePixel = 0
                ob.LayoutOrder = idx
                ob.Size = UDim2.new(1, 0, 0, 24)
                ob.Font = Enum.Font.GothamBold
                ob.Text = "   " .. optStr
                ob.TextSize = 11
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.ZIndex = 9
                ob.Parent = dropWrap

                ob.MouseEnter:Connect(function() ob.BackgroundColor3 = C.dropHover end)
                ob.MouseLeave:Connect(function() ob.BackgroundColor3 = C.dropBg end)
                ob.MouseButton1Click:Connect(function()
                    selectOption(opt)
                end)
                table.insert(optBtns, { val = optStr, btn = ob })
            end
            refreshOptColors()

            topBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                dropWrap.Visible = expanded
                tab.updateCanvas()
            end)
            topBtn.MouseEnter:Connect(function() card.BackgroundColor3 = C.rowHover end)
            topBtn.MouseLeave:Connect(function() card.BackgroundColor3 = C.rowBg end)

            table.insert(tab.itemMeta, {
                kind = "combo",
                name = tostring(name),
                getSelected = function() return selected end,
                step = function(dir)
                    local curIdx = 1
                    for i, o in ipairs(opts) do
                        if tostring(o) == selected then
                            curIdx = i
                            break
                        end
                    end
                    local nxt = ((curIdx - 1 + (dir or 1)) % #opts) + 1
                    selectOption(opts[nxt])
                end,
            })
            table.insert(tab.items, card)
            rebalanceTabColumns(tab)
        end

        function mlib:AddInputBox(name, callback, placeholder, default, opts)
            local tab = mlib._currentBuildTab or mlib:CreateTab("Main")
            opts = type(opts) == "table" and opts or {}

            local rawDefault = tostring(default ~= nil and default or "")
            local defNum = tonumber(rawDefault)
            local rawMin = tonumber(opts.min) or 0
            local rawMax = tonumber(opts.max) or 100

            local sliderMin = rawMin
            if sliderMin == -math.huge or sliderMin < -500 then
                sliderMin = (rawMin == -math.huge) and 0 or -50
            end

            local sliderMax = rawMax
            if sliderMax == math.huge or sliderMax > 1000 then
                if defNum and defNum ~= math.huge and defNum ~= -math.huge and defNum > 0 then
                    sliderMax = math.max(50, defNum * 5)
                else
                    sliderMax = 500
                end
            end
            if sliderMax <= sliderMin then
                sliderMax = sliderMin + 100
            end

            local isSmallFloat = ((sliderMax - sliderMin) <= 2)

            local function formatDisplay(strOrNum)
                local s = tostring(strOrNum)
                local n = tonumber(s)
                if not n or n == math.huge or s:lower():find("inf") then
                    return "inf"
                elseif n == -math.huge then
                    return "-inf"
                end
                return string.format("%.3f", n)
            end

            local card = Instance.new("Frame")
            card.Name = "Slider_" .. tostring(name)
            card.BackgroundColor3 = C.rowBg
            card.BorderSizePixel = 0
            card.Size = UDim2.new(1, 0, 0, 48)
            card.ZIndex = 5
            addCorner(card, 3)
            addStroke(card, C.rowBorder, 1, 0)

            makeRowTextLabel(card, tostring(name), 92, 20, 5)

            local boxWrap = Instance.new("Frame")
            boxWrap.BackgroundColor3 = C.inputBg
            boxWrap.BorderSizePixel = 0
            boxWrap.Position = UDim2.new(1, -84, 0, 5)
            boxWrap.Size = UDim2.fromOffset(76, 18)
            boxWrap.ZIndex = 6
            boxWrap.Parent = card
            addCorner(boxWrap, 2)
            addStroke(boxWrap, C.inputBorder, 1, 0)

            local box = Instance.new("TextBox")
            box.BackgroundTransparency = 1
            box.ClearTextOnFocus = false
            box.Position = UDim2.fromOffset(6, 0)
            box.Size = UDim2.new(1, -10, 1, 0)
            box.Font = Enum.Font.GothamBold
            box.PlaceholderText = tostring(placeholder or "")
            box.PlaceholderColor3 = Color3.fromRGB(140, 160, 185)
            box.Text = formatDisplay(rawDefault)
            box.TextSize = 11
            box.TextColor3 = C.text
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ZIndex = 7
            box.Parent = boxWrap

            local track = Instance.new("Frame")
            track.BackgroundColor3 = C.sliderTrack
            track.BorderSizePixel = 0
            track.Position = UDim2.fromOffset(10, 31)
            track.Size = UDim2.new(1, -20, 0, 10)
            track.Active = true
            track.ZIndex = 6
            track.Parent = card
            addRoundCorner(track)

            local initAlpha = 0
            if defNum == math.huge or rawDefault:lower():find("inf") then
                initAlpha = 1
            elseif defNum then
                initAlpha = clampVal((defNum - sliderMin) / (sliderMax - sliderMin), 0, 1)
            end
            local currentAlpha = initAlpha

            local knob = Instance.new("Frame")
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(initAlpha, 0, 0.5, 0)
            knob.Size = UDim2.fromOffset(12, 12)
            knob.BackgroundColor3 = C.sliderKnob
            knob.BorderSizePixel = 0
            knob.ZIndex = 7
            knob.Parent = track
            addRoundCorner(knob)

            local function setKnobFromVal(vStr)
                local n = tonumber(vStr)
                local a = initAlpha
                if tostring(vStr):lower():find("inf") or n == math.huge then
                    a = 1
                elseif n then
                    a = clampVal((n - sliderMin) / (sliderMax - sliderMin), 0, 1)
                end
                currentAlpha = a
                knob.Position = UDim2.new(a, 0, 0.5, 0)
            end

            local function applySliderAlpha(alpha)
                alpha = clampVal(alpha, 0, 1)
                currentAlpha = alpha
                knob.Position = UDim2.new(alpha, 0, 0.5, 0)

                if opts.isNumber == false and alpha >= 0.995 and rawMax == math.huge then
                    box.Text = "inf"
                    if callback then pcall(callback, "inf") end
                    return
                end

                local val = sliderMin + alpha * (sliderMax - sliderMin)
                if isSmallFloat then
                    val = math.floor(val * 1000 + 0.5) / 1000
                else
                    val = math.floor(val + 0.5)
                end
                val = clampVal(val, rawMin, rawMax)

                local passStr = tostring(val)
                if callback then
                    local ok, ret = pcall(callback, passStr)
                    if ok and ret ~= nil then
                        passStr = tostring(ret)
                    end
                end
                box.Text = formatDisplay(passStr)
            end

            local sliding = false
            local function updateFromMouse(mouseX)
                local absPos = track.AbsolutePosition.X
                local absWidth = math.max(1, track.AbsoluteSize.X)
                applySliderAlpha((mouseX - absPos) / absWidth)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateFromMouse(input.Position.X)
                end
            end)
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                end
            end)

            trackConn(UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end))

            trackConn(UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateFromMouse(input.Position.X)
                end
            end))

            box.FocusLost:Connect(function()
                local txt = box.Text
                local outStr = txt
                if callback then
                    local ok, ret = pcall(callback, txt)
                    if ok and ret ~= nil then
                        outStr = tostring(ret)
                    end
                end
                box.Text = formatDisplay(outStr)
                setKnobFromVal(outStr)
            end)

            card.MouseEnter:Connect(function() card.BackgroundColor3 = C.rowHover end)
            card.MouseLeave:Connect(function() card.BackgroundColor3 = C.rowBg end)

            table.insert(tab.itemMeta, {
                kind = "slider",
                name = tostring(name),
                getAlpha = function() return currentAlpha end,
                getDisplay = function() return box.Text end,
                setAlpha = applySliderAlpha,
            })
            table.insert(tab.items, card)
            rebalanceTabColumns(tab)
        end

        function mlib:AddButton(name, callback)
            local tab = mlib._currentBuildTab or mlib:CreateTab("Main")

            local row = Instance.new("Frame")
            row.Name = "Button_" .. tostring(name)
            row.BackgroundColor3 = C.rowBg
            row.BorderSizePixel = 0
            row.Size = UDim2.new(1, 0, 0, 28)
            row.ZIndex = 5
            addCorner(row, 3)
            addStroke(row, C.rowBorder, 1, 0)

            makeRowTextLabel(row, tostring(name), 78, 28, 0)

            local actBtn = Instance.new("TextButton")
            actBtn.AutoButtonColor = false
            actBtn.BackgroundColor3 = C.whiteBtn
            actBtn.BorderSizePixel = 0
            actBtn.Position = UDim2.new(1, -68, 0.5, -9)
            actBtn.Size = UDim2.fromOffset(60, 18)
            actBtn.Font = Enum.Font.GothamBold
            actBtn.Text = "Run"
            actBtn.TextSize = 10
            actBtn.TextColor3 = Color3.fromRGB(16, 22, 30)
            actBtn.ZIndex = 7
            actBtn.Parent = row
            addCorner(actBtn, 1)
            addStroke(actBtn, C.whiteBtnBrd, 1, 0)

            local rowHit = Instance.new("TextButton")
            rowHit.Text = ""
            rowHit.AutoButtonColor = false
            rowHit.BackgroundTransparency = 1
            rowHit.Size = UDim2.fromScale(1, 1)
            rowHit.ZIndex = 6
            rowHit.Parent = row

            local function fire()
                actBtn.BackgroundColor3 = Color3.fromRGB(190, 215, 245)
                task.delay(0.12, function()
                    if actBtn and actBtn.Parent then
                        actBtn.BackgroundColor3 = C.whiteBtn
                    end
                end)
                if callback then
                    pcall(callback)
                end
            end

            actBtn.MouseButton1Click:Connect(fire)
            rowHit.MouseButton1Click:Connect(fire)
            row.MouseEnter:Connect(function() row.BackgroundColor3 = C.rowHover end)
            row.MouseLeave:Connect(function() row.BackgroundColor3 = C.rowBg end)

            table.insert(tab.itemMeta, {
                kind = "button",
                name = tostring(name),
                fire = fire,
            })
            table.insert(tab.items, row)
            rebalanceTabColumns(tab)
        end

        -- =====================================================================
        -- DISCORD STREAMPROOF / SCREENPROOF ENGINE
        -- Layer 1: Native executor WDA_EXCLUDEFROMCAPTURE / overlay streamproof hooks
        -- Layer 2: Full Roblox DX11 swapchain visual cloak (ScreenGuis, Highlights, Blur, Hitbox cubes, 3D parts)
        -- Layer 3: Pooled external Drawing-API UI + FOV + ESP + AimView renderer + F8 Ghost Cloak
        -- =====================================================================
        local spPools = { Square = {}, Circle = {}, Line = {}, Text = {} }
        local spUsed = { Square = 0, Circle = 0, Line = 0, Text = 0 }
        local spWinW, spWinH = 602, 514
        local spWinX, spWinY = 300, 180
        local spDraggingWin = false
        local spDragOffX, spDragOffY = 0, 0
        local spActiveSlider = nil
        local spHitZones = {}

        local function applyNativeStreamProof(state)
            local hooked = false
            local function tryFn(fn)
                if type(fn) == "function" then
                    local ok = pcall(fn, state)
                    if ok then hooked = true end
                end
            end
            pcall(function()
                local env = (type(getgenv) == "function" and getgenv()) or _G
                if type(env) == "table" then
                    tryFn(env.setstreamproof)
                    tryFn(env.set_streamproof)
                    tryFn(env.set_stream_proof)
                end
            end)
            pcall(function()
                if type(Drawing) == "table" then
                    tryFn(Drawing.setstreamproof)
                    tryFn(Drawing.SetStreamProof)
                    tryFn(Drawing.set_stream_proof)
                end
            end)
            pcall(function()
                if type(syn) == "table" then
                    tryFn(syn.set_stream_proof)
                    tryFn(syn.setstreamproof)
                end
            end)
            pcall(function()
                local gs = game:GetService("GuiService")
                local sh = gs and gs:FindFirstChildOfClass("ScreenshotHud")
                if sh then
                    sh.HideCoreGuiForCaptures = state
                    sh.HidePlayerGuiForCaptures = state
                end
            end)
            mlib._spNativeHook = hooked
            return hooked
        end

        local function applyEngineCloak(state)
            config.streamProof = state
            pcall(function() mlib._screenGui.Enabled = not state end)
            if mlib._motionBlur then
                pcall(function()
                    if state then mlib._motionBlur.Size = 0 end
                    mlib._motionBlur.Enabled = not state
                end)
            end
            if gui and gui.ScreenGui then
                pcall(function() gui.ScreenGui.Enabled = not state end)
            end
            if config.aimbotFOVRing and config.aimbotFOVRing.ScreenGui then
                pcall(function() config.aimbotFOVRing.ScreenGui.Enabled = not state end)
            end
            for _, data in pairs(config.espData) do
                if data and data.screenGui then
                    pcall(function() data.screenGui.Enabled = not state end)
                end
            end
            for _, h in pairs(config.highlightData) do
                if h then
                    pcall(function() h.Enabled = not state end)
                end
            end
            for _, data in pairs(config.hitboxExpandedParts) do
                if data and data.part and data.part.Parent then
                    pcall(function() data.part.Transparency = state and 1 or 0.9 end)
                end
            end
            if not state then
                config.aimviewSegments = {}
            end
        end

        local function allocDraw(dtype)
            if not mlib._hasDrawing then return nil end
            local list = spPools[dtype]
            local idx = spUsed[dtype] + 1
            spUsed[dtype] = idx
            local obj = list[idx]
            if not obj then
                local ok, created = pcall(Drawing.new, dtype)
                if not ok or not created then
                    spUsed[dtype] = idx - 1
                    return nil
                end
                if dtype == "Text" then
                    pcall(function()
                        if Drawing.Fonts and Drawing.Fonts.UI then
                            created.Font = Drawing.Fonts.UI
                        else
                            created.Font = 2
                        end
                    end)
                end
                obj = created
                list[idx] = obj
            end
            return obj
        end

        local function hideUnusedDraws()
            for dtype, list in pairs(spPools) do
                for i = spUsed[dtype] + 1, #list do
                    pcall(function() list[i].Visible = false end)
                end
            end
        end

        local function destroyAllDraws()
            for dtype, list in pairs(spPools) do
                for i = #list, 1, -1 do
                    pcall(function() list[i]:Remove() end)
                    list[i] = nil
                end
                spUsed[dtype] = 0
            end
        end

        local function drawRect(x, y, w, h, col, opacity, z)
            local s = allocDraw("Square")
            if not s then return end
            s.Filled = true
            s.Thickness = 1
            s.Position = Vector2.new(math.floor(x), math.floor(y))
            s.Size = Vector2.new(math.max(1, math.floor(w)), math.max(1, math.floor(h)))
            s.Color = col
            s.Transparency = opacity or 1
            s.ZIndex = z or 50
            s.Visible = true
        end

        local function drawOutlineRect(x, y, w, h, col, thick, opacity, z)
            local s = allocDraw("Square")
            if not s then return end
            s.Filled = false
            s.Thickness = thick or 1
            s.Position = Vector2.new(math.floor(x), math.floor(y))
            s.Size = Vector2.new(math.max(1, math.floor(w)), math.max(1, math.floor(h)))
            s.Color = col
            s.Transparency = opacity or 1
            s.ZIndex = z or 51
            s.Visible = true
        end

        local function drawCircle(cx, cy, r, col, filled, thick, opacity, sides, z)
            local c = allocDraw("Circle")
            if not c then return end
            c.Position = Vector2.new(cx, cy)
            c.Radius = math.max(1, r)
            c.Color = col
            c.Filled = (filled == true)
            c.Thickness = thick or 1
            c.Transparency = opacity or 1
            c.NumSides = sides or 32
            c.ZIndex = z or 52
            c.Visible = true
        end

        local function drawLine(x1, y1, x2, y2, col, thick, opacity, z)
            local l = allocDraw("Line")
            if not l then return end
            l.From = Vector2.new(x1, y1)
            l.To = Vector2.new(x2, y2)
            l.Color = col
            l.Thickness = thick or 1
            l.Transparency = opacity or 1
            l.ZIndex = z or 50
            l.Visible = true
        end

        local function drawText(x, y, str, sz, col, centered, outline, opacity, z)
            local t = allocDraw("Text")
            if not t then return end
            t.Position = Vector2.new(math.floor(x), math.floor(y))
            t.Text = tostring(str)
            t.Size = sz or 13
            t.Color = col
            t.Center = (centered == true)
            t.Outline = (outline ~= false)
            t.OutlineColor = Color3.fromRGB(10, 14, 20)
            t.Transparency = opacity or 1
            t.ZIndex = z or 55
            t.Visible = true
        end

        local function truncText(s, maxLen)
            s = tostring(s or "")
            if #s <= maxLen then return s end
            return string.sub(s, 1, math.max(1, maxLen - 2)) .. ".."
        end

        function mlib:SetStreamProof(state)
            state = (state == true)
            if mlib._streamProof == state then return end

            if state then
                pcall(function()
                    if win and win.AbsoluteSize and win.AbsoluteSize.X > 0 then
                        spWinX = win.AbsolutePosition.X
                        spWinY = win.AbsolutePosition.Y
                    else
                        local cam = workspace.CurrentCamera
                        local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
                        spWinX = math.floor((vp.X - spWinW) * 0.5)
                        spWinY = math.floor((vp.Y - spWinH) * 0.5)
                    end
                end)
                settingsPopup.Visible = false
                mlib._streamProof = true
                mlib._spGhostCloak = false
                mlib._spMenuVisible = true
                applyNativeStreamProof(true)
                applyEngineCloak(true)
            else
                mlib._streamProof = false
                mlib._spGhostCloak = false
                spDraggingWin = false
                spActiveSlider = nil
                spHitZones = {}
                destroyAllDraws()
                applyNativeStreamProof(false)
                applyEngineCloak(false)
                win.Position = UDim2.fromOffset(spWinX + 301, spWinY + 257)
                win.Visible = true
            end

            if mlib._spSyncVisuals then
                pcall(mlib._spSyncVisuals, state)
            end
        end

        -- StreamProof RenderStepped Loop (FOV + ESP + AimView + Interactive dimes.cc Menu)
        trackConn(RunService.RenderStepped:Connect(function()
            if not mlib._streamProof or not mlib._hasDrawing then return end

            spUsed.Square = 0
            spUsed.Circle = 0
            spUsed.Line = 0
            spUsed.Text = 0
            spHitZones = {}

            if mlib._spGhostCloak then
                hideUnusedDraws()
                return
            end

            local cam = workspace.CurrentCamera
            if not cam then
                hideUnusedDraws()
                return
            end
            local vp = cam.ViewportSize
            local cx, cy = vp.X * 0.5, vp.Y * 0.5

            -- 1. StreamProof Aimbot Red FOV Circle (respects 0-1 FOV Outline transparency)
            if config.aimbotEnabled and not config.aimbot360Enabled then
                local opacity = clampVal(1 - (tonumber(config.aimbotFOVTransparency) or 0.3), 0, 1)
                if opacity > 0.01 then
                    drawCircle(cx, cy, tonumber(config.aimbotFOVSize) or 100, Color3.fromRGB(255, 0, 0), false, 1, opacity, 64, 20)
                end
            end

            -- 2. StreamProof SilentAim FOV Circle
            if config.Enabled then
                local saCol = (gui and gui.RingStroke and gui.RingStroke.Color) or (config.currentTarget and config.fovct or Color3.fromRGB(200, 200, 255))
                drawCircle(cx, cy, tonumber(config.fovsize) or 120, saCol, false, 1, 1, 64, 21)
            end

            -- 3. StreamProof AimView 2D Beams
            if config.aimviewEveryone and type(config.aimviewSegments) == "table" then
                for i = 1, #config.aimviewSegments do
                    local seg = config.aimviewSegments[i]
                    if seg and seg.from and seg.to then
                        local v1 = cam:WorldToViewportPoint(seg.from)
                        local v2 = cam:WorldToViewportPoint(seg.to)
                        if v1.Z > 0 and v2.Z > 0 then
                            drawLine(v1.X, v1.Y, v2.X, v2.Y, Color3.fromRGB(255, 45, 45), 1.6, 0.88, 18)
                        end
                    end
                end
            end

            -- 4. StreamProof ESP (Box / Highlight-Box / Health / Text / HeadDot)
            if config.espMasterEnabled and (config.prefBoxESP or config.prefHighlightESP or config.prefTextESP or config.prefHealthESP or config.prefHeadDotESP) then
                local targets = (config._getAllTargets and config._getAllTargets()) or Players:GetPlayers()
                for i = 1, #targets do
                    local t = targets[i]
                    if t and t ~= localPlayer and ((not config._addesp) or config._addesp(t)) then
                        local tchar = (config._getTargetCharacter and config._getTargetCharacter(t)) or (typeof(t) == "Instance" and t:IsA("Player") and t.Character or nil)
                        if tchar and tchar.Parent then
                            local head = tchar:FindFirstChild("Head")
                            local root = tchar:FindFirstChild("HumanoidRootPart") or tchar:FindFirstChild("Torso") or tchar:FindFirstChild("UpperTorso")
                            local hum = tchar:FindFirstChildOfClass("Humanoid")
                            if head and root and (not hum or hum.Health > 0) then
                                local topV3, onTop = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.4, 0))
                                local botV3, onBot = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 1.0, 0))
                                local midV3, onMid = cam:WorldToViewportPoint((head.Position + root.Position) * 0.5)
                                if onTop and onBot and onMid and topV3.Z > 0 and botV3.Z > 0 then
                                    local topY = topV3.Y
                                    local botY = botV3.Y
                                    local hPx = math.max(4, math.abs(botY - topY))
                                    local wPx = clampVal(hPx * 0.45, 4, 400)
                                    local boxX = midV3.X - wPx * 0.5

                                    local hpRatio = 1
                                    if hum and (hum.MaxHealth or 100) > 0 then
                                        hpRatio = clampVal(hum.Health / (hum.MaxHealth or 100), 0, 1)
                                    end
                                    local hpCol = Color3.new(1 - hpRatio, hpRatio, 0)
                                    local isLocked = (t == config.currentTarget) or (t == config.aimbotCurrentTarget)
                                    local espCol = (config.prefColorByHealth and hum) and hpCol or (isLocked and config.esptargetc or config.espc)

                                    if config.prefBoxESP or config.prefHighlightESP then
                                        if config.prefHighlightESP then
                                            drawRect(boxX, topY, wPx, hPx, espCol, 0.20, 14)
                                        else
                                            drawRect(boxX, topY, wPx, hPx, Color3.fromRGB(0, 0, 0), 0.25, 14)
                                        end
                                        drawOutlineRect(boxX, topY, wPx, hPx, espCol, 1, 0.95, 15)
                                    end

                                    if config.prefHealthESP and hum then
                                        local hbX = boxX + wPx + 4
                                        drawRect(hbX, topY, 4, hPx, Color3.fromRGB(0, 0, 0), 0.55, 15)
                                        local fillH = math.max(1, hPx * hpRatio)
                                        drawRect(hbX, topY + (hPx - fillH), 4, fillH, hpCol, 1, 16)
                                    end

                                    if config.prefTextESP then
                                        local tName = (config._getTargetName and config._getTargetName(t)) or tostring(t.Name or t)
                                        local lblStr = string.format("%s [%d]", tName, hum and math.floor(hum.Health) or 0)
                                        drawText(midV3.X, topY - 15, lblStr, 13, espCol, true, true, 1, 17)
                                    end

                                    if config.prefHeadDotESP then
                                        local hdV3, onHd = cam:WorldToViewportPoint(head.Position)
                                        if onHd and hdV3.Z > 0 then
                                            drawCircle(hdV3.X, hdV3.Y, 3, espCol, true, 1, 1, 16, 17)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- 5. StreamProof Interactive dimes.cc Menu
            if mlib._spMenuVisible then
                local wx, wy = spWinX, spWinY
                drawRect(wx, wy, spWinW, spWinH, C.winBg, 0.98, 40)
                drawOutlineRect(wx, wy, spWinW, spWinH, C.winBorder, 1, 1, 41)

                -- Header Drag Zone (inserted first = lowest click priority in header)
                table.insert(spHitZones, {
                    x = wx, y = wy, w = spWinW, h = 50,
                    isHeaderDrag = true,
                })

                -- Title + StreamProof Status Pill
                drawText(wx + 14, wy + 14, "dimes.cc", 21, Color3.fromRGB(115, 182, 238), false, true, 1, 45)
                drawRect(wx + 124, wy + 15, 138, 20, Color3.fromRGB(14, 46, 38), 1, 44)
                drawOutlineRect(wx + 124, wy + 15, 138, 20, Color3.fromRGB(46, 204, 113), 1, 1, 45)
                drawText(wx + 193, wy + 18, "STREAMPROOF ON", 12, Color3.fromRGB(92, 238, 152), true, true, 1, 46)

                -- F8 Ghost Cloak Button (for Entire-Screen shares on basic executors)
                local cloakX, cloakY, cloakW, cloakH = wx + spWinW - 144, wy + 13, 78, 22
                drawRect(cloakX, cloakY, cloakW, cloakH, C.rowBg, 1, 45)
                drawOutlineRect(cloakX, cloakY, cloakW, cloakH, C.tabLine, 1, 1, 46)
                drawText(cloakX + cloakW * 0.5, cloakY + 4, "F8: CLOAK", 12, C.textDim, true, true, 1, 47)
                table.insert(spHitZones, {
                    x = cloakX, y = cloakY, w = cloakW, h = cloakH,
                    onClick = function() mlib._spGhostCloak = true end,
                })

                -- Top-Right Blurple Discord Button (click to exit StreamProof back to ScreenGui)
                local dcX, dcY = wx + spWinW - 58, wy + 12
                drawRect(dcX, dcY, 24, 24, Color3.fromRGB(88, 101, 242), 1, 45)
                drawOutlineRect(dcX, dcY, 24, 24, Color3.fromRGB(132, 146, 255), 1, 1, 46)
                drawRect(dcX + 4, dcY + 7, 16, 10, Color3.fromRGB(246, 248, 255), 1, 47)
                drawRect(dcX + 6, dcY + 5, 4, 3, Color3.fromRGB(246, 248, 255), 1, 47)
                drawRect(dcX + 14, dcY + 5, 4, 3, Color3.fromRGB(246, 248, 255), 1, 47)
                drawRect(dcX + 7, dcY + 10, 3, 3, Color3.fromRGB(88, 101, 242), 1, 48)
                drawRect(dcX + 14, dcY + 10, 3, 3, Color3.fromRGB(88, 101, 242), 1, 48)
                table.insert(spHitZones, {
                    x = dcX, y = dcY, w = 24, h = 24,
                    onClick = function() mlib:SetStreamProof(false) end,
                })

                -- Top-Right Re-Center Button (Gear slot)
                local grX, grY = wx + spWinW - 30, wy + 12
                drawRect(grX, grY, 24, 24, C.rowBg, 1, 45)
                drawOutlineRect(grX, grY, 24, 24, C.tabSep, 1, 1, 46)
                drawLine(grX + 12, grY + 6, grX + 12, grY + 18, C.text, 1.5, 1, 47)
                drawLine(grX + 6, grY + 12, grX + 18, grY + 12, C.text, 1.5, 1, 47)
                table.insert(spHitZones, {
                    x = grX, y = grY, w = 24, h = 24,
                    onClick = function()
                        spWinX = math.floor((vp.X - spWinW) * 0.5)
                        spWinY = math.floor((vp.Y - spWinH) * 0.5)
                    end,
                })

                -- Horizontal Tab Bar
                local tabCount = #mlib._tabList
                if tabCount > 0 then
                    local tbX, tbY, tbW, tbH = wx + 8, wy + 50, spWinW - 16, 28
                    local singleW = tbW / tabCount
                    for idx = 1, tabCount do
                        local tObj = mlib._tabList[idx]
                        local tx = tbX + (idx - 1) * singleW
                        local isSel = (tObj == mlib._activeTab)
                        if isSel then
                            drawRect(tx, tbY, singleW, tbH, Color3.fromRGB(28, 38, 52), 0.65, 44)
                            drawRect(tx + 4, tbY + tbH - 2, singleW - 8, 2, C.tabLine, 1, 46)
                        end
                        drawText(tx + singleW * 0.5, tbY + 7, tObj.name, 13, isSel and C.text or C.textDim, true, true, 1, 46)
                        if idx < tabCount then
                            drawLine(tx + singleW, tbY + 7, tx + singleW, tbY + 21, C.tabSep, 1, 1, 45)
                        end
                        local tName = tObj.name
                        table.insert(spHitZones, {
                            x = tx, y = tbY, w = singleW, h = tbH,
                            onClick = function() mlib:ShowTab(tName) end,
                        })
                    end
                end

                -- 2-Column Tab Items + Scrollbar
                local activeTab = mlib._activeTab
                if activeTab and activeTab.itemMeta then
                    local metaList = activeTab.itemMeta
                    local totalItems = #metaList
                    local half = math.ceil(totalItems / 2)
                    local bodyTop = wy + 86
                    local bodyBot = wy + spWinH - 10
                    local bodyH = bodyBot - bodyTop
                    local colW = 282
                    local colX1 = wx + 10
                    local colX2 = wx + 298

                    local leftH, rightH = 0, 0
                    for i = 1, totalItems do
                        local ih = (metaList[i].kind == "slider") and 48 or 28
                        if i <= half then
                            leftH = leftH + ih + 5
                        else
                            rightH = rightH + ih + 5
                        end
                    end
                    local contentH = math.max(leftH, rightH)
                    activeTab.maxScroll = math.max(0, contentH - bodyH + 8)
                    activeTab.scrollY = clampVal(activeTab.scrollY or 0, 0, activeTab.maxScroll)

                    -- Right Scrollbar Groove + Thumb
                    local grvX = wx + spWinW - 11
                    drawRect(grvX, bodyTop, 6, bodyH, C.scrollGroove, 1, 44)
                    if activeTab.maxScroll > 0 then
                        local thumbRatio = clampVal(bodyH / math.max(1, contentH), 0.15, 1)
                        local thumbH = math.max(20, bodyH * thumbRatio)
                        local scrollAlpha = activeTab.scrollY / activeTab.maxScroll
                        local thumbY = bodyTop + (bodyH - thumbH) * scrollAlpha
                        drawRect(grvX, thumbY, 6, thumbH, C.scrollThumb, 1, 45)
                    end

                    local curLeftY = bodyTop - activeTab.scrollY
                    local curRightY = bodyTop - activeTab.scrollY

                    for i = 1, totalItems do
                        local item = metaList[i]
                        local isLeft = (i <= half)
                        local ix = isLeft and colX1 or colX2
                        local iy = isLeft and curLeftY or curRightY
                        local ih = (item.kind == "slider") and 48 or 28

                        if isLeft then
                            curLeftY = curLeftY + ih + 5
                        else
                            curRightY = curRightY + ih + 5
                        end

                        if iy >= (bodyTop - 4) and (iy + ih) <= (bodyBot + 4) then
                            drawRect(ix, iy, colW, ih, C.rowBg, 1, 45)
                            drawOutlineRect(ix, iy, colW, ih, C.rowBorder, 1, 1, 46)

                            if item.kind == "toggle" then
                                local st = item.getState()
                                drawText(ix + 10, iy + 7, truncText(item.name, 31), 13, C.text, false, true, 1, 47)
                                local px, py = ix + colW - 42, iy + 6
                                drawRect(px, py, 34, 16, st and C.toggleOnBg or C.toggleOffBg, 1, 47)
                                drawOutlineRect(px, py, 34, 16, Color3.fromRGB(36, 46, 58), 1, 1, 48)
                                local kx = st and (px + 26) or (px + 8)
                                drawCircle(kx, py + 8, 5, st and C.knobOn or C.knobOff, true, 1, 1, 18, 49)
                                table.insert(spHitZones, {
                                    x = ix, y = iy, w = colW, h = ih,
                                    onClick = item.trigger,
                                })
                            elseif item.kind == "combo" then
                                drawText(ix + 10, iy + 7, truncText(item.name, 21), 13, C.text, false, true, 1, 47)
                                local selTxt = "< " .. truncText(item.getSelected(), 13) .. " >"
                                drawText(ix + colW - 58, iy + 7, selTxt, 12, Color3.fromRGB(110, 182, 250), true, true, 1, 47)
                                table.insert(spHitZones, {
                                    x = ix, y = iy, w = colW, h = ih,
                                    onClick = function() item.step(1) end,
                                    onRightClick = function() item.step(-1) end,
                                })
                            elseif item.kind == "slider" then
                                drawText(ix + 10, iy + 6, truncText(item.name, 25), 13, C.text, false, true, 1, 47)
                                local bx, by, bw, bh = ix + colW - 82, iy + 5, 74, 18
                                drawRect(bx, by, bw, bh, C.inputBg, 1, 47)
                                drawOutlineRect(bx, by, bw, bh, C.inputBorder, 1, 1, 48)
                                drawText(bx + bw * 0.5, by + 2, truncText(item.getDisplay(), 10), 12, C.text, true, true, 1, 49)

                                local tx, ty, tw, th = ix + 10, iy + 32, colW - 20, 8
                                local alpha = clampVal(item.getAlpha() or 0, 0, 1)
                                drawRect(tx, ty, tw, th, C.sliderTrack, 1, 47)
                                if alpha > 0.01 then
                                    drawRect(tx, ty, math.max(2, tw * alpha), th, C.accent, 1, 48)
                                end
                                drawCircle(tx + tw * alpha, ty + th * 0.5, 6, C.sliderKnob, true, 1, 1, 18, 49)
                                table.insert(spHitZones, {
                                    x = ix, y = iy + 22, w = colW, h = 26,
                                    sliderMeta = item,
                                    trackX = tx,
                                    trackW = tw,
                                })
                            elseif item.kind == "button" then
                                drawText(ix + 10, iy + 7, truncText(item.name, 28), 13, C.text, false, true, 1, 47)
                                local bx, by, bw, bh = ix + colW - 68, iy + 5, 60, 18
                                drawRect(bx, by, bw, bh, C.whiteBtn, 1, 47)
                                drawOutlineRect(bx, by, bw, bh, C.whiteBtnBrd, 1, 1, 48)
                                drawText(bx + bw * 0.5, by + 2, "Run", 12, Color3.fromRGB(16, 22, 30), true, false, 1, 49)
                                table.insert(spHitZones, {
                                    x = ix, y = iy, w = colW, h = ih,
                                    onClick = item.fire,
                                })
                            end
                        end
                    end
                end
            end

            hideUnusedDraws()
        end))

        -- StreamProof Mouse & Scroll Input Handling
        trackConn(UserInputService.InputBegan:Connect(function(input)
            if not mlib._streamProof or not mlib._hasDrawing or not mlib._spMenuVisible or mlib._spGhostCloak then
                return
            end
            local ut = input.UserInputType
            if ut == Enum.UserInputType.MouseButton1 or ut == Enum.UserInputType.MouseButton2 then
                local mPos = UserInputService:GetMouseLocation()
                for i = #spHitZones, 1, -1 do
                    local z = spHitZones[i]
                    if mPos.X >= z.x and mPos.X <= (z.x + z.w) and mPos.Y >= z.y and mPos.Y <= (z.y + z.h) then
                        if ut == Enum.UserInputType.MouseButton1 then
                            if z.sliderMeta then
                                spActiveSlider = z
                                z.sliderMeta.setAlpha((mPos.X - z.trackX) / math.max(1, z.trackW))
                            elseif z.isHeaderDrag then
                                spDraggingWin = true
                                spDragOffX = mPos.X - spWinX
                                spDragOffY = mPos.Y - spWinY
                            elseif z.onClick then
                                z.onClick()
                            end
                        elseif ut == Enum.UserInputType.MouseButton2 and z.onRightClick then
                            z.onRightClick()
                        end
                        break
                    end
                end
            end
        end))

        trackConn(UserInputService.InputChanged:Connect(function(input)
            if not mlib._streamProof or not mlib._hasDrawing or not mlib._spMenuVisible or mlib._spGhostCloak then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local mPos = UserInputService:GetMouseLocation()
                if spDraggingWin then
                    spWinX = mPos.X - spDragOffX
                    spWinY = mPos.Y - spDragOffY
                elseif spActiveSlider and spActiveSlider.sliderMeta then
                    spActiveSlider.sliderMeta.setAlpha((mPos.X - spActiveSlider.trackX) / math.max(1, spActiveSlider.trackW))
                end
            elseif input.UserInputType == Enum.UserInputType.MouseWheel then
                local mPos = UserInputService:GetMouseLocation()
                if mPos.X >= spWinX and mPos.X <= (spWinX + spWinW) and mPos.Y >= (spWinY + 84) and mPos.Y <= (spWinY + spWinH) then
                    local t = mlib._activeTab
                    if t then
                        t.scrollY = clampVal((t.scrollY or 0) - input.Position.Z * 28, 0, t.maxScroll or 0)
                    end
                end
            end
        end))

        trackConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                spDraggingWin = false
                spActiveSlider = nil
            end
        end))

        -- Menu Toggle Keybind + F8 StreamProof / Ghost Cloak Hotkey
        trackConn(UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local kc = input.KeyCode
            if kc == Enum.KeyCode.Unknown then return end

            if mlib._listeningMenuKey then
                mlib._listeningMenuKey = false
                if kc == Enum.KeyCode.Backspace or kc == Enum.KeyCode.Escape then
                    mlib._toggleKey = nil
                    mkBtn.Text = "N/A"
                else
                    mlib._toggleKey = kc
                    mkBtn.Text = kc.Name
                end
                return
            end

            if UserInputService:GetFocusedTextBox() then return end

            if kc == Enum.KeyCode.F8 then
                if not mlib._streamProof then
                    mlib:SetStreamProof(true)
                elseif mlib._hasDrawing then
                    mlib._spGhostCloak = not mlib._spGhostCloak
                else
                    mlib:SetStreamProof(false)
                end
                return
            end

            if (mlib._toggleKey and kc == mlib._toggleKey) or kc == Enum.KeyCode.Insert then
                if mlib._streamProof then
                    if not mlib._hasDrawing then
                        mlib:SetStreamProof(false)
                    elseif mlib._spGhostCloak then
                        mlib._spGhostCloak = false
                        mlib._spMenuVisible = true
                    else
                        mlib._spMenuVisible = not mlib._spMenuVisible
                    end
                else
                    win.Visible = not win.Visible
                end
            end
        end))

        -- Live Sync Toggles with Hotkeys / Config Changes
        do
            local lastSync = 0
            trackConn(RunService.Heartbeat:Connect(function()
                local now = tick()
                if now - lastSync < 0.12 then return end
                lastSync = now
                for _, watcher in ipairs(mlib._toggleWatchers) do
                    watcher()
                end
            end))
        end

        function mlib:Destroy()
            if mlib._streamProof then
                pcall(function() applyNativeStreamProof(false) end)
                config.streamProof = false
            end
            destroyAllDraws()
            for _, c in ipairs(mlib._connections) do
                pcall(function() c:Disconnect() end)
            end
            mlib._connections = {}
            if mlib._motionBlur and mlib._motionBlur.Parent then
                pcall(function() mlib._motionBlur:Destroy() end)
            end
            if mlib._screenGui and mlib._screenGui.Parent then
                pcall(function() mlib._screenGui:Destroy() end)
            end
        end

        return mlib
    end)
    if success and result then
        lib = result
    else
        warn("SilentAim: failed to load external UI library, using fallback stub. Error:", result)
        lib = {}
        function lib:SetTitle() end
        function lib:SetIcon() end
        function lib:SetBackgroundColor() end
        function lib:SetCloseBtnColor() end
        function lib:SetTitleColor() end
        function lib:SetButtonsColor() end
        function lib:SetTheme() end
        function lib:AddToggle(_, callback, default)
            if callback then
                pcall(callback, default)
            end
        end
        function lib:AddComboBox(_, _, callback)
            if callback then
                pcall(callback, "Only enemies")
            end
        end
        function lib:AddInputBox(_, callback, _, default)
            if callback then
                pcall(callback, tostring(default))
            end
        end
        function lib:CreateTab() return {} end
        function lib:Tab() end
    end
end

if not math.clamp then
    function math.clamp(x, a, b)
        if x < a then return a end
        if x > b then return b end
        return x
    end
end

local function updateTeamTargetModes()
    local masterSelection = config.masterTeamTarget or config.targetMode
    
    if masterSelection == "All" then
        config.targetMode = "All"
        config.aimbotTeamTarget = "All"
        config.hitboxTeamTarget = "All"
    else
        config.targetMode = masterSelection
        config.aimbotTeamTarget = masterSelection
        config.hitboxTeamTarget = masterSelection
    end
    
    if config.masterGetTarget then
        config.aimbotGetTarget = config.masterGetTarget
        config.silentGetTarget = config.masterGetTarget
        config.antiAimGetTarget = config.masterGetTarget
    end

    if config.espMasterEnabled then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= localPlayer then
                removeESPLabel(pl)
                if addesp(pl) then
                    makeesp(pl)
                end
            end
        end
    end
    
    if config.espMasterEnabled and config.prefHighlightESP then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= localPlayer then
                removeHighlightESP(pl)
                if addesp(pl) and pl.Character then
                    high(pl)
                end
            end
        end
    end
    applyhb()
    config.aimbotCurrentTarget = nil
    config.currentTarget = nil
    updateESPColors()
end

local function pc()
    local plr = game.Players.LocalPlayer
    task.spawn(function()
        while true do
            pcall(function()
                if settings and settings().Physics then
                    settings().Physics.AllowSleep = false
                end
            end)
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(plr, "SimulationRadius", math.huge)
                    sethiddenproperty(plr, "MaximumSimulationRadius", math.huge)
                end
            end)
            pcall(function()
                plr.MaximumSimulationRadius = math.huge
            end)
            pcall(function()
                plr.SimulationRadius = (config.gp and config.gp > 0) and config.gp or math.huge
            end)
            pcall(function()
                if config.autoFarmEnabled and config.currentAutoFarmTarget then
                    local targetChar = getTargetCharacter(config.currentAutoFarmTarget)
                    local targetPart = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head"))
                    if targetPart and targetPart:IsA("BasePart") then
                        plr.ReplicationFocus = targetPart
                        return
                    end
                end
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.ReplicationFocus = plr.Character.HumanoidRootPart
                end
            end)
            task.wait(0.1)
        end
    end)
end

pc()

local function isNPCModel(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health ~= nil then
        if model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") then
            return true
        end
    end
    return false
end

local function getAllTargets()
    local targets = {}

    if config.masterTarget == "Players" or config.masterTarget == "Both" then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= localPlayer then
                table.insert(targets, pl)
            end
        end
    end

    if config.masterTarget == "NPCs" or config.masterTarget == "Both" then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and isNPCModel(obj) then
                if not Players:GetPlayerFromCharacter(obj) then
                    table.insert(targets, obj)
                end
            end
        end
    end

    return targets
end

local function getTargetCharacter(target)
    if not target then return nil end
    if typeof(target) == "Instance" then
        if target:IsA("Player") then
            return target.Character
        elseif target:IsA("Model") then
            return target
        end
    end
    return nil
end

local function getTargetName(target)
    if not target then return "Unknown" end
    if typeof(target) == "Instance" then
        return target.Name
    end
    return tostring(target)
end

local function isTeammate(p)
    if not (localPlayer and p) then return false end
    if typeof(p) == "Instance" and p:IsA("Player") then
        if localPlayer.Team and p.Team then
            return localPlayer.Team == p.Team
        end
    end
    return false
end

local function addesp(targetPlayer)
    if not targetPlayer then return false end
    if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") and targetPlayer == localPlayer then return false end

    local mode = config.targetMode or "Enemies"
    if mode == "Enemies" then
        if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
            if isTeammate(targetPlayer) then
                return false
            else
                return true
            end
        else
            return true
        end
    elseif mode == "Teams" then
        if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
            return isTeammate(targetPlayer)
        else
            return false
        end
    elseif mode == "All" then
        return true
    else
        if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
            if isTeammate(targetPlayer) then
                return false
            else
                return true
            end
        else
            return true
        end
    end
end

config._getAllTargets = getAllTargets
config._getTargetCharacter = getTargetCharacter
config._getTargetName = getTargetName
config._addesp = addesp

local function plralive(target)
    if not target then return false end

    if typeof(target) == "Instance" and target:IsA("Player") then
        local character = target.Character
        if not character then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        if humanoid.Health <= 0 then return false end

        local state = nil
        pcall(function() state = humanoid:GetState() end)
        if state == Enum.HumanoidStateType.Dead then
            return false
        end

        local bodyEffects = character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local ko = bodyEffects:FindFirstChild("K.O") or bodyEffects:FindFirstChild("KO")
            if ko and (ko.Value == true or ko.Value == 1) then
                return false
            end
            local dead = bodyEffects:FindFirstChild("Dead")
            if dead and (dead.Value == true or dead.Value == 1) then
                return false
            end
        end

        if humanoid.PlatformStand and not humanoid.Sit then
            return false
        end

        if character:FindFirstChild("Ragdoll") and character.Ragdoll:IsA("BoolValue") and character.Ragdoll.Value == true then
            return false
        end
        if character:FindFirstChild("Knocked") and character.Knocked:IsA("BoolValue") and character.Knocked.Value == true then
            return false
        end

        return true
    end

    if typeof(target) == "Instance" and target:IsA("Model") then
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        if humanoid.Health <= 0 then return false end
        local state = nil
        pcall(function() state = humanoid:GetState() end)
        if state == Enum.HumanoidStateType.Dead then
            return false
        end
        return true
    end

    return false
end


local function saveTargetOriginalPosition(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    config.autoFarmOriginalPositions[target] = {
        position = targetRoot.Position,
        cframe = targetRoot.CFrame,
        timestamp = tick()
    }
end

local function restoreTargetOriginalPosition(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local savedData = config.autoFarmOriginalPositions[target]
    if savedData then
        pcall(function()
            targetRoot.CFrame = savedData.cframe
        end)
        config.autoFarmOriginalPositions[target] = nil
    end
end

local function ragdollModel(char)
    if not char or not char:IsA("Model") then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)

            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    pcall(function() track:Stop(0) end)
                end
            end
        end)
    end

    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        pcall(function()
            rootPart.CanCollide = false
            rootPart.Anchored = false
            if rootPart:IsA("BasePart") then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, -3, 0)
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end

    for _, motor in ipairs(char:GetDescendants()) do
        if motor:IsA("Motor6D") then
            local part0 = motor.Part0
            local part1 = motor.Part1
            if part0 and part1 then
                pcall(function()
                    motor.Enabled = false

                    local att0 = part0:FindFirstChild(motor.Name .. "_RagdollAtt0")
                    if not att0 then
                        att0 = Instance.new("Attachment")
                        att0.Name = motor.Name .. "_RagdollAtt0"
                        att0.CFrame = motor.C0
                        att0.Parent = part0
                    end

                    local att1 = part1:FindFirstChild(motor.Name .. "_RagdollAtt1")
                    if not att1 then
                        att1 = Instance.new("Attachment")
                        att1.Name = motor.Name .. "_RagdollAtt1"
                        att1.CFrame = motor.C1
                        att1.Parent = part1
                    end

                    local bsc = part1:FindFirstChild(motor.Name .. "_RagdollBSC")
                    if not bsc then
                        bsc = Instance.new("BallSocketConstraint")
                        bsc.Name = motor.Name .. "_RagdollBSC"
                        bsc.Attachment0 = att0
                        bsc.Attachment1 = att1
                        bsc.LimitsEnabled = true
                        bsc.UpperAngle = 60
                        bsc.TwistLimitsEnabled = true
                        bsc.TwistLowerAngle = -45
                        bsc.TwistUpperAngle = 45
                        bsc.Parent = part1
                    end

                    local ncc = part1:FindFirstChild(motor.Name .. "_RagdollNCC")
                    if not ncc then
                        ncc = Instance.new("NoCollisionConstraint")
                        ncc.Name = motor.Name .. "_RagdollNCC"
                        ncc.Part0 = part0
                        ncc.Part1 = part1
                        ncc.Parent = part1
                    end
                end)
            end
        end
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            pcall(function()
                part.CanCollide = true
                part.Anchored = false
                part.Velocity = Vector3.new(0, -3, 0)
                part.RotVelocity = Vector3.zero
                if part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.new(0, -3, 0)
                    part.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end
    end
end

local function Ragdoll(Character)
	pcall(function()
		if not Character then return end
		local humanoid = Character:FindFirstChildOfClass("Humanoid")
		local rootPart = Character:FindFirstChild("HumanoidRootPart")
		local torso = Character:FindFirstChild("LowerTorso") or Character:FindFirstChild("Torso")
		if not (humanoid and rootPart and torso) then return end

		if not torso:FindFirstChild("Airshot") then
			local BodyVelocity = Instance.new('BodyVelocity')
			BodyVelocity.Name = 'Airshot'
			BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			
			-- Increased backward push (-35) and upward launch (25)
			BodyVelocity.Velocity = rootPart.CFrame.LookVector * -35 + Vector3.new(0, 25, 0)
			BodyVelocity.Parent = torso

			-- Increased duration slightly so the force applies long enough
			game:GetService("Debris"):AddItem(BodyVelocity, 0.4)
		end
	end)
end

local handleEliminatedTarget
do
    config.autoFarmRagdollHold = config.autoFarmRagdollHold or {}
    local ragdollHoldConnection = nil

    local function zeroVelocities(char)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.zero
                    part.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end
    end

    -- Lying-on-the-ground CFrame a few studs in front of the local player
    local function getDropCFrame(targetChar)
        local localChar = localPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return nil end

        local look = localRoot.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude < 0.01 then
            flatLook = Vector3.new(0, 0, -1)
        end
        flatLook = flatLook.Unit

        local spot = localRoot.Position + flatLook * (config.autoFarmRagdollDistance or 5)

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { targetChar, localChar }
        local result = Workspace:Raycast(spot + Vector3.new(0, 6, 0), Vector3.new(0, -60, 0), params)

        local groundY = result and result.Position.Y or (localRoot.Position.Y - 2.5)
        local pos = Vector3.new(spot.X, groundY + 1.1, spot.Z)

        -- face the local player, then lay the body on its back (feet toward you)
        return CFrame.lookAt(pos, pos - flatLook) * CFrame.Angles(math.rad(90), 0, 0)
    end

    local function charHasMotors(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("Motor6D") then return true end
        end
        return false
    end

    local function gameAlreadyRagdolled(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("Motor6D") and not d.Enabled then return true end
        end
        return false
    end

    local function startHold(targetChar, dropCF)
        config.autoFarmRagdollHold[targetChar] = {
            cf = dropCF,
            started = tick(),
            ragdolled = false,
        }

        if ragdollHoldConnection then return end

        ragdollHoldConnection = RunService.Heartbeat:Connect(function()
            local now = tick()
            local holdTime = config.autoFarmRagdollHoldTime or 3
            local active = false

            for char, data in pairs(config.autoFarmRagdollHold) do
                local elapsed = now - data.started
                if elapsed > holdTime or not char.Parent then
                    config.autoFarmRagdollHold[char] = nil
                else
                    active = true
                    local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart

                    if root then
                        if elapsed < 0.35 then
                            -- pin the body in front of you while it settles into the pose
                            pcall(function() char:PivotTo(data.cf) end)
                            zeroVelocities(char)
                        elseif (root.Position - data.cf.Position).Magnitude > 6 then
                            -- something yanked it away (ownership / server snap-back): put it back
                            pcall(function() char:PivotTo(data.cf) end)
                            zeroVelocities(char)
                        end
                    end

                    -- if the game didn't ragdoll the character itself, do it locally
                    if not data.ragdolled and elapsed > 0.2 then
                        data.ragdolled = true
                        if charHasMotors(char) and not gameAlreadyRagdolled(char) then
                            pcall(ragdollModel, char)
                        end
                    end
                end
            end

            if not active then
                ragdollHoldConnection:Disconnect()
                ragdollHoldConnection = nil
            end
        end)
    end

    handleEliminatedTarget = function(target)
        local targetChar = getTargetCharacter(target)
        if not targetChar then
            config.autoFarmOriginalPositions[target] = nil
            return
        end

        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")

        -- make sure the body is solid and free to move
        for _, part in ipairs(targetChar:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = true
                    part.Anchored = false
                end)
            end
        end
        zeroVelocities(targetChar)

        if humanoid then
            pcall(function()
                humanoid.PlatformStand = true
            end)
        end

        -- drop the whole body (not just the root) on the ground in front of the player and hold it there
        local dropCF = getDropCFrame(targetChar)
        if dropCF then
            pcall(function() targetChar:PivotTo(dropCF) end)
            startHold(targetChar, dropCF)
        end

        config.autoFarmOriginalPositions[target] = nil
    end
end

local function getValidAutoFarmTargets()
    local validTargets = {}
    
    local candidates = getAllTargets()
    for _, t in ipairs(candidates) do
        if t ~= localPlayer and plralive(t) then
            local shouldTarget = false
            if config.masterTarget == "NPCs" then
                if typeof(t) == "Instance" and t:IsA("Model") then
                    shouldTarget = true
                else
                    shouldTarget = false
                end
            elseif config.masterTarget == "Players" then
                if typeof(t) == "Instance" and t:IsA("Player") then
                    if not isTeammate(t) or config.masterTeamTarget == "All" then
                        shouldTarget = true
                    else
                        shouldTarget = false
                    end
                else
                    shouldTarget = false
                end
            elseif config.masterTarget == "Both" then
                shouldTarget = true
            end

            if shouldTarget then
                local humanoid = nil
                local char = getTargetCharacter(t)
                if char then
                    humanoid = char:FindFirstChildOfClass("Humanoid")
                end
                if humanoid and humanoid.Health > 0 then
                    if not config.autoFarmCompleted[t] then
                        table.insert(validTargets, t)
                    end
                end
            end
        end
    end

    table.sort(validTargets, function(a, b)
        local charA = getTargetCharacter(a)
        local charB = getTargetCharacter(b)
        local rootA = charA and (charA:FindFirstChild("HumanoidRootPart") or charA:FindFirstChild("Head"))
        local rootB = charB and (charB:FindFirstChild("HumanoidRootPart") or charB:FindFirstChild("Head"))
        local localRoot = localPlayer.Character and (localPlayer.Character:FindFirstChild("HumanoidRootPart") or localPlayer.Character:FindFirstChild("Head"))
        
        if not localRoot then return false end
        if not rootA then return false end
        if not rootB then return true end
        
        local distA = (localRoot.Position - rootA.Position).Magnitude
        local distB = (localRoot.Position - rootB.Position).Magnitude
        
        return distA < distB
    end)
    
    return validTargets
end

local function tptocross(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character or not camera then 
        return false 
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetRoot then return false end
    local targetPart = nil
    if config.autoFarmTargetPart == "Head" and targetHead then
        targetPart = targetHead
    else
        targetPart = targetRoot
    end
    
    if not targetPart then return false end
    local cameraPos = camera.CFrame.Position
    local cameraLook = camera.CFrame.LookVector
    local crosshairWorldPos = cameraPos + (cameraLook * config.autoFarmDistance)
    crosshairWorldPos = crosshairWorldPos + Vector3.new(0, config.autoFarmVerticalOffset, 0)
    local partOffset = targetPart.Position - targetRoot.Position
    local newRootPosition = crosshairWorldPos - partOffset
    pcall(function()
        targetRoot.CanCollide = false
        if targetRoot:IsA("BasePart") then
            targetRoot.AssemblyLinearVelocity = Vector3.zero
            targetRoot.AssemblyAngularVelocity = Vector3.zero
        end
        targetRoot.Velocity = Vector3.zero
        targetRoot.RotVelocity = Vector3.zero
        targetRoot.CFrame = CFrame.new(newRootPosition)
        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(cameraPos)
        end
    end)
    
    return true
end

local function tptocrossExact(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character or not camera then 
        return false 
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetRoot then return false end
    
    local targetPart = nil
    if config.autoFarmTargetPart == "Head" and targetHead then
        targetPart = targetHead
    else
        targetPart = targetRoot
    end
    
    if not targetPart then return false end
    
    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local ray = camera:ScreenPointToRay(screenCenter.X, screenCenter.Y)
    local crosshairWorldPos = ray.Origin + (ray.Direction * config.autoFarmDistance)
    crosshairWorldPos = crosshairWorldPos + Vector3.new(0, config.autoFarmVerticalOffset, 0)
    local partOffset = targetPart.Position - targetRoot.Position
    local newRootPosition = crosshairWorldPos - partOffset
    pcall(function()
        targetRoot.CanCollide = false
        if targetRoot:IsA("BasePart") then
            targetRoot.AssemblyLinearVelocity = Vector3.zero
            targetRoot.AssemblyAngularVelocity = Vector3.zero
        end
        targetRoot.Velocity = Vector3.zero
        targetRoot.RotVelocity = Vector3.zero
        targetRoot.CFrame = CFrame.new(newRootPosition)
        
        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local lookAt = CFrame.new(targetRoot.Position, camera.CFrame.Position)
            targetRoot.CFrame = lookAt
        end
    end)
    
    return true
end
local function tptocrossWithAlignment(target, sideOffset)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character or not camera then 
        return false 
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetRoot then return false end
    
    if not config.autoFarmOriginalPositions[target] then
        saveTargetOriginalPosition(target)
    end

    local cameraCFrame = camera.CFrame
    local forward = cameraCFrame.LookVector
    local right = cameraCFrame.RightVector
    local cameraPos = cameraCFrame.Position
    local targetPos = cameraPos + (forward * config.autoFarmDistance) + (right * (sideOffset or 0))
    targetPos = targetPos + Vector3.new(0, config.autoFarmVerticalOffset, 0)
    local alignPart = nil
    if config.autoFarmTargetPart == "Head" and targetHead then
        alignPart = targetHead
    else
        alignPart = targetRoot
    end
    
    if not alignPart then return false end
    local offsetFromRoot = alignPart.Position - targetRoot.Position
    local newRootPos = targetPos - offsetFromRoot

    pcall(function()
        targetRoot.CanCollide = false
        if targetRoot:IsA("BasePart") then
            targetRoot.AssemblyLinearVelocity = Vector3.zero
            targetRoot.AssemblyAngularVelocity = Vector3.zero
        end
        targetRoot.Velocity = Vector3.zero
        targetRoot.RotVelocity = Vector3.zero
        local directionToCamera = (cameraPos - newRootPos).Unit
        local lookAt = CFrame.new(newRootPos, newRootPos + directionToCamera)
        targetRoot.CFrame = lookAt
    end)
    
    return true
end


local function checkTargetHealth(target)
    return plralive(target)
end
local function autoFarmProcess()
    if config.autoFarmLoop then
        config.autoFarmLoop:Disconnect()
        config.autoFarmLoop = nil
    end
    
    config.autoFarmGroup = config.autoFarmGroup or {}
    
    config.autoFarmLoop = RunService.Heartbeat:Connect(function()
        if not config.autoFarmEnabled or not localPlayer.Character or not camera then
            if config.autoFarmLoop then
                config.autoFarmLoop:Disconnect()
                config.autoFarmLoop = nil
            end
            return
        end

        local group = config.autoFarmGroup
        local groupSize = math.max(1, math.floor(tonumber(config.autoFarmGroupSize) or 3))

        -- 1. Remove group members that were eliminated, knocked down, or left
        for i = #group, 1, -1 do
            local member = group[i]
            local memberChar = getTargetCharacter(member)
            if not memberChar or not checkTargetHealth(member) then
                if config.autoFarmRagdoll then
                    handleEliminatedTarget(member)
                else
                    restoreTargetOriginalPosition(member)
                end
                config.autoFarmCompleted[member] = true
                table.remove(group, i)
            end
        end

        -- 2. Refill the group up to groupSize (or as many valid players as exist)
        if #group < groupSize then
            local validTargets = getValidAutoFarmTargets()
            local inGroup = {}
            for _, m in ipairs(group) do inGroup[m] = true end

            local added = false
            for _, t in ipairs(validTargets) do
                if #group >= groupSize then break end
                if not inGroup[t] then
                    table.insert(group, t)
                    inGroup[t] = true
                    added = true
                end
            end

            if #group == 0 and not added and #validTargets == 0 then
                config.autoFarmCompleted = {}
                config.autoFarmIndex = 1
            end
        end

        -- Keep the first member as the "current target" for the rest of the script (partclaim, etc.)
        config.currentAutoFarmTarget = group[1]

        -- 3. Stand everyone side by side in front of the camera
        local count = #group
        for i, member in ipairs(group) do
            if getTargetCharacter(member) then
                if not config.autoFarmOriginalPositions[member] then
                    saveTargetOriginalPosition(member)
                end

                local sideOffset = (i - (count + 1) / 2) * (config.autoFarmSpacing or 4)
                local success = tptocrossWithAlignment(member, sideOffset)
                if not success and teleportTargetToLocalPlayerFront then
                    teleportTargetToLocalPlayerFront(member)
                end
            end
        end
    end)
end

local function stopAutoFarm()
    if config.autoFarmLoop then
        config.autoFarmLoop:Disconnect()
        config.autoFarmLoop = nil
    end
    
    for target, _ in pairs(config.autoFarmOriginalPositions) do
        if target and getTargetCharacter(target) and plralive(target) then
            restoreTargetOriginalPosition(target)
        end
    end
    
    config.autoFarmGroup = {}
    config.currentAutoFarmTarget = nil
    config.autoFarmIndex = 1
    config.autoFarmCompleted = {}
    config.autoFarmOriginalPositions = {}
    config.autoFarmEnabled = false
    
    pcall(function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.ReplicationFocus = localPlayer.Character.HumanoidRootPart
        end
    end)
end

local function teleportTargetToLocalPlayerFront(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character then 
        return false 
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then return false end
    
    local localCFrame = localRoot.CFrame
    local frontOffset = localCFrame.LookVector * config.autoFarmDistance
    local frontPos = localRoot.Position + frontOffset
    frontPos = Vector3.new(frontPos.X, targetRoot.Position.Y, frontPos.Z)
    
    pcall(function()
        targetRoot.CanCollide = false
        if targetRoot:IsA("BasePart") then
            targetRoot.AssemblyLinearVelocity = Vector3.zero
            targetRoot.AssemblyAngularVelocity = Vector3.zero
        end
        targetRoot.Velocity = Vector3.zero
        targetRoot.RotVelocity = Vector3.zero
        targetRoot.CFrame = CFrame.new(frontPos, localRoot.Position)
    end)
    
    return true
end

local function raycastFromPlayer(player)
    if not player or not player.Character then return false end
    local character = player.Character
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    local lookVector = head.CFrame.LookVector
    local rayOrigin = head.Position
    local rayDirection = lookVector * 1000
    local ray = Ray.new(rayOrigin, rayDirection)
    
    local ignoreList = {character}
    
    local hit, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
        local hitParent = hit.Parent
        if hitParent and hitParent:IsA("Model") then
            local hitPlayer = Players:GetPlayerFromCharacter(hitParent)
            if hitPlayer == localPlayer then
                return true, position, lookVector
            end
        end
    end
    
    return false, nil, nil
end

local function teleportLocalPlayer(direction, distance)
    if not localPlayer.Character then return end
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local currentPos = humanoidRootPart.Position
    local newPos = currentPos + (direction * distance)
    
    if not config.originalPosition then
        config.originalPosition = currentPos
    end
    
    pcall(function()
        humanoidRootPart.CFrame = CFrame.new(newPos)
    end)
    
    config.isTeleported = true
end

local function returnToOriginalPosition()
    if not config.originalPosition or not localPlayer.Character then return end
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    pcall(function()
        humanoidRootPart.CFrame = CFrame.new(config.originalPosition)
    end)
    
    config.originalPosition = nil
    config.isTeleported = false
    config.currentAntiAimTarget = nil
end

local function teleportAboveTarget(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then return end
    
    local targetPos = targetRoot.Position
    local abovePos = targetPos + Vector3.new(0, config.antiAimAboveHeight, 0)
    
    if not config.originalPosition then
        config.originalPosition = localRoot.Position
    end
    
    pcall(function()
        localRoot.CFrame = CFrame.new(abovePos)
    end)
    
    config.currentAntiAimTarget = target
    config.isTeleported = true
end

local function teleportBehindTarget(target)
    local targetChar = getTargetCharacter(target)
    if not targetChar or not localPlayer.Character then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then return end
    
    local targetCFrame = targetRoot.CFrame
    local behindOffset = -targetCFrame.LookVector * config.antiAimBehindDistance
    local behindPos = targetRoot.Position + behindOffset
    
    if not config.originalPosition then
        config.originalPosition = localRoot.Position
    end
    
    pcall(function()
        localRoot.CFrame = CFrame.new(behindPos)
    end)
    
    config.currentAntiAimTarget = target
    config.isTeleported = true
end


local function findClosestEnemy()
    if not localPlayer.Character then return nil end
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    
    local best = nil
    local bestMetric = nil
    local mode = config.antiAimGetTarget or config.masterGetTarget or "Closest"

    for _, t in ipairs(getAllTargets()) do
        if t ~= localPlayer and plralive(t) then
            local shouldTarget = false
            if config.masterTarget == "NPCs" then
                if typeof(t) == "Instance" and t:IsA("Model") then
                    shouldTarget = true
                end
            elseif config.masterTarget == "Players" then
                if typeof(t) == "Instance" and t:IsA("Player") then
                    if config.targetMode == "Enemies" then
                        shouldTarget = not isTeammate(t)
                    elseif config.targetMode == "Teams" then
                        shouldTarget = isTeammate(t)
                    elseif config.targetMode == "All" then
                        shouldTarget = true
                    end
                end
            elseif config.masterTarget == "Both" then
                if typeof(t) == "Instance" and t:IsA("Player") then
                    if config.targetMode == "Enemies" then
                        shouldTarget = not isTeammate(t)
                    elseif config.targetMode == "Teams" then
                        shouldTarget = isTeammate(t)
                    elseif config.targetMode == "All" then
                        shouldTarget = true
                    end
                else
                    shouldTarget = true
                end
            end
            
            if shouldTarget then
                local tgtChar = getTargetCharacter(t)
                local playerRoot = tgtChar and (tgtChar:FindFirstChild("HumanoidRootPart") or tgtChar:FindFirstChild("Head"))
                local humanoid = tgtChar and tgtChar:FindFirstChildOfClass("Humanoid")
                if playerRoot then
                    local distance = (localRoot.Position - playerRoot.Position).Magnitude
                    if mode == "Closest" then
                        if best == nil or distance < bestMetric then
                            bestMetric = distance
                            best = t
                        end
                    else
                        local healthVal = 1e6
                        if humanoid then
                            healthVal = humanoid.Health
                        end
                        if best == nil or healthVal < bestMetric then
                            bestMetric = healthVal
                            best = t
                        end
                    end
                end
            end
        end
    end
    
    return best
end

local function antiAimUpdate()
    if not config.antiAimEnabled then
        if config.isTeleported then
            returnToOriginalPosition()
        end
        return
    end
    
    if config.antiAimOrbitEnabled then
        local closestEnemy = findClosestEnemy()
        if closestEnemy and getTargetCharacter(closestEnemy) then
            local targetChar = getTargetCharacter(closestEnemy)
            local targetPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
            if targetPart and localPlayer.Character then
                config.currentAntiAimTarget = closestEnemy
                if not config.originalPosition then
                    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot then
                        config.originalPosition = localRoot.Position
                    end
                end
                local tpos = targetPart.Position
                local angle = tick() * (config.antiAimOrbitSpeed or 8)
                local radius = config.antiAimOrbitRadius or 5
                local height = config.antiAimOrbitHeight or 0
                local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
                local newPos = tpos + offset
                pcall(function()
                    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot then
                        localRoot.CFrame = CFrame.new(newPos, tpos)
                    end
                    if camera and targetPart then
                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
                    end
                end)
                config.isTeleported = true
            end
        else
            if config.isTeleported then
                returnToOriginalPosition()
            end
            config.currentAntiAimTarget = nil
        end
        return
    end

    if config.antiAimAbovePlayer then
        local closestEnemy = findClosestEnemy()
        if closestEnemy then
            teleportAboveTarget(closestEnemy)
        end
        return
    end
    
    if config.antiAimBehindPlayer then
        local closestEnemy = findClosestEnemy()
        if closestEnemy then
            teleportBehindTarget(closestEnemy)
        end
        return
    end
    if config.autoFarmEnabled then
        if config.isTeleported then
            returnToOriginalPosition()
        end
        return
    end
    
    if not config.antiAimEnabled then
        if config.isTeleported then
            returnToOriginalPosition()
        end
        return
    end
    if config.raycastAntiAim then
        local wasTargeted = false
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and plralive(player) then
                local isLooking, hitPosition, lookVector = raycastFromPlayer(player)
                if isLooking then
                    wasTargeted = true
                    config.currentAntiAimTarget = player
                    
                    local teleportDirection = Vector3.new(-lookVector.Z, 0, lookVector.X)
                    
                    if math.random(1, 2) == 1 then
                        teleportDirection = -teleportDirection
                    end
                    
                    teleportLocalPlayer(teleportDirection.Unit, config.antiAimTPDistance)
                    break
                end
            end
        end
        
        if not wasTargeted and config.isTeleported then
            returnToOriginalPosition()
        end
    end
end

local function RFD(targetPlayer)
    local char = getTargetCharacter(targetPlayer)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                local ok, t = pcall(function() return child.Texture end)
                local nameLower = tostring(child.Name):lower()
                local texLower = tostring(t or ""):lower()
                if nameLower == "face" or string.find(nameLower, "face") or string.find(texLower, "face") then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
end

local function wallCheck(targetPos, sourcePos)
    if not config.wallc then
        return true
    end

    if (targetPos - sourcePos).Magnitude <= 0 then return true end

    local rayDirection = (targetPos - sourcePos)
    local ray = Ray.new(sourcePos, rayDirection.Unit * rayDirection.Magnitude)
    local ignoreList = {}

    if localPlayer and localPlayer.Character then
        table.insert(ignoreList, localPlayer.Character)
    end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            table.insert(ignoreList, otherPlayer.Character)
        end
    end

    local hit, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    if hit and position then
        local distanceToTarget = (targetPos - sourcePos).Magnitude
        local distanceToHit = (position - sourcePos).Magnitude
        return distanceToHit >= (distanceToTarget - 2)
    end

    return true
end

local function high(targetPlayer)
    if not targetPlayer or not getTargetCharacter(targetPlayer) then return end
    if not addesp(targetPlayer) then return end

    if config.highlightData[targetPlayer] then
        local existing = config.highlightData[targetPlayer]
        if existing then existing.Enabled = not config.streamProof end
        if existing and existing.Parent then
            if targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget then
                existing.FillColor = config.esptargetc
            else
                existing.FillColor = config.espc
            end
            return
        else
            config.highlightData[targetPlayer] = nil
        end
    end

    local character = getTargetCharacter(targetPlayer)
    if not character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Enabled = not config.streamProof
    highlight.FillColor = config.espc
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    local okDepth, _ = pcall(function() highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
    if not okDepth then
    end
    highlight.Parent = character

    if targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget then
        highlight.FillColor = config.esptargetc
    else
        highlight.FillColor = config.espc
    end

    config.highlightData[targetPlayer] = highlight
end

local function removeHighlightESP(targetPlayer)
    if not targetPlayer then return end
    local h = config.highlightData[targetPlayer]
    if h and h.Parent then
        pcall(function() h:Destroy() end)
    end
    config.highlightData[targetPlayer] = nil
end
local function removeESPLabel(targetPlayer)
    if not targetPlayer then return end
    local data = config.espData[targetPlayer]
    if not data then return end
    if data.connection then
        pcall(function() data.connection:Disconnect() end)
        data.connection = nil
    end
    
    if data.screenGui and data.screenGui.Parent then
        pcall(function() data.screenGui:Destroy() end)
    end
    
    config.espData[targetPlayer] = nil
end

local function healthColor(humanoid)
    if not humanoid then return config.espc end
    local maxH = humanoid.MaxHealth or 100
    local health = math.clamp(humanoid.Health / maxH, 0, 1)
    local r = 1 - health
    local g = health
    return Color3.new(r, g, 0)
end
local function makeesp(targetPlayer)
    if not targetPlayer then return end
    if not addesp(targetPlayer) then return end
    
    if config.espData[targetPlayer] then
        local oldData = config.espData[targetPlayer]
        if oldData.connection then
            pcall(function() oldData.connection:Disconnect() end)
        end
        if oldData.screenGui and oldData.screenGui.Parent then
            pcall(function() oldData.screenGui:Destroy() end)
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_" .. getTargetName(targetPlayer)
    screenGui.Enabled = not config.streamProof
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    local parent = localPlayer:FindFirstChild("PlayerGui")
    if not parent then
        parent = game:GetService("CoreGui")
    end
    pcall(function() screenGui:Destroy() end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_" .. getTargetName(targetPlayer)
    screenGui.Enabled = not config.streamProof
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.Name = "ESPLabel"
    label.BackgroundTransparency = 1
    label.Text = getTargetName(targetPlayer)
    label.TextSize = 6
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Visible = false
    label.Size = UDim2.new(0, 200, 0, 20)
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = screenGui

    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "ESPBox"
    boxFrame.AnchorPoint = Vector2.new(0, 0)
    boxFrame.Size = UDim2.new(0, 0, 0, 0)
    boxFrame.Position = UDim2.new(0, 0, 0, 0)
    boxFrame.BackgroundTransparency = 0.6
    boxFrame.BorderSizePixel = 0
    boxFrame.Visible = false
    boxFrame.Parent = screenGui

    local boxOutline = Instance.new("UIStroke")
    boxOutline.Thickness = 1
    boxOutline.LineJoinMode = Enum.LineJoinMode.Round
    boxOutline.Color = config.espc
    boxOutline.Transparency = 0.1
    boxOutline.Parent = boxFrame

    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBG"
    healthBg.AnchorPoint = Vector2.new(0, 0)
    healthBg.Size = UDim2.new(0, 4, 0, 0)
    healthBg.Position = UDim2.new(0, 0, 0, 0)
    healthBg.BackgroundTransparency = 0.6
    healthBg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.Parent = screenGui

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.Size = UDim2.new(1, 0, 0, 0)
    healthFill.Position = UDim2.new(0, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg

    local headDot = Instance.new("Frame")
    headDot.Name = "HeadDot"
    headDot.Size = UDim2.new(0, 6, 0, 6)
    headDot.AnchorPoint = Vector2.new(0.5, 0.5)
    headDot.BackgroundColor3 = config.espc
    headDot.BorderSizePixel = 0
    headDot.Visible = false
    headDot.Parent = screenGui

    label.TextColor3 = config.espc
    if targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget then
        label.TextColor3 = config.esptargetc
    end
    local function startUpdater()
        if config.espData[targetPlayer] and config.espData[targetPlayer].connection then
            pcall(function() config.espData[targetPlayer].connection:Disconnect() end)
        end
        
        local conn = RunService.RenderStepped:Connect(function()
            local tchar = getTargetCharacter(targetPlayer)
            if screenGui then screenGui.Enabled = not config.streamProof end
            local charExists = tchar and tchar.Parent
            
            if not charExists then
                if label then label.Visible = false end
                if boxFrame then boxFrame.Visible = false end
                if healthBg then healthBg.Visible = false end
                if headDot then headDot.Visible = false end
                return
            end

            if not addesp(targetPlayer) then
                label.Visible = false
                boxFrame.Visible = false
                healthBg.Visible = false
                headDot.Visible = false
                return
            end

            local head = tchar:FindFirstChild("Head")
            local root = tchar:FindFirstChild("HumanoidRootPart") or tchar:FindFirstChild("Torso") or tchar:FindFirstChild("UpperTorso")
            if not head or not root then
                label.Visible = false
                boxFrame.Visible = false
                healthBg.Visible = false
                headDot.Visible = false
                return
            end

            local topPos = head.Position + Vector3.new(0, 0.4, 0)
            local bottomPos = root.Position - Vector3.new(0, 1.0, 0)
            local midPos = (topPos + bottomPos) * 0.5
            local topV3, onTop = camera:WorldToViewportPoint(topPos)
            local bottomV3, onBottom = camera:WorldToViewportPoint(bottomPos)
            local midV3, onMid = camera:WorldToViewportPoint(midPos)
            local onScreen = onTop and onBottom and onMid and topV3.Z > 0 and bottomV3.Z > 0 and midV3.Z > 0
            local topScreenY = topV3.Y
            local bottomScreenY = bottomV3.Y
            local centerX = midV3.X
            local heightPx = math.abs(bottomScreenY - topScreenY)
            if heightPx <= 2 then heightPx = 2 end
            local widthPx = math.clamp(heightPx * 0.45, 4, 400)

            local humanoid = tchar:FindFirstChildOfClass("Humanoid")
            local hpRatio = 1
            if humanoid then
                local maxH = humanoid.MaxHealth or 100
                if maxH > 0 then
                    hpRatio = math.clamp(humanoid.Health / maxH, 0, 1)
                end
            end

            local hpColor = Color3.new(1,1,1)
            if humanoid then
                hpColor = healthColor(humanoid)
            end

            if config.espMasterEnabled and config.prefTextESP then
                local text = string.format("%s [%d]", getTargetName(targetPlayer), humanoid and math.floor(humanoid.Health) or 0)
                label.Text = text

                local absWidth = 200
                pcall(function()
                    if label.TextBounds and label.TextBounds.X and label.TextBounds.X > 0 then
                        absWidth = label.TextBounds.X + 8
                    elseif label.AbsoluteSize and label.AbsoluteSize.X and label.AbsoluteSize.X > 0 then
                        absWidth = label.AbsoluteSize.X
                    end
                end)

                label.Size = UDim2.new(0, absWidth, 0, 18)
                label.Position = UDim2.new(0, centerX, 0, topScreenY - 4)
                label.Visible = onScreen
                if config.prefColorByHealth and humanoid then
                    label.TextColor3 = hpColor
                else
                    label.TextColor3 = ((targetPlayer == config.currentTarget) or (targetPlayer == config.aimbotCurrentTarget)) and config.esptargetc or config.espc
                end
            else
                label.Visible = false
            end

            if config.espMasterEnabled and config.prefBoxESP then
                boxFrame.Size = UDim2.new(0, widthPx, 0, math.max(2, heightPx))
                boxFrame.Position = UDim2.new(0, centerX - widthPx / 2, 0, topScreenY)
                boxFrame.Visible = onScreen
                boxFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                boxFrame.BackgroundTransparency = 0.7

                if config.prefColorByHealth and humanoid then
                    boxOutline.Color = hpColor
                else
                    boxOutline.Color = ((targetPlayer == config.currentTarget) or (targetPlayer == config.aimbotCurrentTarget)) and config.esptargetc or config.espc
                end
            else
                boxFrame.Visible = false
            end

            if config.espMasterEnabled and config.prefHealthESP and humanoid then
                healthBg.Size = UDim2.new(0, 4, 0, math.max(2, heightPx))
                healthBg.Position = UDim2.new(0, centerX + widthPx / 2 + 4, 0, topScreenY)
                healthBg.Visible = onScreen
                healthFill.Size = UDim2.new(1, 0, hpRatio, 0)
                healthFill.Position = UDim2.new(0, 0, 1, 0)
                healthFill.BackgroundColor3 = healthColor(humanoid)
            else
                healthBg.Visible = false
            end

            if config.espMasterEnabled and config.prefHeadDotESP and head then
                local headV3, onHead = camera:WorldToViewportPoint(head.Position)
                if onHead and headV3.Z > 0 then
                    headDot.Position = UDim2.new(0, headV3.X, 0, headV3.Y)
                    headDot.Visible = true
                    if config.prefColorByHealth and humanoid then
                        headDot.BackgroundColor3 = hpColor
                    else
                        headDot.BackgroundColor3 = ((targetPlayer == config.currentTarget) or (targetPlayer == config.aimbotCurrentTarget)) and config.esptargetc or config.espc
                    end
                else
                    headDot.Visible = false
                end
            else
                headDot.Visible = false
            end

        end)

        config.espData[targetPlayer] = {
            label = label,
            screenGui = screenGui,
            connection = conn,
            box = boxFrame,
            boxOutline = boxOutline,
            healthBG = healthBg,
            healthFill = healthFill,
            headDot = headDot
        }
    end

    local char = getTargetCharacter(targetPlayer)
    if char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")) then
        startUpdater()
    else
        spawn(function()
            local c = getTargetCharacter(targetPlayer)
            if c then
                local okHead = c:WaitForChild("Head", 2)
                local okRoot = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
                if okHead or okRoot then
                    startUpdater()
                end
            end
        end)
    end
end

local function updateESPColors()
    local toRemove = {}
    for targetPlayer, data in pairs(config.espData) do
        if (not targetPlayer) or (not data) or (not data.label) then
            toRemove[#toRemove+1] = targetPlayer
        else
            if not addesp(targetPlayer) then
                toRemove[#toRemove+1] = targetPlayer
            else
                local tchar = getTargetCharacter(targetPlayer)
                local humanoid = tchar and tchar:FindFirstChildOfClass("Humanoid")
                local hpColor = (humanoid and config.prefColorByHealth) and healthColor(humanoid) or nil

                if data.label then
                    if config.espMasterEnabled and config.prefTextESP then
                        if hpColor then
                            data.label.TextColor3 = hpColor
                        else
                            data.label.TextColor3 = ((targetPlayer == config.currentTarget) or (targetPlayer == config.aimbotCurrentTarget)) and config.esptargetc or config.espc
                        end
                        data.label.Visible = true
                    else
                        data.label.Visible = false
                    end
                end

                if data.box then
                    if config.espMasterEnabled and config.prefBoxESP then
                        data.box.Visible = true
                        if data.boxOutline then
                            data.boxOutline.Color = hpColor or ((targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget) and config.esptargetc or config.espc)
                        end
                    else
                        data.box.Visible = false
                    end
                end

                if data.healthBG then
                    if config.espMasterEnabled and config.prefHealthESP and humanoid then
                        data.healthBG.Visible = true
                        local maxH = humanoid.MaxHealth or 100
                        local hRatio = math.clamp(humanoid.Health / maxH, 0, 1)
                        data.healthFill.Size = UDim2.new(1, 0, hRatio, 0)
                        data.healthFill.BackgroundColor3 = healthColor(humanoid)
                    else
                        data.healthBG.Visible = false
                    end
                end

                if data.headDot then
                    if config.espMasterEnabled and config.prefHeadDotESP then
                        data.headDot.Visible = true
                        if hpColor then
                            data.headDot.BackgroundColor3 = hpColor
                        else
                            data.headDot.BackgroundColor3 = ((targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget) and config.esptargetc or config.espc)
                        end
                    else
                        data.headDot.Visible = false
                    end
                end
            end
        end
    end

    for _, targetPlayer in ipairs(toRemove) do
        config.espData[targetPlayer] = nil
    end

    local toRemoveHighlights = {}
    for targetPlayer, highlight in pairs(config.highlightData) do
        if highlight then pcall(function() highlight.Enabled = not config.streamProof end) end
        if not targetPlayer or not highlight or not highlight.Parent then
            toRemoveHighlights[#toRemoveHighlights+1] = targetPlayer
        else
            if not addesp(targetPlayer) then
                toRemoveHighlights[#toRemoveHighlights+1] = targetPlayer
            else
                if targetPlayer == config.currentTarget or targetPlayer == config.aimbotCurrentTarget then
                    highlight.FillColor = config.esptargetc
                else
                    highlight.FillColor = config.espc
                end
            end
        end
    end

    for _, targetPlayer in ipairs(toRemoveHighlights) do
        config.highlightData[targetPlayer] = nil
    end
end

local function toggleHighlightESP(enabled)
    config.prefHighlightESP = enabled
    config.highlightesp = enabled and config.espMasterEnabled or false

    if config.espMasterEnabled and enabled then
        for _, target in ipairs(getAllTargets()) do
            if addesp(target) and target.Character then
                high(target)
            end
        end
    else
        for targetPlayer, _ in pairs(config.highlightData) do
            removeHighlightESP(targetPlayer)
        end
        config.highlightData = {}
    end
end

local function toggleTextESP(enabled)
    config.prefTextESP = enabled
    config.espEnabled = enabled and config.espMasterEnabled or false

    if config.espMasterEnabled and enabled then
        for _, target in ipairs(getAllTargets()) do
            if addesp(target) then
                makeesp(target)
            end
        end
    else
        for targetPlayer, _ in pairs(config.espData) do
            removeESPLabel(targetPlayer)
        end
        config.espData = {}
    end
end

local function toggleBoxESP(enabled)
    config.prefBoxESP = enabled
    if config.espMasterEnabled then
        for _, target in ipairs(getAllTargets()) do
            if addesp(target) then
                if not config.espData[target] then
                    makeesp(target)
                end
            end
        end
        updateESPColors()
    else
        for targetPlayer, _ in pairs(config.espData) do
            removeESPLabel(targetPlayer)
        end
        config.espData = {}
    end
end

local function toggleHealthESP(enabled)
    config.prefHealthESP = enabled
    if config.espMasterEnabled then
        for _, target in ipairs(getAllTargets()) do
            if addesp(target) then
                if not config.espData[target] then
                    makeesp(target)
                end
            end
        end
        updateESPColors()
    else
    end
end

local function applyESPMaster(state)
    config.espMasterEnabled = state

    if not state then
        for targetPlayer, _ in pairs(config.espData) do
            removeESPLabel(targetPlayer)
        end
        config.espData = {}

        for targetPlayer, _ in pairs(config.highlightData) do
            removeHighlightESP(targetPlayer)
        end
        config.highlightData = {}
        config.espEnabled = false
        config.highlightesp = false
    else
        if config.prefHighlightESP then
            for _, target in ipairs(getAllTargets()) do
                if addesp(target) and target.Character then
                    high(target)
                end
            end
        end
        if config.prefTextESP or config.prefBoxESP or config.prefHealthESP or config.prefHeadDotESP then
            for _, target in ipairs(getAllTargets()) do
                if addesp(target) then
                    makeesp(target)
                end
            end
            config.espEnabled = config.prefTextESP
            config.highlightesp = config.prefHighlightESP
        end
    end

    updateESPColors()
end

local function toggleESP(enabled)
    toggleTextESP(enabled)
end

local function removeAllFaceDecals()
    for _, target in ipairs(getAllTargets()) do
        RFD(target)
    end
end

local function saveOriginalPartInfo(targetPlayer, part)
    if not targetPlayer or not part then return end
    config.originalSizes[targetPlayer] = {
        partName = part.Name or "Head",
        size = part.Size,
    }
end

local function chooseBodyPartInstance(target)
    local char = getTargetCharacter(target)
    if not char then return nil, "Head" end

    local bp = config.bodypart or "Head"

    if bp == "Head" then
        return char:FindFirstChild("Head"), "Head"
    elseif bp == "HumanoidRootPart" then
        return char:FindFirstChild("HumanoidRootPart"), "HumanoidRootPart"
    elseif bp == "Both" then
        local roll = math.random(1, 100)
        local primaryName, secondaryName
        if roll <= 85 then
            primaryName = "HumanoidRootPart"
            secondaryName = "Head"
        else
            primaryName = "Head"
            secondaryName = "HumanoidRootPart"
        end
        local primaryPart = char:FindFirstChild(primaryName)
        if primaryPart then
            return primaryPart, primaryName
        else
            local fallback = char:FindFirstChild(secondaryName)
            return fallback, secondaryName
        end
    else
        local found = char:FindFirstChild(bp) or char:FindFirstChild("Head")
        return found, (found and found.Name) or "Head"
    end
end

local function applySizeToPart(targetPlayer, targetDiameter, chosenPart)
    local char = getTargetCharacter(targetPlayer)
    if not char or targetPlayer == localPlayer then return end
    if not plralive(targetPlayer) then return end

    local part = chosenPart
    local partName = nil
    if not part then
        part, partName = chooseBodyPartInstance(targetPlayer)
    else
        partName = part.Name
    end
    if not part then return end

    if not config.originalSizes[targetPlayer] then
        saveOriginalPartInfo(targetPlayer, part)
    end

    local expansionSize = Vector3.new(
        targetDiameter,
        targetDiameter,
        targetDiameter
    )

    local useExpanded = true
    local chance = math.clamp(tonumber(config.hitchance) or 100, 0, 100)
    if chance <= 0 then
        useExpanded = false
    elseif chance < 100 then
        if math.random(1, 100) <= chance then
            useExpanded = true
        else
            useExpanded = false
        end
    else
        useExpanded = true
    end

    if useExpanded then
        config.targethbSizes[targetPlayer] = expansionSize
    else
        local original = config.originalSizes[targetPlayer]
        if original and original.size then
            config.targethbSizes[targetPlayer] = original.size
        else
            config.targethbSizes[targetPlayer] = Vector3.new(0.05, 0.05, 0.05)
        end
    end

    config.activeApplied[targetPlayer] = true
end

local function restorePartForPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == localPlayer then return end

    local char = getTargetCharacter(targetPlayer)
    local original = config.originalSizes[targetPlayer]
    if not original then
        config.activeApplied[targetPlayer] = nil
        config.targethbSizes[targetPlayer] = nil
        return
    end

    local part = nil
    if char then
        part = char:FindFirstChild(original.partName) or char:FindFirstChild(config.bodypart) or char:FindFirstChild("Head")
    end

    if part and original.size then
        pcall(function()
            part.Size = original.size
            part.Transparency = 1
            part.CanCollide = false
            part.Massless = false
            if part:IsA("BasePart") then
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    config.activeApplied[targetPlayer] = nil
    config.originalSizes[targetPlayer] = nil
    config.targethbSizes[targetPlayer] = nil
    config.centerLocked[targetPlayer] = nil
end

local function tnormalsize(targetPlayer)
    local char = getTargetCharacter(targetPlayer)
    if not char then return end  

    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")

    if torso and not config.hitboxOriginalSizes[targetPlayer] then
        config.hitboxOriginalSizes[targetPlayer] = {
            part = torso,
            size = torso.Size
        }
    end
end
local function expandhb(targetPlayer, size)
    if not targetPlayer then return end
    if targetPlayer == localPlayer then return end
    if not plralive(targetPlayer) then return end  

    local char = getTargetCharacter(targetPlayer)
    if not char then return end
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")  
    if not torso then return end  

    tnormalsize(targetPlayer)
    local expansionSize = Vector3.new(size, size, size)
    config.hitboxLastSize[targetPlayer] = size

    config.hitboxExpandedParts[targetPlayer] = {
        part = torso,
        targetSize = expansionSize
    }
    
    if config.hitboxEnabled then
        pcall(function()
            torso.Size = expansionSize
            torso.Transparency = config.streamProof and 1 or 0.9
            torso.CanCollide = false
            torso.Massless = true
        end)
    end
end

local function restoreTorso(targetPlayer)
    if not targetPlayer then return end  

    local original = config.hitboxOriginalSizes[targetPlayer]
    if original and original.part and original.part.Parent then
        pcall(function()
            original.part.Size = original.size
            original.part.Transparency = 0
            original.part.CanCollide = true
        end)
    end

    config.hitboxExpandedParts[targetPlayer] = nil
    config.hitboxOriginalSizes[targetPlayer] = nil
end

local function updateHitboxes()
    if not config.hitboxEnabled then  
        for player, _ in pairs(config.hitboxExpandedParts) do  
            restoreTorso(player)  
        end  
        return  
    end

    for player, data in pairs(config.hitboxExpandedParts) do
        if not player or not plralive(player) or not getTargetCharacter(player) then
            restoreTorso(player)
        else
            local torso = getTargetCharacter(player):FindFirstChild("Torso") or getTargetCharacter(player):FindFirstChild("UpperTorso")
            if torso and data.targetSize then
                pcall(function()
                    torso.Size = data.targetSize
                    torso.Transparency = config.streamProof and 1 or 0.9
                    torso.CanCollide = false
                    torso.Massless = true
                end)
            end
        end
    end
end

local function targethb(player)
    if not player or player == localPlayer then return false end  
    if not plralive(player) then return false end  

    local mode = config.hitboxTeamTarget or "Enemies"

    if typeof(player) == "Instance" and player:IsA("Model") then
        if mode == "Teams" then
            return false
        end
        return true
    end

    if mode == "Enemies" then
        return not isTeammate(player)
    elseif mode == "Teams" then
        return isTeammate(player)
    elseif mode == "All" then
        return true
    end

    return false
end

local function applyhb()
    if not config.hitboxEnabled then return end  

    for _, target in ipairs(getAllTargets()) do  
        if targethb(target) then
            local size = config.hitboxSize
            config.hitboxLastSize[target] = size
            expandhb(target, size)
        else
            restoreTorso(target)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.3)

        if config.hitboxEnabled and targethb(player) then
            local size = config.hitboxSize
            config.hitboxLastSize[player] = size
            expandhb(player, size)
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(0.3)

        if config.hitboxEnabled and targethb(player) then
            local size = config.hitboxSize
            config.hitboxLastSize[player] = size
            expandhb(player, size)
        end
    end)
end

RunService.Heartbeat:Connect(updateHitboxes)

local function hb()
    for playerObj, targetSize in pairs(config.targethbSizes) do
        if playerObj and playerObj ~= localPlayer and getTargetCharacter(playerObj) and plralive(playerObj) then
            local part = getTargetCharacter(playerObj):FindFirstChild(config.originalSizes[playerObj] and config.originalSizes[playerObj].partName) 
                         or getTargetCharacter(playerObj):FindFirstChild(config.bodypart) 
                         or getTargetCharacter(playerObj):FindFirstChild("Head")
            if not part then
                local p1 = getTargetCharacter(playerObj):FindFirstChild("HumanoidRootPart")
                local p2 = getTargetCharacter(playerObj):FindFirstChild("Head")
                part = p1 or p2
            end

            if part then
                local currentSize = part.Size
                local lerpAlpha = math.clamp(tonumber(config.predic) or 1, 0, 1)
                local newSize = currentSize:Lerp(targetSize, lerpAlpha)

                pcall(function()
                    part.Size = newSize
                    part.Transparency = 1
                    part.CanCollide = false
                    part.Massless = (part.Name ~= "HumanoidRootPart")
                end)
            end
        else
            if playerObj ~= localPlayer then
                restorePartForPlayer(playerObj)
            end
        end
    end
    
    updateHitboxes()
end

local function shouldTargetAimbot(target)
    if not target then return false end
    if target == localPlayer then return false end
    if not plralive(target) then return false end
    
    if typeof(target) == "Instance" and target:IsA("Model") then
        if config.masterTarget == "NPCs" or config.masterTarget == "Both" then
            return true
        else
            return false
        end
    end

    local mode = config.aimbotTeamTarget or "Enemies"
    if mode == "Enemies" then
        return not isTeammate(target)
    elseif mode == "Teams" then
        return isTeammate(target)
    elseif mode == "All" then
        return true
    end
    return false
end


local function aimbotWallCheck(targetPos, sourcePos)
    if not config.aimbotWallCheck then return true end
    
    if (targetPos - sourcePos).Magnitude <= 0 then return true end

    local rayDirection = (targetPos - sourcePos)
    local ray = Ray.new(sourcePos, rayDirection.Unit * rayDirection.Magnitude)
    local ignoreList = {}

    if localPlayer and localPlayer.Character then
        table.insert(ignoreList, localPlayer.Character)
    end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            table.insert(ignoreList, otherPlayer.Character)
        end
    end

    local hit, position = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    if hit and position then
        local distanceToTarget = (targetPos - sourcePos).Magnitude
        local distanceToHit = (position - sourcePos).Magnitude
        return distanceToHit >= (distanceToTarget - 2)
    end

    return true
end

local function getAimbotTargetPart(target)
    if not target then return nil end
    local partName = config.aimbotTargetPart or "Head"
    local char = getTargetCharacter(target)
    if not char then return nil end
    
    if partName == "Head" then
        return char:FindFirstChild("Head")
    elseif partName == "HumanoidRootPart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif partName == "Torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    else
        return char:FindFirstChild("Head")
    end
end

local function smoothAim(currentCFrame, targetCFrame, strength)
    strength = math.clamp(strength or 0.5, 0, 1)
    return currentCFrame:Lerp(targetCFrame, strength)
end
local function aimbotUpdate()
    if not config.aimbotEnabled then
        if config.aimbotCurrentTarget then
            config.aimbotCurrentTarget = nil
            updateESPColors()
        end
        return
    end
    
    if not camera then camera = workspace.CurrentCamera end
    if not camera then return end
    
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local radiusPx = config.aimbot360Enabled and math.huge or config.aimbotFOVSize

    local candidates = {}

    local cameraCFrame = camera.CFrame
    local cameraPos = cameraCFrame.Position

    for _, target in ipairs(getAllTargets()) do
        if shouldTargetAimbot(target) then
            local targetPart = getAimbotTargetPart(target)
            if targetPart then
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                local distPx = (screenVec - center).Magnitude
                if config.aimbot360Enabled or (onScreen and distPx <= radiusPx) then
                    local worldDist = (targetPart.Position - cameraPos).Magnitude
                    if aimbotWallCheck(targetPart.Position, cameraPos) then
                        local humanoid = getTargetCharacter(target) and getTargetCharacter(target):FindFirstChildOfClass("Humanoid")
                        table.insert(candidates, {
                            target = target,
                            part = targetPart,
                            worldDist = worldDist,
                            screenDist = distPx,
                            humanoid = humanoid
                        })
                    end
                end
            end
        end
    end

    local bestCandidate = nil
    local selectionMode = config.aimbotGetTarget or config.masterGetTarget or "Closest"
    if #candidates > 0 then
        if selectionMode == "Lowest Health" then
            local bestHealth = math.huge
            for _, c in ipairs(candidates) do
                local h = math.huge
                if c.humanoid then
                    h = c.humanoid.Health
                end
                if bestCandidate == nil or h < bestHealth then
                    bestHealth = h
                    bestCandidate = c
                end
            end
        else
            local bestDist = math.huge
            for _, c in ipairs(candidates) do
                if c.worldDist < bestDist then
                    bestDist = c.worldDist
                    bestCandidate = c
                end
            end
        end
    end

    local bestTarget = bestCandidate and bestCandidate.target or nil
    local bestPart = bestCandidate and bestCandidate.part or nil

    if config.aimbotCurrentTarget ~= bestTarget then
        config.aimbotCurrentTarget = bestTarget
        updateESPColors()
    end
    
    if bestTarget and bestPart and localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPosition = bestPart.Position
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
            
            local strength = math.clamp(config.aimbotStrength, 0, 1)
            if strength < 1 then
                targetCFrame = smoothAim(currentCFrame, targetCFrame, strength)
            end
            
            camera.CFrame = targetCFrame
        end
    end
end


local function aimbotfov()
    if config.aimbotFOVRing and config.aimbotFOVRing.ScreenGui and config.aimbotFOVRing.ScreenGui.Parent then
        config.aimbotFOVRing.ScreenGui:Destroy()
    end
    if config.aimbotFOVRing and config.aimbotFOVRing.Parent then
        config.aimbotFOVRing:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotFOVRing"
    screenGui.Enabled = not config.streamProof
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    local ringFrame = Instance.new("Frame")
    ringFrame.Name = "RingFrame"
    ringFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ringFrame.Size = UDim2.new(0, config.aimbotFOVSize * 2, 0, config.aimbotFOVSize * 2)
    ringFrame.Position = UDim2.new(0.5, 0, 0.5, -28)
    ringFrame.BackgroundTransparency = 1
    ringFrame.Visible = config.aimbotEnabled
    ringFrame.Parent = screenGui
    
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = ringFrame
    
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Thickness = 1
    ringStroke.LineJoinMode = Enum.LineJoinMode.Round
    ringStroke.Color = Color3.fromRGB(255, 0, 0)
    ringStroke.Transparency = math.clamp(tonumber(config.aimbotFOVTransparency) or 0.3, 0, 1)
    ringStroke.Parent = ringFrame
    
    config.aimbotFOVRing = {
        ScreenGui = screenGui,
        RingFrame = ringFrame,
        RingStroke = ringStroke
    }
    
    return config.aimbotFOVRing
end
local function updateAimbotFOVRing()
    if config.aimbotFOVRing and config.aimbotFOVRing.RingFrame then
        if config.aimbotFOVRing.ScreenGui then
            config.aimbotFOVRing.ScreenGui.Enabled = not config.streamProof
        end
        if config.aimbotFOVRing.RingStroke then
            config.aimbotFOVRing.RingStroke.Transparency = math.clamp(tonumber(config.aimbotFOVTransparency) or 0.3, 0, 1)
        end
        if config.aimbot360Enabled then
            config.aimbotFOVRing.RingFrame.Visible = false
        else
            config.aimbotFOVRing.RingFrame.Size = UDim2.new(0, config.aimbotFOVSize * 2, 0, config.aimbotFOVSize * 2)
            config.aimbotFOVRing.RingFrame.Position = UDim2.new(0.5, 0, 0.5, -28)
            config.aimbotFOVRing.RingFrame.Visible = config.aimbotEnabled
        end
    end
end


local function toggle360Aimbot(state)
    config.aimbot360Enabled = state
    
    if state then
        config.aimbot360OriginalFOV = config.aimbotFOVSize
        if not config.aimbotEnabled then
            config.aimbotEnabled = true
        end
        
        safeNotify({
            Title = "360° Aimbot",
            Content = "Enabled - Targeting in all directions",
            Audio = "rbxassetid://17208361335",
            Length = 2,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(255, 165, 0)
        })
    else
        if config.aimbot360OriginalFOV then
            config.aimbotFOVSize = config.aimbot360OriginalFOV
        end
        
        safeNotify({
            Title = "360° Aimbot",
            Content = "Disabled",
            Audio = "rbxassetid://17208361335",
            Length = 1,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(255, 0, 0)
        })
    end
    
    updateAimbotFOVRing()
end

local function toggleOmnidirectionalAimbot(state)
    config.aimbot360Omnidirectional = state
    
    if state then
        safeNotify({
            Title = "Omnidirectional Aimbot",
            Content = "Enabled - Evenly targets all directions",
            Audio = "rbxassetid://17208361335",
            Length = 2,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(0, 200, 255)
        })
    else
        safeNotify({
            Title = "Omnidirectional Aimbot",
            Content = "Disabled - Prefers front targets",
            Audio = "rbxassetid://17208361335",
            Length = 1,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(200, 200, 200)
        })
    end
end

RunService.Heartbeat:Connect(hb)
RunService.RenderStepped:Connect(aimbotUpdate)
RunService.Heartbeat:Connect(antiAimUpdate)

local function onRenderStep()
    if not camera or not camera.Parent then
        camera = workspace.CurrentCamera
        if not camera then return end
    end

    if not gui.RingHolder or not gui.RingStroke then return end
    if gui.ScreenGui then gui.ScreenGui.Enabled = not config.streamProof end

    if not config.Enabled then
        gui.RingHolder.Visible = false
        return
    else
        gui.RingHolder.Visible = true
    end

    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local radiusPx = config.fovsize

    if gui.RingHolder then
        local currentSize = gui.RingHolder.AbsoluteSize and gui.RingHolder.AbsoluteSize.X or (config.fovsize * 2)
        radiusPx = (not config.streamProof and currentSize > 0) and (currentSize / 2) or config.fovsize
    end

    local candidates = {}

    for _, pl in ipairs(getAllTargets()) do
        local bodyPart, chosenName = chooseBodyPartInstance(pl)
        local humanoid = nil
        local char = getTargetCharacter(pl)
        if char then
            humanoid = char:FindFirstChildOfClass("Humanoid")
        end

        if bodyPart and humanoid and humanoid.Health > 0 then
            local mode = config.targetMode or "Enemies"
            local skip = false
            if mode == "Enemies" then
                if typeof(pl) == "Instance" and pl:IsA("Player") and isTeammate(pl) then
                    skip = true
                end
            elseif mode == "Teams" then
                if typeof(pl) == "Instance" and pl:IsA("Player") and not isTeammate(pl) then
                    skip = true
                end
            elseif mode == "All" then
                skip = false
            end

            if not skip then
                local topPos = bodyPart.Position
                local screenPos3, onScreen = camera:WorldToViewportPoint(topPos)
                if onScreen then
                    local screenVec = Vector2.new(screenPos3.X, screenPos3.Y)
                    local distPx = (screenVec - center).Magnitude
                    if distPx <= radiusPx then
                        local cameraPos = camera.CFrame.Position
                        local targetPos = bodyPart.Position
                        if wallCheck(targetPos, cameraPos) then
                            local worldDist = (cameraPos - targetPos).Magnitude
                            table.insert(candidates, {
                                player = pl,
                                part = bodyPart,
                                partName = chosenName,
                                screenDist = distPx,
                                worldDist = worldDist,
                                screenPos = screenVec,
                                screenPos3 = screenPos3,
                                humanoid = humanoid
                            })
                        end
                    end
                end
            end
        else
            if config.activeApplied[pl] then
                restorePartForPlayer(pl)
            end
        end
    end

    local best = nil
    local selectionMode = config.silentGetTarget or config.masterGetTarget or "Closest"
    if #candidates > 0 then
        if selectionMode == "Lowest Health" then
            local bestHealth = math.huge
            for _, c in ipairs(candidates) do
                local h = c.humanoid and c.humanoid.Health or math.huge
                if best == nil or h < bestHealth then
                    bestHealth = h
                    best = c
                end
            end
        else 
            local bestWorldDist = math.huge
            for _, c in ipairs(candidates) do
                if c.worldDist < bestWorldDist then
                    bestWorldDist = c.worldDist
                    best = c
                end
            end
        end
    end

    if best then
        gui.RingStroke.Color = config.fovct
    else
        gui.RingStroke.Color = config.fovc
    end

    if config.currentTarget ~= (best and best.player) then
        config.currentTarget = best and best.player
        updateESPColors()
    end

    for pl, _ in pairs(config.activeApplied) do
        if (not best) or pl ~= best.player or not plralive(pl) then
            restorePartForPlayer(pl)
        end
    end

    if best and plralive(best.player) then
        local diameter = (function()
            local viewportSize = camera.ViewportSize
            local H = viewportSize.Y
            local vFovDeg = camera.FieldOfView
            local vFovRad = math.rad(vFovDeg)
            local halfVFov = vFovRad / 2
            local alpha = (radiusPx / (H / 2)) * halfVFov
            local worldHalf = best.worldDist * math.tan(alpha)
            local worldFull = worldHalf * 2
            return worldFull
        end)()

        diameter = math.max(0.01, diameter)

        local localChar = localPlayer.Character
        local targetChar = getTargetCharacter(best.player)
        local distance = math.huge

        if localChar and targetChar then
            local localRoot = localChar:FindFirstChild("HumanoidRootPart") or localChar:FindFirstChild("Head")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")

            if localRoot and targetRoot then
                distance = (localRoot.Position - targetRoot.Position).Magnitude
            end
        end

        local studz = 5 
        if distance <= studz then
            diameter = math.max(0.05, math.min(0.1, diameter))
        else
            local ok, pixelRadius = pcall(function()
                local rightWorld = camera.CFrame:VectorToWorldSpace(Vector3.new(1, 0, 0)).Unit
                local upWorld = camera.CFrame:VectorToWorldSpace(Vector3.new(0, 1, 0)).Unit
                local worldHalf = diameter / 2
                --scriptmadebyhmmm5651
                local maxPixel = 0
                local samples = 16
                for i = 0, samples - 1 do
                    local angle = (i / samples) * 2 * math.pi
                    local offsetWorld = rightWorld * math.cos(angle) * worldHalf + upWorld * math.sin(angle) * worldHalf
                    local samplePointWorld = best.part.Position + offsetWorld
                    local sp, onScreenSample = camera:WorldToViewportPoint(samplePointWorld)
                    if onScreenSample then
                        local sampleScreen = Vector2.new(sp.X, sp.Y)
                        local d = (sampleScreen - best.screenPos).Magnitude
                        if d > maxPixel then
                            maxPixel = d
                        end
                    end
                end

                if maxPixel <= 0 then
                    return nil
                end

                return maxPixel
            end)

            if ok and pixelRadius and pixelRadius > 0 then
                local scale = best.screenDist / pixelRadius
                scale = math.clamp(scale, 1 / config.maxExpansion, config.maxExpansion)
                diameter = math.max(0.01, diameter * scale)
            end
        end

        diameter = math.max(0.01, diameter)
        if best.screenDist <= 1 then
            if not config.centerLocked[best.player] then
                config.centerLocked[best.player] = true
                applySizeToPart(best.player, diameter, best.part)
            else
                local prevSize = config.targethbSizes[best.player]
                if prevSize then
                    diameter = prevSize.X
                end
                applySizeToPart(best.player, diameter, best.part)
            end
        else
            config.centerLocked[best.player] = nil
            applySizeToPart(best.player, diameter, best.part)
        end

        if config.rfd then
            RFD(best.player)
        end
    end
end

local function setupDeathListener(targetPlayer)
    local char = getTargetCharacter(targetPlayer)
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if config.characterConnections[targetPlayer] then
        pcall(function() config.characterConnections[targetPlayer]:Disconnect() end)
        config.characterConnections[targetPlayer] = nil
    end

    config.characterConnections[targetPlayer] = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            restorePartForPlayer(targetPlayer)
            restoreTorso(targetPlayer)
            if config.currentTarget == targetPlayer then
                config.currentTarget = nil
                updateESPColors()
            end
            if config.aimbotCurrentTarget == targetPlayer then
                config.aimbotCurrentTarget = nil
                updateESPColors()
            end
        end
    end)
end

local function cleanplrdata(targetPlayer)
    if not targetPlayer then return end

    config.autoFarmOriginalPositions[targetPlayer] = nil
    config.autoFarmCompleted[targetPlayer] = nil
    
    if config.currentAutoFarmTarget == targetPlayer then
        config.currentAutoFarmTarget = nil
    end

    if config.autoFarmGroup then
        for i = #config.autoFarmGroup, 1, -1 do
            if config.autoFarmGroup[i] == targetPlayer then
                table.remove(config.autoFarmGroup, i)
            end
        end
    end

    restorePartForPlayer(targetPlayer)
    restoreTorso(targetPlayer)
    removeESPLabel(targetPlayer)
    removeHighlightESP(targetPlayer)

    if config.playerConnections[targetPlayer] then
        for _, conn in ipairs(config.playerConnections[targetPlayer]) do
            pcall(function() conn:Disconnect() end)
        end
        config.playerConnections[targetPlayer] = nil
    end

    if config.characterConnections[targetPlayer] then
        pcall(function() config.characterConnections[targetPlayer]:Disconnect() end)
        config.characterConnections[targetPlayer] = nil
    end

    config.activeApplied[targetPlayer] = nil
    config.originalSizes[targetPlayer] = nil
    config.targethbSizes[targetPlayer] = nil
    config.hitboxExpandedParts[targetPlayer] = nil
    config.hitboxOriginalSizes[targetPlayer] = nil

    if config.currentTarget == targetPlayer then
        config.currentTarget = nil
        updateESPColors()
    end
    if config.aimbotCurrentTarget == targetPlayer then
        config.aimbotCurrentTarget = nil
        updateESPColors()
    end
end
local function setupPlayerListeners(pl)
    if pl == localPlayer then return end
    if config.playerConnections[pl] then
        for _, conn in ipairs(config.playerConnections[pl]) do
            pcall(function() conn:Disconnect() end)
        end
    end
    
    config.playerConnections[pl] = {}
    
    local function updateESPForPlayer()
        if config.espMasterEnabled then
            removeESPLabel(pl)
            removeHighlightESP(pl)
            
            if config.prefTextESP or config.prefBoxESP or config.prefHealthESP or config.prefHeadDotESP then
                if addesp(pl) then
                    makeesp(pl)
                end
            end
            
            if config.prefHighlightESP and pl.Character then
                if addesp(pl) then
                    high(pl)
                end
            end
        end
    end
    updateESPForPlayer()
    
    local charAddedConn = pl.CharacterAdded:Connect(function(char)
        task.wait(0.25)
        setupDeathListener(pl)
        removeESPLabel(pl)
        removeHighlightESP(pl)
        task.wait(0.1)
        
        if config.espMasterEnabled then
            if config.prefTextESP or config.prefBoxESP or config.prefHealthESP or config.prefHeadDotESP then
                if addesp(pl) then
                    makeesp(pl)
                end
            end
            
            if config.prefHighlightESP then
                if addesp(pl) and pl.Character then
                    high(pl)
                end
            end
        end
    end)
    table.insert(config.playerConnections[pl], charAddedConn)
    
    local charRemovingConn = pl.CharacterRemoving:Connect(function(char)
        if config.espData[pl] then
            local data = config.espData[pl]
            if data.label then data.label.Visible = false end
            if data.box then data.box.Visible = false end
            if data.healthBG then data.healthBG.Visible = false end
            if data.headDot then data.headDot.Visible = false end
        end
        removeHighlightESP(pl)
    end)
    table.insert(config.playerConnections[pl], charRemovingConn)
    
    local teamChangedConn = pl:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.05)
        updateESPForPlayer()
    end)
    table.insert(config.playerConnections[pl], teamChangedConn)
    
    if pl.Character then
        setupDeathListener(pl)
    end
end

local function lrfd()
    if config.looprfd then return end
    config.looprfd = true

    task.spawn(function()
        while config.Enabled do
            removeAllFaceDecals()
            task.wait(0.5)
        end
        config.looprfd = false
    end)
end

local function safeGetCharacter()
    if not localPlayer then return nil end
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    return character, humanoid, rootPart
end

local function TpWalkStart()
    if config._tpwalking then return end
    config._tpwalking = true

    task.spawn(function()
        while config._tpwalking and localPlayer and localPlayer.Character and localPlayer.Character.Parent do
            local character, humanoid, rootPart = safeGetCharacter()
            if not humanoid or humanoid.Health <= 0 or not rootPart then
                task.wait(0.1)
            else
                local delta = RunService.Heartbeat:Wait()
                if humanoid.MoveDirection.Magnitude > 0 then
                    local moveDirection = humanoid.MoveDirection.Unit
                    local velocity = moveDirection * (config.clientCFrameSpeed or 1) * 50
                    pcall(function()
                        rootPart.CFrame = rootPart.CFrame + velocity * delta
                    end)
                end
            end
            task.wait()
        end
        config._tpwalking = false
    end)
end

local function TpWalkStop()
    config._tpwalking = false
end

local _noclipConn
local function startNoclip()
    if _noclipConn then return end
    _noclipConn = RunService.Stepped:Connect(function()
        local char = localPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end
    end)
    config.clientConnections.noclip = _noclipConn
end

local function stopNoclip()
    if _noclipConn then
        pcall(function() _noclipConn:Disconnect() end)
        _noclipConn = nil
        config.clientConnections.noclip = nil
    end
end

local function applyClientWalkSpeed(val)
    local character, humanoid = safeGetCharacter()
    if humanoid then
        if config.clientOriginals.WalkSpeed == nil then
            config.clientOriginals.WalkSpeed = humanoid.WalkSpeed
        end
        pcall(function() humanoid.WalkSpeed = val end)
    end
end

local function applyClientJumpPower(val)
    local character, humanoid = safeGetCharacter()
    if humanoid then
        if config.clientOriginals.JumpPower == nil then
            config.clientOriginals.JumpPower = humanoid.JumpPower or humanoid.JumpHeight or 0
        end
        pcall(function()
            if humanoid.JumpPower ~= nil then
                humanoid.JumpPower = val
            else
                humanoid.JumpHeight = val
            end
        end)
    end
end

local function restoreClientValues()
    local character, humanoid = safeGetCharacter()
    if humanoid then
        if config.clientOriginals.WalkSpeed then
            pcall(function() humanoid.WalkSpeed = config.clientOriginals.WalkSpeed end)
            config.clientOriginals.WalkSpeed = nil
        end
        if config.clientOriginals.JumpPower then
            pcall(function()
                if humanoid.JumpPower ~= nil then
                    humanoid.JumpPower = config.clientOriginals.JumpPower
                else
                    humanoid.JumpHeight = config.clientOriginals.JumpPower
                end
            end)
            config.clientOriginals.JumpPower = nil
        end
    end
    if config.clientCFrameWalkEnabled then
        TpWalkStop()
        config.clientCFrameWalkEnabled = false
    end
    if config.clientNoclip then
        stopNoclip()
        config.clientNoclip = false
    end
end

local function applyClientMaster(state)
    if config.clientMasterEnabled == state then
        return
    end
    config.clientMasterEnabled = state

    if state then
        if config.clientNoclipEnabled then
            startNoclip()
            config.clientNoclip = true
        end
        if config.clientCFrameWalkToggle then
            TpWalkStart()
            config.clientCFrameWalkEnabled = true
        end
        if config.clientWalkEnabled and config.clientWalkSpeed and config.clientWalkSpeed > 0 then
            applyClientWalkSpeed(config.clientWalkSpeed)
        end
        if config.clientJumpEnabled and config.clientJumpPower and config.clientJumpPower > 0 then
            applyClientJumpPower(config.clientJumpPower)
        end
        safeNotify({
            Title = "Client Master",
            Content = "Client features enabled",
            Audio = "rbxassetid://17208361335",
            Length = 1,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(0, 170, 255)
        })
    else
        restoreClientValues()
        safeNotify({
            Title = "Client Master",
            Content = "Client features disabled",
            Audio = "rbxassetid://17208361335",
            Length = 1,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(255, 0, 0)
        })
    end
end

local function makeui()
    lib:SetTitle("dimes.cc")
    lib:SetIcon("http://www.roblox.com/asset/?id=7734056878")
    lib:SetTheme("HighContrast")
    local T0 = lib:CreateTab("Client")
    local T1 = lib:CreateTab("Main")
    local T2 = lib:CreateTab("SilentAim")
    local T3 = lib:CreateTab("Visuals")
    local T4 = lib:CreateTab("Aimbot")
    local T5 = lib:CreateTab("Hitbox")
    local T6 = lib:CreateTab("AntiAim")

    lib:Tab("Visuals")
    lib:AddToggle("Enable ESP (Ctrl+'Z')", function(state)
        applyESPMaster(state)
        if state then
            safeNotify({
                Title = "ESP Master",
                Content = "ESP Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "ESP Master",
                Content = "ESP Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddToggle("Toggle Highlight ESP", function(state)
        toggleHighlightESP(state)
        if state then
            safeNotify({
                Title = "Highlight ESP",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Highlight ESP",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    
    lib:AddToggle("Toggle Text ESP", function(state)
        toggleTextESP(state)
        if state then
            safeNotify({
                Title = "Text ESP",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Text ESP",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddToggle("Toggle Box ESP", function(state)
        toggleBoxESP(state)
        if state then
            safeNotify({
                Title = "Box ESP",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Box ESP",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddToggle("Toggle Health ESP", function(state)
        toggleHealthESP(state)
        if state then
            safeNotify({
                Title = "Health ESP",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Health ESP",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("Toggle Head Dot ESP", function(state)
        config.prefHeadDotESP = state
        if config.espMasterEnabled then
            for _, target in ipairs(getAllTargets()) do
                if addesp(target) then
                    if not config.espData[target] then
                        makeesp(target)
                    end
                end
            end
            updateESPColors()
        end

        if state then
            safeNotify({
                Title = "HeadDot ESP",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 200, 255)
            })
        else
            safeNotify({
                Title = "HeadDot ESP",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("ESP Colour Based On Health", function(state)
        config.prefColorByHealth = state
        updateESPColors()
        if state then
            safeNotify({
                Title = "ESP Color By Health",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 200, 0)
            })
        else
            safeNotify({
                Title = "ESP Color By Health",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(200, 0, 0)
            })
        end
    end, false)
    lib:Tab("AntiAim")
    
    lib:AddToggle("Toggle AntiAim (Ctrl+'L')", function(state)
        config.antiAimEnabled = state
        if not state then
            returnToOriginalPosition()
            safeNotify({
                Title = "AntiAim",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        else
            safeNotify({
                Title = "AntiAim",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 100, 0)
            })
        end
    end, false)
    
    lib:AddToggle("Raycast AntiAim", function(state)
        config.raycastAntiAim = state
        if state then
            config.antiAimAbovePlayer = false
            config.antiAimBehindPlayer = false
            config.antiAimOrbitEnabled = false
            safeNotify({
                Title = "Raycast AntiAim",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Raycast AntiAim",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("Above Player", function(state)
        config.antiAimAbovePlayer = state
        if state then
            config.raycastAntiAim = false
            config.antiAimBehindPlayer = false
            config.antiAimOrbitEnabled = false
            safeNotify({
                Title = "Above Player",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            returnToOriginalPosition()
            safeNotify({
                Title = "Above Player",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("Behind Player", function(state)
        config.antiAimBehindPlayer = state
        if state then
            config.raycastAntiAim = false
            config.antiAimAbovePlayer = false
            config.antiAimOrbitEnabled = false
            safeNotify({
                Title = "Behind Player",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            returnToOriginalPosition()
            safeNotify({
                Title = "Behind Player",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddToggle("Orbit Players", function(state)
        config.antiAimOrbitEnabled = state
        if state then
            config.raycastAntiAim = false
            config.antiAimAbovePlayer = false
            config.antiAimBehindPlayer = false
            if not config.antiAimEnabled then
                config.antiAimEnabled = true
            end
            safeNotify({
                Title = "Orbit Players",
                Content = "Enabled - orbiting nearest target",
                Audio = "rbxassetid://17208361335",
                Length = 2,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 200, 255)
            })
        else
            returnToOriginalPosition()
            safeNotify({
                Title = "Orbit Players",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddComboBox("GetTarget", {"Closest", "Lowest Health"}, function(selection)
        config.antiAimGetTarget = selection
    end)

    lib:AddInputBox("Teleport Distance (Raycast)", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.antiAimTPDistance = n
        end
        return tostring(config.antiAimTPDistance)
    end, "Enter Distance...", "3", {
        min = 1,
        max = math.huge,
        isNumber = true
    })
    lib:AddInputBox("Above Height (Above Player)", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.antiAimAboveHeight = n
        end
        return tostring(config.antiAimAboveHeight)
    end, "Enter Height...", "10", {
        min = 1,
        max = math.huge,
        isNumber = true
    })
    
    lib:AddInputBox("Behind Distance (Behind Player)", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.antiAimBehindDistance = n
        end
        return tostring(config.antiAimBehindDistance)
    end, "Enter Distance...", "5", {
        min = 1,
        max = math.huge,
        isNumber = true
    })

    lib:AddInputBox("Orbit Speed (Orbit)", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.antiAimOrbitSpeed = n
        end
        return tostring(config.antiAimOrbitSpeed)
    end, "Angular speed multiplier", tostring(config.antiAimOrbitSpeed), {
        min = 1,
        max = math.huge,
        isNumber = true
    })

    lib:AddInputBox("Orbit Radius (Orbit)", function(text)
        local n = tonumber(text)
        if n and n >= 0 then
            config.antiAimOrbitRadius = n
        end
        return tostring(config.antiAimOrbitRadius)
    end, "Distance from target", tostring(config.antiAimOrbitRadius), {
        min = 0,
        max = math.huge,
        isNumber = true
    })

    lib:AddInputBox("Orbit Height (Orbit)", function(text)
        local n = tonumber(text)
        if n then
            config.antiAimOrbitHeight = n
        end
        return tostring(config.antiAimOrbitHeight)
    end, "Vertical offset", tostring(config.antiAimOrbitHeight), {
        min = -9999,
        max = 9999,
        isNumber = true
    })

    lib:Tab("Aimbot")
    lib:AddToggle("Toggle Aimbot ('Q')", function(state)
        config.aimbotEnabled = state
        if not state and config.aimbot360Enabled then
            toggle360Aimbot(false)
        end
        
        if config.aimbotFOVRing and config.aimbotFOVRing.RingFrame then
        if config.aimbotFOVRing.ScreenGui then
            config.aimbotFOVRing.ScreenGui.Enabled = not config.streamProof
        end
            config.aimbotFOVRing.RingFrame.Visible = state
            updateAimbotFOVRing()
        end
        
        if state then
            if not config.aimbotFOVRing then
                aimbotfov()
            end
            safeNotify({
                Title = "Aimbot",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 255, 0)
            })
        else
            config.aimbotCurrentTarget = nil
            updateESPColors()
            safeNotify({
                Title = "Aimbot",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("WallCheck AB (Ctrl+'B')", function(state)
        config.aimbotWallCheck = state
        if state then
            safeNotify({
                Title = "Aimbot Wall Check",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Aimbot Wall Check",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddToggle("360° Aimbot", function(state)
        toggle360Aimbot(state)
    end, false)
    lib:AddComboBox("Team Target", {"Enemies", "Teams", "All"}, function(selection)
        if config.masterTeamTarget == "All" then
            return
        end
        
        config.aimbotTeamTarget = selection
        config.aimbotCurrentTarget = nil
        updateESPColors()
        if config.aimbotTeamTarget == "All" then
            config.masterTeamTarget = "All"
            updateTeamTargetModes()
        end
    end)
    
    lib:AddComboBox("Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(selection)
        config.aimbotTargetPart = selection
    end)
    
    lib:AddComboBox("GetTarget", {"Closest", "Lowest Health"}, function(selection)
        config.aimbotGetTarget = selection
    end)
    
    lib:AddInputBox("Aim Strength", function(text)
        local n = tonumber(text)
        if n and n >= 0 and n <= 1 then
            config.aimbotStrength = n
        end
        return tostring(config.aimbotStrength)
    end, "0-1", "0.5", {
        min = 0,
        max = 1,
        isNumber = true
    })
    
    lib:AddInputBox("FOV Size", function(text)
        local n = tonumber(text)
        if n and n >= 1 then
            config.aimbotFOVSize = n
            updateAimbotFOVRing()
            return tostring(config.aimbotFOVSize)
        end
        return tostring(config.aimbotFOVSize)
    end, "Enter Value...", "100", {
        min = 1,
        max = math.huge,
        isNumber = true
    })
    lib:AddInputBox("FOV Outline", function(text)
        local n = tonumber(text)
        if n and n >= 0 and n <= 1 then
            config.aimbotFOVTransparency = n
            updateAimbotFOVRing()
            return tostring(config.aimbotFOVTransparency)
        end
        return tostring(config.aimbotFOVTransparency)
    end, "0-1", tostring(config.aimbotFOVTransparency), {
        min = 0,
        max = 1,
        isNumber = true
    })

    lib:Tab("Hitbox")
    lib:AddToggle("Toggle Hitbox (Ctrl+'G')", function(state)
        config.hitboxEnabled = state
        if state then
            applyhb()
            safeNotify({
                Title = "Hitbox Expander",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 255, 0)
            })
        else
            for player, _ in pairs(config.hitboxExpandedParts) do
                restoreTorso(player)
            end
            safeNotify({
                Title = "Hitbox Expander",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)
    lib:AddComboBox("Team Target", {"Enemies", "Teams", "All"}, function(selection)
        if config.masterTeamTarget == "All" then
            return
        end
        
        config.hitboxTeamTarget = selection
        applyhb()
        
        if config.hitboxTeamTarget == "All" then
            config.masterTeamTarget = "All"
            updateTeamTargetModes()
        end
    end)
    lib:AddInputBox("Hitbox Size", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.hitboxSize = n
            if config.hitboxEnabled then
                for player, data in pairs(config.hitboxExpandedParts) do
                    if player and targethb(player) and data and data.part and data.part.Parent then
                        local newSize = Vector3.new(n, n, n)
                        data.targetSize = newSize
                        config.hitboxLastSize[player] = n
                        pcall(function()
                            data.part.Size = newSize
                        end)
                    end
                end
            end
        end
        return tostring(config.hitboxSize)
    end, "Enter Size...", "10", {
        min = 1,
        max = math.huge,
        isNumber = true
    })
    
    lib:Tab("SilentAim")
    lib:AddToggle("Toggle SilentAim (Ctrl+'E')", function(state)
        config.Enabled = state

        if not config.Enabled then
            if gui.RingHolder then
                gui.RingHolder.Visible = false
            end
            for pl, _ in pairs(config.activeApplied) do
                restorePartForPlayer(pl)
            end
            safeNotify({
                Title = "SilentAim",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        else
            safeNotify({
                Title = "SilentAim",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://255",
                BarColor = Color3.fromRGB(255, 100, 0)
            })
            if gui.RingHolder then
                gui.RingHolder.Visible = true
            end
            lrfd()
        end
    end, false)
    
    lib:AddToggle("WallCheck SA (B)", function(state)
        config.wallc = state
        if state then
            safeNotify({
                Title = "Wall Check",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(0, 170, 255)
            })
        else
            safeNotify({
                Title = "Wall Check",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddComboBox("Team Target", {"Enemies", "Teams", "All"}, function(selection)
        if config.masterTeamTarget == "All" then
            return
        end
        
        if selection == "Enemies" then
            config.targetMode = "Enemies"
        elseif selection == "Teams" then
            config.targetMode = "Teams"
        elseif selection == "All" then
            config.targetMode = "All"
        else
            config.targetMode = "Enemies"
        end
        
        if config.targetMode == "All" then
            config.masterTeamTarget = "All"
            updateTeamTargetModes()
        end
    end)

    lib:AddComboBox("Target Part", {"Head", "HumanoidRootPart", "Both"}, function(selection)
        for pl, _ in pairs(config.activeApplied) do
            restorePartForPlayer(pl)
        end
        if selection == "Head" then
            config.bodypart = "Head"
        elseif selection == "HumanoidRootPart" then
            config.bodypart = "HumanoidRootPart"
        elseif selection == "Both" then
            config.bodypart = "Both"
        else
            config.bodypart = "Head"
        end
    end)
    
    lib:AddComboBox("GetTarget", {"Closest", "Lowest Health"}, function(selection)
        config.silentGetTarget = selection
    end)
    
    lib:AddInputBox("HitChance", function(text)
        local n = tonumber(text)
        if n and n >= 0 and n <= 100 then
            config.hitchance = n
        end
        return tostring(config.hitchance)
    end, "0-100", tostring(config.hitchance), {
        min = 0,
        max = 100,
        isNumber = true
    })
    
    lib:AddInputBox("FovSize", function(text)
        local n = tonumber(text)
        if n and n >= 1 then
            config.fovsize = n
            if gui.RingHolder then
                gui.RingHolder.Size = UDim2.new(0, math.max(8, config.fovsize * 2), 0, math.max(8, config.fovsize * 2))
            end
            return tostring(config.fovsize)
        else
            return tostring(config.fovsize)
        end
    end, "Enter Value...", tostring(config.fovsize), {
        min = 0,
        max = math.huge,
        isNumber = true
    })

    lib:Tab("Client")
    lib:AddToggle("Enable Client Configuration (Ctrl+'V')", function(state)
        applyClientMaster(state)
    end, false)
    lib:AddToggle("Noclip", function(state)
        config.clientNoclipEnabled = state
        if config.clientMasterEnabled then
            if state then
                startNoclip()
                config.clientNoclip = true
            else
                stopNoclip()
                config.clientNoclip = false
            end
        else
            stopNoclip()
            config.clientNoclip = false
        end
    end, false)

    lib:AddToggle("Enable WalkSpeed", function(state)
        config.clientWalkEnabled = state
        if config.clientMasterEnabled then
            if state then
                applyClientWalkSpeed(config.clientWalkSpeed or 16)
            else
                if config.clientOriginals.WalkSpeed then
                    local _, humanoid = safeGetCharacter()
                    pcall(function() humanoid.WalkSpeed = config.clientOriginals.WalkSpeed end)
                    config.clientOriginals.WalkSpeed = nil
                end
            end
        end
    end, false)

    lib:AddToggle("Enable JumpPower", function(state)
        config.clientJumpEnabled = state
        if config.clientMasterEnabled then
            if state then
                applyClientJumpPower(config.clientJumpPower or 50)
            else
                if config.clientOriginals.JumpPower then
                    local _, humanoid = safeGetCharacter()
                    pcall(function()
                        if humanoid.JumpPower ~= nil then
                            humanoid.JumpPower = config.clientOriginals.JumpPower
                        else
                            humanoid.JumpHeight = config.clientOriginals.JumpPower
                        end
                    end)
                    config.clientOriginals.JumpPower = nil
                end
            end
        end
    end, false)

    lib:AddToggle("CFrame Walk", function(state)
        config.clientCFrameWalkToggle = state
        if config.clientMasterEnabled then
            if state then
                TpWalkStart()
                config.clientCFrameWalkEnabled = true
            else
                TpWalkStop()
                config.clientCFrameWalkEnabled = false
            end
        else
            TpWalkStop()
            config.clientCFrameWalkEnabled = false
        end
    end, false)
    lib:AddInputBox("WalkSpeed Value", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.clientWalkSpeed = n
            if config.clientMasterEnabled and config.clientWalkEnabled then
                applyClientWalkSpeed(n)
            end
        end
        return tostring(config.clientWalkSpeed)
    end, "Enter WalkSpeed...", tostring(config.clientWalkSpeed), {
        min = 1,
        max = math.huge,
        isNumber = true
    })

    lib:AddInputBox("JumpPower Value", function(text)
        local n = tonumber(text)
        if n and n >= 0 then
            config.clientJumpPower = n
            if config.clientMasterEnabled and config.clientJumpEnabled then
                applyClientJumpPower(n)
            end
        end
        return tostring(config.clientJumpPower)
    end, "Enter JumpPower...", tostring(config.clientJumpPower), {
        min = 0,
        max = math.huge,
        isNumber = true
    })

    lib:AddInputBox("CFrame Walk Speed", function(text)
        local n = tonumber(text)
        if n and n > 0 then
            config.clientCFrameSpeed = n
        end
        return tostring(config.clientCFrameSpeed)
    end, "Enter Speed...", tostring(config.clientCFrameSpeed), {
        min = 1,
        max = math.huge,
        isNumber = true
    })

    lib:Tab("Main")

    lib:AddToggle("Toggle AutoFarm ('V')", function(state)
        config.autoFarmEnabled = state
        
        if state then
            autoFarmProcess()
            safeNotify({
                Title = "AutoFarm",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 3,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 255, 0)
            })
        else
            stopAutoFarm()
            safeNotify({
                Title = "AutoFarm",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddToggle("FirstPerson Toggle", function(enabled)
        if enabled then
            local camera = workspace.CurrentCamera
            camera.CameraType = Enum.CameraType.Custom
            localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            
            if getgenv().cameraLockConnection then
                getgenv().cameraLockConnection:Disconnect()
                getgenv().cameraLockConnection = nil
            end
            safeNotify({
                Title = "FirstPerson Lock",
                Content = "Enabled",
                Audio = "rbxassetid://17208361335",
                Length = 3,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(0, 255, 0)
            })
        else
            localPlayer.CameraMode = Enum.CameraMode.Classic
            safeNotify({
                Title = "FirstPerson Lock",
                Content = "Disabled",
                Audio = "rbxassetid://17208361335",
                Length = 1,
                Image = "rbxassetid://4483362458",
                BarColor = Color3.fromRGB(255, 0, 0)
            })
        end
    end, false)

    lib:AddComboBox("Master Team Target", {"Enemies", "Teams", "All"}, function(selection)
        if selection == "Enemies" then
            config.masterTeamTarget = "Enemies"
            config.targetMode = "Enemies"
        elseif selection == "Teams" then
            config.masterTeamTarget = "Teams"
            config.targetMode = "Teams"
        elseif selection == "All" then
            config.masterTeamTarget = "All"
            config.targetMode = "All"
        else
            config.masterTeamTarget = "Enemies"
            config.targetMode = "Enemies"
        end
        
        updateTeamTargetModes()
    end)

    lib:AddComboBox("Target", {"Players", "NPCs", "Both"}, function(selection)
        if selection == "Players" then
            config.masterTarget = "Players"
        elseif selection == "NPCs" then
            config.masterTarget = "NPCs"
        elseif selection == "Both" then
            config.masterTarget = "Both"
        else
            config.masterTarget = "Players"
        end

        config.currentTarget = nil
        config.aimbotCurrentTarget = nil
        if config.hitboxEnabled then
            applyhb()
        else
            for player, _ in pairs(config.hitboxExpandedParts) do
                restoreTorso(player)
            end
        end
        updateESPColors()
    end)

    lib:AddButton("Partclaim (use if NPC mode isn't working well)", function()
        pc()
        safeNotify({
            Title = "PartClaim",
            Content = "Refreshed",
            Audio = "rbxassetid://17208361335",
            Length = 3,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(0, 255, 0)
        })
    end)

    lib:AddComboBox("Master GetTarget", {"Closest", "Lowest Health"}, function(selection)
        config.masterGetTarget = selection
        config.aimbotGetTarget = selection
        config.silentGetTarget = selection
        config.antiAimGetTarget = selection
    end)
    
    lib:AddComboBox("Align Part (Autofarm)", {"Head", "HumanoidRootPart"}, function(selection)
        config.autoFarmTargetPart = selection
    end)

    lib:AddInputBox("GetPart (Partclaim)", function(text)
        local n = tonumber(text)
        if n then
            config.gp = n
        elseif tostring(text):lower():find("inf") or tostring(text):lower():find("huge") or tostring(text):lower():find("max") then
            config.gp = math.huge
        end
        return tostring(config.gp)
    end, "Claim Radius / inf", tostring(config.gp), {
        min = -math.huge,
        max = math.huge,
        isNumber = false
    })

    lib:AddInputBox("TP Distance (Autofarm)", function(text)
        local n = tonumber(text)
        if n and n >= 0 then
            config.autoFarmDistance = n
        end
        return tostring(config.autoFarmDistance)
    end, "Studs (e.g. 10)", tostring(config.autoFarmDistance), {
        min = 0,
        max = math.huge,
        isNumber = true
    })
    
    lib:AddInputBox("Vertical Offset (Autofarm)", function(text)
        local n = tonumber(text)
        if n then
            config.autoFarmVerticalOffset = n
        end
        return tostring(config.autoFarmVerticalOffset)
    end, "-9999 to 9999", "0", {
        min = -9999,
        max = 9999,
        isNumber = true
    })

    lib:AddInputBox("Players Per Wave (Autofarm)", function(text)
        local n = tonumber(text)
        if n and n >= 1 then
            config.autoFarmGroupSize = math.floor(n)
        end
        return tostring(config.autoFarmGroupSize)
    end, "1 to 10 (default 3)", tostring(config.autoFarmGroupSize), {
        min = 1,
        max = 10,
        isNumber = true
    })

    lib:AddInputBox("Spacing Between Players (Autofarm)", function(text)
        local n = tonumber(text)
        if n and n >= 0 then
            config.autoFarmSpacing = n
        end
        return tostring(config.autoFarmSpacing)
    end, "Studs (default 4)", tostring(config.autoFarmSpacing), {
        min = 0,
        max = 50,
        isNumber = true
    })

    lib:AddToggle("Ragdoll on Elimination (Autofarm)", function(state)
        config.autoFarmRagdoll = state
    end, true)

    do
        local Tracers = {}
        local TracerConnection = nil
        local AimViewSource = "Gun Direction" -- "Gun Direction" or "Mouse Position"
        local MAX_BEAM = 300

        local function clearTracers()
            config.aimviewSegments = {}
            for i = #Tracers, 1, -1 do
                pcall(function() Tracers[i]:Destroy() end)
                table.remove(Tracers, i)
            end
        end

        -- Returns the gun Tool another player is currently holding (as a table, like MainModule.GunHold)
        local function gunHold(character)
            local held = {}
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") and child:FindFirstChild("Handle") then
                    -- Da Hood guns carry an Ammo value; fall back to any held tool with a Handle
                    if child:FindFirstChild("Ammo") or child:FindFirstChild("MaxAmmo") or child:FindFirstChild("Clips") then
                        table.insert(held, 1, child)
                    else
                        table.insert(held, child)
                    end
                end
            end
            if #held > 0 then
                return held
            end
            return nil
        end

        -- Real-time barrel origin + direction taken from how the gun is physically posed on the other player's character
        local function getBarrel(character, tool)
            local handle = tool:FindFirstChild("Handle")
            if not handle then return nil end

            -- 1) a muzzle-like attachment/part gives the exact barrel tip
            for _, d in ipairs(tool:GetDescendants()) do
                if d:IsA("Attachment") or d:IsA("BasePart") then
                    local n = d.Name:lower()
                    if n:find("muzzle") or n:find("firepoint") or n:find("fire_point") or n:find("nozzle") or n:find("barrel") then
                        local tip = d:IsA("Attachment") and d.WorldPosition or d.Position
                        local v = tip - handle.Position
                        if v.Magnitude > 0.25 then
                            return tip, v.Unit
                        end
                    end
                end
            end

            -- 2) otherwise the barrel is the longest axis of the Handle, pointing away from the hand/torso
            local size = handle.Size
            local axis, length
            if size.X >= size.Y and size.X >= size.Z then
                axis, length = handle.CFrame.RightVector, size.X
            elseif size.Y >= size.Z then
                axis, length = handle.CFrame.UpVector, size.Y
            else
                axis, length = handle.CFrame.LookVector, size.Z
            end

            local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
            local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
            local score = 0
            if hand then score = score + axis:Dot(handle.Position - hand.Position) * 2 end
            if torso then score = score + axis:Dot(handle.Position - torso.Position) end
            if score < 0 then axis = -axis end

            return handle.Position + axis * (length * 0.5), axis
        end

        local function drawBeam(from, to, parent)
            local len = (to - from).Magnitude
            if len < 0.5 then return end
            if config.streamProof then
                table.insert(config.aimviewSegments, { from = from, to = to })
                return
            end

            local Tracer = Instance.new("Part")
            Tracer.Anchored = true
            Tracer.CanCollide = false
            Tracer.CanQuery = false
            Tracer.CanTouch = false
            Tracer.CastShadow = false
            Tracer.Shape = Enum.PartType.Cylinder
            Tracer.Size = Vector3.new(len, 0.1, 0.1)
            Tracer.Transparency = 0.25
            Tracer.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -len * 0.5) * CFrame.Angles(0, 1.5707963267948966, 0)
            Tracer.Material = Enum.Material.Neon
            Tracer.BrickColor = BrickColor.Red()
            Tracer.Parent = parent

            table.insert(Tracers, Tracer)
        end

        local function Init()
            clearTracers()

            local ignored = Workspace:FindFirstChild("Ignored")
            local parent = ignored or Workspace

            for _, x in ipairs(Players:GetPlayers()) do
                pcall(function()
                    if x ~= localPlayer and x.Character and x.Character:FindFirstChild("UpperTorso") then
                        local OtherCharacter = x.Character
                        local GunHolding = gunHold(OtherCharacter)

                        if GunHolding then
                            GunHolding = GunHolding[1]

                            if AimViewSource == "Mouse Position" then
                                local bodyEffects = OtherCharacter:FindFirstChild("BodyEffects")
                                local mousePos = bodyEffects and bodyEffects:FindFirstChild("MousePos")
                                if mousePos then
                                    drawBeam(GunHolding.Handle.Position, mousePos.Value, parent)
                                end
                            else
                                local origin, direction = getBarrel(OtherCharacter, GunHolding)
                                if origin then
                                    local params = RaycastParams.new()
                                    params.FilterType = Enum.RaycastFilterType.Exclude
                                    local filter = { OtherCharacter, localPlayer.Character }
                                    if ignored then table.insert(filter, ignored) end
                                    params.FilterDescendantsInstances = filter

                                    local result = Workspace:Raycast(origin, direction * MAX_BEAM, params)
                                    local endPos = result and result.Position or (origin + direction * MAX_BEAM)
                                    drawBeam(origin, endPos, parent)
                                end
                            end
                        end
                    end
                end)
            end
        end

        lib:AddComboBox("AimView Source", {"Gun Direction", "Mouse Position"}, function(selection)
            AimViewSource = selection or "Gun Direction"
        end)

        lib:AddToggle("AimView Everyone", function(state)
            config.aimviewEveryone = state
            if state then
                if TracerConnection == nil then
                    Init()
                    TracerConnection = RunService.Heartbeat:Connect(Init)
                end
            else
                if TracerConnection ~= nil then
                    TracerConnection:Disconnect()
                    TracerConnection = nil
                end
                clearTracers()
            end
        end, false)
    end

    local fovScreenGui = Instance.new("ScreenGui")
    fovScreenGui.Name = "FOVToggleGui_Modern"
    fovScreenGui.Enabled = not config.streamProof
    fovScreenGui.ResetOnSpawn = false
    fovScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    fovScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = fovScreenGui

    local ringHolder = Instance.new("Frame")
    ringHolder.Name = "RingHolder"
    ringHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    ringHolder.Size = UDim2.new(0, config.fovsize * 2, 0, config.fovsize * 2)
    ringHolder.Position = UDim2.new(0.5, 0, 0.5, -28)
    ringHolder.BackgroundTransparency = 1
    ringHolder.Parent = mainFrame

    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = ringHolder

    local ringStroke = Instance.new("UIStroke")
    ringStroke.Thickness = 1
    ringStroke.LineJoinMode = Enum.LineJoinMode.Round
    ringStroke.Parent = ringHolder
    ringStroke.Color = Color3.fromRGB(200, 200, 255)
    ringStroke.Transparency = 0

    gui.ScreenGui = fovScreenGui
    gui.MainFrame = mainFrame
    gui.RingHolder = ringHolder
    gui.RingStroke = ringStroke
    gui.UI = lib
    if lib.ShowTab then
        lib:ShowTab("Aimbot")
    end
    aimbotfov()

    return lib
end

local notif1 = (function()
    pcall(function()
        safeNotify({
            Title = "Script loaded!",
            Content = "Script made by @hmmm5651\nYT: @gpsickle",
            Audio = "rbxassetid://17208361335",
            Length = 10,
            Image = "rbxassetid://4483362458",
            BarColor = Color3.fromRGB(0, 170, 255)
        })
    end)
end)()

local function isCtrlDown()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
end

local function init()
    makeui()

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= localPlayer then
            setupPlayerListeners(pl)
        end
    end

    Players.PlayerAdded:Connect(function(pl)
        if pl ~= localPlayer then
            setupPlayerListeners(pl)
        end
    end)
    Players.PlayerRemoving:Connect(function(pl)
        cleanplrdata(pl)
    end)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= localPlayer then
            setupPlayerListeners(pl)
            if config.espMasterEnabled then
                if config.prefTextESP or config.prefBoxESP or config.prefHealthESP then
                    if addesp(pl) then
                        makeesp(pl)
                    end
                end
                if config.prefHighlightESP and pl.Character then
                    if addesp(pl) then
                        high(pl)
                    end
                end
            end
        end
    end
    Players.PlayerAdded:Connect(function(pl)
        if pl ~= localPlayer then
            setupPlayerListeners(pl)
            task.wait(0.5)
            
            if config.espMasterEnabled then
                if config.prefTextESP or config.prefBoxESP or config.prefHealthESP then
                    if addesp(pl) then
                        makeesp(pl)
                    end
                end
                if config.prefHighlightESP and pl.Character then
                    if addesp(pl) then
                        high(pl)
                    end
                end
            end
        end
    end)
    RunService:BindToRenderStep("FOVhbUpdater_Modern", Enum.RenderPriority.First.Value, onRenderStep)
-- keyz
    if config.hotkeyConnection and config.hotkeyConnection.Connected then
        pcall(function() config.hotkeyConnection:Disconnect() end)
        config.hotkeyConnection = nil
    end

    config.hotkeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local focused = UserInputService:GetFocusedTextBox()
        if focused then return end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            local kc = input.KeyCode
            if kc == Enum.KeyCode.B and not isCtrlDown() and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                config.wallc = not config.wallc
                if config.wallc then
                    safeNotify({
                        Title = "SilentAim Wall Check",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(0, 170, 255)
                    })
                else
                    safeNotify({
                        Title = "SilentAim Wall Check",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.Z and isCtrlDown() then
                config.espMasterEnabled = not config.espMasterEnabled
                applyESPMaster(config.espMasterEnabled)
                if config.espMasterEnabled then
                    safeNotify({
                        Title = "ESP Master",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(0, 170, 255)
                    })
                else
                    safeNotify({
                        Title = "ESP Master",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.V then
                config.autoFarmEnabled = not config.autoFarmEnabled
                
                if config.autoFarmEnabled then
                    autoFarmProcess()
                    safeNotify({
                        Title = "AutoFarm",
                        Content = "Enabled (Hotkey)" ..
                                 "\nAligning " .. config.autoFarmTargetPart .. " to crosshair",
                        Audio = "rbxassetid://17208361335",
                        Length = 3,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(0, 255, 0)
                    })
                else
                    stopAutoFarm()
                    safeNotify({
                        Title = "AutoFarm",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.E and isCtrlDown() then
                config.Enabled = not config.Enabled
                if not config.Enabled then
                    if gui.RingHolder then
                        gui.RingHolder.Visible = false
                    end
                    for pl, _ in pairs(config.activeApplied) do
                        restorePartForPlayer(pl)
                    end
                    safeNotify({
                        Title = "SilentAim",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                else
                    if gui.RingHolder then
                        gui.RingHolder.Visible = true
                    end
                    lrfd()
                    safeNotify({
                        Title = "SilentAim",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 100, 0)
                    })
                end
            elseif kc == Enum.KeyCode.Q then
                config.aimbotEnabled = not config.aimbotEnabled
                if config.aimbotFOVRing and config.aimbotFOVRing.RingFrame then
        if config.aimbotFOVRing.ScreenGui then
            config.aimbotFOVRing.ScreenGui.Enabled = not config.streamProof
        end
                    config.aimbotFOVRing.RingFrame.Visible = config.aimbotEnabled
                    updateAimbotFOVRing()
                end
                
                if config.aimbotEnabled then
                    if not config.aimbotFOVRing then
                        aimbotfov()
                    end
                    safeNotify({
                        Title = "Aimbot",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(0, 255, 0)
                    })
                else
                    config.aimbotCurrentTarget = nil
                    updateESPColors()
                    safeNotify({
                        Title = "Aimbot",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.B and isCtrlDown() then
                config.aimbotWallCheck = not config.aimbotWallCheck
                if config.aimbotWallCheck then
                    safeNotify({
                        Title = "Aimbot Wall Check",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(0, 170, 255)
                    })
                else
                    safeNotify({
                        Title = "Aimbot Wall Check",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.G and isCtrlDown() then
                config.hitboxEnabled = not config.hitboxEnabled
                if config.hitboxEnabled then
                    applyhb()
                    safeNotify({
                        Title = "Hitbox Expander",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(0, 255, 0)
                    })
                else
                    for player, _ in pairs(config.hitboxExpandedParts) do
                        restoreTorso(player)
                    end
                    safeNotify({
                        Title = "Hitbox Expander",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                end
            elseif kc == Enum.KeyCode.L and isCtrlDown() then
                config.antiAimEnabled = not config.antiAimEnabled
                if not config.antiAimEnabled then
                    returnToOriginalPosition()
                    safeNotify({
                        Title = "AntiAim",
                        Content = "Disabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(255, 0, 0)
                    })
                else
                    safeNotify({
                        Title = "AntiAim",
                        Content = "Enabled (Hotkey)",
                        Audio = "rbxassetid://17208361335",
                        Length = 1,
                        Image = "rbxassetid://4483362458",
                        BarColor = Color3.fromRGB(255, 100, 0)
                    })
                end
            end
        end
    end)
end
local function cleanup()
    pcall(function()
        RunService:UnbindFromRenderStep("FOVhbUpdater_Modern")
    end)
    stopAutoFarm()
    if config.hotkeyConnection then
        pcall(function() config.hotkeyConnection:Disconnect() end)
        config.hotkeyConnection = nil
    end

    for pl, _ in pairs(config.activeApplied) do
        restorePartForPlayer(pl)
    end

    if config.aimbot360Enabled then
        toggle360Aimbot(false)
    end

    for pl, _ in pairs(config.hitboxExpandedParts) do
        restoreTorso(pl)
    end

    for pl, _ in pairs(config.espData) do
        removeESPLabel(pl)
    end

    for pl, _ in pairs(config.highlightData) do
        removeHighlightESP(pl)
    end

    for pl, connections in pairs(config.playerConnections) do
        for _, conn in ipairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
        config.playerConnections[pl] = nil
    end

    for pl, conn in pairs(config.characterConnections) do
        pcall(function() conn:Disconnect() end)
    end

    if gui and gui.ScreenGui and gui.ScreenGui.Parent then
        gui.ScreenGui:Destroy()
    end

    if gui and gui.UI and gui.UI.Destroy then
        pcall(function() gui.UI:Destroy() end)
    end
    
    if config.aimbotFOVRing and config.aimbotFOVRing.ScreenGui and config.aimbotFOVRing.ScreenGui.Parent then
        config.aimbotFOVRing.ScreenGui:Destroy()
    end

    config.activeApplied = {}
    config.originalSizes = {}
    config.espData = {}
    config.highlightData = {}
    config.targethbSizes = {}
    config.playerConnections = {}
    config.characterConnections = {}
    config.centerLocked = {}
    config.currentAntiAimTarget = nil
    config.hitboxExpandedParts = {}
    config.hitboxOriginalSizes = {}
    restoreClientValues()
end

init()

return {
    cleanup = cleanup
}
-- fin
