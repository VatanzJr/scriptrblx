local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Multi-Feature Hub15",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- ===== MAIN TAB =====
local MainTab = Window:CreateTab("Main", "bell-ring")

MainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function() Rayfield:Destroy() end,
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

task.defer(function()
    AutoStarsToggle:Set(true)
end)

MainTab:CreateToggle({
    Name = "Auto Spin Daily",
    CurrentValue = false,
    Flag = "AutoSpinDaily",
    Callback = function(value)
        _G.Loop = value
        task.spawn(function()
            while _G.Loop do
                local args = {
                    [1] = "DailyWheel"
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Player"):WaitForChild("Server"):WaitForChild("ClaimTimedReward"):InvokeServer(unpack(args))
                end)
                wait(5) -- wait time between spins to prevent flooding
            end
        end)
    end
})

MainTab:CreateButton({
    Name = "Unlock All Gamepass (soon)",
    Callback = function()
        pcall(function()
            workspace.World.VIPWall:Destroy()
        end)
    end
})


-- ===== TELEPORT TAB =====
local TeleportTab = Window:CreateTab("Teleport", "locate")

-- ===== Teleport to Player (by DisplayName) =====
local DisplayNameMap = {}

local function GetWorkspacePlayers()
    local validDisplayNames = {}
    DisplayNameMap = {}

    for _, player in ipairs(Players:GetPlayers()) do
        local name = player.Name
        local display = player.DisplayName
        table.insert(validDisplayNames, display)
        DisplayNameMap[display] = name
    end

    return validDisplayNames
end

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = GetWorkspacePlayers(),
    Flag = "TeleportDropdown",
    Callback = function(Selected)
        local displayName = Selected[1]
        local targetName = DisplayNameMap[displayName]
        local targetModel = Workspace:FindFirstChild(targetName)
        local localModel = Workspace:FindFirstChild(Players.LocalPlayer.Name)
        if targetModel and targetModel:FindFirstChild("HumanoidRootPart") and localModel and localModel:FindFirstChild("HumanoidRootPart") then
            localModel.HumanoidRootPart.CFrame = targetModel.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
})

-- Generate World Options
local worldOptions = {}
for i = 1, 38 do
    table.insert(worldOptions, "World " .. i)
end

TeleportTab:CreateDropdown({
    Name = "Teleport World",
    Options = worldOptions,
    Flag = "TeleportWorldDropdown",
    Callback = function(selected)
        local worldNumber = tostring(selected[1]:match("%d+"))
        local args = { [1] = worldNumber }

        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("Remote")
                :WaitForChild("Teleport")
                :WaitForChild("Server")
                :WaitForChild("RequestTeleport")
                :FireServer(unpack(args))
        end)
    end
})


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

-- Auto Sync ThrowArea
local syncLoop = nil

TestTab:CreateToggle({
    Name = "Auto Sync ThrowArea to Player",
    CurrentValue = false,
    Flag = "AutoSyncThrowArea",
    Callback = function(Value)
        _G.SyncThrow = Value
        if Value then
            syncLoop = task.spawn(function()
                while _G.SyncThrow do
                    local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        local throwArea = Workspace:WaitForChild("World"):WaitForChild("ThrowArea")
                        
                        for _, part in ipairs(throwArea:GetChildren()) do
                            if part:IsA("BasePart") or part:IsA("UnionOperation") then
                                part.CFrame = hrp.CFrame
                            end
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

TestTab:CreateToggle({
    Name = "Auto Sync EggBasketHitbox to Player",
    CurrentValue = false,
    Flag = "SyncEggBasketHitbox",
    Callback = function(Value)
        _G.SyncBasket = Value
        if Value then
            _G.basketLoop = task.spawn(function()
                while _G.SyncBasket do
                    local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                    local basket = Workspace:FindFirstChild("EggBasketHitbox")
                    if char and char:FindFirstChild("HumanoidRootPart") and basket and basket:IsA("BasePart") then
                        basket.CFrame = char.HumanoidRootPart.CFrame
                    end
                    task.wait(1)
                end
            end)
        else
            if _G.basketLoop then
                task.cancel(_G.basketLoop)
                _G.basketLoop = nil
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
