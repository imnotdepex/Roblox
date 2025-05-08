local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local virtualInputManager = game:GetService("VirtualInputManager")

local clawsplayed = 0
_G.AutoClaw = false
_G.AutoPlaytime = false
_G.AutoClawSkip = false
_G.AutoBubble = false
_G.AutoFarm = false
_G.AntiAFK = false
_G.AutoHatch = false
_G.HathcEgg = "Common Egg"

local function pressButton(button)
    virtualInputManager:SendKeyEvent(true, button, false, nil)
    wait()
    virtualInputManager:SendKeyEvent(false, button, false, nil)
end

local function antiafk()
    while _G.AntiAFK do
        task.wait(600)
        if not _G.AntiAFK then return end
        pressButton("Space")
    end
end

local function autoplaytime()
    while _G.AutoPlaytime do
        task.wait(60)
        if not _G.AutoPlaytime then return end
        for i = 1, 9 do
            task.wait(1)
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Function:InvokeServer("ClaimPlaytime", i)
        end
    end
end

local function autofarm()
    char = game.Players.LocalPlayer.Character
    hrp = char.HumanoidRootPart
    humanoid = char.Humanoid
    ypos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y
    while _G.AutoFarm do
        task.wait(0.05)
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
        if ypos < ypos-30 then return end
        if ypos > ypos+30 then return end

        local folder = workspace.Rendered:GetChildren()[13]
        local closestPart = nil
        local shortestDistance = math.huge

        for _, part in ipairs(folder:GetChildren()) do
            if not part:IsA("Model") then continue end
            if part.Name == "Ignored" then continue end

            if not part.PrimaryPart then
                if part:FindFirstChild("Part") then
                    part.PrimaryPart = part:FindFirstChild("Part")
                elseif part:FindFirstChildOfClass("MeshPart") then
                    part.PrimaryPart = part:FindFirstChildOfClass("MeshPart")
                else
                    continue
                end
            end

            local y = part.PrimaryPart.Position.Y
            if y < ypos-5 or y > ypos+10 then
                part.Name = "Ignored"
                continue
            end

            local distance = (part.PrimaryPart.Position - hrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPart = part
            end
        end

        if closestPart then
            humanoid:MoveTo(closestPart.PrimaryPart.Position)
        end
    end
end

local function autoclaw()
    while _G.AutoClaw do
        task.wait()
        if not workspace:FindFirstChild("ClawMachine") then
            if _G.AutoClawSkip then
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("SkipMinigameCooldown", "Robot Claw")
                task.wait()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("StartMinigame", "Robot Claw", "Insane")
            else
                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.WorldMap.Worlds["Minigame Paradise"].Islands["Robot Factory"].Activities["Robot Claw"].Timer.Text == "0s" then
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("StartMinigame", "Robot Claw", "Insane")
                end
            end
        end
        if workspace:FindFirstChild("ClawMachine") then
            local claw = workspace:FindFirstChild("ClawMachine")
            wait(1)
            while workspace:FindFirstChild("ClawMachine") do
                task.wait()
                if workspace:FindFirstChild("ClawMachine") then
                    for i, childd in workspace:FindFirstChild("ClawMachine"):GetChildren() do
                        if not childd then continue end
                        if childd:GetAttribute("ItemGUID") == nil then continue end
                        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("GrabMinigameItem", childd:GetAttribute("ItemGUID"))
                        task.wait(0.1)
                    end
                end
            end
            clawsplayed = clawsplayed + 1
            ClawsDoneText:Set({Title = "Claws Done", Content = clawsplayed})
        end
    end
end

local function autobubble()
    while _G.AutoBubble do
        task.wait(0.25)
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
    end
end

local function autohatch()
    while _G.AutoHatch do
        task.wait(0.25)
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("HatchEgg", _G.HatchEgg[1], 6)
    end
end

local Window = Rayfield:CreateWindow({
    Name = "BGSInfinity",
    Icon = 135761541287584,
    LoadingTitle = "Loading",
    LoadingSubtitle = "",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = false,
        FolderName = "BGSI",
        FileName = "BGSInfinity"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true 
    },

    KeySystem = false, 
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided", 
        FileName = "Key", 
        SaveKey = true, 
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local AutoTab = Window:CreateTab("Automation", "bot")
local EggsTab = Window:CreateTab("Eggs", "egg")
local MiscTab = Window:CreateTab("Misc", "cog")

local AutoFarmToggle = AutoTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "Toggle152311",
    Callback = function(Value)
        _G.AutoFarm = Value
        autofarm()
    end,
})

