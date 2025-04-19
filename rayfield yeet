local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Star Collector",
    LoadingTitle = "Star Collection System",
    LoadingSubtitle = "by Your Name",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "StarCollectorConfigs",
        FileName = "StarConfig"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Icon ID

MainTab:CreateToggle({
    Name = "Teleport Stars to Me",
    CurrentValue = _G.AutoFarm or false,
    Flag = "AutoFarmToggle", -- For configuration saving
    Callback = function(Value)
        _G.AutoFarm = Value
        
        -- Star collection function
        local function collectStars()
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart then
                    -- Teleport all stars to player
                    for _, star in ipairs(game.Workspace.Stars:GetChildren()) do
                        if star:IsA("Model") and star:FindFirstChild("Root") then
                            -- Instant teleport and collect
                            star.Root.CFrame = humanoidRootPart.CFrame
                            game:GetService("ReplicatedStorage").Remote.Star.Server.Collect:FireServer(star.Name)
                        end
                    end
                end
            end)
        end

        -- Connection management
        if Value then
            -- Create connection for new stars
            _G.StarConnection = game.Workspace.Stars.ChildAdded:Connect(function(star)
                if _G.AutoFarm then
                    task.wait(0.1)
                    collectStars()
                end
            end)
            
            -- Start collection loop
            _G.CollectionLoop = task.spawn(function()
                while _G.AutoFarm do
                    collectStars()
                    task.wait(0.05) -- Aggressive collection interval
                end
            end)
        else
            -- Cleanup when disabled
            if _G.StarConnection then
                _G.StarConnection:Disconnect()
                _G.StarConnection = nil
            end
            if _G.CollectionLoop then
                task.cancel(_G.CollectionLoop)
                _G.CollectionLoop = nil
            end
        end
    end
})

-- Optional: Add notification when loaded
Rayfield:Notify({
    Title = "Star Collector Loaded",
    Content = "Successfully injected star collection system!",
    Duration = 5,
    Image = 4483362458
})
