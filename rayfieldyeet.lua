local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Display Name Teleporter",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})

-- Get players with display names and valid models
local function GetPlayersWithModels()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = Workspace:FindFirstChild(player.Name)
            if character and character:FindFirstChild("HumanoidRootPart") then
                table.insert(playerList, {
                    DisplayName = player.DisplayName,
                    UserName = player.Name
                })
            end
        end
    end
    return playerList
end

-- Create dropdown with display names
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetDisplayName = Selected[1]
        for _, data in ipairs(GetPlayersWithModels()) do
            if data.DisplayName == targetDisplayName then
                local targetModel = Workspace:FindFirstChild(data.UserName)
                local localModel = Workspace:FindFirstChild(LocalPlayer.Name)
                
                if targetModel and localModel then
                    local targetHRP = targetModel.HumanoidRootPart
                    local localHRP = localModel.HumanoidRootPart
                    localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                end
                break
            end
        end
    end
})

-- Update dropdown list
local function UpdateList()
    local players = GetPlayersWithModels()
    local displayNames = {}
    for _, data in ipairs(players) do
        table.insert(displayNames, data.DisplayName)
    end
    PlayerDropdown:SetOptions(displayNames)
end

-- Track player changes
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)
Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        task.wait(0.5)
        UpdateList()
    end
end)

-- Initial update
UpdateList()
