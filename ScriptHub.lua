local scripts = {

{name="Fly",fav=false,run=function()

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")

local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")

local speed=60
local move=Vector3.zero

local bv
local bg
local conn

local gui=Instance.new("ScreenGui")
gui.Parent=game.CoreGui

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,220,0,130)
frame.Position=UDim2.new(0.5,-110,0.5,-65)
frame.BackgroundColor3=Color3.fromRGB(20,20,20)
frame.Active=true
frame.Draggable=true
frame.Parent=gui
Instance.new("UICorner",frame)

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,25,0,25)
close.Position=UDim2.new(1,-30,0,5)
close.Text="X"
close.BackgroundColor3=Color3.fromRGB(120,30,30)
close.TextColor3=Color3.new(1,1,1)
close.Parent=frame
Instance.new("UICorner",close)

local speedBox=Instance.new("TextBox")
speedBox.Size=UDim2.new(0.8,0,0,30)
speedBox.Position=UDim2.new(0.1,0,0.25,0)
speedBox.Text="60"
speedBox.BackgroundColor3=Color3.fromRGB(35,35,35)
speedBox.TextColor3=Color3.new(1,1,1)
speedBox.Parent=frame
Instance.new("UICorner",speedBox)

local toggle=Instance.new("TextButton")
toggle.Size=UDim2.new(0.8,0,0,30)
toggle.Position=UDim2.new(0.1,0,0.65,0)
toggle.Text="Toggle Fly"
toggle.BackgroundColor3=Color3.fromRGB(40,40,40)
toggle.TextColor3=Color3.new(1,1,1)
toggle.Parent=frame
Instance.new("UICorner",toggle)

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
startFly()
end)

close.MouseButton1Click:Connect(function()
stopFly()
gui:Destroy()
end)

end}, -- <<<<<< IMPORTANT COMMA FIX


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
local Clip=false
RunService.Stepped:Connect(function()
if not Clip and LocalPlayer.Character then
for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide=false
end
end
end
end)
end}

}
