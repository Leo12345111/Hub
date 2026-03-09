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
    {name="Freecam",fav=false,run=function() safeLoad("https://raw.githubusercontent.com/Leo12345111/Freecam/main/Freecam.lua") end},
    {name="Touch Fling",fav=false,run=function() safeLoad("https://pastebin.com/raw/LgZwZ7ZB") end},
    {name="Player Follower",fav=false,run=function() safeLoad("https://raw.githubusercontent.com/Leo12345111/PlayerFollower/main/PlayerFollower.lua") end},
    {name="Fling Players",fav=false,run=function() safeLoad("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua") end},
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
