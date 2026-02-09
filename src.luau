-- ROBLOX ADVANCED CHEAT MENU
-- ==========================================
-- INSTALLATION:
-- - Exécutez avec votre Executor préféré (Synapse, KRNL, Fluxus, etc.)
--
-- UTILISATION:
-- - Appuyez sur RightControl pour ouvrir/fermer le menu
q
-- - ESP: Voir les joueurs à travers les murs
-- - Aimbot: Visée automatique (maintenir bouton droit)
-- - Speed/Jump/Flight: Modifications de mouvement
-- - Noclip: Traverser les murs
-- - Infinite Jump: Sauter infiniment
--
-- AVERTISSEMENT:
-- - Utilisez à vos risques et périls
-- - Peut entraîner un ban
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Attendre que le joueur soit complètement chargé
repeat wait() until game:IsLoaded()

local player = Players.LocalPlayer
repeat wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local cheatConfig = {
    Prefix = ".", -- Préfixe des commandes
    ThemeColor = Color3.fromRGB(255, 50, 100), -- Rose/Rouge pour look cheat
    GuiKey = Enum.KeyCode.RightControl, -- Touche pour ouvrir/fermer
    ESPEnabled = false,
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothness = 0.5,
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false
}

-- Création du ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principale
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Corner arrondi
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Barre de titre
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = cheatConfig.ThemeColor
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix pour garder les coins du bas carrés
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = cheatConfig.ThemeColor
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Titre
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ MakeHub v1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Bouton de fermeture
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Bouton de minimisation
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 35, 0, 35)
minimizeButton.Position = UDim2.new(1, -80, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- Container pour les onglets
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, 140, 1, -55)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabContainer

-- Container pour le contenu
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -165, 1, -55)
contentContainer.Position = UDim2.new(0, 155, 0, 50)
contentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentContainer

-- Liste des onglets
local tabs = {"Combat", "Movement", "Visuals", "Players", "Misc"}
local tabButtons = {}
local tabContents = {}

-- Fonction pour créer un bouton d'onglet
local function createTabButton(tabName, index)
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = UDim2.new(0, 5, 0, 5 + (index - 1) * 45)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- Fonction pour créer le contenu d'un onglet
local function createTabContent(tabName)
    local content = Instance.new("ScrollingFrame")
    content.Name = tabName .. "Content"
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = cheatConfig.ThemeColor
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = contentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = content
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    return content
end

-- Créer les onglets et leur contenu
for i, tabName in ipairs(tabs) do
    tabButtons[tabName] = createTabButton(tabName, i)
    tabContents[tabName] = createTabContent(tabName)
end

-- Fonction pour changer d'onglet
local currentTab = "Combat"
local function switchTab(tabName)
    for name, button in pairs(tabButtons) do
        if name == tabName then
            button.BackgroundColor3 = cheatConfig.ThemeColor
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContents[name].Visible = true
            currentTab = name
        else
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabContents[name].Visible = false
        end
    end
end

-- Connecter les boutons d'onglet
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Fonction pour créer un toggle button
local function createToggleButton(text, parent, defaultState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 28)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -14)
    toggleButton.BackgroundColor3 = defaultState and cheatConfig.ThemeColor or Color3.fromRGB(60, 60, 70)
    toggleButton.Text = defaultState and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleButton
    
    local isEnabled = defaultState
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        toggleButton.Text = isEnabled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = isEnabled and cheatConfig.ThemeColor or Color3.fromRGB(60, 60, 70)
        if callback then callback(isEnabled) end
    end)
    
    return container, toggleButton
end

-- Fonction pour créer un slider
local function createSlider(text, parent, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 60)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = cheatConfig.ThemeColor
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. value
        if callback then callback(value) end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return container
end

