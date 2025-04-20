local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")

local Window = Rayfield:CreateWindow({
    Name = "Workspace Player Teleporter",
    LoadingTitle = "Direct Model Detection",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})

-- Get all valid player models in Workspace
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

-- Teleport between models
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player Model",
    Options = GetWorkspacePlayers(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetModel = Workspace:FindFirstChild(targetName)
        
        if targetModel then
            local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
            local localModel = Workspace:FindFirstChild(game.Players.LocalPlayer.Name)
            
            if targetHRP and localModel then
                local localHRP = localModel:FindFirstChild("HumanoidRootPart")
                if localHRP then
                    localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
                end
            end
        end
    end
})

-- Update list when models change
local function UpdateList()
    PlayerDropdown:SetOptions(GetWorkspacePlayers())
end

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        task.wait(0.2) -- Wait for potential HRP initialization
        UpdateList()
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        UpdateList()
    end
end)

-- Initial update
UpdateList()
