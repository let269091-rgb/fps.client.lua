
-- DX TAME BETA | RGB MOVABLE GAMING MENU
-- LocalScript: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("DXTAME_BETA")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DXTAME_BETA"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function outline(obj, thickness)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Parent = obj
    return s
end

local function label(parent, text, y, height, size)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, height)
    t.Position = UDim2.fromOffset(10, y)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.Text = text
    t.TextSize = size
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

-- INTRO
local intro = Instance.new("Frame")
intro.Size = UDim2.fromOffset(320, 100)
intro.Position = UDim2.new(0.5, -160, 0.4, 0)
intro.BackgroundColor3 = Color3.fromRGB(10, 12, 28)
intro.Parent = gui
round(intro, 14)
local introStroke = outline(intro, 3)

local introTitle = label(intro, "DX TAME", 10, 45, 30)
introTitle.TextXAlignment = Enum.TextXAlignment.Center

local introSub = label(intro, "BETA • DEVELOPED BY DX TAME", 60, 25, 12)
introSub.TextXAlignment = Enum.TextXAlignment.Center

-- MAIN MENU
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 220)
panel.Position = UDim2.new(0, 25, 0.25, 0)
panel.BackgroundColor3 = Color3.fromRGB(9, 12, 26)
panel.Visible = false
panel.Parent = gui
round(panel, 12)
local panelStroke = outline(panel, 2.5)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 24, 43)
header.Parent = panel
round(header, 12)

local title = label(header, "DX TAME | BETA", 3, 32, 16)
title.Size = UDim2.new(1, -85, 0, 32)

local function button(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(35, 39, 59)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    round(b, 7)
    return b
end

local minimize = button(header, "−", UDim2.fromOffset(28, 27), UDim2.new(1, -63, 0, 6))
local close = button(header, "×", UDim2.fromOffset(28, 27), UDim2.new(1, -31, 0, 6))

local subtitle = label(panel, "RGB GAMING MONITOR", 46, 20, 11)
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.fromOffset(10, 69)
divider.Parent = panel

local fpsText = label(panel, "FPS              --", 78, 25, 15)
local timeText = label(panel, "PLAY TIME    00:00:00", 107, 25, 14)
local pingText = label(panel, "PING             N/A", 136, 25, 14)
local tempText = label(panel, "CPU/GPU TEMP  N/A", 165, 22, 12)
local footer = label(panel, "Developed by DX TAME", 192, 20, 11)

-- FLOATING CIRCLE
local circle = button(gui, "DX", UDim2.fromOffset(58, 58), UDim2.new(0, 25, 0.35, 0))
circle.Visible = false
circle.TextSize = 19
round(circle, 100)
local circleStroke = outline(circle, 3)

-- Drag panel by header; drag circle by itself.
local function makeDraggable(handle, target)
    local dragging = false
    local startInput, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startInput
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(header, panel)
makeDraggable(circle, circle)

minimize.Activated:Connect(function()
    circle.Position = panel.Position
    panel.Visible = false
    circle.Visible = true
end)

circle.Activated:Connect(function()
    panel.Position = circle.Position
    circle.Visible = false
    panel.Visible = true
end)

close.Activated:Connect(function()
    panel.Visible = false
    circle.Visible = true
end)

local function rainbow(t, offset)
    return Color3.fromHSV((t * 0.22 + offset) % 1, 1, 1)
end

local function getPing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then
        return string.format("%.0f ms", value)
    end
    return "N/A"
end

local start = os.clock()
local animation = 0
local introTime = 0
local frames = 0
local fpsElapsed = 0
local refreshElapsed = 0

RunService.RenderStepped:Connect(function(dt)
    animation += dt
    introTime += dt
    frames += 1
    fpsElapsed += dt
    refreshElapsed += dt

    introTitle.TextColor3 = rainbow(animation, 0)
    introSub.TextColor3 = rainbow(animation, 0.4)
    introStroke.Color = rainbow(animation, 0.2)

    title.TextColor3 = rainbow(animation, 0)
    subtitle.TextColor3 = rainbow(animation, 0.25)
    panelStroke.Color = rainbow(animation, 0.1)
    divider.BackgroundColor3 = rainbow(animation, 0.5)
    circle.TextColor3 = rainbow(animation, 0.3)
    circleStroke.Color = rainbow(animation, 0.15)
    footer.TextColor3 = rainbow(animation, 0.7)
    fpsText.TextColor3 = rainbow(animation, 0.1)
    timeText.TextColor3 = rainbow(animation, 0.35)
    pingText.TextColor3 = rainbow(animation, 0.6)
    tempText.TextColor3 = rainbow(animation, 0.85)

    if introTime >= 10 and intro.Parent then
        intro:Destroy()
        panel.Visible = true
    end

    if fpsElapsed >= 0.5 then
        fpsText.Text = string.format(
            "FPS              %d",
            math.floor(frames / fpsElapsed + 0.5)
        )
        frames = 0
        fpsElapsed = 0
    end

    if refreshElapsed >= 1 then
        local sec = math.floor(os.clock() - start)
        timeText.Text = string.format(
            "PLAY TIME    %02d:%02d:%02d",
            math.floor(sec / 3600),
            math.floor((sec % 3600) / 60),
            sec % 60
        )
        pingText.Text = "PING             " .. getPing()
        refreshElapsed = 0
    end
end)

print("[DX TAME BETA] RGB menu loaded")
