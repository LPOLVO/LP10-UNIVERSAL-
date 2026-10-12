-- [[ LP10 HUB - KEY SYSTEM | HALLOWEEN EDITION 🎃 | Junkie version ]]
-- Developer: Hamza

local Config = {
    -- Anti-Bypass variable (kept for your main script)
    Secret          = "2009",

    -- Main script (has the intro) - loaded after the key is verified
    MainScriptURL   = "https://raw.githubusercontent.com/LPOLVO/LP10-UNIVERSAL-/refs/heads/main/Universal",

    -- Social Media (true = show, false = hide)
    ShowDiscord     = true,
    DiscordURL      = "https://discord.gg/Uqrkdrpwxr",
    ShowInstagram   = true,
    InstagramURL    = "https://www.instagram.com/4me.h4mz4_?igsh=MW9sa20yejExaGo5Nw==",
    ShowYoutube     = true,
    YoutubeURL      = "https://youtube.com/@lpolvoxd1?si=sz_Y8Rm0RTrb1r0-",

    -- File where the valid key is saved for auto-login
    KeyFileName     = "LP10 Key",

    -- GUI names
    OldGuiName      = "LP10",

    -- UI text
    HubName         = "LP10 HUB KeySystem",
    HubDescription  = "Halloween Key  -  grab your key if you dare"
}

-- Junkie
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service    = "LP10 HUB"
Junkie.identifier = "1065840"
Junkie.provider   = "Get LP10 HUB Key"

local fSetClipboard = setclipboard or toclipboard or function() end
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Get the key link
local function cacheLink()
    local ok, link = pcall(Junkie.get_key_link)
    if ok and type(link) == "string" and link ~= "" then
        return true, link
    end
    return false, "Server Unreachable"
end

-- Verify the key
local function redeemKey(key)
    local ok, result = pcall(Junkie.check_key, key)
    if ok and type(result) == "table" and result.valid then
        if result.message == "KEYLESS" then
            getgenv().SCRIPT_KEY = "KEYLESS"
            return true, "Keyless mode"
        elseif result.message == "KEY_VALID" then
            getgenv().SCRIPT_KEY = key
            if writefile then pcall(writefile, Config.KeyFileName, key) end
            return true, "Success"
        end
    end
    return false, (ok and type(result) == "table" and result.message) or "Invalid Key"
end

-- Called after a successful check: Junkie then runs your script
local function StartMainScript()
    local pGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    if pGui:FindFirstChild(Config.OldGuiName) then
        pGui[Config.OldGuiName]:Destroy()
    end
    _G[Config.Secret] = true

    -- Run the main script (this is what shows the intro)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(Config.MainScriptURL))()
    end)
    if not ok then warn("[LP10] Main script failed: " .. tostring(err)) end
end

