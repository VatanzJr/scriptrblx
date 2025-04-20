local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Teleportation System",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Main Tab
local Tab = Window:CreateTab("Main", "bell-ring")

-- Teleport System
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {"Loading players..."},
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer ~= LocalPlayer then
            -- Wait for characters to load
            local targetChar = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
            local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            
            -- Get HRP references
            local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
            local localHRP = localChar:WaitForChild("HumanoidRootPart")
            
            if targetHRP and localHRP then
                -- Teleport with offset (prevents merging)
                localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                Rayfield:Notify({
                    Title = "Teleported!",
                    Content = "Successfully teleported to "..targetName,
                    Duration = 3
                })
            end
        end
    end
})

-- Player List Management
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:SetOptions(playerNames)
end

-- Initial Update
UpdatePlayerList()

-- Player Tracking
Players.PlayerAdded:Connect(function(player)
    task.wait(1) -- Allow character to load
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    UpdatePlayerList()
end)

-- Destroy UI
Tab:CreateButton({
    Name = "Destroy Interface",
    Callback = function()
        Rayfield:Destroy()
    end,
})
