-- esp.lua
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local module = {}

local espFaces = {"Back","Bottom","Front","Left","Right","Top"}

local function createBillboardESP(tp)
    if not tp.Character or not tp.Character:FindFirstChild("Head") then return end
    local head = tp.Character.Head
    if head:FindFirstChild("ESPBillboard") then
        head.ESPBillboard:Destroy()
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESPBillboard"
    bb.Adornee = head
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,200,0,50)
    bb.ExtentsOffset = Vector3.new(0,2,0)
    local lb = Instance.new("TextLabel")
    lb.Name = "ESPLabel"
    lb.Size = UDim2.new(1,0,1,0)
    lb.BackgroundTransparency = 1
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 15
    lb.TextColor3 = Color3.new(1,1,1)
    lb.Parent = bb
    bb.Parent = head
end

local function updateBillboardESP(tp)
    if not tp.Character or not tp.Character:FindFirstChild("Head") then return end
    local head = tp.Character.Head
    local bb = head:FindFirstChild("ESPBillboard")
    if bb then
        local lb = bb:FindFirstChild("ESPLabel")
        if lb and Workspace.CurrentCamera and tp:GetAttribute("Role") then
            local role = tp:GetAttribute("Role")
            local d = math.floor((Workspace.CurrentCamera.CFrame.Position - head.Position).Magnitude)
            if role and role ~= "Unknown" then
                lb.Text = tp.Name.." ["..role.."] - "..d.."m"
            else
                lb.Text = tp.Name.." - "..d.."m"
            end
        end
    end
end

local function createSurfaceESP(part, color)
    for _, gui in ipairs(part:GetChildren()) do
        if gui:IsA("SurfaceGui") and gui.Name == "ESPSurface" then
            gui:Destroy()
        end
    end
    for _, face in ipairs(espFaces) do
        local sg = Instance.new("SurfaceGui")
        sg.Name = "ESPSurface"
        sg.Face = face
        sg.AlwaysOnTop = true
        sg.Parent = part
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 0
        frame.BackgroundColor3 = color
    end
end

local function getESPColor(tp)
    if tp.Backpack:FindFirstChild("Gun") or (tp.Character and tp.Character:FindFirstChild("Gun")) then
        return Color3.new(0,0,1)
    elseif tp.Backpack:FindFirstChild("Knife") or (tp.Character and tp.Character:FindFirstChild("Knife")) then
        return Color3.new(1,0,0)
    else
        return Color3.new(1,1,1)
    end
end

local function updateCharacterESP(tp)
    if not tp.Character then return end
    createBillboardESP(tp)
    local color = getESPColor(tp)
    local partsToESP = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}
    for _, partName in ipairs(partsToESP) do
        local part = tp.Character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            createSurfaceESP(part, color)
        end
    end
    local gun = tp.Character:FindFirstChild("Gun")
    if gun and gun:IsA("BasePart") then
        createSurfaceESP(gun, color)
    end
    if not tp.Character:FindFirstChild("ESP_Highlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.FillColor = color
        hl.OutlineColor = Color3.new(0,0,0)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Parent = tp.Character
    else
        local hl = tp.Character:FindFirstChild("ESP_Highlight")
        hl.FillColor = color
        hl.OutlineTransparency = 0
    end
end

local function clearESPForCharacter(character)
    if not character then return end
    for _, v in ipairs(character:GetDescendants()) do
        if (v:IsA("BillboardGui") and v.Name == "ESPBillboard") or (v:IsA("SurfaceGui") and v.Name == "ESPSurface") then
            v:Destroy()
        end
    end
    if character:FindFirstChild("ESP_Highlight") then
        character:FindFirstChild("ESP_Highlight"):Destroy()
    end
end

function module.refreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            clearESPForCharacter(p.Character)
            updateCharacterESP(p)
        end
    end
end

function module.updateAllBillboardESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            updateBillboardESP(p)
        end
    end
end

return module
