local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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
    Callback = function() Rayfield:Destroy() end,
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
        local localModel = Workspace:FindFirstChild(Players.LocalPlayer.Name)
        if targetModel and targetModel:FindFirstChild("HumanoidRootPart") and localModel and localModel:FindFirstChild("HumanoidRootPart") then
            localModel.HumanoidRootPart.CFrame = targetModel.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
})

-- ===== AUTO STARS =====
local function MoveStars()
    pcall(function()
        local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, star in ipairs(Workspace.Stars:GetChildren()) do
                if star:IsA("Model") and star:FindFirstChild("Root") then
                    star.Root.CFrame = char.HumanoidRootPart.CFrame
                    ReplicatedStorage.Remote.Star.Server.Collect:FireServer(star.Name)
                end
            end
        end
    end)
end

local AutoStarsToggle
AutoStarsToggle = MainTab:CreateToggle({
    Name = "Auto Stars",
    CurrentValue = false,
    Flag = "AutoStarsToggle",
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            _G.starLoopThread = task.spawn(function()
                while _G.AutoFarm do
                    MoveStars()
                    task.wait(2)
                end
            end)
        else
            if _G.starLoopThread then
                task.cancel(_G.starLoopThread)
                _G.starLoopThread = nil
            end
        end
    end
})

-- Force toggle ON visually and functionally on script run
task.defer(function()
    AutoStarsToggle:Set(true)
end)

-- ===== TOOLS TAB =====
local ToolsTab = Window:CreateTab("Tools", "settings")

ToolsTab:CreateButton({
    Name = "Open Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
        Rayfield:Notify({ Title = "Success", Content = "Dark Dex loaded!", Duration = 3, Image = "check" })
    end,
})

ToolsTab:CreateButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
    end,
})

-- ===== TEST TAB (Auto Throw & Sync ThrowArea) =====
local TestTab = Window:CreateTab("Test", "flame")

-- Auto Throw (old logic, now optional)
-- You can remove this if not needed anymore
TestTab:CreateToggle({
    Name = "Auto Throw (Old)",
    CurrentValue = false,
    Flag = "AutoThrowOld",
    Callback = function(Value)
        _G.Loop = Value
        if Value then
            _G.throwLoop = task.spawn(function()
                while _G.Loop do
                    pcall(function()
                        local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local oldCFrame = hrp.CFrame
                            local throwRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Throw"):WaitForChild("Server"):WaitForChild("Request")
                            hrp.CFrame = CFrame.new(-95.644928, 3.56980205, -109.045753)
                            task.wait(0.3)
                            throwRemote:FireServer()
                            task.wait(7)
                            hrp.CFrame = oldCFrame
                        end
                    end)
                    task.wait(7)
                end
            end)
        else
            if _G.throwLoop then
                task.cancel(_G.throwLoop)
                _G.throwLoop = nil
            end
        end
    end
})

-- ===== Auto Sync ThrowArea to Player CFrame =====
local syncLoop = nil

TestTab:CreateToggle({
    Name = "Auto Sync ThrowArea to Player",
    CurrentValue = false,
    Flag = "AutoSyncThrowArea",
    Callback = function(Value)
        _G.SyncThrow = Value
        if Value then
            syncLoop = task.spawn(function()
                local ThrowAreaPart = ReplicatedStorage:WaitForChild("Map"):WaitForChild("MainMap"):WaitForChild("ThrowArea")
                local lastCFrame = nil

                while _G.SyncThrow do
                    local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        if not lastCFrame or (lastCFrame.Position - hrp.Position).Magnitude > 0.1 then
                            ThrowAreaPart.CFrame = hrp.CFrame
                            lastCFrame = hrp.CFrame
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            if syncLoop then
                task.cancel(syncLoop)
                syncLoop = nil
            end
        end
    end
})

-- ===== AUTO-UPDATE PLAYER DROPDOWN =====
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

UpdateList()
