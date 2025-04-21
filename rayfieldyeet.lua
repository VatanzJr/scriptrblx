local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua", true))()
    end,
})

-- ===== TEST TAB (Auto Throw) =====
local TestTab = Window:CreateTab("Test", "flame")

-- ThrowArea position you provided
local OriginalThrowCFrame = CFrame.new(
    -95.644928, 3.56980205, -109.045753,
    -1, 0, 0,
    0, 1, 0,
    0, 0, -1
)

TestTab:CreateToggle({
    Name = "Auto Throw (Teleport + Return)",
    CurrentValue = false,
    Flag = "AutoThrowNew",
    Callback = function(Value)
        _G.Loop = Value
        if Value then
            _G.throwLoop = task.spawn(function()
                while _G.Loop do
                    pcall(function()
                        local char = Workspace:FindFirstChild(Players.LocalPlayer.Name)
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Save the current CFrame (position)
                            local hrp = char.HumanoidRootPart
                            local oldCFrame = hrp.CFrame

                            -- Teleport to the ThrowArea (position you provided)
                            hrp.CFrame = OriginalThrowCFrame
                            task.wait(0.3)  -- Allow some time for teleportation

                            -- Perform the throw action by firing the remote
                            local throwRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Throw"):WaitForChild("Server"):WaitForChild("Request")
                            throwRemote:FireServer()

                            task.wait(7)  -- Wait for the throw to complete

                            -- Return to the original position after the throw
                            hrp.CFrame = oldCFrame
                        end
                    end)
                    task.wait(7)  -- Control the interval between throws
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

-- Initial setup
UpdateList()
