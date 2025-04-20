local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window configuration
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    Icon = 11708967881,
    LoadingTitle = "Yeet A Friend",
    LoadingSubtitle = "by Vatanz",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Vatanz Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Notification
Rayfield:Notify({
    Title = "Hello User",
    Content = "Script has loaded",
    Duration = 6.5,
    Image = "bell-ring",
})

-- Main Tab
local Tab = Window:CreateTab("Main", "bell-ring")
Tab:CreateDivider()

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Player Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Teleport System
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TeleportDropdown",
    Callback = function(Options)
        local selectedName = Options[1]
        
        -- Find target player
        local targetPlayer
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name == selectedName then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer then
            -- Wait for both characters to load
            local targetChar = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
            local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            
            local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
            local localHRP = localChar:WaitForChild("HumanoidRootPart")
            
            if targetHRP and localHRP then
                -- Teleport with vertical offset
                localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end,
})

-- Player list management
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local function RefreshDropdown()
    PlayerDropdown:SetOptions(GetPlayerNames())
end

-- Initial setup
RefreshDropdown()

-- Player tracking
Players.PlayerAdded:Connect(function(player)
    task.wait(0.5) -- Allow time for initialization
    RefreshDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1)
    RefreshDropdown()
end)
