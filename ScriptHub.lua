local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local scripts = {

{name="Fly",fav=false,run=function()

local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")

local flying=false
local speed=60
local move=Vector3.zero
local bv
local bg
local conn

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,220,0,130)
frame.Position=UDim2.new(0.5,-110,0.5,-65)
frame.BackgroundColor3=Color3.fromRGB(20,20,20)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local close=Instance.new("TextButton",frame)
close.Size=UDim2.new(0,25,0,25)
close.Position=UDim2.new(1,-30,0,5)
close.Text="X"
close.BackgroundColor3=Color3.fromRGB(120,30,30)
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close)

local speedBox=Instance.new("TextBox",frame)
speedBox.Size=UDim2.new(0.8,0,0,30)
speedBox.Position=UDim2.new(0.1,0,0.25,0)
speedBox.Text="60"
speedBox.PlaceholderText="Speed"
speedBox.BackgroundColor3=Color3.fromRGB(35,35,35)
speedBox.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",speedBox)

local toggle=Instance.new("TextButton",frame)
toggle.Size=UDim2.new(0.8,0,0,30)
toggle.Position=UDim2.new(0.1,0,0.65,0)
toggle.Text="Start Fly"
toggle.BackgroundColor3=Color3.fromRGB(40,40,40)
toggle.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",toggle)

speedBox:GetPropertyChangedSignal("Text"):Connect(function()
local text=speedBox.Text
text=text:gsub("[^%d%.]","")
speedBox.Text=text
end)

UIS.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.W then move+=Vector3.new(0,0,-1) end
if i.KeyCode==Enum.KeyCode.S then move+=Vector3.new(0,0,1) end
if i.KeyCode==Enum.KeyCode.A then move+=Vector3.new(-1,0,0) end
if i.KeyCode==Enum.KeyCode.D then move+=Vector3.new(1,0,0) end
if i.KeyCode==Enum.KeyCode.Space then move+=Vector3.new(0,1,0) end
if i.KeyCode==Enum.KeyCode.LeftShift then move+=Vector3.new(0,-1,0) end
end)

UIS.InputEnded:Connect(function(i)
if i.KeyCode==Enum.KeyCode.W then move-=Vector3.new(0,0,-1) end
if i.KeyCode==Enum.KeyCode.S then move-=Vector3.new(0,0,1) end
if i.KeyCode==Enum.KeyCode.A then move-=Vector3.new(-1,0,0) end
if i.KeyCode==Enum.KeyCode.D then move-=Vector3.new(1,0,0) end
if i.KeyCode==Enum.KeyCode.Space then move-=Vector3.new(0,1,0) end
if i.KeyCode==Enum.KeyCode.LeftShift then move-=Vector3.new(0,-1,0) end
end)

local function startFly()

speed=tonumber(speedBox.Text) or 60

bv=Instance.new("BodyVelocity")
bv.MaxForce=Vector3.new(1e6,1e6,1e6)
bv.Parent=hrp

bg=Instance.new("BodyGyro")
bg.MaxTorque=Vector3.new(1e6,1e6,1e6)
bg.P=1e4
bg.Parent=hrp

conn=RunService.RenderStepped:Connect(function()

speed=tonumber(speedBox.Text) or speed

local cam=workspace.CurrentCamera
local dir=cam.CFrame:VectorToWorldSpace(move)

bv.Velocity=dir*speed
bg.CFrame=cam.CFrame

end)

end

local function stopFly()

if conn then conn:Disconnect() end
if bv then bv:Destroy() end
if bg then bg:Destroy() end

end

toggle.MouseButton1Click:Connect(function()

flying=not flying

if flying then
toggle.Text="Stop Fly"
startFly()
else
toggle.Text="Start Fly"
stopFly()
end

end)

close.MouseButton1Click:Connect(function()
stopFly()
gui:Destroy()
end)

end},

{name="Freecam", fav=false, run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Leo12345111/Freecam/main/Freecam.lua"))()
end},

{name="Touch Fling", fav=false, run=function()
loadstring(game:HttpGet("https://pastebin.com/raw/LgZwZ7ZB"))()
end},

{name="Player Follower", fav=false, run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Leo12345111/PlayerFollower/main/PlayerFollower.lua"))()
end},

{name="Fling Players", fav=false, run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua"))()
end},

{name="Noclip", fav=false, run=function()
RunService.Stepped:Connect(function()
if LocalPlayer.Character then
for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
end
end
end
end)
end}

}

local gui=Instance.new("ScreenGui",game.CoreGui)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,300,0,420)
frame.Position=UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3=Color3.fromRGB(18,18,18)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.Text="Leo1333877's Script Hub"
title.TextColor3=Color3.new(1,1,1)
title.BackgroundColor3=Color3.fromRGB(25,25,25)
title.Font=Enum.Font.GothamBold
title.TextSize=16

local close=Instance.new("TextButton",frame)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)
close.Text="X"
close.BackgroundColor3=Color3.fromRGB(120,30,30)
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
gui:Destroy()
end)

local search=Instance.new("TextBox",frame)
search.Size=UDim2.new(0.7,0,0,30)
search.Position=UDim2.new(0.05,0,0,50)
search.PlaceholderText="Search Scripts..."
search.BackgroundColor3=Color3.fromRGB(35,35,35)
search.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",search)

local scroll=Instance.new("ScrollingFrame",frame)
scroll.Size=UDim2.new(0.9,0,0.7,0)
scroll.Position=UDim2.new(0.05,0,0.22,0)
scroll.BackgroundTransparency=1
scroll.ScrollBarThickness=6

local layout=Instance.new("UIListLayout",scroll)
layout.Padding=UDim.new(0,6)

local buttons={}

local function refresh(filter)
for i,v in pairs(buttons) do
v.Visible=true
end
if filter~="" then
for i,v in pairs(scripts) do
if not string.find(string.lower(v.name),string.lower(filter)) then
buttons[i].Visible=false
end
end
end
end

for i,v in pairs(scripts) do

local holder=Instance.new("Frame",scroll)
holder.Size=UDim2.new(1,0,0,36)
holder.BackgroundColor3=Color3.fromRGB(30,30,30)
Instance.new("UICorner",holder)

local run=Instance.new("TextButton",holder)
run.Size=UDim2.new(0.8,0,1,0)
run.Text=v.name
run.BackgroundColor3=Color3.fromRGB(40,40,40)
run.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",run)

local fav=Instance.new("TextButton",holder)
fav.Size=UDim2.new(0.2,0,1,0)
fav.Position=UDim2.new(0.8,0,0,0)
fav.Text="☆"
fav.TextColor3=Color3.fromRGB(255,215,0)
fav.BackgroundColor3=Color3.fromRGB(30,30,30)

fav.MouseButton1Click:Connect(function()
v.fav=not v.fav
fav.Text=v.fav and "★" or "☆"
end)

run.MouseButton1Click:Connect(v.run)

table.insert(buttons,holder)

end

search:GetPropertyChangedSignal("Text"):Connect(function()
refresh(search.Text)
end)

local shiftHeld=false

RunService.RenderStepped:Connect(function()

if UIS:IsKeyDown(Enum.KeyCode.RightShift) then
if not shiftHeld then
shiftHeld=true
gui.Enabled=not gui.Enabled
end
else
shiftHeld=false
end

end)
