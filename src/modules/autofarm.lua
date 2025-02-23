local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local config = require(script.Parent.Parent.config)
local module = {}
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local currentTween
local movementSpeed = config.initialMovementSpeed
function module.teleportPlayer(pos)
    if rootPart then
        rootPart.CFrame = CFrame.new(pos)
    end
end
local function slideToCoin(coin)
    if not (coin and coin.Parent and rootPart) then return end
    if currentTween then currentTween:Cancel() end
    local dist = (coin.Position - rootPart.Position).Magnitude
    local dur = dist / movementSpeed
    local ti = TweenInfo.new(dur, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(rootPart, ti, {CFrame = CFrame.new(coin.Position)})
    currentTween:Play()
    currentTween.Completed:Connect(function()
        currentTween = nil
    end)
end
local function detectarMapaAtual()
    for _,mapa in ipairs(config.mapasSalvos) do
        local found = Workspace:FindFirstChild(mapa)
        if found then
            return found
        end
    end
    return nil
end
local function getCoinContainer()
    local mm = detectarMapaAtual()
    if mm then
        return mm:FindFirstChild("CoinContainer")
    end
    return nil
end
local function getCoinContainerPosition()
    local cc = getCoinContainer()
    if cc then
        if cc:IsA("BasePart") then
            return cc.Position
        elseif cc:IsA("Model") then
            if cc.PrimaryPart then
                return cc.PrimaryPart.Position
            else
                local p = cc:FindFirstChildWhichIsA("BasePart")
                if p then
                    return p.Position
                end
            end
        end
    end
    return config.lobbySpawnPos
end
local function getCoins()
    local coins = {}
    local cc = getCoinContainer()
    if cc then
        for _,o in ipairs(cc:GetChildren()) do
            if o:IsA("BasePart") and o.Name=="Coin_Server" then
                table.insert(coins,o)
            end
        end
    end
    return coins
end
local function getPriorityCoins()
    local allCoins = getCoins()
    local pc = {}
    for _,c in ipairs(allCoins) do
        if c:FindFirstChild("Multiplier") then
            table.insert(pc,c)
        end
    end
    if #pc>0 then
        return pc
    end
    return allCoins
end
local function getNearestCoin()
    local coins = getPriorityCoins()
    local nearest,shortest=nil,math.huge
    for _,coin in ipairs(coins) do
        local dist=(rootPart.Position-coin.Position).Magnitude
        if dist<shortest then
            shortest=dist
            nearest=coin
        end
    end
    return nearest
end
function module.autoFarm()
    local player = Players.LocalPlayer
    local character = player.Character
    if not(character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart")) then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if humanoid.Health<=0 then
        repeat task.wait(0.1) until player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart")
        module.teleportPlayer(config.lobbySpawnPos)
        return
    end
    if humanoid.Health<config.healthThreshold then
        module.teleportPlayer(config.lobbySpawnPos)
        task.wait(1)
        return
    end
    local coin = getNearestCoin()
    if coin and coin.Parent then
        local dist = (root.Position-coin.Position).Magnitude
        if dist>config.teleportDistanceThreshold then
            module.teleportPlayer(coin.Position)
            if currentTween then currentTween:Cancel() end
        else
            slideToCoin(coin)
        end
    else
        if currentTween then currentTween:Cancel() end
        module.teleportPlayer(getCoinContainerPosition())
    end
end
return module
