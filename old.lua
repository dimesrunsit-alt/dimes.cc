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
            winBg        = Color3.fromRGB(13, 13, 14),
            winOuterBrd  = Color3.fromRGB(6, 5, 6),
            winBorder    = Color3.fromRGB(36, 33, 36),
            rowBg        = Color3.fromRGB(18, 18, 19),
            rowHover     = Color3.fromRGB(26, 24, 26),
            rowBorder    = Color3.fromRGB(32, 30, 32),
            dropBg       = Color3.fromRGB(16, 15, 16),
            dropHover    = Color3.fromRGB(32, 27, 31),
            tabBgSel     = Color3.fromRGB(28, 24, 27),
            tabLine      = Color3.fromRGB(206, 164, 201),
            tabSep       = Color3.fromRGB(32, 30, 32),
            text         = Color3.fromRGB(240, 236, 239),
            textDim      = Color3.fromRGB(164, 157, 163),
            accent       = Color3.fromRGB(200, 156, 194),
            accentTop    = Color3.fromRGB(215, 173, 209),
            accentMid    = Color3.fromRGB(180, 143, 175),
            accentBot    = Color3.fromRGB(149, 118, 145),
            toggleOffBg  = Color3.fromRGB(10, 9, 10),
            toggleOnBg   = Color3.fromRGB(52, 40, 50),
            toggleBrdOff = Color3.fromRGB(36, 33, 36),
            toggleBrdOn  = Color3.fromRGB(148, 114, 143),
            knobOff      = Color3.fromRGB(104, 99, 103),
            knobOn       = Color3.fromRGB(210, 168, 204),
            inputBg      = Color3.fromRGB(17, 15, 17),
            inputBorder  = Color3.fromRGB(40, 36, 39),
            sliderTrack  = Color3.fromRGB(16, 14, 16),
            sliderKnob   = Color3.fromRGB(217, 175, 211),
            whiteBtn     = Color3.fromRGB(26, 23, 26),
            whiteBtnTxt  = Color3.fromRGB(240, 235, 239),
            whiteBtnBrd  = Color3.fromRGB(70, 58, 68),
            scrollGroove = Color3.fromRGB(10, 9, 10),
            scrollThumb  = Color3.fromRGB(202, 159, 196),
            kbStroke     = Color3.fromRGB(145, 137, 144),
            kbKey        = Color3.fromRGB(176, 169, 175),
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
        local HttpService = game:GetService("HttpService")

        local function cleanOldGui(parent)
            if not parent then return end
            pcall(function()
                for _, ch in ipairs(parent:GetChildren()) do
                    if ch:IsA("ScreenGui") and (ch.Name == "Blossom_UI" or ch.Name == "DimesCC_UI" or ch.Name == "MatrixHub_UI") then
                        ch:Destroy()
                    end
                end
            end)
        end
        pcall(function()
            for _, ef in ipairs(Lighting:GetChildren()) do
                if ef:IsA("BlurEffect") and (ef.Name == "Blossom_MotionBlur" or ef.Name == "DimesCC_MotionBlur") then
                    ef:Destroy()
                end
            end
        end)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Blossom_UI"
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
            _spNativeHook = false,
            _spSyncVisuals = nil,
            _spNextItemId = 0,
            _spItemsById = {},
            _spSchemaDirty = true,
            _spBridgeConnected = false,
            _spAlive = true,
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

        -- Ambient Background Shadow Backdrop + Falling Snow (Bokeh + Directional Motion Blur)
        local bgShadow = Instance.new("Frame")
        bgShadow.Name = "BackgroundShadow"
        bgShadow.BackgroundColor3 = Color3.fromRGB(4, 2, 4)
        bgShadow.BackgroundTransparency = 0.48
        bgShadow.BorderSizePixel = 0
        bgShadow.Position = UDim2.fromScale(0, 0)
        bgShadow.Size = UDim2.fromScale(1, 1)
        bgShadow.Active = false
        bgShadow.ZIndex = 0
        pcall(function() bgShadow.Interactable = false end)
        bgShadow.Parent = screenGui

        local bgShadowGrad = Instance.new("UIGradient")
        bgShadowGrad.Rotation = 90
        bgShadowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.08),
            NumberSequenceKeypoint.new(0.50, 0.34),
            NumberSequenceKeypoint.new(1.00, 0.06),
        })
        bgShadowGrad.Parent = bgShadow

        local snowLayer = Instance.new("Frame")
        snowLayer.Name = "SnowBackground"
        snowLayer.BackgroundTransparency = 1
        snowLayer.BorderSizePixel = 0
        snowLayer.Position = UDim2.fromScale(0, 0)
        snowLayer.Size = UDim2.fromScale(1, 1)
        snowLayer.ClipsDescendants = true
        snowLayer.Active = false
        snowLayer.ZIndex = 1
        pcall(function() snowLayer.Interactable = false end)
        snowLayer.Parent = screenGui

        local motionBlur = Instance.new("BlurEffect")
        motionBlur.Name = "Blossom_MotionBlur"
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
                f.BackgroundColor3 = Color3.fromRGB(252, 246, 250)
                f.BackgroundTransparency = baseTr
                f.BorderSizePixel = 0
                f.Size = UDim2.fromOffset(math.floor(sz + 0.5), math.floor(sz * 1.12 + 0.5))
                f.Active = false
                f.ZIndex = 0
                pcall(function() f.Interactable = false end)
                f.Parent = snowLayer
                addRoundCorner(f)

                local softRim = Instance.new("UIStroke")
                softRim.Color = Color3.fromRGB(248, 238, 246)
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
                f.BackgroundColor3 = Color3.fromRGB(252, 247, 250)
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
                core.BackgroundColor3 = Color3.fromRGB(254, 249, 252)
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
                f.BackgroundColor3 = Color3.fromRGB(250, 244, 248)
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
                midRing.BackgroundColor3 = Color3.fromRGB(252, 246, 250)
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
                innerCore.BackgroundColor3 = Color3.fromRGB(254, 250, 252)
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
        win.BackgroundTransparency = 1
        win.BorderSizePixel = 0
        win.ZIndex = 2
        win.Parent = screenGui

        win:GetPropertyChangedSignal("Visible"):Connect(function()
            bgShadow.Visible = win.Visible
        end)

        -- Multi-Layer Feathered Gaussian Drop Shadow Behind Window
        local dropShadowWrap = Instance.new("Frame")
        dropShadowWrap.Name = "DropShadowWrap"
        dropShadowWrap.BackgroundTransparency = 1
        dropShadowWrap.Size = UDim2.fromScale(1, 1)
        dropShadowWrap.Active = false
        dropShadowWrap.ZIndex = 0
        pcall(function() dropShadowWrap.Interactable = false end)
        dropShadowWrap.Parent = win

        local shadowSpecs = {
            { spread = 4,  y = 2,  rad = 5,  tr = 0.72 },
            { spread = 8,  y = 3,  rad = 8,  tr = 0.76 },
            { spread = 13, y = 4,  rad = 11, tr = 0.80 },
            { spread = 18, y = 5,  rad = 15, tr = 0.84 },
            { spread = 24, y = 6,  rad = 19, tr = 0.87 },
            { spread = 31, y = 8,  rad = 24, tr = 0.90 },
            { spread = 39, y = 10, rad = 30, tr = 0.925 },
            { spread = 48, y = 12, rad = 36, tr = 0.945 },
            { spread = 58, y = 14, rad = 43, tr = 0.962 },
            { spread = 70, y = 16, rad = 52, tr = 0.976 },
        }
        for _, sp in ipairs(shadowSpecs) do
            local sh = Instance.new("Frame")
            sh.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            sh.BackgroundTransparency = sp.tr
            sh.BorderSizePixel = 0
            sh.Position = UDim2.fromOffset(-sp.spread, -sp.spread + sp.y)
            sh.Size = UDim2.new(1, sp.spread * 2, 1, sp.spread * 2)
            sh.Active = false
            sh.ZIndex = 0
            pcall(function() sh.Interactable = false end)
            sh.Parent = dropShadowWrap
            addCorner(sh, sp.rad)
        end

        local outerBezel = Instance.new("Frame")
        outerBezel.Name = "OuterBezel"
        outerBezel.BackgroundColor3 = C.winOuterBrd
        outerBezel.BorderSizePixel = 0
        outerBezel.Position = UDim2.fromOffset(-2, -2)
        outerBezel.Size = UDim2.new(1, 4, 1, 4)
        outerBezel.Active = false
        outerBezel.ZIndex = 0
        pcall(function() outerBezel.Interactable = false end)
        outerBezel.Parent = dropShadowWrap
        addCorner(outerBezel, 3)

        local winSurface = Instance.new("Frame")
        winSurface.Name = "WindowSurface"
        winSurface.Size = UDim2.fromScale(1, 1)
        winSurface.BackgroundColor3 = C.winBg
        winSurface.BorderSizePixel = 0
        winSurface.ZIndex = 1
        winSurface.Parent = win
        addCorner(winSurface, 2)
        addStroke(winSurface, C.winBorder, 1, 0)

        -- Anime girl backdrop (centered, behind all UI)
        do
            local girlParts = {
                "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",
                "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",
                "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",
                "aOzQITYqRTouLUAN0BWNRnleeI3NShHl8tRh6V340th9Xv7sSRp2IUZiirNC0PZsttvzx/tHY2sIx9PLWZyoU7vTplodVhEVLpCHKSterzVqVEXdVqtN4YiArt5eCgpQbDRQn1ZyjFHJuwJRc/26uglBhsNucb0tAcvuRgblDLvrHW95f/9qSy9EUrf1EOrQpAs+R73Q8xGLAMRGIXE+UxPj2tHJCd+h4eGoqWm9+Z1s4smnnwqdf/tNU5yLAi8lJaW7loIuJaU7KL+9jWFtrK4Er1++HFm4cdOXXd/UrY5GYV+AeiJxGuoboFg0xmm1bHaHcoWCACui4bFROnz8GB2amqJANExNASglASewTphfmKcrV6/Q3MICpxWTyST19w/QyMgonTpxiqKxGJUqZbZx6E0l6ZAAsJCAFrnaT9Y3caRLFpJ7fKq8MLMrL4zpbM8gTVEleNmaF7g6e0aH2t3tNTZJJSrXKlSpV6jVaZHlMwV0WWyeWiyX+Fwtv598gSCFwhFK9qaoLa5RoVBkiNI8gMirEXlezkydoJY0RpXz0/YAV8e7qlDb+/ptrS5sZzgpUtM1JUNrJqd9EaJcJgxhueWQbLSt0chAn3b/6ZP62NBgOBoO9Wxtb6bWV1cj5575qe8gbzElJSWlg6SgS0npDiqVK9rayqo/l82EVpcWA7ptGwPpNNdsoTNhtVyh/nQf2zFsrG/QViZDsUSC7n/wAZoQsBXv6WHYqlRrtJ3NCNhaoHcEbC2vrHDUamR4mIEK0AXPLaQU2Y5B3MMBWSi4HxgY4LnIaBZu8IgUAbhM181eFqV7B9Gt1hC3Mxq9XWE9efbFBqxu8bztQg48w2CK2nEjYbpjE09lAYxYnYhz4gicG63DIwrrYYmBufN+5T7t3QThnea514OMGBI1HrcW/99J3W299W1uPZnmpjwxLDFnU2wQ8Fva/WdPGyeOHQmGg4F4uVjonZ+5GTt/7gXzjVdeVBEvJSWld5WCLiWl26heLmu2oITZmdmwZflCJ48f148fPaolYnG6fv06u68HQ0EGj83NTapWK/TpT3+afvVXf5XSfX1c3wQ4go8WViBefPsizczOUp+AtMOHD7PvFgZu/Ei55Qt5LpiH9xVSiYAxrHSET5dcOdgU+4OrO/ckRHNoy+r2TLzFe+tdoi93DV77tvfuvyquAYrhAYgAKswD54BzxjxRk4b5o4l2b28vfw4eY5VKtbsS0mtDsce2Qtv1GrvVVd+TRsU/Y7Y3NfmzyQtzRLsLEWxyrDHQ2sgwNBoeGtQe/dgjZjgUiFSq5djC3ExseXHBd+HcOQVeSkpKd5SCLiWl26iwualpnbaxsrjkq5VK1nD/gGbpBq9SvDE9zVCByBTMPyenDtNnP/95fi6jUAAPtL558sknKbuTpZGxUfqNL3xBgFSCYQNF8Yj+YNtLly5xE2eAFqJbwyPD3DQaQIf38TMEyIE7PY4NwIEZKYBARo1+Fu2HrT1w5XWzdw1XIQlJONdAMMgLBTAHRL1wPWpinmjujXZHljs3fBbGqcFgQMy73jVYlVGuu5nf3Uax7qSDIoIHHtOtc0MUDeazNQGTTRjWoqG3gMxPf/ozxsceeSQ0PzOTzGd3opVSyX/14ttauVz8ueeopKT04ZSCLiWl26iQyxm6bQcCfr8Vi0aNqcnDZLfatL66RusrqwwWKBD/+Cc/QYfGx/lGDZgCECHydePGDS40f+CBB+iwgDJAx+XLl3nfgC0MFNIjCoaI1aTY/8mTJ9lAFDYMAC5AAeAK0SHATFNAFqJKgDvsDxAmm0bfEZ7uoINSktI/yzuw2hJ2D2y4IB5xnhh+n4/SyRR7kwFKCgI24ZwPUARkYV+Aw2azToOD/XTsmJMyxTlIny+kMQ19/z9H3TWHdFAUaz883WnsSWHasrbr3QFMOtob4vCmrlG7Jc5DAGOn3aRYJKSNDA9aArwirU4r9fIrzyfr7Zp/c3PVuJvfLyUlpY+eFHQpKR0geDGtLS6bm6vrwZ5YzIwEgjpWtc3PzNLG2jodOXKEzpw9S8dOHGendcAFwGR7e5vm5udpYWGB4j0JSvT2cAPonZ0cGaZJp8+eoZHRUXZlvy6gDIanuNnDlX5kZJjhC2lJNIrG/hAN2tjc4HQmwAvv43gAL5melDVed3leBw7v+wf97LzgrI6E7xYYCDDI9VwCZjAPPHLT63KFQYzbAXk+jHMBUCIqNjg4yOeAz+CcHAf7zh0B6MA53eW53u7c7yTHeoOchQcANAGaPrRk8vnJLx6rlQp3uRw/dEg/duRocOrwVOzN115PXjj3aqi4vm6IcddzVVJS+mhIQZeS0j5lMhmYmWrrmxvGxsa6b2Rw0IhFIjQzfYOq5TIN9PfRZz7zGZp067IAPNsZp0ge1g8Q0oS4qZdLTnPqURimTkxwjRYEe4iXX36ZGgJc0H8RkTCsWJSrEfEHUAOIQ5qSHd8FsEiQabimqQxoAuYQ6ToIIu5USO99vv8zu87vu4CyJ8WI6FGr7bTkweo/ASQtMae6gC6AF+YVCPg5ugX/KwP2EnCBRx2X+HxUXE/AG47szF971xSjXHV5p/O5zadJRs2kr+lBn7ndvuQKSrxsmgbXdZHbWskSPwf9PhodGdIPjY74w8Fg3OczI+9MXw5s5Gd02758h3kpKSl91KSgS0lpn+rb25oYCL34K6VSUICTUSoUaSe7zfB09uwZjtbE4zGueVpcWuI0IWqtkDaDLxUsE9riRp1Mp+jEyRMOUInnSAeimB5wBqiamJwU759keIMkeACqsL91REtgPzE8zBEubjDt1ox13NY6+yM5Ut6f39OKRc/n7X3QBeH43MZHPKINkuFCGDvTN5r8Ppp6B/wB3obcRtNIReI9QBsAUkbHUC/l9HE8uHZrr9fYfvtU2rPd7eu/7nzedwIwBkMsWhBwiPQuau/4NTQXx/VAk2+fn/rSaf3UieN+yzBi169fj29vVAPT7zRUqlFJSakr",
                "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",
                "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",
                "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",
                "D0BBqOmCaWkkFu1G9qRlw+3EXmnktl3a88ZurZh0Tu3WgXXrwaSnWacLdohqhoNBjl5CaCcURNugeEJA1v30b7/82/SpT36KHnrgQTp94gSdOn6cjgj4H+pNUtRnkQlvN/HdVATcb8zN08yli3Tj4ts0f+UKZZaWqLaTFV9CjfBtBASAmuI7bVXr1BSf6TQb/DuABSP4vkzxHTXaLXtpdbVZbzXKyb5k0fJbrd7+/tvndJWUlH7hUtCl9KFRLpczqpWKb2Z6OprZ3Io2aw1LAEYn1dPTPHL4sN3T0+MrlcuB61evGVtbW7xGEMCFPoSIcAFYAAu5nR26Km5sMDpNp1I0KaBqcGCwm9ZDzz3AFH5Gui7eLaqvOb360KhavIe0IoAG9WLsWI8IU8fpbYhH6VLvNQ7dbblD3RWM3lRcN/rlDs0DYd1Gy+RYEhjuKr5atcJpNMwTj7onJecU87e7qT0HwOpdw1McT9aYIRomI2A4Jppa43rJdj7YBxYqAHKcerE2eZy4PN/U7V3nD9KthqXe6JTzmvcaykcUvmOVZsA1LZXRqf379jrRa57XPRO8Q52X+x3Iz9vOP6oBf4CbpUNINzvgTAzE/ckUHRoZpUOjYxRHSynDoqh49Iv32uKaFjNZ2l5epY35BR4Z8XtU2NigWi5HtgBoUwBVQOwOsOUXRw0hsiiOarvNz/l6iIcGfmfEz1YwQLVmwy6Wy81SrVps23bx8NTharov1RkRsKekpPT+SUGX0odGSwsL+ub6hr+Qzwdr1aolZKeSycb4ofFmsjepN6o1K7u5Za0sLmqIOgwNDZIfEQVxc0Z7FqTIkDKcm5nl1CLsDx584H7qScSdKIW4kfrd7dZWVxmukJ50/Liq3Rs/WvGglmtzc4NX8J04dYpv/Hhf9jcE2JS5DY/N+5GApLuNnqX7uawVasmVjq12d6WcXMno7acoA0e65lhFcJpN3Mh9psWF7jI1KN/DIyBKAhbqvmQqEkJkD0Da4XRik1OK8j1v6x28hqgKW0Q4SyG786TbwNRBfmO32+728sARQE+cPFocNdy6NkTu5KIAB7pu0wZIRrJ2D+o80C4u7k9Jyke2rdB2a/PwB9eiR/xuwAeNi+1RI9dEA/K6AP0whXG9XcDKrm3S9soGbS6t0tbSGmVWNym/uU3F7SxVMjvULJZJE9c+JPYS0jEMAWrieuOaie8DzbTbgHekrA0dXwa1xEGbYi4N8VjtdOxMqdjIFIulSDyRj8Tj1V+7/+H2w7/+r1TxvJLS+ywFXUr3vOB/JYZ28+aMb/rGjUi1WhP3fqM9PDxcnpiYbKBvYrvV8S0vLpmrS0taKBDgCFdIQFQ3NeQaWqIQfmF+QQBXiCbGx+n4saNc/Iw6LAAFIkhIK+Z2ck6BdizOKx0BI4isALKwmnFldYUjQImexJ6G1oa7UhERIzxiZR0K7lETJuNUMhpFnigXAw7XfrmRpc4+mHHpQEIYu7GLeeXFPLE94MPv8/MRZC9Ib60XgAHzybk9IZFa5N12wcn5HLbhov+O48qOucpidACfrKfCddK8U7vdSsF979+tMapX3VWghtPuKLuzwwXz+1d27jmuB/YOlIwg3gKNLni5Cxkcc1RP9M1zLngG2MXCAkARFiY0kaIVEFsU30tmbZ3yAroK2ZwzMnmq5ErUrojfi6ZNvo44r5Z4FFwbtAFbJvnFawaimBhczO+Y0+J644gtRCDFT03U4SHtK76SjZ1co1xvFFpE+ZFD4+XDx040taEhBVxKSh+AFHQp3fMSoKBtb28bmWwmsL6xgUbWWn9ff+uBs2ebA/19RqNeD2yurQVyOztGs9HU+tJ9HLHiGiwBDE2GjR1ueI2ByBX8tDAQsZDO64iKlcslKuQLfJPnIm0xAEy6jHKIsSP2tbyywq2AkGKSRd4Q6qAAOwwvsBpADZiYi1M875wPF9Hbdtc81dsTUUa3bBlJ6g57ty7MtVIARGLI2iwH4Drczgfg2HRtKjA3gBLmheeyjyBHh1xbB7ZgqFQ4goe5M7SJfcB5n2G01d4DMvKc90e6DvLH2j232/tv3UndxQfkgCOidZinPP7e1KzHusIzJ/LOxd6Nbu2y176ej575ewGNTVDdllEcRUStlYBBXLu2u/qxJH5/drYzlBPzrCNC2miR3RTXrymutwAsgeAUMHwU1C0KaALKxT/Tlti9BchCZJG3d1a5AurYPw2/X6ZBLaxgxfchXq+Kky02mo2NXK7Q0fXc1PGTRTHn5kOf/awCLiWlD0gKupTuaWF14M7OjrawsOCvVWv+SrnsGx4a0k6eOGHE4/FQq9GIiJtbaHFhwRKgpQ/29wsAsXYtDMRARAipwPX1VQEidUonkzQyPMwNq0vFEkcSABaBgJ9tEgBeskaLrQfETVVzi81lETr2Pzo6RqlUumtRAHCRbWlkNEmCge5JXXVcx3JZS+W1WvCajDrtZHbb8XCxPT4vwArnxBAl/qCWC9CF/QE0MQBekOE6xgNS8D5W3YVcY1hu0u3OByvwAHAyJQm4QfG95sbnZCTJEseJuMX1jsHqfsh69+/0dvVTt264+7601MB54TvCe5gHr9DsOIC627Jnd/HBgccnL4DtjXIdNE9nFek+2wm2ozC5DyWgq1wu8gpQ1LwxtMHrC14U4vvrCOBq11tErQ4/h9kqIVIo5m0gamk7Rq34PL9GcpGEnJbuwLH4vRZfAHUMi5qabm8Xio3tQqFkRoNZ269XP/e7v9v6/O/93rt/AUpKSv9iUtCldE8rs5MxiqWib35hPqIZeqinJ2EcOjTmHxzsD1qWEdrJZKz1tVUdzukomEedVrvRRNkxFx1vrK3zCkX4bW2IR4DU6dOnGT4014pAwhG8tlCUjlsveuz5OO0obvRYtefej7M7Wd720KFDNDQ6Qj3J3q45aUnAWslNeyHdFxT7RVTE7si6LAdg2q79Qtet3t51mu+msDreKIvMkvLaO45myeLtcCjM8IE5SMNQ",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "u+7ngjT/ese+6w5Dm9iB7hWDzur88mKrJaqyIQFdOEMiVmuGdFm5qxs22H6QpMglc2eD82nqUjDuDSg1ohElKJ/LuQXgMpQHI64XtNsMXaaH1RNI9vFw1BzKD0ai4WiMgVvMKVeMXYmEl+zL2eMzU9VSrVpeKaxVVgrrdtt3/WQuLT6Z+A6BumDyxyX41dsnp5PJSCzbLFfSsydfCf3j5z7Xi5W98WMZvYnUG29o6JulkYjx7S0Uiifi8RgDpcjRoy9bDz30kPnAA/cbzz//HJ05fZoWFxcJwKvZqKsSI4MQyDOAvIxAl2cAs3PPbnnsyNEjdM/XviadbbbIN5iSZegmicsHm7o13bgUZAQYIlC2F5FNgCm8h3S4tSXTEoVh9vgY9Q0PSvAH0ALwQkBGO7lnwMbHIyUC8OqxZ88eiknWKgSAZCxWq+YCB4hwNOKHY1E3m+9vZ/v73EQm5SczaR8ZLlCesC8IIuLLCBkDWNSgoxASFo5L9VaD+qHkPzZGS0vLtLyyLCUzAEZsXte5uERSYpMF0KXn5NKs1uaMlybavKk5sBlkvRboCraJiQm68eab6bd++7fpVxh8vf8Xf4H27NsrpT6AHjE05zANxferb7iO9l12mWQHs/DUTKXUOdDim6LXJXIbrmRZYPcDyQHwr0IoKfPj0ViUiqUivXLyBF/XlgCtcrVCa8V1MT9HhktlGaNK942vP5wRIMYqgADG27GYlH8xz87MXqD1atkPp+Lu0vpqY7mwVvYscz3dl6184uMfbxlbtvi8veHz+LM8rrrqKmT9vLHpqXrDbpfnlhZLjXa75YLFJ9laZQgk5UXxT7Re831eS+8t+DuQnghGkPlSPM26AC/JNgrWU5ph4Gm6Bmk5FlNlgPl94OcZU2bpBt+ZsFSJ8hZrtdqh7z75pPGeD3/Y/+iv/ZqbGxioRxLx0sLKUq1QLrZbcNIAtEYmPaSI+mH+pS+ZDvdnckkGcJmVhbXE4oWV0MWnL/7LQdW98VMbPdDVG29orK+sYLNMw4x4np9YW1sLzc/PG+eRpWKQAD2urVu30MzMDI2NjVKr1aTV1RVaWV6SLBSkFNC2D4mHHEjuQ4PSPYab6lNPP0mPPf4YHT1+TFS/kbFAkAWQcn2tIa9kqrvKZxuZMMNUNiG+r7sa+fOw4b2ULIIhYC6cUBmv/NCQmGcDFDXwXMcxOCibtuuFQtGYiYze5uNH51oilcBmZHI5g4O+yZsRTcbdUDRic0BvMeiyQ5Gwn0ilKc6gwYpEJFCAa4bfYeKN44EEAtT2AfhW19alvIrsULVeo4WFRZqfvyjNAZvHJeKom4j06pyotIN6nilE+h8kqKoA7Gtf61eVVLrA20bpd6NDMvi3zdkx/A1e2/S2bfTu97yHfuM3f5N++9/8Dn3owx+iq6+9hsa2TAgIyjMIu+rw1dJVyGheBVqt/WRqJXlks0TmDJwtPm9BUMZ5g38mAC3kINbW16lcqwqwqvG8PHX2DMV4H8a2jNPoxLjwCmHN1GCwi2uhzNBD2hA9LGR9zJ1FBsCr6+t+sVpxGo7daHh2MZJJFD/6y5+o3vKeO2wjl/sXW3f60G/8Ch24+XrXs4wGf4OKtWajwnO1FYpEfHAhsXByvY259oMyp0EDSLBdmvWijlyM7yk3C7yL3bYlgwmOF0RNMY/FyYHnsmS8fMXlDIytwXPEK8PQ7jMgoBqP9udy8ZbvxApOOzQ7O2tAEPed73+vPTG1tdpy2oXl9dXK2bnz7ZbneBBRRclUvhJ472aLBnK58JaxscRgf38uxavMex+82/q7//rZHvDqjR9p9EBXb7zugZtksVQyLi4sRJZXV2Nz8xdjyysrIQTcQ4cO0vve9x768Ifvottuu4Vu5+3mm26gvXt3C63qwvlzAr7q4CoJv6tJ5UqJ1tZWie9pNMGBtz/fTy+8+ALd/8D9dJafD8Am5TdzQ0dK9kNvhuF3MlziF01GR1AVCvdAE+22y6DL4+CrJRa0An6UA3CWAV//8DCDsCQDH4fBEIyxDcZB0Vh+YDC2OH8x7JcY5pUujavRaNTgAG8kEwnLazdN3vixjNdutJ1crq/NYNQtV+sUhvFuEgbJYbErQoekz79XGSw0eEdiDMpA5kYpbL1UlKwTzsE4nwuQ8KGKXkZW0HE1l8mSoGNYG8R511VK89SduRKAqYuWRvCQyiL43WVGnSUw/Y2zupH8CljzygPP0P92SQHJ7/oM6vbc02K3UgZU3aa40TgMkDIMZvbu3UMf+tBd9Fu/9Zv0+7//+/TpT/8y3XXXB3nO3Ebbtk1TjsFoWLhC6vOBryGGCR9ET8zGTfm3IoOrGgMrgC4AVoCyBgfLo8eOU6VWo6HhIUiAiIE1GjcguHroyisl0wUAZoiUREg6TJVuGUAeMiohYtBNS6urdPzECa/eatkwrQ6HI+sj42PFO37xfbWRkUlndHTqXyzgCsaOHTv83bt3OjPbZxqlWqVct9sVmzFPmyeQLAcsUxYtnudvmhpd4IqU7dZmwKUWS740xqgn8e++0TE7bzda1KjUqVGtkcffT4CqCMqZ/Bx4czrip6n+g/tBMFfRPptJJ0MD+f44L34yoUgofvrEUevC2VPGyPS0N7l1q33TrbeWS/VqcXZ5sVJsNuya6/htvQDBezn4TodMI5tOhifHxzK5dDJdr5YTYX7w3q99rQe8euNNjx7o6o3XPRqNhsHBzLwwNxdZYdC1vLrCi96IMTExLoF0YCBPUXgPIpgxIEonE3Tt1YfpmsOHaXp6koPkGhUYZCF4Qo+q2azD6U14Wgi0sHXBjDx99jR997576egrx6nIQVP8Di1d0hDRRFUyNAL9KXAxNFlfiOc2RDr5Ns9RYX2tSMsra1SDpARu1FDChmk237zNaIL6hkco3ZenSDJN2b5Byg+OhBhwxcOhSGZtrZDklXKIt0u+J5FQRG1WyGzVK1a7ofhXkVDY68v12aVK1V5aXXdjiZRnhCP+eqXC",
                "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",
                "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",
                "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",
                "S/NLi7VKoy7vPPAFlY0K75BGckMx3hQklhaWYsX1ks2bwR6S78UDozfx9OKR4uTp0+7egwcbvPA1E4l46+OPP/bBtYLsA7Ja09unBbggawLxShhiYycLsIWJFO3fyEygUw56XFsnJnRmKyKTJYQzcR8snMNDOSk5JsUeBr5osLNpSQYEwAvlJgAviLQqXllLiYFqgryvCd5i0Osr8+SAWxQORSTzhawRVPAhewFQiIwPyqEQ19yzd4+dGxpCGm1ToCsIgE8+RN665YnZteF6nuk4juHxxhnlzmg45oesiGcbtjilkFBiFOvJCocdftP1VpvPSLvl4TNk+ZwMwXybQS3OOThM9XqDnEZTskUCavSChsDuHDy3oNPR83zawFp3f6S7Mz+Si1KdkIZ5F7TauN9dlPouUUzqtPDLIXY9ylA6JN2hyjMPHBmccxDhA+sggDBkwFBGRKfiZ59dEk0u3Bf2Qfv27uHxkhYZCdwfOlz79+3ln7voyKFDtH1qWriAVy5fRlOH0d/XZ24Z3xIZG98SvzO/kFjOr4WWl5d7C+OvKP7lv/5vfD7cfLVUr7Vb5ZbvNx3Pc2HBBG9RNLeQbvbAdxEiygGPsjt0AXsDvgebAk26D6yCMK4s0arzxFJM+bpWJBtu26ZYaGJ4WvJaIeGTBt2QoPrHwmEefmbEd904P39o9urVB66Fz/zwhx4fbSscqfJnKd9ZWmg23ZYbjkWkfA7Tdf5aQoTV7k9lYqlIImX7Zvj8e+/11tZePDB6A6MXjxo+L3b+2Ni439/XLzdg8V9eWRFleHCpiqWiyD9cn52hD899REvLi7ReXKP82irdvn1LhFEBpIQrxuAJcgFAAqGQLWVGeLIhgwXQcvqp0/SPf/BD+tY3v8UAbasIJS4tLQrfC23jyKYBsMnizRNhIKAoJFzwx7R0BHbBIJX7Wuk6kF6AUOr8/ALdZvCCMiN20HhsX1+f0d/fbw0M9vPbMSAMu+mFenB42OfDtWy7zWCuJecOCt6q3QqSBn44EnH5fbqGEYLS5AYcEmBjubxoOS1GXQxSXfDlAGZHR0doz549ch9wl0CwB9/N1YKvweMDOQkKsltajuKL9LWCxz1I9uHeUty9HY3dEZCOEcgM4LpiEYUEhMPjolGuUl0L5wJsSYs/Ssew7BEV8hLd4LHz/nvvCV8LmdCnnnxSul8BmiEbAHA8lMuJhRAeJ4CbH5vNZWnvnr0CvADE19dLRjqTsYdyQ/FoJNrPR2ItXwjfvr1sLC4WNntJe/EFMTwx1uLvf229XCr5plmPJVOoB8J8k2wGPuLso50YpKxIdPfhP8gYW20UgmwVNhUA2rZwBC0BWphL1tYLVGbgZYXsjSYQnX3H5g0ADBszlCedhoO/hbL9A/GIFYoszM3djwBpI1v9je9/r2lGI+XZ27dK+fVCo1SteIH3q6m6MY10PBnes31HMh4KJZZuzkV+9hd/YfDx93j2e/HbED3Q1YtHDYOBgsE4wMyNDBmnn32GJia3CXn95twcffjhh3Tm7BlaK6yJLhKUxT+7/DmdO3+erl27JhycEE/EULVH5iKZStDC4rzwcQCksI6HQ7xQY9fqu3Tp4gV647VXRRAT3J6jhw/TlrFR8XeslIsQJaW+dIomxsf4Nrsj2BpM2Mh6AWl1fOEEjChuCf4GYPbsM8/QEX5eSyblhgC7qrIdsRKxeJgfB/2BULFY2BTwgkYUH35ff7+TGx6utT23BT4XAXwx+grZofbw0LAzODjY5l25B0B0L5DxGEm5bQ+uQm4AFlGyQ2PB2NiYgNbALgjAI6DABE5BQfYI4AeejYFhdockf09X45de+IBzo+TDKchu3RtY5KLhiGQkFZfL25BI1XpigVck3pso0fNPlEs/u3SJLp6/ICKo26cm6anHH6fDBw6Ipyd039bza5K1yPFYGBnKSYYPj5UF1gDvL0aDgwM0xY9FVg0djQCk0VjUntg6kbBDof7lpZVMpVILVyrV3jz4K4pv/7N/5hdKpfbtxYVy021XXcN3sKlAphWbAemi5TEYCKLe25wRcA+7cl2dTFeHC+gpRXtfbLWow+MS4MXjAiC7rXXpxHJKZ1ojDPoA3Hwo1vNfMomkNTEyGk7wbs1w3VChUDDg4fmgmNi1y80NDzX3HTywvry2Wr1+c9bhF/bALcV0gi7bWChsDWez0WQ01jeQSqfr9Uao0XR6Y6sXd0VvQPTikYMXOR/ZBmRddu7YIQs/CK1Ly8t07fp1unr9GvGOUBZ1TIJXGGx9yovpdf4bwAEeh6xFLBIRcUuUJ9ECHtVkbmQpMKkqwvgNunLlMn366SW6fPmydO4BzKA0iU47ACfJTjFgyvT1SdkNGaEg02JrQ15Le7YhE4SyYrFYko7Hxx47Qd94/nnas2u3CLyWS0Uh8PvCG6lZxeJ67ObNm4Pz87dTDLqic3Mzm+J2cXijY2Otia1b6+Bm8ft1cdSqlSbvwqtbt20rMfhsZrO+j+Oep/BdUHil51E9nxDdSXFa0NEIyyCcB2QbwfOSjJfmcAU/A82u4Pe7/fEe7nM8yOi6OwvW/TdXzMibcm1wHdAMUYUC/npROs8kW8HXA9cb2UqMkYuffEKXeIxg8RtlUA1leTQp4HnxmfBcAJrIbOIzxGNxGsoN8fjbLqVmgK/uxRsaZOlUWkpaGJvlUsUorpdNXhAT7XYrc/v2bGZxcQ7WMPc1SfRi84HrFE0nvP6x4cbS8mJ17vZcxRHBBc9vwLQd9C6I8zJYQdlf6PRGR8pL2aR3yZ10h9gLua50q2L8B9ZR2EhgTIBSUCyXaDWfF5kYbCC65UmkccNTfE9sBHjeMZIMvJLxRAxkeJ5XTD4e+FXA5zrw2GPu0dOn6/wuSo1mszRzY7bFr+dhHsJ7QvHdcH1z9/ad8T0796Suz8xl7iyshPj72Ctj96ITPdDVi0eOaDxuRiIRaf4GP0l8/hhEoZUcXYBYw+DZJ759MI/lxyDrAHCGshBK",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "3Wi3fN/msUtKV80lX3fAbnD/EA/OlFKnbG1q4G2qzhFFrNcZL3QzNvkaAmyBbG/y32PhMEVCYcPmSSdkWbFIKBRdWViw+Nj0Ne2PRHw+2sPDw/VsbqiysrrSyq+t+djM8GbBSKVT9pbxLfHRsfHofH4tdPPylb/biezFbyx6oKsXDx0hnmAmJrZaf/D9H1jPP/cNc++e/TQ4mKNarSEcLkhBAHhhMT5y9Bh9+/e+Q48/cZoOHzlO+w8c4p/HaHhkTHS8oNXV4hUQnYpNpy1cLd7dyW0Q3ESRy2AwhAkUAAzaSZF4jAayKDvGO5wbTEotDRxgReO5LSHLY6ZVhrWecDCaTl2I6E3YGMHrDN14WnUcq7WPTBfKi1+hEqPWHoIMN2qnlmhA8fsEgV0p80MiwqY9e3cz+Nou/C2xB4IVEPhvfD5xXnbt2ilE/BuikVaR84AORpUFJFlglP2PIecGvDeACXQ48gZbdYh6fofvhHMLHlQ4GhegoXhd2oPRDMCXISDI8zfESQOPRfwu2mCe4o15XeVB2lBV6hwo1flygK9l6udVIAsdm81mSwAjuiv5jdMKAy6UFqElNzQ6SrnhUYrGErS+XpJxl8n0yxhVXaHaEsjn9wW+n9gh8at0OmC1wj7K0r7Xyd51HA40CAzGYpvvg3OPEi8MxgEAA44Xrh1fDytk28lwOJTK5wuxYrFkgSvZi4eLLaf24vDSfZlGNpcrrZWKzUKl7IJriDIjxh+y46I5Z2/IfShRXRUKeG2ML5Ez0Z2Ppgb6CoQrRQqArma9xsC5GlipC0ALo9wOb1I7ZPIRZfAVXV5ZDq+urW56XTVGRnB4vFltDg0NV1cLhUat2WhjcwMZnmQqZQ6PjPDX1I7P3boT5UFk1PUGqhe/XdEDXb146IjHk2Y2m7OPHztmjY+PmxAQPH/hPJ09e1akC7B4QNl9aGhEvBKj0h0XpkQiKUTm9fWiqMnnckNCxkbJqsqADWUkLIIxXhixSCEb1dffR00GWvm1vPCRMAkiKwUpBNi1iH6S7GZBfmfwFrZVa3dg/aPbxSEnIZ5qjaZITzSdpmTJ/n/23qs5kuTMFvSQGZE6E5nQQBVKtW6yye5RtLsjbATvfZx52rV5ml80P+DuvMzT2rW1sd1rNJu7S94ZXt6l6Gk2W1SLEgBKQgOJ1CLUfudz98gAqrrIArvZxWE66Q1UIkVkhIf78fOd73z4O5eAEYKdrRFeZGvpF2giA2iibtJiDZaL5lvL1M7bYLvGLAZPOFsRBcO/+93v8oL/8ccf83Nw3nBNwIJdunSJrSag70KmIwCVZmpwHnDdsBhpU0gI5YvFIttKQIDOmqcoYgYIGr7ElIXFATJCABNThvW4XI5ppCG7MxopbTQqnl7KR7fsY1NriOnfphmCMWv5cOxgUw3lMr8JP7J2h8ZdiY8HomQA0aMTCcZQBghASDOG+jzgXOrvmYYXhUh9yDDeAHZxjnGeoKVDsXeUuMLPYwJ7AHY6wcBi41gJOG36TADEbrdPb2W7dOx+q3VcHA4HNr3fbB5+zvYXf/GfJtevv9I5abd6veFgHNCFjACWLKUDxPxgmWfC2s/ye9M6rzhWWczKYkbXJo2CSAR0XcPRRJk0o4QYdfjYITQZhvZoPPKO2yf+OBraSXIxT7YrywvhZNQfxnHYi6JwROMswZiU5btyYPy9o6PDgkmYj0DXbNz8FrbZRZu1X9p2dhJ0gxZjt9NpF3727s/cH/zgB+Y///M/E9h6wLv6VuuUmQMYm/7pn/4ZL9w/+clP2VUeCz+0QLSD40UOjAs8pDCJVKsVXgDBvICV4ZqKfh4BGrG7sye2t+/z4ggRODRMc9WayOdQUNk4VztNMKslUIxZ727DgBZJaarK9diwmKpaaj69B1smmJYRTgKz1++bQRiag8nkhWG6bNs3qJv9fs/qdE4BvAwADGQlouF86V4o5MUrr4LxuiIKxTyHGgEE8DfouQC6/uIv/kIgJIxziQamC18WmYwArPh9SEANvmtYfPBZHH5FvczxkP2twDxyNqJK0eeQmgrbZgOJZ8KCikXQPX4K2NLP1yaq5wsBfVHol33cAulQDq+43b09tiqZa8yLJo03gMc2AbCd3T0en3hvFCnGBgAgSNuzYYEF2+eYDnWbx5PFj1lgMoSuwwggC8AFd//TVlt02j06Z2MOy2JE2rr2J4AcgVJojDB+dT1AfIvJZIyhm5trNIqWbXnvv//+i1n08wVupaW5eGKFQbU516Nz3L/38EHY6/eYnnJ9b+rXlRl3aGdsRs51tFhJE2zly6VtJfAY3OpxL0FMjzCjacjHwZIPegNzPBg5tmn7VuJaO7dHF5tH8vmkWK6FV69c706CCG714XA0ig1ZqgyVKZAJ631y89Pch+9/ZM28u3772gx0zdozG27qWm1slMtD97333s1///vfL/3i/fdt7O7BlhicAeaK1dVV8cYbb7CNwU9/+lPxySefMFODLDvoaiDQBvjCa2B3ACYMOziANfhQweEe7wPLA0xsWIDBshQKBT6GhYUFBgzIxpOsRJQWWTYNZVOgU/UjGSaajEciYDYoTL+PtEtw5OJoyCLJw+HQOG21LJrczN5w+Iyz8ZttUUSLeTSyCPjYrptLNV3M8CiBOxZ0PCaLgLvizTffZI0X2CywWhBqAyiAzQLjhXOPn4bayZuMcOIz4TIwg2DR0HRNSoSQx+zQTYsQGByYRNJOX4rmpQgfAAO6GmmYKnTufcps6VItTwNcZ0TO5wCWPq6s0F3+W1tfuMxy7e8fiK2tbS5bhLAofgJAAsjVanWxsrLKTGmrfSqLJLOJqcnh1IAAGD5VZnNaqi6fwWOqddpiAAtbDnwGl2DqtDl8CCA2bVi9TdZw4VxxpYAoUWxXnNqSGCzi92wCvz59fpk+Ij+rz/h8Ld+oCK/gJ+tXrwwHw0FvZ3enH8VxCNY8jKNUo6ntPc5XNnhaFqzOPtX3Aj8vlsysFtV3aW6a",
                "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",
                "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",
                "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",
                "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",
                "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",
                "m6NabIYKk1SDX+PkXFGt19iGApmLm1tbPLZQqPqdd94W9XqV63BCHzMYdPknFjII3+V3t1LTVS3iP6+pYgCEDDO47NM4G08itqCALQWbqzLbJcXsOLc4Voxl6MFwDpDZaCrNj8UGmWBxY+7YSMBQk6XvaizJDFAP5Vu47BR+R4kmMGgFAr75Ul70hj1xeHggDvcP+B6qlitifWVVvPn6a+L1114Xi4uLBMJ2xEcffWQOBkN3PBn7g0Hfp2s7swO4QGs2m0mlVA3ffOvt/nAcDje370/GIc0OdM3HIW1i6LoDcAVsbRKzJ5xO/AA4xrVnth0gCx6CYIEVA8YbFQA3Gl8Tui/G3b7IqQQizEfw8UrC0CzkcnaFNnQr8/NFFHw62d+/+Dqcb6HHzYWFiefnJ7t7e3G/N0iKfsG4dvmKPV9verc+u1vY2nxgz8bLi9FmoGvWntrmaNGYkwsHr1q86NIuiha5yPf9iBa6BDt37O7c3DS8KAyRLkxnHbkTZR8glH5IySSSVB7OOi9CVMKihbNAC3WtUuUd5i9+/r7Y39vnRRGMl6FSvWP1Yg04ACbAUiXKUV235Cm/ZckwXkTB9OC4EUoaj5iJc2zTKBXyZrVcKjbm6tWdx9ulnUfbbpJ85aWCDFkBII0tTo8/1avFKno7DTvqmpMAVHDsB+hFR+iwXCmJRmNOAbiEQ1rQPIHJyrIzulYizikE7PC5SuswKqYG7A9eh8cQAkYJnpOTU8WEWUoLo1mgqTaGQKTyA+NyN/wZEMEj+xCvRcHpmzc/JhByyGHDS5cu808OYysBfJ4ACxYwsAlI1bcU0DTTATUFkLrQtGajNDMYKJsTLV7X4EqzU7L4d5ieB7wHO/OrUK4sJTXm44TLfZYl1N5g8H7DOMfmBMzVFoHIra1Nsb29JTY374qHDx/QOTvm15YIaDJr5+Y4FIXzCyAI0IZrBHsP27KND37xgfXwwWOfQGyePo+z377icfjvsi0115PV5Suj0SToj6O4z3sYQtDwHWQTN5XJq2towlKEzXLB2ItpaFjORfKnrtMpXeoFV9sY9Qfs0wUGnceqIQ2eqRt5z3OqlZIfJ5EXxwHK9lzMDsTM0xvm43qzQbtSY3h8fBJ0O50YZsWFnG84KHJKH4dw497m5my9fwHa7CLM2lNbK+4Z6BZtzVGxjBaXpN/rjyuVSrtcKnVpzkeassqW8dIaZiyuZhQl65tFChxMfYiM1PtIp2TrUj7sdROG6SJbBSigBXlvZ0c8pMUdoZZEMRjYbWobBISm+HPo9ZgAtX+obufT+JMkOYu/lCGDjifgs5kxS2A3EBilYsGt1yqFnOvUc45d2Lm/6Ty+d/crWfDonBropmpP2hDIY5T6okiBr+lP/VQZruqxbqvZbLCvGgCPrlWJBb1KCz0AldY1peFhpUPCwgLdli6lw8yhAmVgmCA2115YAGMIAwLMgCHQIdEgCFNLilTLZNtsVcGaMHo/WE3cv3+frvFDZoCuXN0Qr7/xmlhfX2XzVmQYar84zhCj33Fs8/PzwqOxp53y9VmSAMg+I17XgBKvxbnRxc+1p5nDAA4mtKZIMpgdf0MYlAX6cZzq2BAGBEgE0yc1WR6DN5i+7u8f8PcB2Nrf3+cEBnzvRqMpNjauiLW1dXrPKg83LtsEB3wFANF0bUptdIvPx7mGdQhtfOzDo0NvNBo6BiiYWXvu9q3/+IfJYvNSRONwaDtOp9U+HfeHwxgbR2lkK8cos54qKxHyB2lfo6pgsDuOrGoBry4tq9DAKeQi5gMe/9iYgh2G1quLahxSDwkTU4fex6cNirOzs2NQf+7vYhgN7pV6g4Z1OKQNw2g4GoXdTldmm9NOp1qreeVS2d3b2be/5FM5axdoM9A1a09td25vG9QdmmpsWs7NwWgYD4aDcbVW7RbLpb5pWaN+v8/zjBYhIxtuEkg2QK/+7Omk2a9M6nz2p8gsmOypRAsXC56R/ZPzRalQFHuPd8WnH98UEf1NGqcmHO7CIqoz7qSr99T4NHMYX9j0n/VrcEMAcKGGJKd7S7dyg8Cfs7wwX/Rcp3JyclgcjEYmJsov41x/0aGpJrQnl866zNb409+TWT6AVdNQoOCYfbUc1xbLy8u8cEvwY6Y7dYS58BiMTwFEdJafBljy/UwGVgBn+B0gAewOQAHeE+8NNgqgBNcCzA7+jp86M1Lrzbh8DwvFR+wcD1Byn8B0q3XC73/l6hXx+uuviWvXNsTcXEV6hqUISAI+HKe2KkGVBJSh0iFSDRYlw+WcAV3MkqZMVpgpuh1naipKs8usqF4/h4tgK88u/MT36/X6ShNmsZYMTv9HR8eso8PzwFLh3HC1A/qJ84XvqTMpNQjF4o330ccdBBGHxaXkMWHWEG78yA6N4sja2tpyO52eNxhMnPNC/Vn71dry28ui3KxDSD84PjkeDMejiWFbiThjhsvbuKlWz5A1XmWFi4QZdeOMZ5eZdvwN9WLBkiGT2yNgfto6FYcHRzIEDxM207Rp8+F7hNi3bn/mPNy++EauUpuLHdse1+dq3WASjFunLd6G5gsFs9GYs8fBJHdne9OejZevv81A16w9td1/8Mik7tPCmVPWVkmURGG+WJjkPG8C7TNNHhzdMlXIb8JWEkOWl6ZgQP1XhpiSs9mN+m9c+0yFH1UmUBLSlEE7whxNVpdW18SQFrjPP/1U7O3scp0zLr+RmlUKBlvS/0g5SRuqf+E3lNOqrhcpvapkeC4m8IhJky0IXEeK/uPI9HOu4zp2gSbJMoFDr9e+uKv0FzUFEhRxk6j5PpsnxydJaIXceRYM4AB+XAA+YHvAcpXLJaXlmuqcdMM10wWe0TTg0Pow/BuASpfTAaMFwAHghIYwI94f4TQ8Dw07fAm+TgmEHLIhK3bxu7s7DLT29nbE8ckRf49Goy5u3LguXn31ZfHSS9fFwsI8AZO8MqOM2P5Bx6Dxb5kBZnHpImbZkMHJBbkNnSyrxPOOCnWaBKQc",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "ZhHUA5gNWRzfB4fQQgq3UW+Iy0F6O07JRqFukB7GUVRzXtQGINVPfC/ozIEoJ4A35Evwd/CLUt3K5wQfiueUnzX0hog62cUjZ51L27HYkjtq6LTwzenwbilVmptL8zjkudKF9jfFoscrWcBOUrXQ1iXScJK21h5KiiUubFKd1MvBYgVnNDwyItGEaq0aRxlghluDv0TYPF/MU09/nyiB11EuL02zTTqk5bDa6pl0OqNNM8nwbshUYWoVIQPK9GssPqkUqhj9IMWe0p1+6ikLY6lr08OOmoFtkxfmRq3RDKrsbMmkLiKlB4aUZbPesHp6utP9fb25zU9tze/cvucAEbSOHYrt3LlTSPSITJbLZQeVYyriEWopj5TMJUxYNLPeu3cffe/uu+l2Bl7f/e53aXp2VsCNiTAohe+sRBdQbQvRW0S1stk8g5iKgJ75uVIMjBZHX6xFMaPk4pqUX4h0wVkycqN6eQaShsS90CWblH6JDqt+nzaNjIxKBMREjE13BJCqzzn7bLr26mvojDPOkMo2pF8luqMbUYOnhSgQHsNGJptV6ufPnJ1q37z8R9hiHlmUeK4V8TKRpSQHTUeewH31Vq9aXV63bn357LPPqZ922ovCq6666pCPqQowxHsunaa1QJMwBUGWUBm0H0z8P9QeaGERkIo6WqjEFa3CrFadN/5JeKyoutYcWZxTG63CipsvdewIWAd0dSw2DS50pXoUimp0ENoonQfZ9lCtf3ggLHQVeP3idwvDaCFYUO2HrMUgKxFGj9OLOvIFJ4IFo7evLxZYNQKFUkqPZtgQrrRVmgcLB85ndm4ujq6Fic+LK8cooQmk1Wri/boVF7erv4WDRrROt1wJVRkmyPVWynHtXDqdyeey6fsefdTlsXQVYz4PAoyXyeVr5VrNm5mfjyIDSIW74wkpGfIR3V1dThZs3blSnk8wtWvjxs79e5jskUcesXhIKr1SqdhYjEx6yfB5JC2jozyIzKIi7Mc//jHdfPPN9N3v3EUbNzzBr+e/yWSVFAopbqIv1YmqUAORCnBpsBjiMZFNsV0tQmLCWMosWjoyA2vjF5mOBvHCrFNRZMWLLO6LHIO/DIMj8IQgFzE6OkJdxS4B9hD9NXMtm00z8Bqhk046gS569avo3HPOofHlK+T8Eb1DY22JsPE96UpPQBIBYlp0Bsba5Rl+k9VxS+1LWtQBLbkQUTwg1YJ7OANwRaoiOY8UsW4fpi3g69k88aQTKueff17jrLPOCa699rrnBVIiz7MipHNFYZYsE12F1pqriyMkdaw3qOZYwqilZWiAE34C+AN0wcB/NeAR74GoP55HStmkjaMW6Iowkyyrg7mOlHWcdsdi06Al5IXGx04OpHoeEVKNNpixh2i9Q31hZJM/NzfrNxr1QG/MY+9s64auxlrcCjU9Y+4VtUfAkA6RSkZ2HIrD5cmiAhAEHlipUhaemMuLYEG3vYDDQYpIqVybvo9G8VoDMH0c8TKhj9XSZH45LkulPyLLqIS3WrmIA2OwWsgX0ryoZWZmZtKlcnnJKtDeiYkoXyz63X19lWqtVi/Xqh48nmo947XJUWQzWSuTyaa6u7sL2UI+88S2TW4n2nV4bM+ePahcdEGiR/EDKneFtEwq2hXotiwKsDvyeMgzef++Kbr33nvp1lu/RLfefAvdd+99tH//lDyPOWFS5I5u5+LYKUkpIobpuqr/YgsqtVfMmjm3lLXkChxJ1ZNwIENdUUmJhvKRNNRGmn1gcEAiXohKFYsFWrVqkhfeXvn7dAqVj4qUj/sJYBNg47hjjqGXX3A+XXnFm+i0U06hsdFR1YXBSBPollhKYDgOHC9h/zF8rwNjuwToIlo08JTZDCJKiffBNUGKmDdw3viK8fro2Fj9Raef5h0Kh2uhBXoY3Tal4WZJZSHSja0TWQy+je4bDN85ABWAPdKI0CvE5tTRLaLwvOHAomsHzkl8iObfJjsjdOzIWAd0dSw23vVEGOxYPN4VN/mGDFKpdGR21Ye6wHcXuqJapRru27fPr9cFdOlwGsULmalaNGYcC55XHBKKK3SSOjoIjQN8zTGYQtWimyiZV0TSuiyYWHTACUOkAgKqErFQH9QippIWHYylKWnR8RiwhRSladQt18dWMg9ybIGqLsvn8k6xUOCljNz0Qbb2I8uXh6MrVjQYNNYZEDb5ZwhgKC2HpIpRLci2Ime74+PjmXQqldu5bbsIlnWA1/M3gCweLsj0qNbFBgSGKJX6yu24SkxFlxwBUQDs5VKFHn30UbrjjjvohhtuoNtvv50efPDBmAuFOarmr8vfX4HnYo/8fblcEfmIuEpW+FhWYu6pfxsokEx3GzOzSmbsArX3+LkIpP08DfHiu3zZGA0ODEgl2/DQoBD9oRMmGlu2qpazQqW3lWNwNsSvOfqo9XTWS86Qfo2vfPkFtHrVJHUzaCMdiQ1lQxQpkNg62ni0W3uUqcWZXIIcvmAc2BZBpgWPH+AvdHQr3lAJRcGNG0wbuoKJrI8y4Lzgggvo7LPP9o497thaLpdvjo+ves6VikuZh4hkGFpqj6WOxZVjScvxhZocv5Siv/m3yHMwiKpWqgz896uNqWrtI88bYj3ODWlvAHBHA7w4JKg+HZ2ADsdpdWwJ64CujsWmcUHU3d0d8M0KDhYiXRYvQorgcogsjBSlo/J8JZybm+dNox+oJGYL2ojQpIhKLjEdNTozmjiGX2EI9nAqCJNjV4dFzuhc4UBBUK5UytKHLs871B5eaLDITM/MUKPZUBwdA6Qss2IcXIwxCcoM8d8IUsq5aIcJfcNcJmOnXRfNY1P8Onvv3r1LvunE+vURjzCyrDqParlaDQI0vgTXQldu4pMB5Pg9rWVjY1jFc6XZuczTjz5qP32A1GXHnr3t3r3b5pEKAt/p6ipap512Kh177LE0MNCvNwQkgN/oJsVkZunrGQnxGYr1d955J9100030uc9+lr71zW/RExs3KukFvbnAotjd1SPz",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "lcvVqWLxaP3cuRZBl+DW7Rvp4vR0dn5xMV0oTtkxeg7wXAnlb8cCecXw6QSa0HQ4MDi0KL37ZHIEarTCSy0M39LzyEkxSrifprEGwApJE2yBxfdB1n31Dcl6BcxqWazlAyjm+yVMfk7gpwV/rcALIjdWJ4mGyI01qOiJmjXTCT4yG9qlccKTzGpYCkpmpKIPwsO63qx77cHA752W3mPSJqBr0j6/hklhaX7enS6W+gQivFg8ZhDgiNNgltzZ2Y+f1ve+9dZbvJ1ZXYV2o3/v/n3kNDo00vLAwgOUEGOlPbSzu6tCcyJcXaoisv5TmAjxZGjnpG5DC1exL+3bpe0iIK4HAHvw4AGbT4IFCu0oUB4IE0qPJrtOmyYUmTkFULUEYX2pJDY2NzjU2KbJI9AZTLzalXUhcT4swDbleYDtgqC5VCwauUwmnqbZ9qNbt1L37959bqd4nN/M0oI/t7zUd3zRJsRFE19liHkK5ZiQ8YbJLBFP8OSVJMCBtP75ublkcWoq85d/+x8yP73xnvVZWbdut270ei2z3+/Zw+HApHOXQnprJC7+OLeF8fvnfzzYCkaC+vH3nDSxlH9jc02a7cBQwsIBFiDTM7MsulYXTzEjkj2TuG/k9m4oP6zotR5949ObdsnnfutJ4TUmYU/9hPYJ+4Elifbkwm65BqQrMxNl2DEm+y4zYBpkOJwdO0t98OWLl8U33v2a+O3f/E3x3/2r/0b88R/+ofgffvCnvP3gT/5Y/Mkf/ZH44z+mn3/6J+L3fv/3xNe+9i7rx3CZkOFM/bQ1GA76U7mCO3UCdHXKZfPerbuxf/u//9t8p9EqlvLFwsX188kziwu2MxwaYNP4mUC4dDgMGs2ms7293Wq328e5fL42NzfXXr941j2uVWLbu7vZTDaTOX/+fJyup4EqEFLjpEr7qMw+rfvj0KzrRa6DrhkvGU+MIXg+u31ZMQLaLb6PADV0ncBAx1MJ1oRC2hDIVMOx+6iTG2SihSylhT4CRtJ3PbWIG7eQ0As7TaXpMKhmU8GgIsSJ+4hzhK7N18kjhtwfjgnMO/09gJF0uVoJqrXaBHSdUpuArkn7XNtMYdajAXrYbNRpYTXwaYVl0T+SzVbjuYswf1J74+23/War5Wxtb3frjcag2WzRWMlNlqwxZJkPAAGZqWiMBNBKpKzp+uhxngxXPQ1saRGsfr/eYHaKDEowVelMGqWTRL1RR0hENGgiBAMH0blcsSoxrzJOHSon7JmZGbG6tgo/NP4dnzPDMKQU4rqquLcsyitDX5YqA2MRqqN9WNOlUnJ3ayt3XKkkjjc2rNrjx891vc+99FqwfvlVvzA92xu4Xnv/6KjdaDSdbqfHGMW2Yjx5a91QMpE01lbXbDqWVLPRyNE9Sd2+ceMzMaDewDPcoWsRaLYJaFtheEyM2K0wdf8pW7SNosUnw3Yq3KhAeChgFiLMLowCMblvwRO7DBlLgTeyFXP5gmSgVEh59H5dDsaIWAp8QsZiML6N9iG/Xy8itNgbvwPE46ettFwe9xWpdQTwx2StMzLDwJa+TPqcaYsTwMjgfLIZgGixvLQkrr58RXzpy++Ib3/nW+I73/2O+M6vfFt865vfFAR4RCaT5b5MwMjrtDvDbK4wKBSKbnpuLsggO5Jat1o12oeH5g///IfJB/cfFnKZ7NTaymrmtWvXYrls1gQgGdLx63tMxx1UKpXBzu5ui56RGo0xzXfffbe/fPas+97Pf25S34oTuEyl02l6vGzD92ABZghadKgC9MqXT2mi+Nl1VSkgbSWjQ3mqL7g6qxBCeWMEjGWkUo4dWGBBqC89vKzQ4kUzlMw+WWbIpHMfUUASjUOXkXqPIYNujEyYo8ekxxt8V4cWYqgxyQWuNWvLhqrhh/jS0Xl4g07X70+yF0+tTUDXpH2uLZee8h0XlpVmhwbbPvQXtNKO02Cf3NzcjG2eQk1G3a5fv44xxrXtGEBX76hcHgB1aR8kM+Iaz8aGSgfhqglIT3bRrLePc46OAi/dok7S2DfYAjA/GIDjbCWRJRA1yyHEjY2NkM3SPl9a56HLk+iVPRiK1157jQEZTTY8yMrVtmRWZIKACIW4rFUDiGMTWEcU83kzn83E+r1elo4rvbm9HW8Ph88NgnGsl157zaOVfd/1/UatXu9WajXH9b1gqDQ+pvKNAnChSdSYnZmNXzh3PptKJrOPHz1IHR0dGbT9Yt9r0dnRxTI5DiRM6Znlhc7b4hOYLvmWEyBM3vjR/Q5G2YmaiRJhmSitrTnZN9hBg/3Vuv2utCFQgvOQnVD3eLQpDdC4wGzsGPW/I0bw4aY9w3DvjdCtVjKtrCtSBqYjnaK2K9EZcp7y43JlhQNakGAhEFPheD5GfJGn2SG8V2Y7wuYEn4HQPgu9YTpN4CY5YskUCGi1W165WnbSmZQztzgfGqEGvZ75+PFm7C//8j/kO61OyQzE9KVzF7JnV1bitC+Da546LvchaMKOG3Xnzr273cOjo3q336/Nzc93Lr30krN48WIw/eCBqByVYwQgU6srq/E8il47jjHy2TNCYTrC8SKQpb1gOcGMtzdiM6OJEdKeQS3YOGtYAitdHgjniOeZpQpC1WEEwx1H5moszB4Mw8iGXBC4yjken9csuR4LRh0y0h/U8eiwtKt0g2DoOs0Wl3DCOWjQzJUs6N7CNLrnDAIzbjuZfM5JpJJ+PJmcMF2n1Caga9I+35YVQTqX8lbXVjs0QHRhTkijBY3jdnJnZye1u7t7atouDOQXLl72r77yar/ZbnfqzUaXUJgXAF8Bk0DvBLNG25S6G0MNSpwJ6Iwmo2g452PCTie/O/r+UQkPGarJZrI8kSG8iOLWKAeDIsgHB4dsVJhIEDAzbSXsl/XTXGXmytYXNBGiQG9hqsCD9f3790WlVmFNCYS7yN7TZrBoLB/BRIvsShqUkzYYiqRVLBSSnudmtzY3MqbpWqJff25918LCQnBuZcW9culS57jV7FSb9X6r",
                "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",
                "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",
                "Jx3ZY/EY92dT1RtEn8PzUy5XxP1798SHt25ZDx48SM0vLCRfJcA1Pzdngodpq9qJyWSCibWbN28O792/1xq6To2uW/3s+Qu9lbNnfdqeuHP43IP79xNx207Toi5DBxcLHE8kUJQbWYK+8tVSWZQccnYDzjLVoORZEgB9P6MMlw7fCmP0uqkYrDAbUodtAymqR7UJbGBOPUcyma56lkP2G3pNAlvoayOBP74Lxw3RPXzSbL6v+LdlxYD6VRKHYG0YDFGl3pM7gQDJ6qoyU3DKp3P1qc+4qXRmmM7kJkWuP4c2AV2T9ktt2VwuoM2dKkz1F+YX2jn6Nw061lHlKF2tVeO7u7vmaWUy6ja3sOA7rjOs1RttWo33642G3x86gc+aJ1sxF+Yo/BLJZNTFZMeYkqe4bj4xgBsionsJwgLXPGEa0vMnkyEASuBLhxoXFxe5UDQm3eNajTMttbYrynroupE6DIXC2vgsmK+tzS1xVC4zkESoAROMtjBgwEVfDiYgzgWLXVHIZsxiPh/vNFo5WomnaxsbMdpeUJgRZWdywfzCtEOgr00w43hv/7ADRkOW6+EZSorIfZ8z4abyOeP8ufXES5cvZz68/UHu5//w00RQr5u08T5dt2PQRlDVB4wl0OUZsg6lmk+MyP2IJiWKcfZLvlWXgZF6GYSCWJUfiqO1TmcceEX3FRqnqncA7OjagDDRFGpylqL2gcxeVGa84T5Uph9YPHoeuEwUslkBrJlZUaL5aM3QkyyN1ixhcuYECprguf5nKiVSiSRntzn0/WEfNY0nwIb82zgIMVT4VBiysDf6VUz1Sc6YhVAf1giGqWqN2qJSrYif/eynrDU06cJev37dWltdNenvBhgunCf6JS3Eglr92H34+FGvelw7JmBeo8VQM53NDq6//Y73NCau+uCBUXv40O53Omnqw7m1ldVYPpNFWJFBDsJzzPTq8Km6n7qcke+NmKyTkgF9X3UGqQRc9ihBwByBMAZO6v4zi2bI74FGC7547MJBe2LLF9RXVbYvrMvCWMCM25DlArrT6vuGn+P9VYT3WGdXI+mi3Wwy4IrzotHmfsLgHww33TW2yPF81/GCYTydcdJTxQno+hzaBHRN2i+1ARDk8/lgZmZmQKvdZjKZRGyIxj0fsQ641MfLn9Im4LO26+++GxiW5dFg3u90e739w6PhgEAXJsg+DXzsVK/K9WgANBiMl+d4In3cNCNi2/ECxU8byKOTpGYZAPAQaoyr7+XCyPm8mJ2dFZVKRRwR+LJV2CJkVRRww8SuXbAx4MJCAqJ8Oj3OZmzDnTqQXI7jRcqbsNGPLz2GaF+FXFbMTpesQi6XpL+kf/Tj/5i6+/DBZ66JeLLlly5jI+C15MQTCVqYd5vNdqdbrdddmnj5pHTtP13uZHqqaM3NzCTy2Vwhnojn/68f/vvUTz68wX5irUbToM32Xc+WJYSlW7rPvkmuzOxSbEMoOlcTLWu4tE2AvDgyHBRqxRXIEkKZfgZ8nZgZigj0OfMvCEJtjzJI4/vS78vrj/1Pl2Y4w1RP9GA7cCwAB1pobUFkD0DW69Mk2lKO8JYUWxO4Qmabp4xHtY5nQPe4Sv0DiRX4GwZ5yYD6IcuFzDkcE0KLAEPIdMPBujpDUhd3ZmHcqOyMEFKf5qvT4mxQIYEp/KZw7hDpc8KGdkX3vfB+12pVUT46Ysbu7Nl1cfXqK7wYQEN/RaIIYxNCqpvbW87m9nZn//CgbsXM+sxcqfsv/9s/cH/l1349eBrgQp/86N49+8bNm2l6JrMIK2aSKZMZIjpvCOe5xBfAkRK54/4xvHc9zh51uMC8r4rWq/vunxh71HfLChERWYE8iLHwrKlDzDqpQT1jYNXYB8yVLBfuH6630P0Qt1LVyLTUfqSprLzH0X/rfevvYbUWhPJ0jXF+yMLWgW7WbxrqybDswLRtl14jVGx6djo9yVr8HNoEdE3aL71BBJsr5N3C1FSXVo49AhduvpC3aUKFSWeK3mI1m81TNY5ZXT8frF+87BxVKoPd/f1BdzBAgITAmM2qIAxWceXdhQbmISqmjdpCnPz5SS1kuIQY248GWroAMQAUtDcwLsS/YSoJxgMTpU5Xj4aatN4DP6EdggfX8soyC2kfbzzmCdNmGwk/zH7Sky3E5Bi84RWfSSaNsyvLVjxmJzceb2RarUZsd+PeCx07Lr39dhBPJd1MLtfqD4etaq3e7Q8cF2WacP4hgDWkG3o+l7XOrq4maULJ16rHU4QEkgebm7bhG+ag048Nen3bGQxNF2VewtV/JHtRZ5lF2K7QiBQgCiA4vBZycuTCzjrUozRB0Wsd1VaNWC4JbAHMoNsB69Prdfn1FBuRWir+KAEfn19MmmXyhOq6I0NTuicADjDSZR0PAAKAv7KD0JM++sTNGzfEo4cPGeAZqv9oPdpYZqE5Kl6tzyVQpXBGiSMRraLamAlj93RLMni+8rBTBCJ0jwCd7ENGCwfYPTx+/Fjcu3efTUGvX3+DANfLYm5uTjQJHGAxAOd7lMZpNBve9vbWYHd3t1Gv149tO1afm5/p//Pvf897Wt/RbefePatWrVIffVxIxRPpQj4fMwIpGecMShbMm6HQnI1PXW903x13TKCuvT80CB8xoOPeWKNrG6gyQv4o81TpCEOLD7W4McL9+qENiKE+r410eb/+6DtDxkyMjksvAqILPAbJyPhs1LmPIHwsDW/l2ILMZXlv4nRvkm4yk3LjluVj8ft8T/GkfZo2AV2T9oVoNFjQdGkMY/FYJ5FI9tJyYoFRarbX66FE0AtxRn9Wu/b22+KVt97y2p3OoNvvtxutFn76UlAvg1MYpCwlQkfTnlKhx5UYD1FFwdiYQFt8MiDTtfJgmIgsN2QpahsLsIOlUokHWIReEcLB66F5qxp8dagRuhBZ5zEmLpy/IHK5vNg/OBSHR0dcoxGvy4OSXkJcvoVDaRDVDxATE9NTBTOXTsfTyURq0OslHt6998LLNV04",
                "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",
                "8OvKbG1t5WniidPq9dT6Lb5/Zf28//ZXv97f3d1r3b79UZNW4k4HhqM0UTgIKaJWGnQ3qtbc2OQWGQijE9gntSjTFS07g4YJCqJrTHRcExLZZiqzEZmMiwuLPKD/7Gc/YxE1r2xDwGcyYJOZc/3QPBUT89raqpiBkJnAxFH5iL2fwJbZzGrIUAWsI7BCdxUDRt9rXLp80Z6dn800mo0CzZuJ+nHthd8PMCO0BWvnz/dX1teP9/YPmgdHR71Wt0OXxQ/MaC0/TIB0jCvLy8aVyy8Zw37fgD8RmqV0TtKTylTnprU94cUfZY2xb5IsncJGsrTv6WJJzJRKzFDhIz26TtVyRQwIBAnPU1lsTzKcMutSmmTCUXzYG/DnwT4gG9awbQVmVM08oe0aVGkXVeYJ9wX3DWWdNJvJP+NxPm6dbegrfzbcp7COoGY9lWbN86XHlqFmd6n1MpTthfKZigCJ0B1fZeoayrAWGjRP2VXAVBW6O4BC2FncJBAPNuvSpUviW9/6lihNT/P5weKEEwdoz+1Ox797927vzkd36tR/D2dnZo5/67/8/e6VV66hUPUnM1wIq1eqxv7WNsLImZhpT01PTydKxSkThaGxEIHpL0LwsFkJwZdphWF3Z6hCe1zoWhqKanCk9XFehB21lEmyNjaNgsJnZFM+sYVeagjLInFCgTL5gdFndXat3o82WR1P0tFsth+CMoR0kZjQbnUE2L6YFWNAyc8L299YzJAGLEv0XDoTd356waftky75pL2gNgFdk/aFazRQ+rRhtdungQ4bJlobwnpYSdRqtVM1Tb148aK4cOGCP/C8oYjZ7b3D/UGlUvEAejB5uaouHrK+tL5GD6baYylqCxEV1aOd/NvJ0GL0/QjNgFXBJEerUnaql2aWglmNTrMl1tfWxNrqKgMuhBmb9BoKdcdiCWYg0mk56WgNmjTQdHlfZ8+uievXr/NnHz18JH2eUGpmMOSQE7K9EKITXBtuwLom6JfMgE3rM/1uO/3o/m0Ulj4Vvd1Lr7/ul2Znh4lkst3t9doPHz12mu1O4PmytE1Y3oZ+z9H5LC8ticsXL0HrxYBJZ2ViYtOFwa1wcjVHKf0KlEC4Dgd8d+gyg1YgoAVtDLRBAKAAYMl4Uuq8FBiK+jox0NGMhxCKtRJ8H3E9wQbhXjArBUsPfB9d7y7dY1OxqAwCVZYgzhNgBoAKrCbCc4Hqg54OTRkjjzbovgA42NcsWqdPnqRWzI9AggKgfjAe1tbMKoNJZd46Ai4wOJXaujhdC9yDra1t8ed//kPx/vs32DLiK1/5qjh37jydd5cd0esNgKCh6BPw3N3d9//mr/92cFxrNIrF2fo7736j889+5/fcX6hj1GpGr1w1H9y5n8mk0rmrL7+cSSWSNoAUrheYJoDbQiFHx2jztdfli2BMy8+qyuIzlC0GW0kosHNSrwVzZDzrCZXBrAGUEBEW6gTwChM0IgspgC04z3PB7Ugol9+qkjiwmYolsxRo56xZbXOiATKmb5/6iCM1jtg/F7eO9PFAMfR8aIHMMpWMedKP2ZZLz7CXsG0/oVjTSTv9NgFdk/ZFbBzQWV5ebtMA0SQg0fNdP8hlcjEUw9549Ajpdqcuqr909aq7uLzS3dzc6dTqjZ5hWwHYLoGyJoHUyLARZGgjMZ7JGJ7Mpwg1Pk2QazKLkAjZNLSYEtazQFyMhNbQNl25dJm9mXa2t3mFa7GDvstgw1Xam1FdP5cBQ75QEK+88gp/J0wrIcxHZl0qk5ZhMcVwcdgSLtooE0OfLeanrEvrF+LdVje/s7mTBhCm7YWHfXF+cJBaO3OmRyCnsbe/X3U9rx8YRmAnE5xoYCpTSl0yBcJ/E5MpPKNQ1NeXVgu2bYbnFDqOa42OIcOEYKPAZA27HWHSBJVOxEUGABb3GAabYEro/FsEInwCF5ZipZhxcqXFRFhbU3uEqcLD+DxCmPh8hz5fOTwSx9Vj0aw3aGvyRIlrzEaZOEZlYYD7hIkTdTh1kXMGRCp7UYesNBul3dYl02GzPs1XyQc64zKsrail24HMa0Q1BmzwbhvifIQspITXEKJG0WlZLF2mQ+J77927J1nWckW8dOkl8Wu/+j3qoxlaLAx4Q0k/O5EU2UIxeLy9PdzY3mkVSqXy9Pxc/dU33+wmU6lPDCWebB/s7trDuJWOxa2CHbczc3Nz7B0H0+Dt7U0UsxcLBMC1A74Gx/o+seWLO1TZpiMbDT/ynIYieA7Zx0PQpVmwqPt/tL8+bVEVrRahPxeOEyocqUONDLJUrUuhM005LOiPGS/Lv2OfDpelQp1S6A3R59LJhFp0yGoAuH8DOt/uoAcnej+dzbiFUrGfLeTd4tJSMLe+/gs/m5P22doEdE3aF66pQSsolUo0Tjht27BaiUQc7o/27u5e7uDwMLO/vx+n7VT779ziYuC7LgTcnW6/37n74KHbcxwfuiKHBskhQlE0mCG8AqGxLq3C2VKwOFC6Ds6YCzPHVMq+GEUTAnnSgod4WUlYRby0vkRtvlzdIkSWzWTZ9BATOzLUsMIvTRUZNBztH/CGf8fZ3dqXafHsFeVIA0WANXbGNpgheu3V18TC4qL44MMPxWGlwm7V8FdCGJV1XvT9WGnDt8uilXXKtI1cImVn7HgqZcUyH/78JwnaTuV+LJ4/T+c25WVzuf7M9HTt7sOHjYebGz0ftvPxWACH7bpid7IEPpMqo8+hCSYGfRrABMqpeDKsZljS1wpTHoAEyAVD2y0Q4OoQ8IwhLIvrhqLnAEBwDifwYqgbAbYCui+UWjGYmTBZ+2SbNnt4cf4jStzRz5hh8+v8GiZeADDYLdCuXNr/sNvjfccAshlEGhwKol2yLgmTKqBR1LNNM6rcozCR0+fB0CUIHKBvQM8D0GWrkjQhgBBCAQxPSbykiJ6hm4EwaZyuBd1lWlhwOB1Cf18WSI7R/uLQ1Ck9U71+LP7u7/5WPHz4QCTp9e/92vfES5evcEmdRr0lev0h",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "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",
                "u2V2Ok2TXkOza9LDqul0u6bTp+l0TNtuG7bdNega4Un3BYOubcN1O/QQ2zO+q0BuCLqG4w861AWFSIFUDVqP4momIjOufmepyezfl30xpkZGfLr7OVcuXmplksn28eGhj46z6enp2IULF1LZXHbk8PBgrNNqjfQ73bTatq9tu16dnw9oOrNzM73puZmu7dgeMjEIWCDlwq6mh6dgZe4biqMqGxLeHJacsFgOwWc7klA7Qg4F0GSGQwI5DiyGNvKJDAAQywz9+Qwlm8AK27RNaRZsLIiRsVGRHylSUMzydo3T0zyyViCFI+vV7fZFJpMVhXyBAzZ0lQAuuISidJZQdsOTfoaC+PLyInfwEcgSo6MlMTk5wbNAf3tx9ULsxiuvpD3XGem0W7lOoxGj+R+CLozF6emAplOpjNnjE+NOoVAIcvSe8JoEeNBmyDKjFZMT62Jo+Y4v/hgIlmINwW+6fu2auHLlCoM4lE1RWtTkeYBHZLTQsfnDH/6QpTO0jQ1+jjUA+HEcSZ7Xdk1CfvrgEIaiuGdLnX4UeCmVdRbyZHV1meXxPKm0rr9qwAehVWiGZdMZc2pyMvbWm2+k5udmrUI+R0HRpmM6JmZnpkSKtnFqvMKemvFUUvIKFUcNcF1vt7bmAcCDsfdYeZyOfUGk6DxI0rrga4rOn3Q2x/Y4OA9QrgbHj8vpdDwAtvAecC4A6EqojKIwIs0NKFer/cG6QNgX75XS7wMleHovcKMyNNN6ZuTU753S/z43z/8sze+dYrcG/DuJLsqkJPZDvJQ+y6fL0Ts+PXbjiWT/2vWbdqfv+Mbk5Jle4/L4qEX3k3hxpBCjtTXonBRleoAZKRVEhda6VCrS/seFB/0LKwiWLiz5C0vzZ5LWv+04d8/V913cQFI0cR/L0MzSxIlaULNIf1cMfH9EzZJ/do5i4uf0uhJ9yAiddUX1t3k1c+p9M+pz9MTnJsXgfh+LzHM3rG//+P8BfFyTV7YMY2IAAAAASUVORK5CYII=",
            }
            task.spawn(function()
                pcall(function()
                    local getAsset = getcustomasset or getsynasset
                    if type(getAsset) ~= "function" or type(writefile) ~= "function" then return end
                    local fname = "blossom_girl_v1.png"
                    local have = false
                    if type(isfile) == "function" then
                        local okF, r = pcall(isfile, fname)
                        have = okF and r == true
                    end
                    if not have then
                        local b64str = table.concat(girlParts)
                        local raw
                        local env = (type(getgenv) == "function" and getgenv()) or _G
                        local decoders = {
                            function() return crypt.base64decode(b64str) end,
                            function() return crypt.base64.decode(b64str) end,
                            function() return syn.crypt.base64.decode(b64str) end,
                            function() return base64decode(b64str) end,
                            function() return base64_decode(b64str) end,
                            function() return env.base64_decode(b64str) end,
                        }
                        for _, d in ipairs(decoders) do
                            local okD, r = pcall(d)
                            if okD and type(r) == "string" and #r > 1000 then raw = r break end
                        end
                        if not raw then
                            local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                            local map = {}
                            for i = 1, 64 do map[string.byte(alphabet, i)] = i - 1 end
                            local out, n = {}, 0
                            local len = #b64str
                            local i = 1
                            while i <= len do
                                local c1 = map[string.byte(b64str, i)] or 0
                                local c2 = map[string.byte(b64str, i + 1)] or 0
                                local b3, b4 = string.byte(b64str, i + 2), string.byte(b64str, i + 3)
                                local c3, c4 = map[b3 or 0], map[b4 or 0]
                                local v = c1 * 262144 + c2 * 4096 + (c3 or 0) * 64 + (c4 or 0)
                                local x1 = math.floor(v / 65536)
                                local x2 = math.floor(v / 256) % 256
                                local x3 = v % 256
                                n = n + 1
                                if c4 then
                                    out[n] = string.char(x1, x2, x3)
                                elseif c3 then
                                    out[n] = string.char(x1, x2)
                                else
                                    out[n] = string.char(x1)
                                end
                                i = i + 4
                                if n % 4000 == 0 then task.wait() end
                            end
                            raw = table.concat(out)
                        end
                        writefile(fname, raw)
                    end
                    local asset = getAsset(fname)
                    if not asset or asset == "" then return end
                    local girl = Instance.new("ImageLabel")
                    girl.Name = "BlossomGirl"
                    girl.AnchorPoint = Vector2.new(0.5, 0.5)
                    girl.Position = UDim2.fromScale(0.5, 0.5)
                    girl.Size = UDim2.fromScale(1, 1)
                    girl.BackgroundTransparency = 1
                    girl.BorderSizePixel = 0
                    girl.Image = asset
                    girl.ImageTransparency = 0
                    girl.ScaleType = Enum.ScaleType.Fit
                    girl.Active = false
                    girl.ZIndex = 1
                    pcall(function() girl.Interactable = false end)
                    girl.Parent = winSurface
                end)
            end)
        end
        -- Crisp Header Divider Line (Obsidian 2nd-Theme Signature Detail)
        local hdrLine = Instance.new("Frame")
        hdrLine.BackgroundColor3 = C.rowBorder
        hdrLine.BorderSizePixel = 0
        hdrLine.Position = UDim2.fromOffset(8, 48)
        hdrLine.Size = UDim2.new(1, -16, 0, 1)
        hdrLine.ZIndex = 4
        hdrLine.Parent = win

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
        titleLabel.Text = "BLOSSOM"
        titleLabel.TextSize = 23
        titleLabel.TextColor3 = C.text
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        titleLabel.ZIndex = 6
        titleLabel.Parent = header


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
            f.BackgroundColor3 = Color3.fromRGB(240, 236, 239)
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
                col = dcHovering and Color3.fromRGB(224, 184, 218) or Color3.fromRGB(205, 157, 197)
            else
                col = dcHovering and C.tabLine or Color3.fromRGB(240, 236, 239)
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
            tooth.BackgroundColor3 = Color3.fromRGB(240, 236, 239)
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
        gearDisk.BackgroundColor3 = Color3.fromRGB(240, 236, 239)
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
            for _, p in ipairs(gearParts) do p.BackgroundColor3 = C.tabLine end
        end)
        gearBtn.MouseLeave:Connect(function()
            for _, p in ipairs(gearParts) do p.BackgroundColor3 = Color3.fromRGB(240, 236, 239) end
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
        addStroke(settingsPopup, C.tabLine, 1, 0.35)

        local mkRow = Instance.new("Frame")
        mkRow.BackgroundColor3 = C.rowBg
        mkRow.BorderSizePixel = 0
        mkRow.Position = UDim2.fromOffset(6, 6)
        mkRow.Size = UDim2.new(1, -12, 0, 26)
        mkRow.ZIndex = 61
        mkRow.Parent = settingsPopup
        addCorner(mkRow, 2)
        addStroke(mkRow, C.rowBorder, 1, 0)

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
        mkBtn.TextColor3 = C.whiteBtnTxt
        mkBtn.ZIndex = 62
        mkBtn.Parent = mkRow
        addCorner(mkBtn, 2)
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
            local pStroke = addStroke(pPill, st and C.toggleBrdOn or C.toggleBrdOff, 1, 0)

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
                TweenService:Create(pStroke, tw, { Color = st and C.toggleBrdOn or C.toggleBrdOff }):Play()
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

        local setSnowPopupVisual = makePopupToggle("Snow Effect", 36, true, function(v) mlib._snowEnabled = v end)
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
            ["Fly"] = function() return config.flyEnabled == true end,
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
            btn.BackgroundColor3 = C.tabBgSel
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
            row.BackgroundTransparency = 0.38
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
            local pillStroke = addStroke(pill, state and C.toggleBrdOn or C.toggleBrdOff, 1, 0)

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
                TweenService:Create(pillStroke, fastTween, {
                    Color = state and C.toggleBrdOn or C.toggleBrdOff
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

            mlib._spNextItemId = mlib._spNextItemId + 1
            local spId = mlib._spNextItemId
            local meta = {
                id = spId,
                kind = "toggle",
                name = tostring(name),
                getState = function() return state end,
                trigger = triggerToggle,
            }
            mlib._spItemsById[spId] = meta
            mlib._spSchemaDirty = true
            table.insert(tab.itemMeta, meta)
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
            card.BackgroundTransparency = 0.38
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
            valLbl.TextColor3 = Color3.fromRGB(230, 220, 229)
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
                    ob.btn.TextColor3 = (ob.val == selected) and C.tabLine or C.textDim
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

            mlib._spNextItemId = mlib._spNextItemId + 1
            local spId = mlib._spNextItemId
            local optStrings = {}
            for i, o in ipairs(opts) do
                optStrings[i] = tostring(o)
            end
            local meta = {
                id = spId,
                kind = "combo",
                name = tostring(name),
                opts = optStrings,
                getSelected = function() return selected end,
                selectOpt = function(chosenStr)
                    for _, rawOpt in ipairs(opts) do
                        if tostring(rawOpt) == tostring(chosenStr) then
                            selectOption(rawOpt)
                            return
                        end
                    end
                    selectOption(chosenStr)
                end,
            }
            mlib._spItemsById[spId] = meta
            mlib._spSchemaDirty = true
            table.insert(tab.itemMeta, meta)
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
            card.BackgroundTransparency = 0.38
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
            box.PlaceholderColor3 = Color3.fromRGB(128, 120, 127)
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
            addStroke(track, C.rowBorder, 1, 0)

            local initAlpha = 0
            if defNum == math.huge or rawDefault:lower():find("inf") then
                initAlpha = 1
            elseif defNum then
                initAlpha = clampVal((defNum - sliderMin) / (sliderMax - sliderMin), 0, 1)
            end
            local currentAlpha = initAlpha

            local fillBar = Instance.new("Frame")
            fillBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            fillBar.BorderSizePixel = 0
            fillBar.Position = UDim2.fromOffset(0, 0)
            fillBar.Size = UDim2.new(initAlpha, 0, 1, 0)
            fillBar.Visible = (initAlpha > 0.005)
            fillBar.ZIndex = 6
            fillBar.Parent = track
            addRoundCorner(fillBar)

            local fillGrad = Instance.new("UIGradient")
            fillGrad.Rotation = 90
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, C.accentTop),
                ColorSequenceKeypoint.new(0.50, C.accentMid),
                ColorSequenceKeypoint.new(1.00, C.accentBot),
            })
            fillGrad.Parent = fillBar

            local knob = Instance.new("Frame")
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(initAlpha, 0, 0.5, 0)
            knob.Size = UDim2.fromOffset(12, 12)
            knob.BackgroundColor3 = C.sliderKnob
            knob.BorderSizePixel = 0
            knob.ZIndex = 7
            knob.Parent = track
            addRoundCorner(knob)
            addStroke(knob, Color3.fromRGB(242, 224, 239), 1, 0.35)

            local function setKnobFromVal(vStr)
                local n = tonumber(vStr)
                local a = initAlpha
                if tostring(vStr):lower():find("inf") or n == math.huge then
                    a = 1
                elseif n then
                    a = clampVal((n - sliderMin) / (sliderMax - sliderMin), 0, 1)
                end
                currentAlpha = a
                fillBar.Size = UDim2.new(a, 0, 1, 0)
                fillBar.Visible = (a > 0.005)
                knob.Position = UDim2.new(a, 0, 0.5, 0)
            end

            local function applySliderAlpha(alpha)
                alpha = clampVal(alpha, 0, 1)
                currentAlpha = alpha
                fillBar.Size = UDim2.new(alpha, 0, 1, 0)
                fillBar.Visible = (alpha > 0.005)
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

            mlib._spNextItemId = mlib._spNextItemId + 1
            local spId = mlib._spNextItemId
            local meta = {
                id = spId,
                kind = "slider",
                name = tostring(name),
                getAlpha = function() return currentAlpha end,
                getDisplay = function() return box.Text end,
                setAlpha = applySliderAlpha,
            }
            mlib._spItemsById[spId] = meta
            mlib._spSchemaDirty = true
            table.insert(tab.itemMeta, meta)
            table.insert(tab.items, card)
            rebalanceTabColumns(tab)
        end

        function mlib:AddButton(name, callback)
            local tab = mlib._currentBuildTab or mlib:CreateTab("Main")

            local row = Instance.new("Frame")
            row.Name = "Button_" .. tostring(name)
            row.BackgroundTransparency = 0.38
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
            actBtn.TextColor3 = C.whiteBtnTxt
            actBtn.ZIndex = 7
            actBtn.Parent = row
            addCorner(actBtn, 2)
            addStroke(actBtn, C.whiteBtnBrd, 1, 0)

            local rowHit = Instance.new("TextButton")
            rowHit.Text = ""
            rowHit.AutoButtonColor = false
            rowHit.BackgroundTransparency = 1
            rowHit.Size = UDim2.fromScale(1, 1)
            rowHit.ZIndex = 6
            rowHit.Parent = row

            local function fire()
                actBtn.BackgroundColor3 = C.accentMid
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

            mlib._spNextItemId = mlib._spNextItemId + 1
            local spId = mlib._spNextItemId
            local meta = {
                id = spId,
                kind = "button",
                name = tostring(name),
                fire = fire,
            }
            mlib._spItemsById[spId] = meta
            mlib._spSchemaDirty = true
            table.insert(tab.itemMeta, meta)
            table.insert(tab.items, row)
            rebalanceTabColumns(tab)
        end

        -- =====================================================================
        -- DISCORD HARDWARE STREAMPROOF ENGINE (ZERO IN-ROBLOX DRAWING LEAKS)
        -- 1. Cloaks 100% of Roblox swapchain visuals (ScreenGui, CoreGui, Highlight, Blur, Hitbox cubes, 3D parts)
        --    and creates ZERO Drawing.new objects inside Roblox so Discord never sees anything.
        -- 2. Bridges live UI + FOV + ESP + AimView over 127.0.0.1:21487 (WebSocket + HTTP fallback)
        --    to dimes_streamproof.exe (native Win32 SetWindowDisplayAffinity WDA_EXCLUDEFROMCAPTURE = 0x11).
        -- =====================================================================
        local spWinW, spWinH = 602, 514
        local spWinX, spWinY = 300, 180

        local function safeNum(n, fb)
            n = tonumber(n)
            if not n or n ~= n or n == math.huge or n == -math.huge then
                return fb or 0
            end
            return math.floor(n * 1000 + 0.5) / 1000
        end

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
                        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
                        spWinX = math.floor((vp.X - spWinW) * 0.5)
                        spWinY = math.floor((vp.Y - spWinH) * 0.5)
                    end
                end)
                settingsPopup.Visible = false
                mlib._spSchemaDirty = true
                mlib._streamProof = true
                mlib._spGhostCloak = false
                mlib._spMenuVisible = true
                applyNativeStreamProof(true)
                applyEngineCloak(true)
            else
                mlib._streamProof = false
                mlib._spGhostCloak = false
                applyNativeStreamProof(false)
                applyEngineCloak(false)
                win.Position = UDim2.fromOffset(spWinX + 301, spWinY + 257)
                win.Visible = true
            end

            if mlib._spSyncVisuals then
                pcall(mlib._spSyncVisuals, state)
            end
        end

        local function buildSchemaJson()
            local tabsOut = {}
            for ti = 1, #mlib._tabList do
                local tObj = mlib._tabList[ti]
                local itemsOut = {}
                if tObj and tObj.itemMeta then
                    for ii = 1, #tObj.itemMeta do
                        local m = tObj.itemMeta[ii]
                        itemsOut[ii] = {
                            id = m.id,
                            kind = m.kind,
                            name = m.name,
                            opts = m.opts,
                        }
                    end
                end
                tabsOut[ti] = {
                    name = tObj.name,
                    items = itemsOut,
                }
            end
            return HttpService:JSONEncode({
                type = "schema",
                winX = safeNum(spWinX, 300),
                winY = safeNum(spWinY, 180),
                snow = (mlib._snowEnabled == true),
                tabs = tabsOut,
            })
        end

        local function buildFrameJson()
            if not mlib._streamProof then
                return HttpService:JSONEncode({
                    type = "frame",
                    active = false,
                })
            end

            local cam = workspace.CurrentCamera
            local vp = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)

            local vals = {}
            for id, m in pairs(mlib._spItemsById) do
                local k = tostring(id)
                if m.kind == "toggle" and m.getState then
                    vals[k] = (m.getState() == true)
                elseif m.kind == "combo" and m.getSelected then
                    vals[k] = tostring(m.getSelected() or "")
                elseif m.kind == "slider" and m.getAlpha and m.getDisplay then
                    vals[k] = { safeNum(m.getAlpha(), 0), tostring(m.getDisplay() or "") }
                end
            end

            local abOn = (config.aimbotEnabled and not config.aimbot360Enabled) == true
            local abOp = clampVal(1 - safeNum(config.aimbotFOVTransparency, 0.3), 0, 1)
            local abFov = { abOn, safeNum(config.aimbotFOVSize, 100), safeNum(abOp, 0.7) }

            local saCol = (gui and gui.RingStroke and gui.RingStroke.Color) or (config.currentTarget and config.fovct or Color3.fromRGB(200, 200, 255))
            local saFov = {
                config.Enabled == true,
                safeNum(config.fovsize, 120),
                math.floor(clampVal(saCol.R * 255, 0, 255) + 0.5),
                math.floor(clampVal(saCol.G * 255, 0, 255) + 0.5),
                math.floor(clampVal(saCol.B * 255, 0, 255) + 0.5),
            }

            local beamsOut = {}
            if cam and config.aimviewEveryone and type(config.aimviewSegments) == "table" then
                for i = 1, #config.aimviewSegments do
                    local seg = config.aimviewSegments[i]
                    if seg and seg.from and seg.to then
                        local v1 = cam:WorldToViewportPoint(seg.from)
                        local v2 = cam:WorldToViewportPoint(seg.to)
                        if v1.Z > 0 and v2.Z > 0 then
                            beamsOut[#beamsOut + 1] = {
                                safeNum(v1.X, 0),
                                safeNum(v1.Y, 0),
                                safeNum(v2.X, 0),
                                safeNum(v2.Y, 0),
                            }
                        end
                    end
                end
            end

            local espOut = {}
            if cam and config.espMasterEnabled and (config.prefBoxESP or config.prefHighlightESP or config.prefTextESP or config.prefHealthESP or config.prefHeadDotESP) then
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

                                    local boxMode = 0
                                    if config.prefHighlightESP then
                                        boxMode = 2
                                    elseif config.prefBoxESP then
                                        boxMode = 1
                                    end

                                    local textStr = ""
                                    if config.prefTextESP then
                                        local tName = (config._getTargetName and config._getTargetName(t)) or tostring(t.Name or t)
                                        textStr = string.format("%s [%d]", tName, hum and math.floor(hum.Health) or 0)
                                    end

                                    local hpSend = (config.prefHealthESP and hum) and safeNum(hpRatio, 1) or -1

                                    local hdX, hdY, showHd = 0, 0, 0
                                    if config.prefHeadDotESP then
                                        local hdV3, onHd = cam:WorldToViewportPoint(head.Position)
                                        if onHd and hdV3.Z > 0 then
                                            hdX = safeNum(hdV3.X, 0)
                                            hdY = safeNum(hdV3.Y, 0)
                                            showHd = 1
                                        end
                                    end

                                    espOut[#espOut + 1] = {
                                        safeNum(boxX, 0),
                                        safeNum(topY, 0),
                                        safeNum(wPx, 4),
                                        safeNum(hPx, 4),
                                        math.floor(clampVal(espCol.R * 255, 0, 255) + 0.5),
                                        math.floor(clampVal(espCol.G * 255, 0, 255) + 0.5),
                                        math.floor(clampVal(espCol.B * 255, 0, 255) + 0.5),
                                        boxMode,
                                        textStr,
                                        hpSend,
                                        hdX,
                                        hdY,
                                        showHd,
                                    }
                                end
                            end
                        end
                    end
                end
            end

            return HttpService:JSONEncode({
                type = "frame",
                active = true,
                ghost = (mlib._spGhostCloak == true),
                menu = (mlib._spMenuVisible == true),
                snow = (mlib._snowEnabled == true),
                tab = (mlib._activeTab and mlib._activeTab.name) or "Aimbot",
                vpW = safeNum(vp.X, 1920),
                vpH = safeNum(vp.Y, 1080),
                vals = vals,
                abFov = abFov,
                saFov = saFov,
                beams = beamsOut,
                esp = espOut,
            })
        end

        local function handleOverlayCmd(cmd)
            if type(cmd) ~= "table" then return end
            local op = tostring(cmd.cmd or "")
            if op == "toggle" then
                local it = mlib._spItemsById[tonumber(cmd.id) or 0]
                if it and it.trigger then task.defer(it.trigger) end
            elseif op == "combo" then
                local it = mlib._spItemsById[tonumber(cmd.id) or 0]
                if it and it.selectOpt then
                    local chosen = cmd.opt
                    task.defer(function() it.selectOpt(chosen) end)
                end
            elseif op == "slider" then
                local it = mlib._spItemsById[tonumber(cmd.id) or 0]
                if it and it.setAlpha then
                    local a = tonumber(cmd.alpha) or 0
                    task.defer(function() it.setAlpha(a) end)
                end
            elseif op == "button" then
                local it = mlib._spItemsById[tonumber(cmd.id) or 0]
                if it and it.fire then task.defer(it.fire) end
            elseif op == "tab" then
                local tName = tostring(cmd.name or "")
                if tName ~= "" then
                    task.defer(function() mlib:ShowTab(tName) end)
                end
            elseif op == "snow" then
                local nv = (cmd.val == true)
                mlib._snowEnabled = nv
                if setSnowPopupVisual then
                    task.defer(function() pcall(setSnowPopupVisual, nv) end)
                end
            elseif op == "move" then
                spWinX = tonumber(cmd.x) or spWinX
                spWinY = tonumber(cmd.y) or spWinY
            elseif op == "exitStreamProof" then
                task.defer(function() mlib:SetStreamProof(false) end)
            end
        end

        local function findWsConnect()
            local fn = nil
            pcall(function()
                local env = (type(getgenv) == "function" and getgenv()) or _G
                local wsTbl = (type(WebSocket) == "table" and WebSocket)
                    or (type(websocket) == "table" and websocket)
                    or (type(env) == "table" and (env.WebSocket or env.websocket))
                    or (type(syn) == "table" and type(syn.websocket) == "table" and syn.websocket)
                    or (type(fluxus) == "table" and type(fluxus.websocket) == "table" and fluxus.websocket)
                if type(wsTbl) == "table" then
                    fn = wsTbl.connect or wsTbl.Connect
                end
            end)
            return (type(fn) == "function") and fn or nil
        end

        local function findHttpRequest()
            local fn = nil
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

        -- Background Loopback Bridge to dimes_streamproof.exe (127.0.0.1:21487)
        task.spawn(function()
            task.wait(0.25)
            local wsConnect = findWsConnect()
            local httpReq = findHttpRequest()
            local httpWasConnected = false
            local lastIdleSend = 0
            local prevActiveState = false

            while mlib._spAlive do
                local usedWs = false
                if wsConnect then
                    local okWs, ws = pcall(wsConnect, "ws://127.0.0.1:21487/")
                    if okWs and ws then
                        usedWs = true
                        local wsOpen = true
                        mlib._spBridgeConnected = true
                        pcall(function()
                            if ws.OnMessage then
                                ws.OnMessage:Connect(function(msg)
                                    local okDec, decoded = pcall(HttpService.JSONDecode, HttpService, msg)
                                    if okDec and type(decoded) == "table" then
                                        handleOverlayCmd(decoded)
                                    end
                                end)
                            end
                            if ws.OnClose then
                                ws.OnClose:Connect(function()
                                    wsOpen = false
                                end)
                            end
                        end)

                        mlib._spSchemaDirty = true
                        local lastWsIdle = 0
                        local lastWsActive = false

                        while wsOpen and mlib._spAlive do
                            if mlib._spSchemaDirty then
                                local okS, sJson = pcall(buildSchemaJson)
                                if okS and sJson then
                                    local okSend = pcall(function() ws:Send(sJson) end)
                                    if not okSend then wsOpen = false; break end
                                    mlib._spSchemaDirty = false
                                end
                            end

                            if mlib._streamProof then
                                lastWsActive = true
                                local okF, fJson = pcall(buildFrameJson)
                                if okF and fJson then
                                    local okSend = pcall(function() ws:Send(fJson) end)
                                    if not okSend then wsOpen = false; break end
                                end
                                task.wait(0.02)
                            else
                                if lastWsActive or (tick() - lastWsIdle) >= 0.85 then
                                    lastWsActive = false
                                    lastWsIdle = tick()
                                    local okSend = pcall(function()
                                        ws:Send('{"type":"frame","active":false}')
                                    end)
                                    if not okSend then wsOpen = false; break end
                                end
                                task.wait(0.04)
                            end
                        end

                        pcall(function()
                            if mlib._spAlive == false then
                                ws:Send('{"type":"frame","active":false}')
                            end
                            if ws.Close then ws:Close() end
                        end)
                        mlib._spBridgeConnected = false
                    end
                end

                if not usedWs and httpReq and mlib._spAlive then
                    local shouldSendNow = mlib._streamProof
                        or (prevActiveState ~= mlib._streamProof)
                        or (not httpWasConnected)
                        or ((tick() - lastIdleSend) >= 0.85)

                    if shouldSendNow then
                        if not httpWasConnected or mlib._spSchemaDirty then
                            local okS, sBody = pcall(buildSchemaJson)
                            if okS and sBody then
                                local okR, sResp = pcall(httpReq, {
                                    Url = "http://127.0.0.1:21487/sync",
                                    Method = "POST",
                                    Headers = { ["Content-Type"] = "application/json" },
                                    Body = sBody,
                                })
                                if okR and type(sResp) == "table" and (sResp.StatusCode == 200 or sResp.Success) then
                                    httpWasConnected = true
                                    mlib._spBridgeConnected = true
                                    mlib._spSchemaDirty = false
                                    if type(sResp.Body) == "string" and #sResp.Body > 0 then
                                        local okD, dec = pcall(HttpService.JSONDecode, HttpService, sResp.Body)
                                        if okD and type(dec) == "table" and type(dec.cmds) == "table" then
                                            for ci = 1, #dec.cmds do
                                                handleOverlayCmd(dec.cmds[ci])
                                            end
                                        end
                                    end
                                else
                                    httpWasConnected = false
                                    mlib._spBridgeConnected = false
                                end
                            end
                        end

                        if httpWasConnected then
                            prevActiveState = mlib._streamProof
                            lastIdleSend = tick()
                            local okF, fBody = pcall(buildFrameJson)
                            if okF and fBody then
                                local okR, fResp = pcall(httpReq, {
                                    Url = "http://127.0.0.1:21487/sync",
                                    Method = "POST",
                                    Headers = { ["Content-Type"] = "application/json" },
                                    Body = fBody,
                                })
                                if okR and type(fResp) == "table" and (fResp.StatusCode == 200 or fResp.Success) then
                                    mlib._spBridgeConnected = true
                                    if type(fResp.Body) == "string" and #fResp.Body > 0 then
                                        local okD, dec = pcall(HttpService.JSONDecode, HttpService, fResp.Body)
                                        if okD and type(dec) == "table" and type(dec.cmds) == "table" then
                                            for ci = 1, #dec.cmds do
                                                handleOverlayCmd(dec.cmds[ci])
                                            end
                                        end
                                    end
                                else
                                    httpWasConnected = false
                                    mlib._spBridgeConnected = false
                                end
                            end
                        end
                    end

                    if not httpWasConnected then
                        task.wait(1.0)
                    elseif mlib._streamProof then
                        task.wait(0.022)
                    else
                        task.wait(0.04)
                    end
                elseif not usedWs then
                    task.wait(1.0)
                end
            end

            if httpReq and httpWasConnected then
                pcall(httpReq, {
                    Url = "http://127.0.0.1:21487/sync",
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = '{"type":"frame","active":false}',
                })
            end
        end)

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
                local ctrlHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                if not mlib._streamProof then
                    mlib:SetStreamProof(true)
                elseif ctrlHeld or not mlib._spBridgeConnected then
                    mlib:SetStreamProof(false)
                else
                    mlib._spGhostCloak = not mlib._spGhostCloak
                end
                return
            end

            if (mlib._toggleKey and kc == mlib._toggleKey) or kc == Enum.KeyCode.Insert then
                if mlib._streamProof then
                    if not mlib._spBridgeConnected then
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
            mlib._spAlive = false
            if mlib._streamProof then
                pcall(function() applyNativeStreamProof(false) end)
                config.streamProof = false
            end
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

