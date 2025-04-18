local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Initialize variables
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local collecting = false
local loopRunning = false
local stepDelay = 0.12

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "🌟 Star Collector",
    LoadingTitle = "Initializing Star Collector...",
    LoadingSubtitle = "Powered by Rayfield",
    ConfigurationSaving = {
        Enabled = false,
    }
})

-- Main tab
local MainTab = Window:CreateTab("Main Controls", 11777753337)

-- Auto Collect Toggle
MainTab:CreateToggle({
    Name = "Auto Collect Stars",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        collecting = Value
        if Value then
            collectStars()
            Rayfield:Notify({
                Title = "Collection Started",
                Content = "Star collecting activated!",
                Duration = 3,
                Image = 11777740008
            })
        else
            Rayfield:Notify({
                Title = "Collection Stopped",
                Content = "Star collecting disabled!",
                Duration = 3,
                Image = 11777740034
            })
        end
    end
})

-- Speed Slider
MainTab:CreateSlider({
    Name = "Collection Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "Seconds",
    CurrentValue = stepDelay,
    Flag = "CollectSpeed",
    Callback = function(Value)
        stepDelay = Value
    end
})

-- Info Section
MainTab:CreateSection("Information")
MainTab:CreateLabel("Status: "..(collecting and "Active" or "Inactive"))
MainTab:CreateLabel("Current Speed: "..stepDelay.."s")

-- Collection function
local function collectStars()
    if loopRunning then return end
    loopRunning = true

    while collecting do
        for _, star in pairs(workspace.Stars:GetDescendants()) do
            if not collecting then break end
            if star:IsA("BasePart") then
                local targetCFrame = star.CFrame + Vector3.new(0, 3, 0)
                char:PivotTo(targetCFrame)
                task.wait(stepDelay)
            end
        end
        task.wait(0.5)
    end

    loopRunning = false
end

-- Initialize UI
Rayfield:LoadConfiguration()