-- Fonction pour créer un bouton standard
local function createButton(text, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = cheatConfig.ThemeColor
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- Fonction pour créer un label
local function createLabel(text, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- ===== ONGLET COMBAT =====
createLabel("⚔️ COMBAT FEATURES", tabContents["Combat"])

-- ESP Storage
local espObjects = {}

-- Fonction ESP
local function createESP(plr)
    if plr == player then return end
    
    local function addESP(char)
        pcall(function()
            if espObjects[plr] then
                for _, obj in pairs(espObjects[plr]) do
                    if obj then obj:Destroy() end
                end
            end
            
            espObjects[plr] = {}
            
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if not hrp then return end
            
            -- Box ESP
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 5, 3)
            box.Color3 = cheatConfig.ThemeColor
            box.Transparency = 0.7
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Adornee = hrp
            box.Parent = hrp
            table.insert(espObjects[plr], box)
            
            -- Name ESP
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = plr.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.TextSize = 16
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
            
            -- Distance ESP
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.4, 0)
            distLabel.Position = UDim2.new(0, 0, 0.6, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextStrokeTransparency = 0.5
            distLabel.TextSize = 14
            distLabel.Font = Enum.Font.Gotham
            distLabel.Parent = billboard
            table.insert(espObjects[plr], billboard)
            
            -- Update distance
            spawn(function()
                while wait(0.1) and cheatConfig.ESPEnabled and hrp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                    local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. " studs"
                end
            end)
        end)
    end
    
    if plr.Character then
        addESP(plr.Character)
    end
    plr.CharacterAdded:Connect(addESP)
end

-- Toggle ESP
createToggleButton("ESP (Wallhack)", tabContents["Combat"], false, function(enabled)
    cheatConfig.ESPEnabled = enabled
    
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
        Players.PlayerAdded:Connect(createESP)
    else
        for _, objects in pairs(espObjects) do
            for _, obj in pairs(objects) do
                if obj then 
                    pcall(function() obj:Destroy() end)
                end
            end
        end
        espObjects = {}
    end
end)

-- Fonction pour trouver la cible la plus proche (Aimbot)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = cheatConfig.AimbotFOV
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local char = plr.Character
            local head = char.Head
            local humanoid = char:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot variables
local aimbotConnection

-- Toggle Aimbot
createToggleButton("Aimbot (Hold RightClick)", tabContents["Combat"], false, function(enabled)
    cheatConfig.AimbotEnabled = enabled
    
    if enabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not cheatConfig.AimbotEnabled then return end
            
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local target = getClosestPlayer()
                
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local cam = workspace.CurrentCamera
                    local headPos = target.Character.Head.Position
                    local aimCFrame = CFrame.new(cam.CFrame.Position, headPos)
                    
                    cam.CFrame = cam.CFrame:Lerp(aimCFrame, cheatConfig.AimbotSmoothness)
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
    end
end)

-- Aimbot FOV Slider
createSlider("Aimbot FOV", tabContents["Combat"], 50, 500, cheatConfig.AimbotFOV, function(value)
    cheatConfig.AimbotFOV = value
end)

-- Aimbot Smoothness Slider
createSlider("Aimbot Smoothness", tabContents["Combat"], 1, 100, cheatConfig.AimbotSmoothness * 100, function(value)
    cheatConfig.AimbotSmoothness = value / 100
end)

-- ===== ONGLET MOVEMENT =====
createLabel("🏃 MOVEMENT HACKS", tabContents["Movement"])

-- Speed Hack
createSlider("WalkSpeed", tabContents["Movement"], 16, 500, 16, function(value)
    cheatConfig.WalkSpeed = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Jump Power
createSlider("JumpPower", tabContents["Movement"], 50, 500, 50, function(value)
    cheatConfig.JumpPower = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Infinite Jump
createToggleButton("Infinite Jump", tabContents["Movement"], false, function(enabled)
    cheatConfig.InfiniteJump = enabled
end)

UserInputService.JumpRequest:Connect(function()
    if cheatConfig.InfiniteJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
local noclipEnabled = false
createToggleButton("Noclip", tabContents["Movement"], false, function(enabled)
    noclipEnabled = enabled
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flyEnabled = false
local flySpeed = 50
local flyConnection

local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        local char = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Name = "FlyVelocity"
            bodyVelocity.Parent = rootPart
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.P = 9e4
            bodyGyro.Name = "FlyGyro"
            bodyGyro.Parent = rootPart
            
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flyEnabled or not rootPart:FindFirstChild("FlyVelocity") then return end
                
                local camera = workspace.CurrentCamera
                local moveDirection = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDirection.Unit * flySpeed
                bodyGyro.CFrame = camera.CFrame
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
        end
        local char = player.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            if rootPart:FindFirstChild("FlyVelocity") then
                rootPart.FlyVelocity:Destroy()
            end
            if rootPart:FindFirstChild("FlyGyro") then
                rootPart.FlyGyro:Destroy()
            end
        end
    end
end

createToggleButton("Fly (WASD to move)", tabContents["Movement"], false, function(enabled)
    if enabled ~= flyEnabled then
        toggleFly()
    end
end)

createSlider("Fly Speed", tabContents["Movement"], 10, 500, 50, function(value)
    flySpeed = value
end)

-- ===== ONGLET VISUALS =====
createLabel("👁️ VISUAL MODIFICATIONS", tabContents["Visuals"])

-- FOV Changer
createSlider("Field of View", tabContents["Visuals"], 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

-- Fullbright
createToggleButton("Fullbright", tabContents["Visuals"], false, function(enabled)
    if enabled then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.GlobalShadows = true
        game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

-- Remove Fog
createToggleButton("Remove Fog", tabContents["Visuals"], false, function(enabled)
    if enabled then
        game.Lighting.FogEnd = 999999
    else
        game.Lighting.FogEnd = 100000
    end
end)

-- ===== ONGLET PLAYERS =====
createLabel("👥 PLAYER TELEPORTS", tabContents["Players"])

-- Créer la liste des joueurs
local function updatePlayerButtons()
    -- Supprimer les anciens boutons
    for _, child in pairs(tabContents["Players"]:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Créer un bouton pour chaque joueur
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = createButton("TP to " .. plr.Name, tabContents["Players"])
            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end

updatePlayerButtons()
Players.PlayerAdded:Connect(updatePlayerButtons)
Players.PlayerRemoving:Connect(updatePlayerButtons)

-- ===== ONGLET MISC =====
createLabel("⚙️ MISCELLANEOUS", tabContents["Misc"])

-- God Mode
createToggleButton("God Mode", tabContents["Misc"], false, function(enabled)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enabled then
            player.Character.Humanoid.MaxHealth = math.huge
            player.Character.Humanoid.Health = math.huge
        else
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
    end
end)

-- Invisible
createToggleButton("Invisible", tabContents["Misc"], false, function(enabled)
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = enabled and 1 or 0
                if part.Name == "Head" and part:FindFirstChild("face") then
                    part.face.Transparency = enabled and 1 or 0
                end
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = enabled and 1 or 0
            end
        end
    end
end)

-- Anti-AFK
local afkEnabled = false
createToggleButton("Anti-AFK", tabContents["Misc"], false, function(enabled)
    afkEnabled = enabled
end)

if afkEnabled then
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        if afkEnabled then
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
end

-- Reset Camera
local resetCamBtn = createButton("Reset Camera", tabContents["Misc"])
resetCamBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
        workspace.CurrentCamera.FieldOfView = 70
    end
end)

-- Boutons de contrôle
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tabContainer.Visible = false
        contentContainer.Visible = false
        mainFrame.Size = UDim2.new(0, 600, 0, 45)
    else
        tabContainer.Visible = true
        contentContainer.Visible = true
        mainFrame.Size = UDim2.new(0, 600, 0, 450)
    end
end)

-- Animation d'ouverture
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Expo, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 450),
    Position = UDim2.new(0.5, -300, 0.5, -225)
})
openTween:Play()

-- Activer le premier onglet
switchTab("Combat")

-- Toggle GUI avec touche
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == cheatConfig.GuiKey then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Appliquer les modifications lors du respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    wait(0.5)
    
    if cheatConfig.WalkSpeed ~= 16 and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = cheatConfig.WalkSpeed
    end
    
    if cheatConfig.JumpPower ~= 50 and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = cheatConfig.JumpPower
    end
    
    updatePlayerButtons()
end)

-- Notification de chargement
local notification = Instance.new("Frame")
notification.Size = UDim2.new(0, 350, 0, 70)
notification.Position = UDim2.new(1, -360, 1, -80)
notification.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
notification.BorderSizePixel = 0
notification.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notification

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -20, 1, -20)
notifText.Position = UDim2.new(0, 10, 0, 10)
notifText.BackgroundTransparency = 1
notifText.Text = "⚡ Cheat Menu Loaded!\nPress RightControl to toggle"
notifText.TextColor3 = cheatConfig.ThemeColor
notifText.TextSize = 14
notifText.Font = Enum.Font.GothamBold
notifText.TextWrapped = true
notifText.TextYAlignment = Enum.TextYAlignment.Center
notifText.Parent = notification

wait(3)
notification:Destroy()

print("========================================")
print("⚡ CHEAT MENU v3.0 LOADED ⚡")
print("Press RightControl to toggle menu")
print("========================================")