local Divider = AutoTab:CreateDivider()

local BubbleToggle = AutoTab:CreateToggle({
    Name = "Auto Bubble",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        _G.AutoBubble = Value
        autobubble()
    end,
})

local Divider2 = AutoTab:CreateDivider()

local ClawsDoneText = AutoTab:CreateParagraph({Title = "Claws Done", Content = clawsplayed})

local function autoclaw()
    while _G.AutoClaw do
        task.wait()
        if not workspace:FindFirstChild("ClawMachine") then
            if _G.AutoClawSkip then
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("SkipMinigameCooldown", "Robot Claw")
                task.wait()
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("StartMinigame", "Robot Claw", "Insane")
            else
                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.WorldMap.Worlds["Minigame Paradise"].Islands["Robot Factory"].Activities["Robot Claw"].Timer.Text == "0s" then
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("StartMinigame", "Robot Claw", "Insane")
                end
            end
        end
        if workspace:FindFirstChild("ClawMachine") then
            local claw = workspace:FindFirstChild("ClawMachine")
            wait(1)
            while workspace:FindFirstChild("ClawMachine") do
                task.wait()
                if workspace:FindFirstChild("ClawMachine") then
                    for i, childd in workspace:FindFirstChild("ClawMachine"):GetChildren() do
                        if not childd then continue end
                        if childd:GetAttribute("ItemGUID") == nil then continue end
                        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("GrabMinigameItem", childd:GetAttribute("ItemGUID"))
                        task.wait(0.1)
                    end
                end
            end
            clawsplayed = clawsplayed + 1
            ClawsDoneText:Set({Title = "Claws Done", Content = clawsplayed})
        end
    end
end


local ClawToggle = AutoTab:CreateToggle({
    Name = "Auto Claw",
    CurrentValue = false,
    Flag = "Toggle1511",
    Callback = function(Value)
        _G.AutoClaw = Value
        autoclaw()
    end,
})

local ClawToggle = AutoTab:CreateToggle({
    Name = "Use Tickets",
    CurrentValue = false,
    Flag = "Toggle1231",
    Callback = function(Value)
        _G.AutoClawSkip = Value
    end,
})

local Divider3 = AutoTab:CreateDivider()

local HatchToggle = EggsTab:CreateToggle({
    Name = "Auto Hatch the selected egg",
    CurrentValue = false,
    Flag = "Toggle4",
    Callback = function(Value)
        _G.AutoHatch = Value
        autohatch()
    end,
})

local Eggs = EggsTab:CreateDropdown({
    Name = "Choose the egg",
    Options = {"Common Egg","Spotted Egg","Iceshard Egg","Spikey Egg","Magma Egg","Crystal Egg","Lunar Egg","Void Egg","Hell Egg","Nightmare Egg","Rainbow Egg","Snowman Egg","Mining Egg","Cyber Egg"},
    CurrentOption = {"Common Egg"},
    MultipleOptions = false,
    Flag = "Eggs",
    Callback = function(Option)
        _G.HatchEgg = Option
    end,
})

--[[
local clawadd = AutoTab:CreateButton({
	Name = "+1",
	Callback = function()
        clawsplayed = clawsplayed + 1
        ClawsDoneText:Set({Title = "Claws Done", Content = clawsplayed})
    end
})
]]--

local PlaytimeToggle = MiscTab:CreateToggle({
    Name = "Auto Collect Playtime Rewards",
    CurrentValue = false,
    Flag = "Toggle4124",
    Callback = function(Value)
        _G.AutoPlaytime = Value
        autoplaytime()
    end,
})

local AntiAFKToggle = MiscTab:CreateToggle({
    Name = "AntiAFK",
    CurrentValue = false,
    Flag = "Toggle3",
    Callback = function(Value)
        _G.AntiAFK = Value
        antiafk()
    end,
})

local deletegui = MiscTab:CreateButton({
	Name = "Delete Gui",
	Callback = function()
        Rayfield:Destroy()
    end
})
