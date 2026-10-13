
-- DX TAME BETA | Intro 10 Seconds

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local intro = Instance.new("ScreenGui")
intro.Name = "DXTAME_Intro"
intro.ResetOnSpawn = false
intro.DisplayOrder = 10000
intro.Parent = playerGui

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 100)
nameLabel.Position = UDim2.new(0, 0, 0.4, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "DX TAME"
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBlack
nameLabel.Parent = intro

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 35)
sub.Position = UDim2.new(0, 0, 0.4, 100)
sub.BackgroundTransparency = 1
sub.Text = "BETA • DEVELOPED BY DX TAME"
sub.TextScaled = true
sub.Font = Enum.Font.GothamBold
sub.TextColor3 = Color3.new(1, 1, 1)
sub.Parent = intro

local start = os.clock()
local connection

connection = RunService.RenderStepped:Connect(function()
    local elapsed = os.clock() - start
    local color = Color3.fromHSV((elapsed * 0.35) % 1, 1, 1)

    nameLabel.TextColor3 = color
    sub.TextColor3 = Color3.fromHSV(
        (elapsed * 0.35 + 0.4) % 1, 1, 1
    )

    if elapsed >= 10 then
        connection:Disconnect()
        intro:Destroy()
    end
end)
