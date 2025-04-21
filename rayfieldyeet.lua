local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Multi-Feature Hub V1",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- Main Tab (Existing Features)
local MainTab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button
MainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})

-- Player Teleport Section
local function GetWorkspacePlayers()
    local validPlayers = {}
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hrp then
                table.insert(validPlayers, model.Name)
            end
        end
    end
    return validPlayers
end

local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = GetWorkspacePlayers(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetModel = Workspace:FindFirstChild(targetName)
        
        if targetModel then
            local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
            local localModel = Workspace:FindFirstChild(Players.LocalPlayer.Name)
            
            if targetHRP and localModel then
                local localHRP = localModel:FindFirstChild("HumanoidRootPart")
                if localHRP then
                    localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                end
            end
        end
    end
})

-- Auto Farm Stars Toggle (automatically enabled)
local AutoStarsToggle = MainTab:CreateToggle({
    Name = "Auto Stars",
    CurrentValue = true,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        _G.AutoFarm = Value
        
        local function MoveStars()
            pcall(function()
                local plr = Players.LocalPlayer
                if plr and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, star in ipairs(Workspace.Stars:GetChildren()) do
                            if star:IsA("Model") and star:FindFirstChild("Root") then
                                star.Root.CFrame = hrp.CFrame
                                game:GetService("ReplicatedStorage").Remote.Star.Server.Collect:FireServer(star.Name)
                            end
                        end
                    end
                end
            end)
        end

        local connection
        if Value then
            connection = Workspace.Stars.ChildAdded:Connect(function(star)
                MoveStars()
            end)
            MoveStars()
        end

        while _G.AutoFarm do
            MoveStars()
            task.wait(0.05)
            if not _G.AutoFarm then break end
        end

        if connection then
            connection:Disconnect()
        end
    end
})
AutoStarsToggle:Set(true)

-- Update List Function
local function UpdateList()
    PlayerDropdown:SetOptions(GetWorkspacePlayers())
end

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        task.wait(0.2)
        UpdateList()
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        UpdateList()
    end
end)
UpdateList()

-- New Tools Tab
local ToolsTab = Window:CreateTab("Tools", "bell-ring") -- "settings" is a gear icon

-- Dark Dex Button
ToolsTab:CreateButton({
    Name = "Open Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
        Rayfield:Notify({
            Title = "Dark Dex Loaded",
            Content = "Explorer opened successfully",
            Duration = 3,
            Image = "check"
        })
    end,
})

-- Optional: Add more tools here
ToolsTab:CreateButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua", true))()
    end,
})
