local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Player Teleporter",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Main Tab
local Tab = Window:CreateTab("Main", "bell-ring")

-- Teleport System
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {}, -- Start with empty list
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetPlayer = Players[targetName]
        
        if targetPlayer and targetPlayer ~= LocalPlayer then
            local targetChar = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
            local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            
            local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
            local localHRP = localChar:WaitForChild("HumanoidRootPart")
            
            if targetHRP and localHRP then
                localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Teleported to "..targetName,
                    Duration = 2
                })
            end
        end
    end
})

-- Player List Management
local function UpdatePlayerList()
    local playerNames = {}
    
    -- Get all players except yourself
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    -- Update dropdown only if there are players
    if #playerNames > 0 then
        PlayerDropdown:SetOptions(playerNames)
    else
        PlayerDropdown:SetOptions({"No other players"})
    end
end

-- Initial population
UpdatePlayerList()

-- Player tracking
Players.PlayerAdded:Connect(function(player)
    task.wait(0.2) -- Wait for player to fully initialize
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    UpdatePlayerList()
end)

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})
