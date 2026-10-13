
-- DX TAME BETA | RGB FPS HUD
-- LocalScript > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DXTAME_BETA"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 190)
panel.Position = UDim2.new(0, 20, 0.25, 0)
panel.BackgroundColor3 = Color3.fromRGB(10, 12, 26)
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius =
    UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Parent = panel

local function makeLabel(text, y, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.fromOffset(10, y)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = size
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel
    return label
end

local title = makeLabel("DX TAME BETA", 8, 23)
local fpsText = makeLabel("FPS: --", 48, 18)
local tempText = makeLabel("CPU/GPU TEMP: N/A", 83, 15)
local timeText = makeLabel("TIME: 00:00:00", 115, 16)
local footer = makeLabel("Developed by DX TAME", 150, 13)

local startTime = os.clock()
local elapsed, frames, sample = 0, 0, 0

local function rainbow(t, offset)
    return Color3.fromHSV((t * 0.2 + offset) % 1, 1, 1)
end

RunService.RenderStepped:Connect(function(dt)
    elapsed += dt
    sample += dt
    frames += 1

    title.TextColor3 = rainbow(elapsed, 0)
    fpsText.TextColor3 = rainbow(elapsed, 0.2)
    tempText.TextColor3 = rainbow(elapsed, 0.4)
    timeText.TextColor3 = rainbow(elapsed, 0.6)
    footer.TextColor3 = rainbow(elapsed, 0.8)
    stroke.Color = rainbow(elapsed, 0.1)

    if sample >= 0.5 then
        fpsText.Text = "FPS: " ..
            math.floor(frames / sample + 0.5)
        frames = 0
        sample = 0
    end

    local sec = math.floor(os.clock() - startTime)
    timeText.Text = string.format(
        "TIME: %02d:%02d:%02d",
        math.floor(sec / 3600),
        math.floor((sec % 3600) / 60),
        sec % 60
    )
end)
