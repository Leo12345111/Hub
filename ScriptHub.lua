local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function safeLoad(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            func()
        else
            warn("Script Error: " .. tostring(err))
        end
    else
        warn("Failed to download script from: " .. url)
    end
end

local scripts = {
    {name = "Fly", fav = false, run = function()
        local flying, speed, move = false, 60, Vector3.zero
        local bv, bg, conn

        local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        gui.ResetOnSpawn = false
        local frame = Instance.new("Frame", gui)
        frame.Size, frame.Position = UDim2.new(0, 220, 0, 120), UDim2.new(0.5, -110, 0.5, -60)
        frame.BackgroundColor3, frame.Active = Color3.fromRGB(20, 20, 20), true
        Instance.new("UICorner", frame)
        makeDraggable(frame)

        local close = Instance.new("TextButton", frame)
        close.Size, close.Position, close.Text = UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 5), "X"
        close.BackgroundColor3, close.TextColor3 = Color3.fromRGB(120, 30, 30), Color3.new(1, 1, 1)
        Instance.new("UICorner", close)

        local speedBox = Instance.new("TextBox", frame)
        speedBox.Size, speedBox.Position = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.25, 0)
        speedBox.PlaceholderText, speedBox.Text = "Speed", "60"
        speedBox.BackgroundColor3, speedBox.TextColor3 = Color3.fromRGB(35, 35, 35), Color3.new(1, 1, 1)
        Instance.new("UICorner", speedBox)

        local toggle = Instance.new("TextButton", frame)
        toggle.Size, toggle.Position, toggle.Text = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.65, 0), "Start Fly"
        toggle.BackgroundColor3, toggle.TextColor3 = Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)
        Instance.new("UICorner", toggle)

        speedBox.FocusLost:Connect(function()
            move = Vector3.zero
        end)

        local bIn = UIS.InputBegan:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.W then move += Vector3.new(0, 0, -1) end
            if i.KeyCode == Enum.KeyCode.S then move += Vector3.new(0, 0, 1) end
            if i.KeyCode == Enum.KeyCode.A then move += Vector3.new(-1, 0, 0) end
            if i.KeyCode == Enum.KeyCode.D then move += Vector3.new(1, 0, 0) end
            if i.KeyCode == Enum.KeyCode.Space then move += Vector3.new(0, 1, 0) end
            if i.KeyCode == Enum.KeyCode.LeftShift then move += Vector3.new(0, -1, 0) end
        end)

        local bOut = UIS.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then move -= Vector3.new(0, 0, -1) end
            if i.KeyCode == Enum.KeyCode.S then move -= Vector3.new(0, 0, 1) end
            if i.KeyCode == Enum.KeyCode.A then move -= Vector3.new(-1, 0, 0) end
            if i.KeyCode == Enum.KeyCode.D then move -= Vector3.new(1, 0, 0) end
            if i.KeyCode == Enum.KeyCode.Space then move -= Vector3.new(0, 1, 0) end
            if i.KeyCode == Enum.KeyCode.LeftShift then move -= Vector3.new(0, -1, 0) end
        end)

        conn = RunService.RenderStepped:Connect(function()
            if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                if not bv or bv.Parent ~= hrp then
                    bv = Instance.new("BodyVelocity", hrp)
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bg = Instance.new("BodyGyro", hrp)
                    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                end
                speed = tonumber(speedBox.Text) or 60
                bv.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(move) * speed
                bg.CFrame = workspace.CurrentCamera.CFrame
            else
                if bv then bv:Destroy() bv = nil end
                if bg then bg:Destroy() bg = nil end
            end
        end)

        toggle.MouseButton1Click:Connect(function()
            flying = not flying
            toggle.Text = flying and "Stop Fly" or "Start Fly"
        end)

        close.MouseButton1Click:Connect(function()
            flying = false
            if conn then conn:Disconnect() end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            bIn:Disconnect(); bOut:Disconnect()
            gui:Destroy()
        end)
    end},

    {name = "WalkSpeed", fav = false, run = function()
        local active = false
        local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        gui.ResetOnSpawn = false
        local frame = Instance.new("Frame", gui)
        frame.Size, frame.Position = UDim2.new(0, 200, 0, 140), UDim2.new(0.5, -100, 0.5, -70)
        frame.BackgroundColor3, frame.Active = Color3.fromRGB(20, 20, 20), true
        Instance.new("UICorner", frame)
        makeDraggable(frame)

        local speedInput = Instance.new("TextBox", frame)
        speedInput.Size, speedInput.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.2, 0)
        speedInput.PlaceholderText, speedInput.Text = "Speed", "16"
        speedInput.BackgroundColor3, speedInput.TextColor3 = Color3.fromRGB(35, 35, 35), Color3.new(1, 1, 1)
        Instance.new("UICorner", speedInput)

        local toggle = Instance.new("TextButton", frame)
        toggle.Size, toggle.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.55, 0)
        toggle.Text, toggle.BackgroundColor3, toggle.TextColor3 = "Enable Speed", Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)
        Instance.new("UICorner", toggle)

        local close = Instance.new("TextButton", frame)
        close.Size, close.Position, close.Text = UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 5), "X"
        close.BackgroundColor3, close.TextColor3 = Color3.fromRGB(120, 30, 30), Color3.new(1, 1, 1)
        Instance.new("UICorner", close)

        local loop = RunService.Heartbeat:Connect(function()
            if active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(speedInput.Text) or 16
            end
        end)

        toggle.MouseButton1Click:Connect(function()
            active = not active
            toggle.Text = active and "Disable Speed" or "Enable Speed"
        end)

        close.MouseButton1Click:Connect(function()
            active = false
            loop:Disconnect()
            gui:Destroy()
        end)
    end},

    {name = "Noclip", fav = false, run = function()
        local noclip = false
        local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        gui.ResetOnSpawn = false
        local frame = Instance.new("Frame", gui)
        frame.Size, frame.Position = UDim2.new(0, 200, 0, 100), UDim2.new(0.5, -100, 0.5, -50)
        frame.BackgroundColor3, frame.Active = Color3.fromRGB(20, 20, 20), true
        Instance.new("UICorner", frame)
        makeDraggable(frame)

        local toggle = Instance.new("TextButton", frame)
        toggle.Size, toggle.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.45, 0)
        toggle.Text, toggle.BackgroundColor3, toggle.TextColor3 = "Enable Noclip", Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)
        Instance.new("UICorner", toggle)

        local close = Instance.new("TextButton", frame)
        close.Size, close.Position, close.Text = UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 5), "X"
        close.BackgroundColor3, close.TextColor3 = Color3.fromRGB(120, 30, 30), Color3.new(1, 1, 1)
        Instance.new("UICorner", close)

        local connection = RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)

        toggle.MouseButton1Click:Connect(function()
            noclip = not noclip
            toggle.Text = noclip and "Disable Noclip" or "Enable Noclip"
        end)

        close.MouseButton1Click:Connect(function() 
            noclip = false 
            connection:Disconnect() 
            gui:Destroy() 
        end)
    end},

    {name = "ESP", fav = false, run = function()
        local Camera = workspace.CurrentCamera

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ESPGui"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = game:GetService("CoreGui")

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 150, 0, 100)
        MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        MainFrame.BorderSizePixel = 2
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = "ESP Settings"
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 18
        Title.Parent = MainFrame

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
        ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleBtn.Text = "ESP: OFF"
        ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
        ToggleBtn.Parent = MainFrame

        local ExitBtn = Instance.new("TextButton")
        ExitBtn.Size = UDim2.new(0, 20, 0, 20)
        ExitBtn.Position = UDim2.new(1, -25, 0, 5)
        ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ExitBtn.Text = "X"
        ExitBtn.TextColor3 = Color3.new(1, 1, 1)
        ExitBtn.Parent = MainFrame

        local ESPEnabled = false
        local Drawings = {}

        local function CreateESP(player)
            local box = Drawing.new("Square")
            box.Visible = false
            box.Color = Color3.new(1, 0, 0)
            box.Thickness = 1
            box.Filled = true
            box.Transparency = 0.4

            local outline = Drawing.new("Square")
            outline.Visible = false
            outline.Color = Color3.new(0, 0, 0)
            outline.Thickness = 2
            outline.Filled = false
            outline.Transparency = 1

            local healthBar = Drawing.new("Line")
            healthBar.Visible = false
            healthBar.Color = Color3.new(0, 1, 0)
            healthBar.Thickness = 2

            local healthText = Drawing.new("Text")
            healthText.Visible = false
            healthText.Color = Color3.new(1, 1, 1)
            healthText.Size = 14
            healthText.Center = false
            healthText.Outline = true

            local nameText = Drawing.new("Text")
            nameText.Visible = false
            nameText.Color = Color3.new(1, 1, 1)
            nameText.Size = 16
            nameText.Center = true
            nameText.Outline = true

            Drawings[player] = {
                Box = box,
                Outline = outline,
                HealthBar = healthBar,
                HealthText = healthText,
                NameText = nameText
            }
        end

        local function RemoveESP(player)
            if Drawings[player] then
                for _, obj in pairs(Drawings[player]) do
                    obj:Remove()
                end
                Drawings[player] = nil
            end
        end

        ToggleBtn.MouseButton1Click:Connect(function()
            ESPEnabled = not ESPEnabled
            ToggleBtn.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
            if not ESPEnabled then
                for _, data in pairs(Drawings) do
                    for _, obj in pairs(data) do
                        obj.Visible = false
                    end
                end
            end
        end)

        ExitBtn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            for player, _ in pairs(Drawings) do
                RemoveESP(player)
            end
        end)

        Players.PlayerAdded:Connect(CreateESP)
        Players.PlayerRemoving:Connect(RemoveESP)

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then CreateESP(player) end
        end

        RunService.RenderStepped:Connect(function()
            if not ESPEnabled then return end
            for player, data in pairs(Drawings) do
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                    local hrp = character.HumanoidRootPart
                    local humanoid = character.Humanoid
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local size = Vector2.new(2000 / pos.Z, 2500 / pos.Z)
                        local boxPos = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                        data.Box.Size = size
                        data.Box.Position = boxPos
                        data.Box.Visible = true
                        data.Outline.Size = size
                        data.Outline.Position = boxPos
                        data.Outline.Visible = true
                        data.NameText.Position = Vector2.new(pos.X, boxPos.Y - 20)
                        data.NameText.Text = player.Name
                        data.NameText.Visible = true
                        local barHeight = size.Y * (humanoid.Health / humanoid.MaxHealth)
                        data.HealthBar.From = Vector2.new(boxPos.X - 7, boxPos.Y + size.Y)
                        data.HealthBar.To = Vector2.new(boxPos.X - 7, boxPos.Y + size.Y - barHeight)
                        data.HealthBar.Visible = true
                        data.HealthText.Position = Vector2.new(boxPos.X - 45, boxPos.Y + size.Y - barHeight - 7)
                        data.HealthText.Text = "hp: " .. math.floor(humanoid.Health)
                        data.HealthText.Visible = true
                    else
                        for _, obj in pairs(data) do obj.Visible = false end
                    end
                else
                    for _, obj in pairs(data) do obj.Visible = false end
                end
            end
        end)
    end},

    {name="Freecam", fav=false, run=function() safeLoad("https://raw.githubusercontent.com/Leo12345111/Freecam/main/Freecam.lua") end},
    {name="Touch Fling", fav=false, run=function() safeLoad("https://pastebin.com/raw/LgZwZ7ZB") end},
    {name="Player Follower", fav=false, run=function() safeLoad("https://raw.githubusercontent.com/Leo12345111/PlayerFollower/main/PlayerFollower.lua") end},
    {name="Fling Players", fav=false, run=function() safeLoad("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua") end},
    {name="Part Conntroller", fav=false, run=function() safeLoad("https://raw.githubusercontent.com/hm5650/PCR/refs/heads/main/PartControllerRemote") end},
    
    {name = "Utility Hub X", fav = false, run = function()
        if game:GetService("CoreGui"):FindFirstChild("UtilityHubX") then
            game:GetService("CoreGui").UtilityHubX:Destroy()
        end

        local tweenService = game:GetService("TweenService")
        local mouse = LocalPlayer:GetMouse()

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "UtilityHubX"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = game:GetService("CoreGui")

        local dropShadow = Instance.new("ImageLabel")
        dropShadow.Name = "DropShadow"
        dropShadow.BackgroundTransparency = 1
        dropShadow.Position = UDim2.new(0.5, -145, 0.5, -245)
        dropShadow.Size = UDim2.new(0, 290, 0, 490)
        dropShadow.Image = "rbxassetid://6015897843"
        dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        dropShadow.ImageTransparency = 0.5
        dropShadow.ScaleType = Enum.ScaleType.Slice
        dropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        dropShadow.Parent = screenGui

        local utilMainFrame = Instance.new("Frame")
        utilMainFrame.Size = UDim2.new(1, -30, 1, -30)
        utilMainFrame.Position = UDim2.new(0, 15, 0, 15)
        utilMainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        utilMainFrame.BorderSizePixel = 0
        utilMainFrame.Parent = dropShadow

        local utilMainCorner = Instance.new("UICorner")
        utilMainCorner.CornerRadius = UDim.new(0, 12)
        utilMainCorner.Parent = utilMainFrame

        local utilTitleBar = Instance.new("Frame")
        utilTitleBar.Size = UDim2.new(1, 0, 0, 50)
        utilTitleBar.BackgroundTransparency = 1
        utilTitleBar.Parent = utilMainFrame

        local utilTitleText = Instance.new("TextLabel")
        utilTitleText.Size = UDim2.new(1, -50, 1, 0)
        utilTitleText.Position = UDim2.new(0, 20, 0, 0)
        utilTitleText.BackgroundTransparency = 1
        utilTitleText.Text = "UTILITY HUB"
        utilTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        utilTitleText.Font = Enum.Font.GothamBlack
        utilTitleText.TextSize = 18
        utilTitleText.TextXAlignment = Enum.TextXAlignment.Left
        utilTitleText.Parent = utilTitleBar

        local utilTitleGradient = Instance.new("UIGradient")
        utilTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
        })
        utilTitleGradient.Parent = utilTitleText

        local utilCloseButton = Instance.new("TextButton")
        utilCloseButton.Size = UDim2.new(0, 28, 0, 28)
        utilCloseButton.Position = UDim2.new(1, -38, 0.5, -14)
        utilCloseButton.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
        utilCloseButton.Text = "✕"
        utilCloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        utilCloseButton.Font = Enum.Font.GothamBold
        utilCloseButton.TextSize = 14
        utilCloseButton.AutoButtonColor = false
        utilCloseButton.Parent = utilTitleBar

        local utilCloseCorner = Instance.new("UICorner")
        utilCloseCorner.CornerRadius = UDim.new(0, 8)
        utilCloseCorner.Parent = utilCloseButton

        local currentDisable = nil
        local currentActiveBar = nil

        utilCloseButton.MouseEnter:Connect(function()
            tweenService:Create(utilCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        utilCloseButton.MouseLeave:Connect(function()
            tweenService:Create(utilCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 30, 35), TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        end)

        utilCloseButton.MouseButton1Click:Connect(function()
            if currentDisable then
                currentDisable()
                currentDisable = nil
            end
            screenGui:Destroy()
        end)

        local dragging = false
        local dragStart = nil
        local startPos = nil

        utilTitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = dropShadow.Position
                
                tweenService:Create(dropShadow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        tweenService:Create(dropShadow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
                    end
                end)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    local delta = input.Position - dragStart
                    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    dropShadow.Position = dropShadow.Position:Lerp(targetPos, 0.4)
                end
            end
        end)

        local utilScrollFrame = Instance.new("ScrollingFrame")
        utilScrollFrame.Size = UDim2.new(1, 0, 1, -50)
        utilScrollFrame.Position = UDim2.new(0, 0, 0, 50)
        utilScrollFrame.BackgroundTransparency = 1
        utilScrollFrame.ScrollBarThickness = 2
        utilScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 180)
        utilScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        utilScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        utilScrollFrame.Parent = utilMainFrame

        local utilLayout = Instance.new("UIListLayout")
        utilLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        utilLayout.Padding = UDim.new(0, 10)
        utilLayout.Parent = utilScrollFrame

        local utilPadding = Instance.new("UIPadding")
        utilPadding.PaddingTop = UDim.new(0, 5)
        utilPadding.PaddingBottom = UDim.new(0, 20)
        utilPadding.Parent = utilScrollFrame

        local function getHumanoid()
            local char = LocalPlayer.Character
            if char then
                return char:FindFirstChildOfClass("Humanoid")
            end
            return nil
        end

        local function getRaycast()
            local origin = mouse.UnitRay.Origin
            local direction = mouse.UnitRay.Direction * 1500
            local params = RaycastParams.new()
            local ignoreList = {LocalPlayer.Character}
            params.FilterType = Enum.RaycastFilterType.Exclude

            local maxTries = 50
            local tries = 0

            while tries < maxTries do
                tries = tries + 1
                params.FilterDescendantsInstances = ignoreList
                local result = workspace:Raycast(origin, direction, params)
                
                if not result then return nil end
                
                if result.Instance.Transparency == 1 or not result.Instance.CanCollide then
                    table.insert(ignoreList, result.Instance)
                else
                    return result
                end
            end
            return nil
        end

        local function createUtilButton(text, desc, color1, color2, enableFunc, disableFunc)
            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(0, 230, 0, 55)
            btnFrame.BackgroundTransparency = 1
            btnFrame.Parent = utilScrollFrame

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Position = UDim2.new(0.5, 0, 0.5, 0)
            btn.AnchorPoint = Vector2.new(0.5, 0.5)
            btn.Text = ""
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.AutoButtonColor = false
            btn.ClipsDescendants = true
            btn.Parent = btnFrame

            local activeBar = Instance.new("Frame")
            activeBar.Size = UDim2.new(0, 0, 1, 0)
            activeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            activeBar.BorderSizePixel = 0
            activeBar.Parent = btn

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -15, 0.5, 0)
            titleLbl.Position = UDim2.new(0, 15, 0.15, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = text
            titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 14
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = btn

            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.new(1, -15, 0.35, 0)
            descLbl.Position = UDim2.new(0, 15, 0.55, 0)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = desc
            descLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent = btn

            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color1),
                ColorSequenceKeypoint.new(1, color2)
            })
            gradient.Rotation = 30
            gradient.Parent = btn

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            btn.MouseEnter:Connect(function()
                tweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 4, 1, 4)}):Play()
            end)

            btn.MouseLeave:Connect(function()
                tweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            end)

            btn.MouseButton1Down:Connect(function()
                tweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.96, 0, 0.96, 0)}):Play()
            end)

            btn.MouseButton1Up:Connect(function()
                tweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 4, 1, 4)}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                if currentDisable then
                    currentDisable()
                    currentDisable = nil
                end
                
                if currentActiveBar then
                    tweenService:Create(currentActiveBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 1, 0)}):Play()
                end

                if currentActiveBar == activeBar then
                    currentActiveBar = nil
                    return
                end

                currentActiveBar = activeBar
                currentDisable = disableFunc
                tweenService:Create(activeBar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 8, 1, 0)}):Play()

                if enableFunc then
                    enableFunc()
                end
            end)
        end

        createUtilButton("Speed Toggle", "Sets your running speed to 25", Color3.fromRGB(30, 100, 200), Color3.fromRGB(50, 150, 255), function()
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = 25 end
        end, function()
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = 16 end
        end)

        createUtilButton("Jump Toggle", "Boosts your jump power to 100", Color3.fromRGB(200, 50, 50), Color3.fromRGB(255, 100, 80), function()
            local hum = getHumanoid()
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = 100
            end
        end, function()
            local hum = getHumanoid()
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end
        end)

        createUtilButton("Combined Boost", "Gives you both speed and jump boosts", Color3.fromRGB(120, 50, 200), Color3.fromRGB(180, 100, 255), function()
            local hum = getHumanoid()
            if hum then
                hum.WalkSpeed = 25
                hum.UseJumpPower = true
                hum.JumpPower = 100
            end
        end, function()
            local hum = getHumanoid()
            if hum then
                hum.WalkSpeed = 16
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end
        end)

        local activeConnection = nil

        createUtilButton("TP Cursor", "Right-click to teleport (Max 1000 studs)", Color3.fromRGB(40, 160, 100), Color3.fromRGB(80, 220, 140), function()
            activeConnection = mouse.Button2Down:Connect(function()
                local result = getRaycast()
                local char = LocalPlayer.Character
                if result and char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local distance = (hrp.Position - result.Position).Magnitude
                    
                    if distance <= 1000 then
                        local targetPos = result.Position + Vector3.new(0, 3, 0)
                        hrp.CFrame = CFrame.new(targetPos, targetPos + mouse.UnitRay.Direction * Vector3.new(1, 0, 1))
                    end
                end
            end)
        end, function()
            if activeConnection then
                activeConnection:Disconnect()
                activeConnection = nil
            end
        end)

        createUtilButton("Low Gravity", "Lowers gravity to float around smoothly", Color3.fromRGB(200, 140, 30), Color3.fromRGB(255, 180, 60), function()
            workspace.Gravity = 40
        end, function()
            workspace.Gravity = 196.2
        end)

        local activeFire = nil

        createUtilButton("Fire Aura", "Spawns an epic particle trail behind you", Color3.fromRGB(220, 80, 30), Color3.fromRGB(255, 130, 80), function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                activeFire = Instance.new("Fire")
                activeFire.Size = 6
                activeFire.Heat = 10
                activeFire.Parent = char.HumanoidRootPart
            end
        end, function()
            if activeFire then
                activeFire:Destroy()
                activeFire = nil
            end
        end)

        createUtilButton("Destruction Cursor", "Left-click to delete parts instantly", Color3.fromRGB(180, 40, 120), Color3.fromRGB(240, 80, 160), function()
            activeConnection = mouse.Button1Down:Connect(function()
                local result = getRaycast()
                if result then
                    local target = result.Instance
                    if not target:IsA("Terrain") and not target:FindFirstAncestorOfClass("Humanoid") then
                        target:Destroy()
                    end
                end
            end)
        end, function()
            if activeConnection then
                activeConnection:Disconnect()
                activeConnection = nil
            end
        end)

        createUtilButton("Size Modifier", "Toggles your character into a giant size", Color3.fromRGB(30, 160, 160), Color3.fromRGB(70, 220, 220), function()
            local hum = getHumanoid()
            if hum then
                for _, v in pairs({"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}) do
                    local scale = hum:FindFirstChild(v)
                    if scale then scale.Value = 2.5 end
                end
            end
        end, function()
            local hum = getHumanoid()
            if hum then
                for _, v in pairs({"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}) do
                    local scale = hum:FindFirstChild(v)
                    if scale then scale.Value = 1 end
                end
            end
        end)
    end}
}

local mainGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
mainGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size, mainFrame.Position = UDim2.new(0, 300, 0, 420), UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3, mainFrame.Active = Color3.fromRGB(18, 18, 18), true
Instance.new("UICorner", mainFrame)
makeDraggable(mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size, title.Text = UDim2.new(1, 0, 0, 40), "Leo1333877's Script Hub"
title.BackgroundColor3, title.TextColor3 = Color3.fromRGB(25, 25, 25), Color3.new(1, 1, 1)
Instance.new("UICorner", title)

local closeHub = Instance.new("TextButton", mainFrame)
closeHub.Size, closeHub.Position, closeHub.Text = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5), "X"
closeHub.BackgroundColor3, closeHub.TextColor3 = Color3.fromRGB(120, 30, 30), Color3.new(1, 1, 1)
Instance.new("UICorner", closeHub)
closeHub.MouseButton1Click:Connect(function() mainGui:Destroy() end)

local search = Instance.new("TextBox", mainFrame)
search.Size, search.Position = UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0, 50)
search.PlaceholderText, search.Text = "Search Scripts...", ""
search.BackgroundColor3, search.TextColor3 = Color3.fromRGB(35, 35, 35), Color3.new(1, 1, 1)
Instance.new("UICorner", search)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size, scroll.Position = UDim2.new(0.9, 0, 0.7, 0), UDim2.new(0.05, 0, 0.22, 0)
scroll.BackgroundTransparency, scroll.ScrollBarThickness = 1, 6
local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local buttons = {}
local function createButtons()
    for _, b in pairs(buttons) do b:Destroy() end
    table.clear(buttons)
    for i, v in pairs(scripts) do
        local holder = Instance.new("Frame", scroll)
        holder.Size, holder.BackgroundColor3 = UDim2.new(1, 0, 0, 36), Color3.fromRGB(30, 30, 30)
        holder.LayoutOrder = v.fav and 0 or 1
        Instance.new("UICorner", holder)
        local run = Instance.new("TextButton", holder)
        run.Size, run.Text, run.BackgroundTransparency = UDim2.new(0.8, 0, 1, 0), v.name, 1
        run.TextColor3, run.TextXAlignment = Color3.new(1, 1, 1), Enum.TextXAlignment.Left
        run.Position = UDim2.new(0.05, 0, 0, 0)
        run.MouseButton1Click:Connect(v.run)
        local favBtn = Instance.new("TextButton", holder)
        favBtn.Size, favBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 3)
        favBtn.Text = v.fav and "★" or "☆"
        favBtn.BackgroundColor3 = v.fav and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(45, 45, 45)
        favBtn.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", favBtn)
        favBtn.MouseButton1Click:Connect(function() v.fav = not v.fav createButtons() end)
        buttons[i] = holder
    end
end
createButtons()

search:GetPropertyChangedSignal("Text"):Connect(function()
    for i, v in pairs(scripts) do 
        if buttons[i] then
            buttons[i].Visible = string.find(v.name:lower(), search.Text:lower()) ~= nil 
        end
    end
end)

local shiftHeld = false
RunService.RenderStepped:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.RightShift) then
        if not shiftHeld then shiftHeld = true mainGui.Enabled = not mainGui.Enabled end
    else shiftHeld = false end
end)
