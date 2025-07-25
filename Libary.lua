local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SimpleUI = {}
SimpleUI.__index = SimpleUI

function SimpleUI:CreateWindow(title)
    local self = setmetatable({}, SimpleUI)

    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "SimpleUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 350, 0, 400)
    frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 24
    titleLabel.Text = title or "Simple UI"
    titleLabel.BorderSizePixel = 0

    local container = Instance.new("ScrollingFrame", frame)
    container.Size = UDim2.new(1, 0, 1, -40)
    container.Position = UDim2.new(0, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 6
    container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local layout = Instance.new("UIListLayout", container)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    self.Gui = gui
    self.Frame = frame
    self.Container = container
    self.Layout = layout

    -- Auto update canvas size based on contents
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    return self
end

function SimpleUI:AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = text
    btn.Parent = self.Container

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

function SimpleUI:AddToggle(text, default, callback)
    local toggled = default or false

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = (toggled and "[✓] " or "[ ] ") .. text
    btn.Parent = self.Container

    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.Text = (toggled and "[✓] " or "[ ] ") .. text
        if callback then
            callback(toggled)
        end
    end)
end

-- Optional: hide/show UI with RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        local gui = player.PlayerGui:FindFirstChild("SimpleUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
end)

-- Create one global UI window:
local MainUI = SimpleUI:CreateWindow("Simple UI")

-- Run function to add buttons/toggles easily
function run(func)
    func(MainUI)
end
