-- Discord The_Plaft

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer.Name
local nukc = game.ReplicatedStorage.Data:FindFirstChild(player)
local nukes = nukc.Total.Nukes.Value

local function getPlayerPosition()

    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return nil
end


local function teleportPlayerToPosition(position)

    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        print("Teleported", player, "To" position)
    end
end



local function teleportToNukeAndBack()
    local previousPos = getPlayerPosition()

    local nuke = workspace:FindFirstChild("Nuke")
    if nuke then

        teleportPlayerToPosition(nuke.Position)
        wait(5)


        if previousPos then
            teleportPlayerToPosition(previousPos)
            refresh(nukes)
        end
    else
        print("No nukes lol, your nukes =", nukes)
    end
end

local function main()
    while true do
        teleportToNukeAndBack()
        wait(10) 
    end
end

main()
