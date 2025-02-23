local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local module={}
function module.createUI()
    local AdminUI=Instance.new("ScreenGui")
    AdminUI.Name="MM2AdminPanel_SidebarUI_Advanced"
    AdminUI.ResetOnSpawn=false
    AdminUI.Parent=game.CoreGui
    local MainFrame=Instance.new("Frame")
    MainFrame.Name="MainFrame"
    MainFrame.Parent=AdminUI
    MainFrame.AnchorPoint=Vector2.new(0.5,0.5)
    MainFrame.Position=UDim2.new(0.5,0,0.5,0)
    MainFrame.Size=UDim2.new(0,620,0,400)
    MainFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
    MainFrame.BackgroundTransparency=0.05
    MainFrame.BorderSizePixel=0
    local mainCorner=Instance.new("UICorner",MainFrame)
    mainCorner.CornerRadius=UDim.new(0,10)
    local TopBar=Instance.new("Frame")
    TopBar.Name="TopBar"
    TopBar.Parent=MainFrame
    TopBar.Size=UDim2.new(1,0,0,40)
    TopBar.BackgroundColor3=Color3.fromRGB(25,25,25)
    TopBar.BorderSizePixel=0
    local topBarCorner=Instance.new("UICorner",TopBar)
    topBarCorner.CornerRadius=UDim.new(0,10)
    local TitleLabel=Instance.new("TextLabel")
    TitleLabel.Name="TitleLabel"
    TitleLabel.Parent=TopBar
    TitleLabel.Size=UDim2.new(1,-20,1,0)
    TitleLabel.Position=UDim2.new(0,10,0,0)
    TitleLabel.BackgroundTransparency=1
    TitleLabel.Font=Enum.Font.GothamBold
    TitleLabel.Text="Murder Mystery 2 - script do vitor lol kakak"
    TitleLabel.TextSize=18
    TitleLabel.TextColor3=Color3.new(1,1,1)
    TitleLabel.TextXAlignment=Enum.TextXAlignment.Left
    local SideBar=Instance.new("Frame")
    SideBar.Name="SideBar"
    SideBar.Parent=MainFrame
    SideBar.Position=UDim2.new(0,0,0,40)
    SideBar.Size=UDim2.new(0,160,1,-40)
    SideBar.BackgroundColor3=Color3.fromRGB(35,35,35)
    SideBar.BorderSizePixel=0
    local sideBarCorner=Instance.new("UICorner",SideBar)
    sideBarCorner.CornerRadius=UDim.new(0,10)
    local SideBarListLayout=Instance.new("UIListLayout")
    SideBarListLayout.Parent=SideBar
    SideBarListLayout.SortOrder=Enum.SortOrder.LayoutOrder
    SideBarListLayout.Padding=UDim.new(0,5)
    local ContentFrame=Instance.new("Frame")
    ContentFrame.Name="ContentFrame"
    ContentFrame.Parent=MainFrame
    ContentFrame.Position=UDim2.new(0,160,0,40)
    ContentFrame.Size=UDim2.new(1,-160,1,-40)
    ContentFrame.BackgroundColor3=Color3.fromRGB(35,35,35)
    ContentFrame.BorderSizePixel=0
    local contentFrameCorner=Instance.new("UICorner",ContentFrame)
    contentFrameCorner.CornerRadius=UDim.new(0,10)
    local contentLayoutHolder=Instance.new("Frame")
    contentLayoutHolder.Name="ContentHolder"
    contentLayoutHolder.Parent=ContentFrame
    contentLayoutHolder.Size=UDim2.new(1,0,1,0)
    contentLayoutHolder.BackgroundTransparency=1
    local Tabs={}
    local currentTab
    local function createSidebarButton(tabName,buttonText,iconId)
        local btn=Instance.new("TextButton")
        btn.Name=tabName.."Button"
        btn.Parent=SideBar
        btn.Size=UDim2.new(1,-10,0,40)
        btn.BackgroundColor3=Color3.fromRGB(40,40,40)
        btn.BorderSizePixel=0
        btn.Text=""
        btn.AutoButtonColor=false
        local btnCorner=Instance.new("UICorner",btn)
        btnCorner.CornerRadius=UDim.new(0,8)
        local icon=Instance.new("ImageLabel")
        icon.Name="Icon"
        icon.Parent=btn
        icon.BackgroundTransparency=1
        icon.Size=UDim2.new(0,24,0,24)
        icon.Position=UDim2.new(0,8,0.5,-12)
        icon.Image=iconId
        local textLabel=Instance.new("TextLabel")
        textLabel.Name="TextLabel"
        textLabel.Parent=btn
        textLabel.Size=UDim2.new(1,-40,1,0)
        textLabel.Position=UDim2.new(0,40,0,0)
        textLabel.BackgroundTransparency=1
        textLabel.Font=Enum.Font.GothamBold
        textLabel.Text=buttonText
        textLabel.TextColor3=Color3.new(1,1,1)
        textLabel.TextSize=14
        textLabel.TextXAlignment=Enum.TextXAlignment.Left
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(40,40,40)}):Play()
        end)
        local tabFrame=Instance.new("Frame")
        tabFrame.Name=tabName.."Tab"
        tabFrame.Parent=contentLayoutHolder
        tabFrame.Size=UDim2.new(1,0,1,0)
        tabFrame.BackgroundColor3=Color3.fromRGB(35,35,35)
        tabFrame.BorderSizePixel=0
        tabFrame.BackgroundTransparency=1
        tabFrame.Visible=false
        local tabFrameCorner=Instance.new("UICorner",tabFrame)
        tabFrameCorner.CornerRadius=UDim.new(0,10)
        Tabs[tabName]={Button=btn,Frame=tabFrame}
        btn.MouseButton1Click:Connect(function()
            if currentTab and currentTab~=tabFrame then
                TweenService:Create(currentTab,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
                task.wait(0.3)
                currentTab.Visible=false
            end
            tabFrame.BackgroundTransparency=1
            tabFrame.Visible=true
            TweenService:Create(tabFrame,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
            currentTab=tabFrame
        end)
        return tabFrame
    end
    local mainTab=createSidebarButton("Main","Main","rbxassetid://108037566095845")
    local playerTab=createSidebarButton("Player","Player","rbxassetid://107856790068028")
    local visualsTab=createSidebarButton("Visuals","Visuals","rbxassetid://70377247183702")
    Tabs["Main"].Frame.Visible=true
    Tabs["Main"].Frame.BackgroundTransparency=0
    currentTab=Tabs["Main"].Frame
    local mainLayout=Instance.new("UIListLayout",mainTab)
    mainLayout.SortOrder=Enum.SortOrder.LayoutOrder
    mainLayout.Padding=UDim.new(0,5)
    local playerLayout=Instance.new("UIListLayout",playerTab)
    playerLayout.SortOrder=Enum.SortOrder.LayoutOrder
    playerLayout.Padding=UDim.new(0,5)
    local visualsLayout=Instance.new("UIListLayout",visualsTab)
    visualsLayout.SortOrder=Enum.SortOrder.LayoutOrder
    visualsLayout.Padding=UDim.new(0,5)
    local function createToggle(parent,text,defaultState,callback)
        local toggleFrame=Instance.new("Frame")
        toggleFrame.Size=UDim2.new(0,200,0,40)
        toggleFrame.BackgroundColor3=Color3.fromRGB(40,40,40)
        toggleFrame.BorderSizePixel=0
        toggleFrame.Parent=parent
        local c=Instance.new("UICorner",toggleFrame)
        c.CornerRadius=UDim.new(0,8)
        local label=Instance.new("TextLabel")
        label.Size=UDim2.new(1,-60,1,0)
        label.Position=UDim2.new(0,10,0,0)
        label.BackgroundTransparency=1
        label.Font=Enum.Font.GothamBold
        label.TextSize=14
        label.TextColor3=Color3.new(1,1,1)
        label.Text=text
        label.TextXAlignment=Enum.TextXAlignment.Left
        label.Parent=toggleFrame
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(0,40,0,20)
        btn.AnchorPoint=Vector2.new(1,0.5)
        btn.Position=UDim2.new(1,-10,0.5,0)
        btn.BackgroundColor3=Color3.fromRGB(60,60,60)
        btn.Text=""
        btn.BorderSizePixel=0
        btn.Parent=toggleFrame
        local bC=Instance.new("UICorner",btn)
        bC.CornerRadius=UDim.new(0,10)
        local circle=Instance.new("Frame")
        circle.Size=UDim2.new(0,16,0,16)
        circle.AnchorPoint=Vector2.new(0,0.5)
        circle.Position=UDim2.new(0,2,0.5,0)
        circle.BackgroundColor3=Color3.fromRGB(100,100,100)
        circle.BorderSizePixel=0
        circle.Parent=btn
        local cC=Instance.new("UICorner",circle)
        cC.CornerRadius=UDim.new(0,8)
        local state=defaultState
        if state then
            TweenService:Create(circle,TweenInfo.new(0),{Position=UDim2.new(1,-18,0.5,0),BackgroundColor3=Color3.fromRGB(0,200,0)}):Play()
        end
        btn.MouseButton1Click:Connect(function()
            state=not state
            if state then
                TweenService:Create(circle,TweenInfo.new(0.2),{Position=UDim2.new(1,-18,0.5,0),BackgroundColor3=Color3.fromRGB(0,200,0)}):Play()
            else
                TweenService:Create(circle,TweenInfo.new(0.2),{Position=UDim2.new(0,2,0.5,0),BackgroundColor3=Color3.fromRGB(100,100,100)}):Play()
            end
            callback(state)
        end)
        return toggleFrame
    end
    local function createButton(parent,text,color,callback)
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(0,200,0,30)
        btn.BackgroundColor3=color
        btn.BorderSizePixel=0
        btn.Font=Enum.Font.GothamBold
        btn.Text=text
        btn.TextColor3=Color3.new(1,1,1)
        btn.TextSize=14
        btn.Parent=parent
        local c=Instance.new("UICorner",btn)
        c.CornerRadius=UDim.new(0,8)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=color:Lerp(Color3.fromRGB(0,200,0),0.3)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=color}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            callback()
        end)
        return btn
    end
    local function createSlider(parent,text,minVal,maxVal,defaultVal,callback)
        local sliderFrame=Instance.new("Frame")
        sliderFrame.Size=UDim2.new(0,200,0,60)
        sliderFrame.BackgroundColor3=Color3.fromRGB(40,40,40)
        sliderFrame.BorderSizePixel=0
        sliderFrame.Parent=parent
        local c=Instance.new("UICorner",sliderFrame)
        c.CornerRadius=UDim.new(0,8)
        local title=Instance.new("TextLabel")
        title.Size=UDim2.new(1,-10,0,20)
        title.Position=UDim2.new(0,10,0,5)
        title.BackgroundTransparency=1
        title.Font=Enum.Font.GothamBold
        title.TextSize=14
        title.TextColor3=Color3.new(1,1,1)
        title.Text=text
        title.Parent=sliderFrame
        local bar=Instance.new("Frame")
        bar.Size=UDim2.new(1,-20,0,6)
        bar.Position=UDim2.new(0,10,0,35)
        bar.BackgroundColor3=Color3.fromRGB(60,60,60)
        bar.BorderSizePixel=0
        bar.Parent=sliderFrame
        local bc=Instance.new("UICorner",bar)
        bc.CornerRadius=UDim.new(0,3)
        local fill=Instance.new("Frame")
        fill.Size=UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
        fill.BackgroundColor3=Color3.fromRGB(0,200,0)
        fill.BorderSizePixel=0
        fill.Parent=bar
        local fc=Instance.new("UICorner",fill)
        fc.CornerRadius=UDim.new(0,3)
        local sliding=false
        local function setValue(px)
            local percent=math.clamp((px-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local val=math.floor(minVal+ (maxVal-minVal)*percent)
            fill.Size=UDim2.new(percent,0,1,0)
            callback(val)
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                sliding=true
                setValue(input.Position.X)
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                sliding=false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType==Enum.UserInputType.MouseMovement then
                setValue(input.Position.X)
            end
        end)
        return sliderFrame
    end
    createToggle(Tabs["Main"].Frame,"Auto Farm",false,function(state)
        _G.autoFarmActive=state
    end)
    createToggle(Tabs["Main"].Frame,"Invincibility",false,function(state)
        _G.invincibilityActive=state
    end)
    createSlider(Tabs["Main"].Frame,"Movement Speed",50,300,_G.movementSpeed or 100,function(val)
        _G.movementSpeed=val
    end)
    createButton(Tabs["Main"].Frame,"Respawn",Color3.fromRGB(255,51,51),function()
        local player=game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health=0
        end
    end)
    createToggle(Tabs["Player"].Frame,"Auto Collect Gun",true,function(state)
        _G.autoCollectGunActive=state
    end)
    createToggle(Tabs["Player"].Frame,"Aim Lock (Sheriff)",false,function(state)
        _G.autoAimLock=state
    end)
    createToggle(Tabs["Player"].Frame,"Noclip",false,function(state)
        _G.noclipActive=state
    end)
    createToggle(Tabs["Player"].Frame,"Fly",false,function(state)
        _G.flyEnabled=state
    end)
    createToggle(Tabs["Player"].Frame,"Infinite Jump",false,function(state)
        _G.infiniteJump=state
    end)
    local teleportBox=Instance.new("TextBox")
    teleportBox.Size=UDim2.new(0,200,0,30)
    teleportBox.BackgroundColor3=Color3.fromRGB(40,40,40)
    teleportBox.Font=Enum.Font.GothamBold
    teleportBox.TextColor3=Color3.new(1,1,1)
    teleportBox.TextSize=14
    teleportBox.PlaceholderText="Player Name"
    teleportBox.BorderSizePixel=0
    teleportBox.Parent=Tabs["Player"].Frame
    local cc=Instance.new("UICorner",teleportBox)
    cc.CornerRadius=UDim.new(0,8)
    createButton(Tabs["Player"].Frame,"Teleport To Player",Color3.fromRGB(255,51,51),function()
        local tn=teleportBox.Text
        for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
            if string.lower(p.Name):find(string.lower(tn)) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp=p.Character.HumanoidRootPart
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(hrp.Position)
                end
                break
            end
        end
    end)
    createToggle(Tabs["Visuals"].Frame,"Player ESP",false,function(state)
        _G.playerESPActive=state
    end)
    createSlider(Tabs["Visuals"].Frame,"Camera FOV",70,120,Workspace.CurrentCamera.FieldOfView or 70,function(val)
        Workspace.CurrentCamera.FieldOfView=val
        _G.fovValue=val
    end)
    createToggle(Tabs["Visuals"].Frame,"ESP Tracers",false,function(state)
        _G.tracersEnabled=state
    end)
    createSlider(Tabs["Visuals"].Frame,"Tracer Thickness",1,10,_G.tracerThickness or 2,function(val)
        _G.tracerThickness=val
    end)
    createSlider(Tabs["Visuals"].Frame,"Tracer Transparency",0,100,(_G.tracerTransparency or 0)*100,function(val)
        _G.tracerTransparency=val/100
    end)
    local function dragify(dragFrame,mainFrame)
        local dragging=false
        local dragInput
        local dragStart
        local startPos
        dragFrame.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true
                dragStart=input.Position
                startPos=mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        dragging=false
                    end
                end)
            end
        end)
        dragFrame.InputChanged:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseMovement then
                dragInput=input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input==dragInput and dragging then
                local delta=input.Position-dragStart
                mainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
    end
    dragify(TopBar,MainFrame)
    UserInputService.InputBegan:Connect(function(input,gpe)
        if not gpe and input.KeyCode==Enum.KeyCode.RightControl then
            AdminUI.Enabled=not AdminUI.Enabled
        end
    end)
end
return module
