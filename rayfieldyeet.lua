local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window configuration remains unchanged
local Window = Rayfield:CreateWindow({
   Name = "Vatanz Hub",
   Icon = 11708967881,
   LoadingTitle = "Yeet A Friend",
   LoadingSubtitle = "by Vatanz",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "Vatanz Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

Rayfield:Notify({
   Title = "Hello User",
   Content = "Script has loaded",
   Duration = 6.5,
   Image = "bell-ring",
})

local Tab = Window:CreateTab("Main", "bell-ring")
Tab:CreateDivider()

Tab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local PlayerDropdown = Tab:CreateDropdown({
   Name = "Teleport to Player",
   Options = {},
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "TeleportDropdown",
   Callback = function(Options)
      local selectedName = Options[1]
      
      -- Find target player's character model
      local targetModel = Workspace:FindFirstChild(selectedName)
      if targetModel then
          -- Get target's HRP using proper hierarchy
          local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
          
          -- Get local player's character model
          local localModel = Workspace:FindFirstChild(LocalPlayer.Name)
          if localModel and targetHRP then
              -- Get local player's HRP using proper hierarchy
              local localHRP = localModel:FindFirstChild("HumanoidRootPart")
              
              if localHRP then
                  -- Teleport using CFrame with offset
                  localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
              end
          end
      else
          Rayfield:Notify({
              Title = "Error",
              Content = "Player not found in workspace",
              Duration = 3,
              Image = "alert-triangle"
          })
      end
   end,
})

local function GetPlayerNames()
   local names = {}
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         table.insert(names, player.Name)
      end
   end
   return names
end

local function RefreshDropdown()
   PlayerDropdown:SetOptions(GetPlayerNames())
end

RefreshDropdown()

Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)
