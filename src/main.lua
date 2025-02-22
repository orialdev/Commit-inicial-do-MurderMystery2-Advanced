local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Importa o config que está dentro da pasta "modules"
local config = require(script.modules:WaitForChild("config"))

-- Variáveis Globais
_G.autoFarmActive = false
_G.autoCollectGunActive = true
_G.playerESPActive = false
_G.invincibilityActive = false
_G.noclipActive = false
_G.flyEnabled = false
_G.infiniteJump = false
_G.fovValue = Workspace.CurrentCamera.FieldOfView or 70
_G.autoAimLock = false
_G.movementSpeed = config.initialMovementSpeed
_G.tracersEnabled = false
_G.tracerThickness = 2
_G.tracerTransparency = 0

-- Prevenir Idle
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Proteção de Invencibilidade
local function protectHumanoid(h)
    h.HealthChanged:Connect(function(newHealth)
        if _G.invincibilityActive and newHealth < h.MaxHealth then
            h.Health = h.MaxHealth
        end
    end)
end
protectHumanoid(humanoid)

pcall(function()
    local oldTakeDamage = hookfunction(humanoid.TakeDamage, function(s, dmg)
        if _G.invincibilityActive then return end
        return oldTakeDamage(s, dmg)
    end)
    local oldBreakJoints = hookfunction(humanoid.BreakJoints, function(s, ...)
        if _G.invincibilityActive then return end
        return oldBreakJoints(s, ...)
    end)
    local oldDestroy = hookfunction(humanoid.Destroy, function(s, ...)
        if _G.invincibilityActive then return end
        return oldDestroy(s, ...)
    end)

    local mt = getrawmetatable(game)
    local old_newindex = mt.__newindex
    setreadonly(mt, false)
    mt.__newindex = newcclosure(function(t, k, v)
        if _G.invincibilityActive and t == humanoid and k == "Health" then
            return old_newindex(t, k, t.MaxHealth)
        end
        return old_newindex(t, k, v)
    end)
    setreadonly(mt, true)

    local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(s, ...)
        local m = getnamecallmethod()
        if _G.invincibilityActive and not checkcaller() then
            if m == "FireServer" or m == "InvokeServer" then
                -- Se quiser bloquear chamadas de dano, etc., faça aqui
            end
        end
        return oldNamecall(s, ...)
    end))
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Evento CharacterAdded
local function onCharacterAdded(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if rootPart then
        rootPart.CFrame = CFrame.new(config.lobbySpawnPos)
    end
    protectHumanoid(humanoid)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- Importa os outros módulos
local autofarm   = require(script.modules:WaitForChild("autofarm"))
local autopickup = require(script.modules:WaitForChild("autopickup"))
local esp        = require(script.modules:WaitForChild("esp"))
local fly        = require(script.modules:WaitForChild("fly"))
local noclip     = require(script.modules:WaitForChild("noclip"))
local ui         = require(script.modules:WaitForChild("ui"))

-- Loop de Auto Farm
task.spawn(function()
    while true do
        if _G.autoFarmActive then
            autofarm.autoFarm()
        end
        task.wait(0.1)
    end
end)

-- Loop de Auto Collect Gun
task.spawn(function()
    while true do
        if _G.autoCollectGunActive then
            autopickup.autoEquipGun()
        end
        task.wait(0.5)
    end
end)

-- Loop de atualização do ESP
task.spawn(function()
    while true do
        if _G.playerESPActive then
            esp.updateAllBillboardESP()
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if _G.playerESPActive then
            esp.refreshAllESP()
        end
        task.wait(1)
    end
end)

-- Auto Aim Lock e Tracers no RenderStepped
local tracers = {} -- Tabela para armazenar tracers
RunService.RenderStepped:Connect(function()
    -- Auto Aim Lock para Sheriff
    if _G.autoAimLock then
        local cam = Workspace.CurrentCamera
        local isSheriff = (player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")))
        if isSheriff then
            local murderer
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    if p.Backpack:FindFirstChild("Knife") or (p.Character:FindFirstChild("Knife")) then
                        murderer = p
                        break
                    end
                end
            end
            if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
                local targetPos = murderer.Character.Head.Position
                local currentPos = cam.CFrame.Position
                cam.CFrame = CFrame.new(currentPos, targetPos)
            end
        end
    end

    -- Atualiza os Tracers
    if _G.tracersEnabled then
        local cam = Workspace.CurrentCamera
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local headPos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
                if not tracers[p] then
                    local tracer = Drawing.new("Line")
                    tracer.Color = Color3.new(1,1,1)
                    tracer.Thickness = _G.tracerThickness
                    tracer.Transparency = _G.tracerTransparency
                    tracers[p] = tracer
                end
                local tracer = tracers[p]
                tracer.Color = Color3.new(1,1,1)
                tracer.Thickness = _G.tracerThickness
                tracer.Transparency = _G.tracerTransparency

                local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                tracer.From = center
                tracer.To = Vector2.new(headPos.X, headPos.Y)
                tracer.Visible = onScreen
            else
                if tracers[p] then
                    tracers[p]:Remove()
                    tracers[p] = nil
                end
            end
        end
    else
        -- Se os tracers estiverem desativados, remove todos
        for _, tracer in pairs(tracers) do
            tracer:Remove()
        end
        tracers = {}
    end
end)

-- Ativa ou desativa Fly conforme a configuração
if _G.flyEnabled then
    fly.enableFly()
else
    fly.disableFly()
end

-- Inicializa a UI
ui.createUI()

print("Murder Mystery 2 Advanced Script iniciado!")
