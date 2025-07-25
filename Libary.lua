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

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    self.Gui = gui
    self.Frame = frame
    self.Container = container
    self.Layout = layout

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
        if callback then callback() end
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
        if callback then callback(toggled) end
    end)
end

function SimpleUI:AddSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Parent = self.Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.Text = text .. ": " .. default
    label.Parent = frame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0.5, -5)
    slider.Position = UDim2.new(0, 5, 0.5, 5)
    slider.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    slider.Text = ""
    slider.BorderSizePixel = 0
    slider.Parent = frame

    local fill = Instance.new("Frame", slider)
    fill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

    local dragging = false
    local function update(input)
        local relX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local value = math.floor((relX * (max - min)) + min + 0.5)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        label.Text = text .. ": " .. value
        if callback then callback(value) end
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

function SimpleUI:AddInput(text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Parent = self.Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -5, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.Text = text
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Parent = frame

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.6, -10, 1, -10)
    inputBox.Position = UDim2.new(0.4, 5, 0, 5)
    inputBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.PlaceholderText = placeholder or ""
    inputBox.Text = ""
    inputBox.Font = Enum.Font.SourceSans
    inputBox.TextSize = 18
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = frame

    inputBox.FocusLost:Connect(function(enter)
        if enter and callback then
            callback(inputBox.Text)
        end
    end)
end

function SimpleUI:AddSeparator()
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -10, 0, 2)
    sep.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sep.BorderSizePixel = 0
    sep.Parent = self.Container
end

-- RightShift UI toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        local gui = player.PlayerGui:FindFirstChild("SimpleUI")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end
end)

-- Create global UI window:
local MainUI = SimpleUI:CreateWindow("Simple UI")

function run(func)
    func(MainUI)
end
