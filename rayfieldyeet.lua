local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Window = Rayfield:CreateWindow({
    Name = "Teleport by Display Name",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Destroy UI Button
Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})

-- Fungsi untuk mendapatkan DisplayName dan username
local function GetPlayerDisplayNames()
    local playerData = {}
    
    -- Cari semua model di Workspace
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            -- Cari player berdasarkan username (nama model)
            local player = Players:FindFirstChild(model.Name)
            if player then
                table.insert(playerData, {
                    DisplayName = player.DisplayName,
                    UserName = player.Name
                })
            end
        end
    end
    
    return playerData
end

-- Buat dropdown dengan DisplayName
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local selectedDisplayName = Selected[1]
        
        -- Cari username yang sesuai dengan DisplayName
        for _, data in ipairs(GetPlayerDisplayNames()) do
            if data.DisplayName == selectedDisplayName then
                local targetModel = Workspace:FindFirstChild(data.UserName)
                local localModel = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                
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
    local players = GetPlayerDisplayNames()
    local displayNames = {}
    
    for _, data in ipairs(players) do
        table.insert(displayNames, data.DisplayName)
    end
    
    PlayerDropdown:SetOptions(displayNames)
end

-- Update saat ada perubahan di Workspace
Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        task.wait(0.5) -- Tunggu HRP terload
        UpdateList()
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        UpdateList()
    end
end)

-- Update awal
UpdateList()
