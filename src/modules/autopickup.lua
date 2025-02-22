-- autopickup.lua
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local module = {}

local function detectarMapaAtual()
    local config = require(script.Parent.Parent.config)
    for _, mapa in ipairs(config.mapasSalvos) do
        local found = Workspace:FindFirstChild(mapa)
        if found then
            return found
        end
    end
    return nil
end

local function getGunDrop()
    local mm = detectarMapaAtual()
    if mm then
        return mm:FindFirstChild("GunDrop")
    end
    return nil
end

function module.autoEquipGun()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    local g = getGunDrop()
    if g and g:IsA("BasePart") then
        local op = rootPart.Position
        rootPart.CFrame = CFrame.new(g.Position)
        task.wait(0.3)
        rootPart.CFrame = CFrame.new(op)
    end
end

return module