local function CreateGUI()
    local player = game:GetService("Players").LocalPlayer
    local coreGui = game:GetService("CoreGui")
    local targetParent = coreGui
    pcall(function() if gethui then targetParent = gethui() end end)
    if not targetParent then targetParent = player:WaitForChild("PlayerGui") end
    
    if targetParent:FindFirstChild("OYB_KeySystem") then targetParent.OYB_KeySystem:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", targetParent)
    ScreenGui.Name = "OYB_KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Purple Aurora background: intentionally kept independent from the key logic.
    local Backdrop = Instance.new("Frame", ScreenGui)
    Backdrop.Name = "AuroraBackdrop"
    Backdrop.Size = UDim2.fromScale(1, 1)
    Backdrop.BackgroundColor3 = Color3.fromRGB(9, 5, 13)
    Backdrop.BorderSizePixel = 0
    Backdrop.ZIndex = 1

    local BackdropGradient = Instance.new("UIGradient", Backdrop)
    BackdropGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 5, 13)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(28, 10, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 7, 20)),
    })
    BackdropGradient.Rotation = 135

    local function createAuroraOrb(name, size, position, color, transparency)
        local orb = Instance.new("ImageLabel", Backdrop)
        orb.Name = name
        orb.Size = UDim2.fromOffset(size, size)
        orb.Position = position
        orb.BackgroundTransparency = 1
        orb.Image = "rbxassetid://5028857084"
        orb.ImageColor3 = color
        orb.ImageTransparency = transparency
        orb.ZIndex = 2
        return orb
    end

    local AuroraOne = createAuroraOrb(
        "AuroraOne", 420, UDim2.new(0.08, -210, 0.08, -210),
        Color3.fromRGB(255, 117, 24), 0.68
    )
    local AuroraTwo = createAuroraOrb(
        "AuroraTwo", 360, UDim2.new(0.92, -180, 0.86, -180),
        Color3.fromRGB(170, 60, 5), 0.73
    )
    local AuroraThree = createAuroraOrb(
        "AuroraThree", 260, UDim2.new(0.50, -130, 1.04, -130),
        Color3.fromRGB(120, 255, 70), 0.82
    )

    local AuroraLine = Instance.new("Frame", Backdrop)
    AuroraLine.Name = "AuroraLine"
    AuroraLine.Size = UDim2.new(1.5, 0, 0, 1)
    AuroraLine.Position = UDim2.new(-0.25, 0, 0.35, 0)
    AuroraLine.Rotation = -17
    AuroraLine.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
    AuroraLine.BackgroundTransparency = 0.78
    AuroraLine.BorderSizePixel = 0
    AuroraLine.ZIndex = 3

    local AuroraLineTwo = AuroraLine:Clone()
    AuroraLineTwo.Name = "AuroraLineTwo"
    AuroraLineTwo.Position = UDim2.new(-0.25, 0, 0.68, 0)
    AuroraLineTwo.Rotation = 12
    AuroraLineTwo.BackgroundColor3 = Color3.fromRGB(120, 255, 70)
    AuroraLineTwo.BackgroundTransparency = 0.86
    AuroraLineTwo.Parent = Backdrop

    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            local info = TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(AuroraOne, info, {
                Position = UDim2.new(0.28, -210, 0.24, -210),
                ImageTransparency = 0.78,
            }):Play()
            TweenService:Create(AuroraTwo, TweenInfo.new(7.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.72, -180, 0.70, -180),
                ImageTransparency = 0.82,
            }):Play()
            TweenService:Create(AuroraThree, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.40, -130, 0.84, -130),
                ImageTransparency = 0.88,
            }):Play()
            TweenService:Create(AuroraLine, info, {
                Position = UDim2.new(0.08, 0, 0.62, 0),
                BackgroundTransparency = 0.90,
            }):Play()
            TweenService:Create(AuroraLineTwo, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.12, 0, 0.28, 0),
                BackgroundTransparency = 0.93,
            }):Play()
            task.wait(4.5)
            if not ScreenGui or not ScreenGui.Parent then break end
            TweenService:Create(AuroraOne, info, {
                Position = UDim2.new(0.08, -210, 0.08, -210),
                ImageTransparency = 0.68,
            }):Play()
            TweenService:Create(AuroraTwo, TweenInfo.new(7.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.92, -180, 0.86, -180),
                ImageTransparency = 0.73,
            }):Play()
            TweenService:Create(AuroraThree, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.50, -130, 1.04, -130),
                ImageTransparency = 0.82,
            }):Play()
            TweenService:Create(AuroraLine, info, {
                Position = UDim2.new(-0.25, 0, 0.35, 0),
                BackgroundTransparency = 0.78,
            }):Play()
            TweenService:Create(AuroraLineTwo, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(-0.25, 0, 0.68, 0),
                BackgroundTransparency = 0.86,
            }):Play()
            task.wait(4.5)
        end
    end)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "KeyCard"
    MainFrame.Size = UDim2.new(0.88, 0, 0, 460)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 10
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

    -- Keep the card comfortable on short landscape phone screens.
    local MainScale = Instance.new("UIScale", MainFrame)
    local function applyResponsiveScale()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
        local scale = math.clamp(viewport.Y / 520, 0.78, 0.93)
        MainScale.Scale = scale
    end
    applyResponsiveScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveScale)
    end
    
    local mainStroke = Instance.new("UIStroke", MainFrame)
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(255, 117, 24)
    mainStroke.Transparency = 0.12

    local borderPhase = 0
    local borderConnection
    borderConnection = RunService.Heartbeat:Connect(function(dt)
        if not ScreenGui or not ScreenGui.Parent then
            if borderConnection then borderConnection:Disconnect() end
            return
        end
        borderPhase = (borderPhase + dt * 0.12) % 1
        mainStroke.Color = Color3.fromRGB(255, 117, 24):Lerp(Color3.fromRGB(150, 70, 230), (math.sin(borderPhase * math.pi * 2) + 1) / 2)
    end)

    local MainGradient = Instance.new("UIGradient", MainFrame)
    MainGradient.Color = ColorSequence.new(
        Color3.fromRGB(42, 18, 40),
        Color3.fromRGB(12, 7, 16)
    )
    MainGradient.Rotation = 135

    local HeaderGlow = Instance.new("Frame", MainFrame)
    HeaderGlow.Size = UDim2.new(1, 0, 0, 3)
    HeaderGlow.Position = UDim2.fromOffset(0, 78)
    HeaderGlow.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
    HeaderGlow.BorderSizePixel = 0
    HeaderGlow.ZIndex = 14

    local HeaderGlowGradient = Instance.new("UIGradient", HeaderGlow)
    HeaderGlowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 60, 5)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 60, 5)),
    })
    HeaderGlowGradient.Offset = Vector2.new(-1, 0)

    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            TweenService:Create(HeaderGlowGradient, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 0),
            }):Play()
            task.wait(2.8)
            if not ScreenGui or not ScreenGui.Parent then break end
            HeaderGlowGradient.Offset = Vector2.new(-1, 0)
        end
    end)

    ---------------------------------------------------------------------
    -- HALLOWEEN FX: fog, cobwebs, floating spirits, lightning, backdrop bats
    ---------------------------------------------------------------------
    local rng = Random.new()
    local SPIRITS = {"🦇","👻","🎃","🕸️","🍬","💀","🕷️"}

    local Fog = Instance.new("Frame", MainFrame)
    Fog.Name = "Fog"
    Fog.Size = UDim2.new(1, 0, 0, 80)
    Fog.Position = UDim2.new(0, 0, 1, -80)
    Fog.BackgroundColor3 = Color3.fromRGB(122, 46, 180)
    Fog.BorderSizePixel = 0
    Fog.ZIndex = 11
    local FogGradient = Instance.new("UIGradient", Fog)
    FogGradient.Color = ColorSequence.new(Color3.fromRGB(122, 46, 180), Color3.fromRGB(122, 46, 180))
    FogGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.75),
    })
    FogGradient.Rotation = 90

    for _, web in ipairs({
        {pos = UDim2.fromOffset(-10, -10), rot = 0, tr = 0.25},
        {pos = UDim2.new(1, -44, 1, -44), rot = 180, tr = 0.35},
    }) do
        local w = Instance.new("TextLabel", MainFrame)
        w.Size = UDim2.fromOffset(50, 50)
        w.Position = web.pos
        w.BackgroundTransparency = 1
        w.Text = "🕸️"
        w.TextSize = 40
        w.TextTransparency = web.tr
        w.Rotation = web.rot
        w.ZIndex = 15
    end

    local CardFlash = Instance.new("Frame", MainFrame)
    CardFlash.Size = UDim2.fromScale(1, 1)
    CardFlash.BackgroundColor3 = Color3.fromRGB(176, 96, 255)
    CardFlash.BackgroundTransparency = 1
    CardFlash.BorderSizePixel = 0
    CardFlash.ZIndex = 30
    Instance.new("UICorner", CardFlash).CornerRadius = UDim.new(0, 15)

    local BackFlash = Instance.new("Frame", Backdrop)
    BackFlash.Size = UDim2.fromScale(1, 1)
    BackFlash.BackgroundColor3 = Color3.fromRGB(176, 96, 255)
    BackFlash.BackgroundTransparency = 1
    BackFlash.BorderSizePixel = 0
    BackFlash.ZIndex = 5

    local function flashOnce(frameObj, strength)
        TweenService:Create(frameObj, TweenInfo.new(0.05), {BackgroundTransparency = strength}):Play()
        task.delay(0.08, function()
            TweenService:Create(frameObj, TweenInfo.new(0.08), {BackgroundTransparency = 1}):Play()
            task.delay(0.12, function()
                TweenService:Create(frameObj, TweenInfo.new(0.05), {BackgroundTransparency = strength + 0.1}):Play()
                task.delay(0.07, function()
                    TweenService:Create(frameObj, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
                end)
            end)
        end)
    end
    local function strike()
        flashOnce(CardFlash, 0.7)
        flashOnce(BackFlash, 0.85)
    end
    task.delay(0.6, strike)
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            task.wait(rng:NextNumber(8, 16))
            if ScreenGui and ScreenGui.Parent then strike() end
        end
    end)

    local function floatEmoji(parent, z, x, size, duration, trans)
        local lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.fromOffset(size, size)
        lbl.Position = UDim2.new(x, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = SPIRITS[rng:NextInteger(1, #SPIRITS)]
        lbl.TextSize = size
        lbl.TextTransparency = trans
        lbl.Rotation = rng:NextInteger(-25, 25)
        lbl.ZIndex = z
        TweenService:Create(lbl, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(math.clamp(x + rng:NextNumber(-0.12, 0.12), 0, 1), 0, -0.1, 0),
            TextTransparency = 1,
            Rotation = rng:NextInteger(-50, 50),
        }):Play()
        task.delay(duration + 0.1, function() pcall(function() lbl:Destroy() end) end)
    end
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            task.wait(rng:NextNumber(0.9, 1.8))
            pcall(floatEmoji, MainFrame, 11, rng:NextNumber(0.05, 0.9), rng:NextInteger(14, 22), rng:NextNumber(4, 6.5), 0.4)
        end
    end)
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            task.wait(rng:NextNumber(0.5, 1.1))
            pcall(floatEmoji, Backdrop, 4, rng:NextNumber(0.03, 0.97), rng:NextInteger(20, 38), rng:NextNumber(6, 10), 0.55)
        end
    end)
    -- bats flying across the whole screen
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            task.wait(rng:NextNumber(2.5, 5))
            pcall(function()
                local y = rng:NextNumber(0.08, 0.9)
                local bat = Instance.new("TextLabel", Backdrop)
                bat.Size = UDim2.fromOffset(32, 32)
                bat.AnchorPoint = Vector2.new(0.5, 0.5)
                bat.Position = UDim2.new(-0.05, 0, y, 0)
                bat.BackgroundTransparency = 1
                bat.Text = "🦇"
                bat.TextSize = rng:NextInteger(20, 34)
                bat.ZIndex = 4
                local dur = rng:NextNumber(2.2, 3.6)
                TweenService:Create(bat, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(1.05, 0, math.clamp(y + rng:NextNumber(-0.15, 0.15), 0.05, 0.95), 0),
                    Rotation = rng:NextInteger(-25, 25),
                }):Play()
                task.delay(dur + 0.1, function() pcall(function() bat:Destroy() end) end)
            end)
        end
    end)

    -- Close Button
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 29)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "☠"
    CloseBtn.TextColor3 = Color3.fromRGB(232, 190, 150)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 24
    CloseBtn.ZIndex = 10
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(255, 83, 105),
            Rotation = 8,
        }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(232, 190, 150),
            Rotation = 0,
        }):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0.88, 0, 0, 0),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.24, function()
            if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
        end)
    end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, -46, 0, 30)
    Title.Position = UDim2.fromOffset(18, 29)
    Title.Text = "🎃 "..Config.HubName
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 117, 24)
    Title.Font = Enum.Font.Creepster
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 12

    local PromoText = Instance.new("TextLabel", MainFrame)
    PromoText.Size = UDim2.new(1, -36, 0, 24)
    PromoText.Position = UDim2.fromOffset(18, 59)
    PromoText.BackgroundTransparency = 1
    PromoText.Text = string.upper(Config.HubDescription)
    PromoText.TextColor3 = Color3.fromRGB(232, 190, 150)
    PromoText.Font = Enum.Font.GothamSemibold;
    PromoText.TextSize = 10
    PromoText.TextWrapped = true
    PromoText.TextXAlignment = Enum.TextXAlignment.Left
    PromoText.ZIndex = 12

    local SecurePill = Instance.new("TextLabel", MainFrame)
    SecurePill.Size = UDim2.fromOffset(132, 20)
    SecurePill.Position = UDim2.new(1, -154, 0, 61)
    SecurePill.BackgroundColor3 = Color3.fromRGB(30, 40, 14)
    SecurePill.Text = "💀  SECURE GATEWAY"
    SecurePill.TextColor3 = Color3.fromRGB(120, 245, 70)
    SecurePill.Font = Enum.Font.GothamBold
    SecurePill.TextSize = 8
    SecurePill.ZIndex = 13
    local SecurePillCorner = Instance.new("UICorner", SecurePill)
    SecurePillCorner.CornerRadius = UDim.new(0, 8)

    -- Rainbow Stroke Function
    local function AddRainbowStroke(parent)
        local stroke = Instance.new("UIStroke", parent)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.05
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        task.spawn(function()
            while stroke and stroke.Parent do
                local hue = (os.clock() * 0.12) % 1
                stroke.Color = Color3.fromRGB(255, 117, 24):Lerp(Color3.fromRGB(120, 255, 70), (math.sin(hue * math.pi * 2) + 1) / 2 * 0.7)
                task.wait(0.06)
            end
        end)
        return stroke
    end

    local function AddButtonMotion(button, baseColor, hoverColor)
        button.AutoButtonColor = false
        button.ZIndex = 12
        local scale = Instance.new("UIScale", button)
        scale.Scale = 1
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = hoverColor,
            }):Play()
            TweenService:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Scale = 1.015,
            }):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = baseColor,
            }):Play()
            TweenService:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Scale = 1,
            }):Play()
        end)
        button.MouseButton1Down:Connect(function()
            TweenService:Create(scale, TweenInfo.new(0.08), {Scale = 0.97}):Play()
        end)
        button.MouseButton1Up:Connect(function()
            TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1.015,
            }):Play()
        end)
    end

    -- Dynamic Positioning for elements
    local currentYOffset = 105

    -- Discord Button
    if Config.ShowDiscord then
        local DiscordBtn = Instance.new("TextButton", MainFrame)
        DiscordBtn.Size = UDim2.new(0.85, 0, 0, 35)
        DiscordBtn.Position = UDim2.new(0.075, 0, 0, currentYOffset)
        DiscordBtn.Text = "      👻 JOIN DISCORD"
        DiscordBtn.Font = Enum.Font.GothamBold
        DiscordBtn.TextSize = 11
        DiscordBtn.BackgroundColor3 = Color3.fromRGB(60, 26, 70)
        DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
        local DiscordCorner = Instance.new("UICorner", DiscordBtn)
        DiscordCorner.CornerRadius = UDim.new(0, 10)
        AddRainbowStroke(DiscordBtn)
        AddButtonMotion(DiscordBtn, Color3.fromRGB(60, 26, 70), Color3.fromRGB(86, 36, 98))

        local DiscordIcon = Instance.new("ImageLabel", DiscordBtn)
        DiscordIcon.Size = UDim2.new(0, 20, 0, 20)
        DiscordIcon.Position = UDim2.new(0.1, 0, 0.5, -10)
        DiscordIcon.BackgroundTransparency = 1
        DiscordIcon.Image = "rbxassetid://18505728201"
        
        DiscordBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.DiscordURL)
            local Status = MainFrame:FindFirstChild("StatusLabel")
            if Status then 
                Status.Text = "Discord Link Copied!"
                Status.TextColor3 = Color3.fromRGB(88, 101, 242)
            end
            -- Auto-extract invite code from config URL
            local inviteCode = string.match(Config.DiscordURL, "discord%.gg/([%w-]+)")
            if syn and syn.request and inviteCode then
                syn.request({Url = "http://localhost:1111/discord?invite=" .. inviteCode, Method = "GET"})
            end
        end)
        
        currentYOffset = currentYOffset + 45
    end

    -- Instagram Button
    if Config.ShowInstagram then
        local InstaBtn = Instance.new("TextButton", MainFrame)
        InstaBtn.Size = UDim2.new(0.85, 0, 0, 35)
        InstaBtn.Position = UDim2.new(0.075, 0, 0, currentYOffset)
        InstaBtn.Text = "      🕸️ FOLLOW INSTAGRAM"
        InstaBtn.Font = Enum.Font.GothamBold
        InstaBtn.TextSize = 11
        InstaBtn.BackgroundColor3 = Color3.fromRGB(96, 42, 10)
        InstaBtn.TextColor3 = Color3.new(1, 1, 1)
        local InstaCorner = Instance.new("UICorner", InstaBtn)
        InstaCorner.CornerRadius = UDim.new(0, 10)
        AddRainbowStroke(InstaBtn)
        AddButtonMotion(InstaBtn, Color3.fromRGB(96, 42, 10), Color3.fromRGB(140, 60, 14))

        local InstaIcon = Instance.new("ImageLabel", InstaBtn)
        InstaIcon.Size = UDim2.new(0, 20, 0, 20)
        InstaIcon.Position = UDim2.new(0.1, 0, 0.5, -10)
        InstaIcon.BackgroundTransparency = 1
        InstaIcon.Image = "rbxassetid://18355586382"
        
        InstaBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.InstagramURL)
            local Status = MainFrame:FindFirstChild("StatusLabel")
            if Status then 
                Status.Text = "Instagram Link Copied!"
                Status.TextColor3 = Color3.fromRGB(225, 48, 108)
            end
        end)
        
        currentYOffset = currentYOffset + 45
    end

    -- YouTube Button
    if Config.ShowYoutube then
        local YTBtn = Instance.new("TextButton", MainFrame)
        YTBtn.Size = UDim2.new(0.85, 0, 0, 35)
        YTBtn.Position = UDim2.new(0.075, 0, 0, currentYOffset)
        YTBtn.Text = "      💀 SUBSCRIBE YOUTUBE"
        YTBtn.Font = Enum.Font.GothamBold
        YTBtn.TextSize = 11
        YTBtn.BackgroundColor3 = Color3.fromRGB(70, 16, 30)
        YTBtn.TextColor3 = Color3.new(1, 1, 1)
        local YTCorner = Instance.new("UICorner", YTBtn)
        YTCorner.CornerRadius = UDim.new(0, 10)
        AddRainbowStroke(YTBtn)
        AddButtonMotion(YTBtn, Color3.fromRGB(70, 16, 30), Color3.fromRGB(110, 26, 44))

        local YTIcon = Instance.new("ImageLabel", YTBtn)
        YTIcon.Size = UDim2.new(0, 20, 0, 20)
        YTIcon.Position = UDim2.new(0.1, 0, 0.5, -10)
        YTIcon.BackgroundTransparency = 1
        YTIcon.Image = "rbxassetid://82532989017804"
        
        YTBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.YoutubeURL)
            local Status = MainFrame:FindFirstChild("StatusLabel")
            if Status then
                Status.Text = "YouTube Link Copied!"
                Status.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
        
        currentYOffset = currentYOffset + 45
    end

    -- Key Input Box
    local KeyInput = Instance.new("TextBox", MainFrame)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.075, 0, 0, currentYOffset + 15)
    KeyInput.PlaceholderText = "SPEAK THE KEY, MORTAL... 💀"
    KeyInput.Text = ""
    KeyInput.Font = Enum.Font.GothamSemibold
    KeyInput.TextSize = 12
    KeyInput.BackgroundColor3 = Color3.fromRGB(26, 13, 28)
    KeyInput.TextColor3 = Color3.fromRGB(255, 238, 215)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(176, 128, 98)
    KeyInput.ClearTextOnFocus = false
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ZIndex = 12
    local InputCorner = Instance.new("UICorner", KeyInput)
    InputCorner.CornerRadius = UDim.new(0, 10)
    local InputPadding = Instance.new("UIPadding", KeyInput)
    InputPadding.PaddingLeft = UDim.new(0, 14)
    InputPadding.PaddingRight = UDim.new(0, 14)
    local InputStroke = Instance.new("UIStroke", KeyInput)
    InputStroke.Color = Color3.fromRGB(96, 46, 28)
    InputStroke.Thickness = 1
    KeyInput.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.18), {
            Color = Color3.fromRGB(255, 160, 50),
            Thickness = 1.5,
        }):Play()
    end)
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.18), {
            Color = Color3.fromRGB(96, 46, 28),
            Thickness = 1,
        }):Play()
    end)

    local VerifyBtn = Instance.new("TextButton", MainFrame)
    VerifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0, currentYOffset + 65)
    VerifyBtn.Text = "🎃  VERIFY KEY"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 10
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
    VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
    VerifyBtn.ZIndex = 12
    local VerifyCorner = Instance.new("UICorner", VerifyBtn)
    VerifyCorner.CornerRadius = UDim.new(0, 10)
    local VerifyGradient = Instance.new("UIGradient", VerifyBtn)
    VerifyGradient.Color = ColorSequence.new(
        Color3.fromRGB(255, 160, 50),
        Color3.fromRGB(170, 60, 5)
    )
    VerifyGradient.Rotation = 0
    AddButtonMotion(VerifyBtn, Color3.fromRGB(255, 117, 24), Color3.fromRGB(255, 140, 40))
    local VerifyStroke = Instance.new("UIStroke", VerifyBtn)
    VerifyStroke.Color = Color3.fromRGB(255, 170, 70)
    VerifyStroke.Transparency = 0.45
    VerifyStroke.Thickness = 1

    local GetKeyBtn = Instance.new("TextButton", MainFrame)
    GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    GetKeyBtn.Position = UDim2.new(0.525, 0, 0, currentYOffset + 65)
    GetKeyBtn.Text = "🗝️  GET KEY"
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 10
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(34, 16, 30)
    GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    GetKeyBtn.ZIndex = 12
    local GetKeyCorner = Instance.new("UICorner", GetKeyBtn)
    GetKeyCorner.CornerRadius = UDim.new(0, 10)
    local GetKeyStroke = Instance.new("UIStroke", GetKeyBtn)
    GetKeyStroke.Color = Color3.fromRGB(150, 76, 30)
    GetKeyStroke.Thickness = 1
    AddButtonMotion(GetKeyBtn, Color3.fromRGB(34, 16, 30), Color3.fromRGB(56, 26, 22))

    local Status = Instance.new("TextLabel", MainFrame)
    Status.Name = "StatusLabel"
    Status.Size = UDim2.new(1, -36, 0, 30)
    Status.Position = UDim2.fromOffset(18, currentYOffset + 115)
    Status.BackgroundTransparency = 1
    Status.Text = "THE CRYPT AWAITS  /  ENTER YOUR KEY 👻"
    Status.TextColor3 = Color3.fromRGB(176, 96, 255)
    Status.Font = Enum.Font.GothamSemibold
    Status.TextSize = 10
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.ZIndex = 12
    
    local StatusLine = Instance.new("Frame", MainFrame)
    StatusLine.Size = UDim2.new(1, -36, 0, 1)
    StatusLine.Position = UDim2.fromOffset(18, currentYOffset + 146)
    StatusLine.BackgroundColor3 = Color3.fromRGB(96, 46, 28)
    StatusLine.BorderSizePixel = 0
    StatusLine.ZIndex = 12

    local Footer = Instance.new("TextLabel", MainFrame)
    Footer.Size = UDim2.new(1, -36, 0, 18)
    Footer.Position = UDim2.fromOffset(18, currentYOffset + 154)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🦇  LP10  /  HALLOWEEN EDITION  /  SECURE ACCESS  🦇"
    Footer.TextColor3 = Color3.fromRGB(176, 128, 98)
    Footer.Font = Enum.Font.GothamBold
    Footer.TextSize = 8
    Footer.TextXAlignment = Enum.TextXAlignment.Center
    Footer.ZIndex = 12

    -- Dynamically adjust main frame height based on active elements
    MainFrame.Size = UDim2.new(0.88, 0, 0, currentYOffset + 184)

    -- Logic
    local verifying = false
    VerifyBtn.MouseButton1Click:Connect(function()
        if verifying then return end
        local key = KeyInput.Text
        if key == "" then
            Status.Text = "ERROR  /  ENTER A KEY FIRST"
            Status.TextColor3 = Color3.fromRGB(255, 156, 40)
            return
        end
        verifying = true
        VerifyBtn.Active = false
        VerifyBtn.Text = "🕯️  SUMMONING..."
        Status.Text = "SECURE CHECK  /  CONTACTING SERVER..."
        Status.TextColor3 = Color3.fromRGB(255, 190, 110)
        local callOK, success, msg = pcall(redeemKey, key)
        if not callOK then
            success = false
            msg = "Verification error. Please try again."
        end
        if success then
            Status.Text = "ACCESS GRANTED  /  RAISING THE SPIRITS 🎃"
            Status.TextColor3 = Color3.fromRGB(120, 245, 70)
            task.wait(0.5)
            ScreenGui:Destroy()
            StartMainScript()
        else
            verifying = false
            VerifyBtn.Active = true
            VerifyBtn.Text = "🎃  VERIFY KEY"
            Status.Text = "ACCESS DENIED  /  "..tostring(msg)
            Status.TextColor3 = Color3.fromRGB(255, 83, 105)
        end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        Status.Text = "REQUESTING  /  GENERATING YOUR KEY LINK..."
        Status.TextColor3 = Color3.fromRGB(255, 190, 110)
        local callOK, success, link = pcall(cacheLink)
        if not callOK then
            success = false
            link = "Unable to reach the key service."
        end
        if success then
            fSetClipboard(link)
            Status.Text = "LINK COPIED  /  OPEN IT TO GET YOUR KEY"
            Status.TextColor3 = Color3.fromRGB(120, 245, 70)
        else
            Status.Text = "REQUEST FAILED  /  "..tostring(link)
            Status.TextColor3 = Color3.fromRGB(255, 83, 105)
        end
    end)

    -- Auto Check Saved Key
    if isfile and isfile(Config.KeyFileName) then
        local savedKey = readfile(Config.KeyFileName)
        if savedKey ~= "" then
            Status.Text = "SAVED KEY FOUND  /  VERIFYING..."
            Status.TextColor3 = Color3.fromRGB(255, 190, 110)
            task.spawn(function()
                local callOK, success, msg = pcall(redeemKey, savedKey)
                if not callOK then
                    success = false
                    msg = "Saved key could not be verified."
                end
                if success then
                    Status.Text = "AUTO-LOGIN SUCCESS  /  THE SPIRITS RISE 🎃"
                    Status.TextColor3 = Color3.fromRGB(120, 245, 70)
                    task.wait(0.5)
                    ScreenGui:Destroy()
                    StartMainScript()
                else
                    Status.Text = "SAVED KEY EXPIRED  /  ENTER A NEW KEY 🕯️"
                    Status.TextColor3 = Color3.fromRGB(255, 150, 0)
                end
            end)
        end
    end

    local finalSize = MainFrame.Size
    MainFrame.Size = UDim2.new(finalSize.X.Scale, finalSize.X.Offset, 0, 0)
    MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = finalSize,
        BackgroundTransparency = 0,
    }):Play()
end

-- Remove old GUI if it is already open, then show the key system
local pGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if pGui:FindFirstChild(Config.OldGuiName) then pGui[Config.OldGuiName]:Destroy() end

CreateGUI()

-- Junkie waits here until the key is verified, then runs your protected script
while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end
