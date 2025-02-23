local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local module={}
local player=Players.LocalPlayer
local function onCharacterAdded(character)
    RunService.Stepped:Connect(function()
        if _G.noclipActive and character then
            for _,part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide=false
                end
            end
        end
    end)
end
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)
return module
