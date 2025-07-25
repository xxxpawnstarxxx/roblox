local Camera = game.Workspace.CurrentCamera

function ShowNotification(options)
    options = options or {}

    local config = {
        Text = options.Text or "Notification Text",
        Color = options.Color or Color3.fromRGB(255, 0, 0),
        Duration = options.Duration or 3,
        Center = options.Center or true,
        Outline = options.Outline or true,
        Speed = options.Speed or 0.5
    }

    local notify = Drawing.new("Text")
    notify.Visible = true
    notify.Font = 2
    notify.Center = config.Center
    notify.Size = 15
    notify.Outline = config.Outline
    notify.Transparency = 1
    notify.Color = config.Color
    notify.Text = config.Text
    notify.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    task.spawn(function()
        for i = 0, 10, config.Speed do
            task.wait()
            notify.Position = Vector2.new(notify.Position.X, math.clamp(notify.Position.Y - ((config.Speed * 10) * i), Camera.ViewportSize.Y / 2, math.huge))
            notify.Transparency = (i - config.Speed) / 10
            if notify.Position.Y == Camera.ViewportSize.Y / 2 then
                notify.Transparency = 1
                break
            end
        end

        task.wait(config.Duration)

        for i = 1, 100 do
            task.wait()
            notify.Transparency = notify.Transparency - 0.01
        end

        notify:Remove()
    end)
end

-- Example Usage
ShowNotification({
    Text = "This is a Notification.",
    Duration = 5,
    Speed = 0.1,
    Center = true,
    Outline = true,
    Color = Color3.fromRGB(0, 255, 0)
})
