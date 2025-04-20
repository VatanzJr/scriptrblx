local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Proper Teleport System",
    LoadingSubtitle = "Using Workspace Characters",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Get ACTUAL PLAYER MODELS from Workspace
local function GetPlayerModels()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = Workspace:FindFirstChild(player.Name)
            if character then
                table.insert(players, player.Name)
            end
        end
    end
    return players
end

-- Teleport to Workspace character
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = GetPlayerModels(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetCharacter = Workspace:FindFirstChild(targetName)
        
        if targetCharacter then
            local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
            local localCharacter = Workspace:FindFirstChild(LocalPlayer.Name)
            
            if targetHRP and localCharacter then
                local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
                if localHRP then
                    localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                    Rayfield:Notify({
                        Title = "Teleported!",
                        Content = "Moved to "..targetName.."'s position",
                        Duration = 3
                    })
                end
            end
        end
    end
})

-- Update player list in real-time
local function UpdateDropdown()
    PlayerDropdown:SetOptions(GetPlayerModels())
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(0.5) -- Wait for model to load
        UpdateDropdown()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    UpdateDropdown()
end)

-- Initial update
UpdateDropdown()

Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})
