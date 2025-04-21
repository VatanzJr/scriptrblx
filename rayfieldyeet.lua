local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Multi-Feature Hub",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- ===== MAIN TAB =====
local MainTab = Window:CreateTab("Main", "bell-ring")

MainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Teleport to Player
local function GetWorkspacePlayers()
    local validPlayers = {}
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, model.Name)
        end
    end
    return validPlayers
end

local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = GetWorkspacePlayers(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local targetName = Selected[1]
        local targetModel = Workspace:FindFirstChild(targetName)
        if targetModel and targetModel:FindFirstChild("HumanoidRootPart") then
            local localChar = Workspace:FindFirstChild(Players.LocalPlayer.Name)
            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                localChar.HumanoidRootPart.CFrame = targetModel.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

-- Auto Stars Toggle (Fixed)
local AutoStarsToggle = MainTab:CreateToggle({
    Name = "Auto Stars",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        _G.AutoFarm = Value

        if Value then
            _G.StarLoop = true

            local function MoveStars()
                pcall(function()
                    local char = Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, star in ipairs(Workspace.Stars:GetChildren()) do
                            if star:IsA("Model") and star:FindFirstChild("Root") then
                                star.Root.CFrame = char.HumanoidRootPart.CFrame
                                game:GetService("ReplicatedStorage").Remote.Star.Server.Collect:FireServer(star.Name)
                            end
                        end
                    end
                end)
            end

            -- Initial grab
            MoveStars()
            _G.starConnection = Workspace.Stars.ChildAdded:Connect(MoveStars)

        else
            _G.StarLoop = false
            if _G.starConnection then
                _G.starConnection:Disconnect()
                _G.starConnection = nil
            end
        end
    end
})

-- ===== TOOLS TAB =====
local ToolsTab = Window:CreateTab("Tools", "settings")

ToolsTab:CreateButton({
    Name = "Open Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
        Rayfield:Notify({
            Title = "Success",
            Content = "Dark Dex loaded!",
            Duration = 3,
            Image = "check"
        })
    end,
})

ToolsTab:CreateButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua", true))()
    end,
})

-- ===== TEST TAB =====
local TestTab = Window:CreateTab("Test", "flame")

-- Original ThrowArea CFrame
local OriginalThrowCFrame = CFrame.new(
    -95.644928, 3.56980205, -109.045753,
    -1, 0, 0,
     0, 1, 0,
     0, 0, -1
)

TestTab:CreateToggle({
    Name = "Auto Throw",
    CurrentValue = false,
    Flag = "AutoThrowToggle",
    Callback = function(value)
        _G.Loop = value
        if value then
            task.spawn(function()
                while _G.Loop do
                    pcall(function()
                        local char = Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local throwArea = Workspace:FindFirstChild("World"):FindFirstChild("ThrowArea")
                            if throwArea and throwArea:IsA("Part") then
                                throwArea.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -3, 5)
                            end

                            local throwRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Throw"):WaitForChild("Server"):WaitForChild("Request")
                            throwRemote:FireServer()
                        end
                    end)
                    task.wait(7)
                end
            end)
        else
            local throwArea = Workspace:FindFirstChild("World"):FindFirstChild("ThrowArea")
            if throwArea and throwArea:IsA("Part") then
                throwArea.CFrame = OriginalThrowCFrame
            end
        end
    end
})

-- ===== AUTO-UPDATES =====
local function UpdateList()
    PlayerDropdown:SetOptions(GetWorkspacePlayers())
end

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        task.wait(0.5)
        UpdateList()
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        UpdateList()
    end
end)

-- Initial setup
UpdateList()