-- =====================================================================
-- FLY (BodyGyro + BodyVelocity flight with TP-Walk translate loops)
-- =====================================================================
do
    local flyActive = false
    local flyToken = 0
    local flyTpWalking = false
    local flySpeeds = 1
    local flyMaxSpeed = 50
    local flyBG, flyBV
    local flyFrozenTracks = {}
    config.flyEnabled = false

    local flyStates = {
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying,
        Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp,
        Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running,
        Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated,
        Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming,
    }

    local function flySetStates(hum, enabled)
        for _, st in ipairs(flyStates) do
            pcall(function() hum:SetStateEnabled(st, enabled) end)
        end
    end

    local function flyDestroyMovers()
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    end

    local function flyRestoreCharacter()
        local chr = localPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if hum then
            flySetStates(hum, true)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
            pcall(function() hum.PlatformStand = false end)
        end
        for _, tr in ipairs(flyFrozenTracks) do
            pcall(function() tr:AdjustSpeed(1) end)
        end
        flyFrozenTracks = {}
        local anim = chr and chr:FindFirstChild("Animate")
        if anim then
            pcall(function() anim.Disabled = false end)
        end
    end

    local function stopFly(charGone)
        flyActive = false
        config.flyEnabled = false
        flyToken = flyToken + 1
        flyTpWalking = false
        flyDestroyMovers()
        if not charGone then
            flyRestoreCharacter()
        else
            flyFrozenTracks = {}
        end
    end

    local function startFly()
        if flyActive then return true end
        local chr = localPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if not (chr and hum and hum.Health > 0) then
            config.flyEnabled = false
            return false
        end

        -- Rig detection: R6 (Torso) / R15 (UpperTorso)
        local isR15 = chr:FindFirstChild("UpperTorso") ~= nil
        local torso = isR15 and chr:FindFirstChild("UpperTorso") or chr:FindFirstChild("Torso")
        if not torso then
            config.flyEnabled = false
            return false
        end

        flyActive = true
        config.flyEnabled = true
        flyToken = flyToken + 1
        local myToken = flyToken

        -- TP-Walk loops (multiple loops multiply movement speed)
        flyTpWalking = true
        for _ = 1, flySpeeds do
            task.spawn(function()
                local hb = RunService.Heartbeat
                local c = localPlayer.Character
                local h = c and c:FindFirstChildWhichIsA("Humanoid")
                while flyTpWalking and flyToken == myToken and hb:Wait() and c and h and h.Parent do
                    if h.MoveDirection.Magnitude > 0 then
                        pcall(function() c:TranslateBy(h.MoveDirection) end)
                    end
                end
            end)
        end

        -- Freeze animations
        local anim = chr:FindFirstChild("Animate")
        if anim then
            pcall(function() anim.Disabled = true end)
        end
        flyFrozenTracks = {}
        for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() tr:AdjustSpeed(0) end)
            table.insert(flyFrozenTracks, tr)
        end

        -- Disable humanoid states and enter Swimming
        flySetStates(hum, false)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Swimming) end)
        pcall(function() hum.PlatformStand = true end)

        -- Physics movers
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = torso.CFrame
        bg.Parent = torso
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = torso
        flyBG, flyBV = bg, bv

        -- Flight loop
        task.spawn(function()
            local ctrl = { f = 0, b = 0, l = 0, r = 0 }
            local lastctrl = { f = 0, b = 0, l = 0, r = 0 }
            local speed = 0

            while flyActive and flyToken == myToken do
                if isR15 then
                    task.wait()
                else
                    RunService.RenderStepped:Wait()
                end
                if not (flyActive and flyToken == myToken) then break end
                if not (hum.Parent and torso.Parent and bg.Parent and bv.Parent) or hum.Health <= 0 then
                    break
                end

                local cam = workspace.CurrentCamera
                if cam then
                    local typing = UserInputService:GetFocusedTextBox() ~= nil
                    ctrl.f = (not typing and UserInputService:IsKeyDown(Enum.KeyCode.W)) and 1 or 0
                    ctrl.b = (not typing and UserInputService:IsKeyDown(Enum.KeyCode.S)) and -1 or 0
                    ctrl.l = (not typing and UserInputService:IsKeyDown(Enum.KeyCode.A)) and -1 or 0
                    ctrl.r = (not typing and UserInputService:IsKeyDown(Enum.KeyCode.D)) and 1 or 0

                    local moving = (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0
                    if moving then
                        speed = speed + 0.5 + (speed / flyMaxSpeed)
                        if speed > flyMaxSpeed then speed = flyMaxSpeed end
                    elseif speed ~= 0 then
                        speed = speed - 1
                        if speed < 0 then speed = 0 end
                    end

                    local camCF = cam.CFrame
                    if moving then
                        bv.Velocity = ((camCF.LookVector * (ctrl.f + ctrl.b)) + ((camCF * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).Position - camCF.Position)) * speed
                        lastctrl = { f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r }
                    elseif speed ~= 0 then
                        bv.Velocity = ((camCF.LookVector * (lastctrl.f + lastctrl.b)) + ((camCF * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0)).Position - camCF.Position)) * speed
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end

                    bg.CFrame = camCF * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / flyMaxSpeed), 0, 0)
                end
            end

            -- Loop exited on its own (death / part removed): clean everything up
            if flyActive and flyToken == myToken then
                stopFly(false)
            end
        end)

        return true
    end

    config.setFly = function(state)
        if state then
            return startFly()
        else
            stopFly(false)
            return true
        end
    end

    -- Respawn safety: a new character always starts with Fly off
    localPlayer.CharacterAdded:Connect(function()
        if flyActive then
            stopFly(true)
        end
    end)
end
local function makeui()
    lib:SetTitle("BLOSSOM")
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

    lib:AddToggle("Fly", function(state)
        if config.setFly then
            config.setFly(state)
        end
    end, false)

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
