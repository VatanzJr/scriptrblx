local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window configuration
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Yeet A Friend",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "Vatanz Hub" }
})

Rayfield:Notify({ Title = "Script Loaded", Content = "Welcome!", Duration = 3 })

-- Main Tab
local Tab = Window:CreateTab("Main", "bell-ring")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fixed Player Dropdown
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {"Loading players..."},  -- Initial placeholder
    Flag = "TeleportDropdown",
    Callback = function(Option)
        local target = Players:FindFirstChild(Option[1])
        if target and target.Character then
            local targetHRP = target.Character:WaitForChild("HumanoidRootPart")
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(targetHRP.Position + Vector3.new(0, 3, 0))
            end
        end
    end
})

-- Improved player list handling
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:Refresh({ Options = playerNames })
end

-- Initial update
UpdatePlayerList()

-- Player connection handlers
Players.PlayerAdded:Connect(function()
    task.wait(0.5)  -- Allow time for player initialization
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    UpdatePlayerList()
end)

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})
