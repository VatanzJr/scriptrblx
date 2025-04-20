local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Workspace-Based Teleport",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button (as requested)
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Get player models directly from Workspace
local function GetWorkspacePlayers()
    local validPlayers = {}
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") then
            local hrp = child:FindFirstChild("HumanoidRootPart")
            local isPlayer = Players:FindFirstChild(child.Name)
            
            -- Exclude self and non-player models
            if hrp and isPlayer and child.Name ~= LocalPlayer.Name then
                table.insert(validPlayers, child.Name)
            end
        end
    end
    return validPlayers
end

-- Teleport to Workspace model
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = GetWorkspacePlayers(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetModel = Workspace:FindFirstChild(targetName)
        
        if targetModel then
            local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
            local localModel = Workspace:WaitForChild(LocalPlayer.Name)
            
            if targetHRP and localModel then
                local localHRP = localModel:WaitForChild("HumanoidRootPart")
                localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

-- Update when models change
local function UpdateList()
    PlayerDropdown:SetOptions(GetWorkspacePlayers())
end

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        task.wait(0.5) -- Wait for HRP to load
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
