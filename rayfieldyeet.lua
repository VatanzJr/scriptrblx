local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
    Name = "Vatanz Hub",
    LoadingTitle = "Multi-Feature Hub12",
    LoadingSubtitle = "by Vatanz",
    ConfigurationSaving = { Enabled = true, FileName = "VatanzHub" }
})

-- ===== MAIN TAB =====
local MainTab = Window:CreateTab("Main", "locate")
local TeleportTab = Window:CreateTab("Teleport", "locate")
local ToolsTab = Window:CreateTab("Tools", "settings")
local TestTab = Window:CreateTab("Test", "flame")
local EggsTab = Window:CreateTab("Eggs", "egg")

-- Create dividers for each tab
local MainDivider = MainTab:CreateDivider()
local TeleportDivider = TeleportTab:CreateDivider()
local ToolsDivider = ToolsTab:CreateDivider()
local TestDivider = TestTab:CreateDivider()
local EggsDivider = EggsTab:CreateDivider()

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
                wait(5)
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

MainTab:CreateToggle({
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

MainTab:CreateToggle({
    Name = "Auto Use Best Equip",
    Callback = function()
        pcall(function()
            local remote = ReplicatedStorage:WaitForChild("Remote")
                :WaitForChild("Pet")
                :WaitForChild("Server")
                :WaitForChild("EquipBest")
            
            remote:FireServer()
        end)
    end,
})


-- ===== TELEPORT TAB =====

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

-- ===== TEST TAB =====


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


-- ===== EGGS TAB =====


local eggOptions = {
    {Name = "World 1 - Forest Egg", Id = "1"},
    {Name = "World 1 - Flight", Id = "2"},
    {Name = "World 1 - Bugs", Id = "3"},
    {Name = "World 1 - Aqua Egg", Id = "4"}, -- Added Aqua Egg
    {Name = "World 1 - Bzzzz", Id = "5"},
    {Name = "World 1 - Slime", Id = "6"},
    {Name = "World 2 - Elemental", Id = "7"},
    {Name = "World 2 - Green", Id = "8"},
    {Name = "World 3 - Candy", Id = "9"},
    {Name = "World 4 - Sweet", Id = "10"},
    {Name = "World 4 - Wild", Id = "11"},
    {Name = "World 4 - Feral", Id = "12"},
    {Name = "World 5 - Viking", Id = "13"},
    {Name = "World 5 - Mythic", Id = "14"},
    {Name = "World 6 - Anime", Id = "15"},
    {Name = "World 6 - Special", Id = "16"},
    {Name = "World 7 - Captain", Id = "17"},
    {Name = "World 7 - Pirate", Id = "18"},
    {Name = "World 8 - Planetary", Id = "19"},
    {Name = "World 8 - Cosmic", Id = "20"},
    {Name = "World 9 - Hard", Id = "21"},
    {Name = "World 9 - Insane", Id = "22"},
    {Name = "World 10 - Monster", Id = "23"},
    {Name = "World 10 - Hell", Id = "24"},
    {Name = "World 11 - Sketch", Id = "25"},
    {Name = "World 11 - Cartoon", Id = "26"},
    {Name = "World 12 - Royal", Id = "27"},
    {Name = "World 12 - Luxury", Id = "28"},
    {Name = "World 13 - Park", Id = "29"},
    {Name = "World 13 - City", Id = "30"},
    {Name = "World 14 - Snowball", Id = "31"},
    {Name = "World 14 - Iceberg", Id = "32"},
    {Name = "World 15 - Tome", Id = "33"},
    {Name = "World 15 - Fairytale", Id = "34"},
    {Name = "World 16 - Salvage", Id = "35"},
    {Name = "World 16 - Depot", Id = "36"},
    {Name = "World 17 - Jungle", Id = "37"},
    {Name = "World 17 - Relic", Id = "38"},
    {Name = "World 18 - Trick", Id = "39"},
    {Name = "World 18 - Treat", Id = "40"},
    {Name = "World 19 - Toxic", Id = "41"},
    {Name = "World 19 - Lethal", Id = "42"},
    {Name = "World 20 - Jingle", Id = "43"},
    {Name = "World 20 - Tinkle", Id = "44"},
    {Name = "World 21 - Funny", Id = "45"},
    {Name = "World 21 - Playful", Id = "46"},
    {Name = "World 22 - Cloud", Id = "47"},
    {Name = "World 22 - Sky", Id = "48"},
    {Name = "World 23 - Cactus", Id = "49"},
    {Name = "World 23 - Fruit", Id = "50"},
    {Name = "World 24 - Sweet", Id = "51"},
    {Name = "World 24 - Favourite", Id = "52"},
    {Name = "World 25 - Claws", Id = "53"},
    {Name = "World 25 - Surveillance", Id = "54"},
    {Name = "World 26 - Emoticon", Id = "55"},
    {Name = "World 26 - Smile", Id = "56"},
    {Name = "World 27 - Pass", Id = "57"},
    {Name = "World 27 - Ticket", Id = "58"},
    {Name = "World 28 - Comet", Id = "59"},
    {Name = "World 28 - Base", Id = "60"},
    {Name = "World 29 - Weapons", Id = "61"},
    {Name = "World 29 - Sharp", Id = "62"},
    {Name = "World 30 - Element", Id = "63"},
    {Name = "World 30 - Essence", Id = "64"},
    {Name = "World 31 - Criminal", Id = "65"},
    {Name = "World 31 - Victim", Id = "66"},
    {Name = "World 32 - Trick", Id = "67"},
    {Name = "World 32 - Treat", Id = "68"},
    {Name = "World 33 - Wooden", Id = "69"},
    {Name = "World 33 - Ice", Id = "70"},
    {Name = "World 34 - Marble", Id = "71"},
    {Name = "World 34 - Tartarus", Id = "72"},
    {Name = "World 35 - Love", Id = "73"},
    {Name = "World 35 - Sweet", Id = "74"},
    {Name = "World 36 - Goal", Id = "75"},
    {Name = "World 36 - Jet", Id = "76"},
    {Name = "World 37 - Iron", Id = "77"},
    {Name = "World 37 - Sea Blue", Id = "78"},
}

local eggDisplayNames = {}
for _, egg in ipairs(eggOptions) do
    table.insert(eggDisplayNames, egg.Name)
end

local selectedEggId = nil

EggsTab:CreateDropdown({
    Name = "Select Egg",
    Options = eggDisplayNames,
    Flag = "EggDropdown",
    Callback = function(selected)
        for _, egg in ipairs(eggOptions) do
            if egg.Name == selected[1] then
                selectedEggId = egg.Id
                Rayfield:Notify({ Title = "Egg Selected", Content = "ID: "..egg.Id, Duration = 3 })
                break
            end
        end
    end
})

EggsTab:CreateToggle({
    Name = "Auto Purchase Egg",
    CurrentValue = false,
    Flag = "AutoPurchaseEgg",
    Callback = function(value)
        _G.AutoPurchase = value
        if value then
            _G.purchaseLoop = task.spawn(function()
                while _G.AutoPurchase do
                    if selectedEggId then
                        local args = { selectedEggId }
                        pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Remote")
                                :WaitForChild("Egg")
                                :WaitForChild("Server")
                                :WaitForChild("Purchase")
                                :InvokeServer(unpack(args))
                        end)
                    else
                        Rayfield:Notify({ Title = "Error", Content = "No egg selected!", Duration = 3, Image = "error" })
                        task.wait(2)
                    end
                end
            end)
        else
            if _G.purchaseLoop then
                task.cancel(_G.purchaseLoop)
                _G.purchaseLoop = nil
            end
        end
    end
})

EggsTab:CreateToggle({
    Name = "Auto Craft All Pets",
    CurrentValue = false,
    Flag = "AutoCraftAllPets",
    Callback = function(Value)
        _G.AutoCraftAll = Value
        if Value then
            _G.craftLoop = task.spawn(function()
                while _G.AutoCraftAll do
                    pcall(function()
                        local remote = ReplicatedStorage:WaitForChild("Remote")
                            :WaitForChild("Pet")
                            :WaitForChild("Server")
                            :WaitForChild("CraftAll")
                        
                        remote:FireServer()
                        task.wait(1) -- Small delay to prevent spamming
                    end)
                    task.wait(5) -- Adjust delay between crafts (e.g., 5 seconds)
                end
            end)
        else
            if _G.craftLoop then
                task.cancel(_G.craftLoop)
                _G.craftLoop = nil
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
