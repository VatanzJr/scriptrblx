local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Teleport by Display Name",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

local Tab = Window:CreateTab("Main", "bell-ring")

-- Debugging function
local function debug(message)
    print("[DEBUG] " .. message)
    Rayfield:Notify({
        Title = "Debug",
        Content = message,
        Duration = 3
    })
end

-- Get valid players with models
local function GetValidPlayers()
    local valid = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = Workspace:FindFirstChild(player.Name)
            if character and character:FindFirstChild("HumanoidRootPart") then
                debug("Found valid player: " .. player.DisplayName)
                table.insert(valid, {
                    DisplayName = player.DisplayName,
                    UserName = player.Name
                })
            else
                debug("Missing model/HRP for: " .. player.DisplayName)
            end
        end
    end
    return valid
end

-- Create dropdown
local PlayerDropdown = Tab:CreateDropdown({
    Name = "Select Player",
    Options = {"Loading..."},
    Flag = "TeleportDropdown"
})

-- Update dropdown
local function UpdateList()
    debug("Updating player list...")
    local players = GetValidPlayers()
    
    if #players == 0 then
        debug("No valid players found")
        PlayerDropdown:SetOptions({"No players available"})
        return
    end
    
    local displayNames = {}
    for _, data in ipairs(players) do
        table.insert(displayNames, data.DisplayName)
    end
    
    PlayerDropdown:SetOptions(displayNames)
    debug("List updated with " .. #displayNames .. " players")
end

-- Character tracking
local function TrackCharacter(player)
    player.CharacterAdded:Connect(function(char)
        debug("Character added: " .. player.Name)
        UpdateList()
    end)
    
    player.CharacterRemoving:Connect(function(char)
        debug("Character removed: " .. player.Name)
        UpdateList()
    end)
end

-- Initial setup
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        TrackCharacter(player)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    debug("New player joined: " .. newPlayer.Name)
    TrackCharacter(newPlayer)
    UpdateList()
end)

Players.PlayerRemoving:Connect(function(leftPlayer)
    debug("Player left: " .. leftPlayer.Name)
    UpdateList()
end)

-- First update
UpdateList()

Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
})
