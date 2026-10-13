--[[
    DX TAME BETA - RGB Gaming HUD
    Roblox Studio LocalScript
    Install: StarterPlayer > StarterPlayerScripts
    Shows: FPS estimate, session timer, RGB rainbow effects.
    Roblox LuaU does not expose real CPU/GPU temperature sensors.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
if not player then
    return
end

local playerGui = player:WaitForChild("PlayerGui")

-- Prevent duplicate HUDs if the script is restarted.
local oldGui = playerGui:FindFirstChild("DXTAME_BETA_HUD")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DXTAME_BETA_HUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(320, 218)
panel.Position = UDim2.new(0, 18, 0.22, 0)
panel.BackgroundColor3 = Color3.fromRGB(9, 12, 27)
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel = 0
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local outline = Instance.new("UIStroke")
outline.Name = "RainbowOutline"
outline.Thickness = 2.5
outline.Color = Color3.fromRGB(0, 255, 255)
outline.Parent = panel

local function addLabel(name, text, y, height, size, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(1, -24, 0, height)
    label.Position = UDim2.fromOffset(12, y)
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = font or Enum.Font.GothamBold
    label.Text = text
    label.TextSize = size
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = false
    label.Parent = panel
    return label
end

local title = addLabel("Title", "DX TAME  //  BETA", 10, 31, 23)
local subtitle = addLabel("Subtitle", "RGB GAMING HUD", 40, 20, 11, Enum.Font.GothamMedium)

local divider = Instance.new("Frame")
divider.Name = "RainbowDivider"
divider.Size = UDim2.new(1, -24, 0, 2)
divider.Position = UDim2.fromOffset(12, 66)
divider.BorderSizePixel = 0
divider.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
divider.Parent = panel

local fpsLabel = addLabel("FPS", "FPS                 --", 77, 25, 16)
local timeLabel = addLabel("SessionTime", "PLAY TIME      00:00:00", 106, 25, 14)
local pingLabel = addLabel("Ping", "PING                N/A", 135, 23, 13)
local tempLabel = addLabel("Temperature", "CPU / GPU TEMP   N/A", 160, 22, 12)
local footer = addLabel("Footer", "Developed by DX TAME", 187, 20, 12, Enum.Font.GothamMedium)

-- Small close button so the HUD can be hidden.
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(24, 24)
closeButton.Position = UDim2.new(1, -30, 0, 7)
closeButton.BackgroundColor3 = Color3.fromRGB(35, 39, 58)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = panel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.Activated:Connect(function()
    gui.Enabled = false
end)

-- Tap/click the small BETA tag area? Use a reopen button outside the panel.
local reopenButton = Instance.new("TextButton")
reopenButton.Name = "ReopenButton"
reopenButton.Size = UDim2.fromOffset(118, 34)
reopenButton.Position = UDim2.new(0, 18, 0.22, 0)
reopenButton.BackgroundColor3 = Color3.fromRGB(12, 16, 34)
reopenButton.Text = "DX TAME HUD"
reopenButton.TextColor3 = Color3.new(1, 1, 1)
reopenButton.TextSize = 13
reopenButton.Font = Enum.Font.GothamBold
reopenButton.Visible = false
reopenButton.Parent = gui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 8)
reopenCorner.Parent = reopenButton

local reopenStroke = Instance.new("UIStroke")
reopenStroke.Thickness = 2
reopenStroke.Parent = reopenButton

closeButton.Activated:Connect(function()
    panel.Visible = false
    reopenButton.Visible = true
end)

reopenButton.Activated:Connect(function()
    panel.Visible = true
    reopenButton.Visible = false
end)

local function rainbow(t, offset)
    return Color3.fromHSV((t * 0.20 + offset) % 1, 1, 1)
end

local startedAt = os.clock()
local animationTime = 0
local fpsFrames = 0
local fpsElapsed = 0
local refreshElapsed = 0
local currentFps = 0

local function getPingText()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)

    if ok and type(value) == "number" then
        return string.format("%.0f ms", value)
    end

    return "N/A"
end

RunService.RenderStepped:Connect(function(dt)
    animationTime += dt
    fpsFrames += 1
    fpsElapsed += dt
    refreshElapsed += dt

    title.TextColor3 = rainbow(animationTime, 0.00)
    subtitle.TextColor3 = rainbow(animationTime, 0.18)
    fpsLabel.TextColor3 = rainbow(animationTime, 0.34)
    timeLabel.TextColor3 = rainbow(animationTime, 0.50)
    pingLabel.TextColor3 = rainbow(animationTime, 0.66)
    tempLabel.TextColor3 = rainbow(animationTime, 0.80)
    footer.TextColor3 = rainbow(animationTime, 0.92)
    outline.Color = rainbow(animationTime, 0.12)
    divider.BackgroundColor3 = rainbow(animationTime, 0.42)
    reopenStroke.Color = rainbow(animationTime, 0.12)

    if fpsElapsed >= 0.5 then
        currentFps = math.floor((fpsFrames / fpsElapsed) + 0.5)
        fpsLabel.Text = string.format("FPS                 %d", currentFps)
        fpsFrames = 0
        fpsElapsed = 0
    end

    if refreshElapsed >= 1 then
        local elapsed = math.floor(os.clock() - startedAt)
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60

        timeLabel.Text = string.format(
            "PLAY TIME      %02d:%02d:%02d",
            hours,
            minutes,
            seconds
        )
        pingLabel.Text = "PING                " .. getPingText()
        refreshElapsed = 0
    end
end)

print("[DX TAME BETA] HUD loaded successfully.")
