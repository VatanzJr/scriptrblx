local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Teleport System",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- Main Tab
local Tab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button (kept as requested)
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Teleport System
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local localChar = LocalPlayer.Character
            
            if targetHRP and localChar then
                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                if localHRP then
                    -- Two teleport methods (choose one)
                    -- Method 1: Instant teleport
                    localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                    
                    -- Method 2: Natural movement
                    -- LocalPlayer:MoveTo(targetHRP.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
})

-- Player list updater
local function UpdatePlayers()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    PlayerDropdown:SetOptions(playerList)
end

-- Initial update
UpdatePlayers()

-- Connections
Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
