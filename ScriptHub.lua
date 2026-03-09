local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local scripts = {

{name="Fly",fav=false,run=function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator"))()
end},

{name="Freecam",fav=false,run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Leo12345111/Freecam/refs/heads/main/Freecam.lua"))()
end},

{name="Touch Fling",fav=false,run=function()
loadstring(game:HttpGet("https://pastebin.com/raw/LgZwZ7ZB",true))()
end},

{name="Player Follower",fav=false,run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Leo12345111/PlayerFollower/main/PlayerFollower.lua"))()
end},

{name="Fling Players",fav=false,run=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua"))()
end}

}

local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Enabled=true

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,300,0,420)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.Active=true
frame.Draggable=true

local title = Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.Text="Leo1333877's Script Hub"
title.TextColor3=Color3.new(1,1,1)
title.BackgroundColor3=Color3.fromRGB(25,25,25)
title.Font=Enum.Font.GothamBold
title.TextSize=16

local close = Instance.new("TextButton",frame)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)
close.Text="X"
close.BackgroundColor3=Color3.fromRGB(120,30,30)
close.TextColor3=Color3.new(1,1,1)

close.MouseButton1Click:Connect(function()
gui.Enabled=false
end)

local search = Instance.new("TextBox",frame)
search.Size=UDim2.new(0.7,0,0,30)
search.Position=UDim2.new(0.05,0,0,50)
search.PlaceholderText="Search Scripts..."
search.BackgroundColor3=Color3.fromRGB(35,35,35)
search.TextColor3=Color3.new(1,1,1)

local clear = Instance.new("TextButton",frame)
clear.Size=UDim2.new(0,30,0,30)
clear.Position=UDim2.new(0.76,0,0,50)
clear.Text="X"
clear.BackgroundColor3=Color3.fromRGB(60,60,60)
clear.TextColor3=Color3.new(1,1,1)

local scroll = Instance.new("ScrollingFrame",frame)
scroll.Size=UDim2.new(0.9,0,0.7,0)
scroll.Position=UDim2.new(0.05,0,0.22,0)
scroll.BackgroundTransparency=1

local layout = Instance.new("UIListLayout",scroll)
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

local holder = Instance.new("Frame",scroll)
holder.Size=UDim2.new(1,0,0,36)
holder.BackgroundColor3=Color3.fromRGB(30,30,30)

local run = Instance.new("TextButton",holder)
run.Size=UDim2.new(0.8,0,1,0)
run.Text=v.name
run.BackgroundColor3=Color3.fromRGB(40,40,40)
run.TextColor3=Color3.new(1,1,1)

local fav = Instance.new("TextButton",holder)
fav.Size=UDim2.new(0.2,0,1,0)
fav.Position=UDim2.new(0.8,0,0,0)
fav.Text="☆"
fav.BackgroundColor3=Color3.fromRGB(30,30,30)
fav.TextColor3=Color3.fromRGB(255,215,0)

run.MouseButton1Click:Connect(function()
v.run()
end)

fav.MouseButton1Click:Connect(function()

v.fav = not v.fav

if v.fav then
fav.Text="★"
holder.LayoutOrder=-1
else
fav.Text="☆"
holder.LayoutOrder=1
end

end)

table.insert(buttons,holder)

end

search:GetPropertyChangedSignal("Text"):Connect(function()
refresh(search.Text)
end)

clear.MouseButton1Click:Connect(function()
search.Text=""
refresh("")
end)

UIS.InputBegan:Connect(function(input,gp)

if gp then return end

if input.KeyCode==Enum.KeyCode.RightShift then
gui.Enabled = not gui.Enabled
end

end)
