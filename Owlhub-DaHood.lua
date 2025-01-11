local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Drawing Pool
local DrawingPool = {
    ESP = {},
    FOVCircle = Drawing.new("Circle")
}

-- Settings
local Settings = {
    ESP = {
        Enabled = false,
        Box = false,
        Health = false,
        Name = false,
        Distance = false,
        Tracers = false,
        BoxFill = false
    },
    Combat = {
        Aimbot = false,
        HeadOnly = false,
        HeadExpander = false,
        FOV = 100
    }
}

-- Head Expander Part
local HeadPart = Instance.new("Part")
HeadPart.Size = Vector3.new(7, 7, 7)
HeadPart.Transparency = 0.5
HeadPart.Color = Color3.fromRGB(255, 128, 0)
HeadPart.Material = Enum.Material.ForceField
HeadPart.CanCollide = false

local HeadOutline = Instance.new("SelectionBox")
HeadOutline.Color3 = Color3.fromRGB(0, 0, 0)
HeadOutline.LineThickness = 0.02
HeadOutline.Parent = HeadPart

-- Initialize FOV Circle
DrawingPool.FOVCircle.Visible = false
DrawingPool.FOVCircle.Color = Color3.fromRGB(255, 255, 255)
DrawingPool.FOVCircle.Thickness = 1
DrawingPool.FOVCircle.Transparency = 1
DrawingPool.FOVCircle.NumSides = 64
DrawingPool.FOVCircle.Radius = Settings.Combat.FOV
DrawingPool.FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Create ScreenGui
local OwlHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local VisualsFrame = Instance.new("Frame")
local CombatFrame = Instance.new("Frame")
local VisualsTitle = Instance.new("TextLabel")
local CombatTitle = Instance.new("TextLabel")

-- Main GUI Setup
OwlHub.Name = "OwlHub"
OwlHub.Parent = CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = OwlHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "    ✨ Owl Hub"
Title.TextColor3 = Color3.fromRGB(255, 128, 0)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sections Setup
VisualsFrame.Name = "VisualsFrame"
VisualsFrame.Parent = MainFrame
VisualsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
VisualsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
VisualsFrame.Position = UDim2.new(0, 10, 0, 35)
VisualsFrame.Size = UDim2.new(0.5, -15, 0.9, -10)

CombatFrame.Name = "CombatFrame"
CombatFrame.Parent = MainFrame
CombatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CombatFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
CombatFrame.Position = UDim2.new(0.5, 5, 0, 35)
CombatFrame.Size = UDim2.new(0.5, -15, 0.9, -10)

VisualsTitle.Name = "VisualsTitle"
VisualsTitle.Parent = VisualsFrame
VisualsTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
VisualsTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
VisualsTitle.Size = UDim2.new(1, 0, 0, 25)
VisualsTitle.Font = Enum.Font.GothamBold
VisualsTitle.Text = "  Visuals"
VisualsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualsTitle.TextSize = 14
VisualsTitle.TextXAlignment = Enum.TextXAlignment.Left

CombatTitle.Name = "CombatTitle"
CombatTitle.Parent = CombatFrame
CombatTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CombatTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
CombatTitle.Size = UDim2.new(1, 0, 0, 25)
CombatTitle.Font = Enum.Font.GothamBold
CombatTitle.Text = "  Combat"
CombatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatTitle.TextSize = 14
CombatTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Create Toggle Function
local function CreateToggle(parent, text, yPos, settingType, settingName)
    local Toggle = Instance.new("TextButton")
    local Status = Instance.new("Frame")
    
    Toggle.Name = text.."Toggle"
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.Position = UDim2.new(0, 5, 0, yPos)
    Toggle.Size = UDim2.new(1, -10, 0, 23)
    Toggle.Font = Enum.Font.Gotham
    Toggle.Text = "  "..text
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 14
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.AutoButtonColor = false
    
    Status.Name = "Status"
    Status.Parent = Toggle
    Status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Status.Position = UDim2.new(1, -25, 0.5, -4)
    Status.Size = UDim2.new(0, 16, 0, 8)
    
    Toggle.MouseButton1Click:Connect(function()
        Settings[settingType][settingName] = not Settings[settingType][settingName]
        Status.BackgroundColor3 = Settings[settingType][settingName] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        
        if settingName == "HeadExpander" then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character then
                        local head = character:FindFirstChild("Head")
                        if head then
                            if Settings.Combat.HeadExpander then
                                local expander = HeadPart:Clone()
                                expander.Name = "ExpandedHead"
                                expander.CFrame = head.CFrame
                                HeadOutline:Clone().Parent = expander
                                expander.Parent = head
                                
                                local weld = Instance.new("Weld")
                                weld.Part0 = head
                                weld.Part1 = expander
                                weld.C0 = CFrame.new()
                                weld.Parent = expander
                            else
                                local expander = head:FindFirstChild("ExpandedHead")
                                if expander then
                                    expander:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return Toggle
end

-- Create Slider Function
local function CreateSlider(parent, text, yPos, min, max, default, settingType, settingName)
    local SliderFrame = Instance.new("Frame")
    local SliderText = Instance.new("TextLabel")
    local SliderBar = Instance.new("Frame")
    local SliderButton = Instance.new("TextButton")
    local ValueLabel = Instance.new("TextLabel")
    
    SliderFrame.Name = text.."Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderFrame.Position = UDim2.new(0, 5, 0, yPos)
    SliderFrame.Size = UDim2.new(1, -10, 0, 35)
    
    SliderText.Name = "SliderText"
    SliderText.Parent = SliderFrame
    SliderText.BackgroundTransparency = 1
    SliderText.Position = UDim2.new(0, 5, 0, 0)
    SliderText.Size = UDim2.new(1, -10, 0, 20)
    SliderText.Font = Enum.Font.Gotham
    SliderText.Text = text
    SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderText.TextSize = 14
    SliderText.TextXAlignment = Enum.TextXAlignment.Left
    
    SliderBar.Name = "SliderBar"
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderBar.Position = UDim2.new(0, 5, 0, 22)
    SliderBar.Size = UDim2.new(1, -45, 0, 4)
    
    SliderButton.Name = "SliderButton"
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
    SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderButton.Size = UDim2.new(0, 8, 0, 12)
    SliderButton.Position = UDim2.new(0, -4, 0.5, -6)
    SliderButton.Text = ""
    
    ValueLabel.Name = "ValueLabel"
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -35, 0, 17)
    ValueLabel.Size = UDim2.new(0, 30, 0, 15)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 12
    
    local dragging = false
    Settings[settingType][settingName] = default
    
    local function updateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), -4, 0.5, -6)
        SliderButton.Position = pos
        local value = math.floor(min + (max - min) * pos.X.Scale)
        Settings[settingType][settingName] = value
        ValueLabel.Text = tostring(value)
        
        if settingName == "FOV" then
            DrawingPool.FOVCircle.Radius = value
        end
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return SliderFrame
end

-- Create Visual Toggles
local visualToggles = {
    {"Box ESP", "ESP", "Box"},
    {"Health ESP", "ESP", "Health"},
    {"Name ESP", "ESP", "Name"},
    {"Distance ESP", "ESP", "Distance"},
    {"Tracers", "ESP", "Tracers"},
    {"Box Fill", "ESP", "BoxFill"}
}

for i, toggle in ipairs(visualToggles) do
    CreateToggle(VisualsFrame, toggle[1], 27 + (i * 27), toggle[2], toggle[3])
end

-- Create Combat Toggles and Sliders
local combatToggles = {
    {"Aimbot", "Combat", "Aimbot"},
    {"Head Only", "Combat", "HeadOnly"},
    {"Head Expander", "Combat", "HeadExpander"}
}

for i, toggle in ipairs(combatToggles) do
    CreateToggle(CombatFrame, toggle[1], 27 + (i * 27), toggle[2], toggle[3])
end

CreateSlider(CombatFrame, "FOV", 135, 30, 500, 100, "Combat", "FOV")

-- ESP Functions
local function CreateESPDrawings(player)
    local drawings = {
        Box = Drawing.new("Square"),
        BoxFill = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }

    for _, drawing in pairs(drawings) do
        drawing.Visible = false
        drawing.Color = Color3.fromRGB(255, 255, 255)
        if drawing.Thickness then drawing.Thickness = 1 end
    end

    drawings.BoxFill.Filled = true
    drawings.BoxFill.Transparency = 0.5
    drawings.HealthBar.Filled = true
    
    for _, text in pairs({drawings.Name, drawings.Distance}) do
        text.Size = 14
        text.Center = true
        text.Outline = true
    end

    DrawingPool.ESP[player] = drawings
    return drawings
end

-- ESP Update Function
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local drawings = DrawingPool.ESP[player] or CreateESPDrawings(player)
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if not (character and humanoidRootPart and humanoid and humanoid.Health > 0) then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end

        local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        if not onScreen then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end

        local distance = (Camera.CFrame.Position - humanoidRootPart.Position).Magnitude
        local size = Vector2.new(2000 / vector.Z, 2500 / vector.Z)
        local position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)

        drawings.Box.Size = size
        drawings.Box.Position = position
        drawings.Box.Visible = Settings.ESP.Box

        drawings.BoxFill.Size = size
        drawings.BoxFill.Position = position
        drawings.BoxFill.Visible = Settings.ESP.BoxFill

        if Settings.ESP.Health then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            drawings.HealthBar.Size = Vector2.new(2, size.Y * healthPercent)
            drawings.HealthBar.Position = Vector2.new(position.X - 5, position.Y + (size.Y * (1 - healthPercent)))
            drawings.HealthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBar.Visible = false
        end

        drawings.Name.Text = player.Name
        drawings.Name.Position = Vector2.new(vector.X, position.Y - 16)
        drawings.Name.Visible = Settings.ESP.Name

        drawings.Distance.Text = math.floor(distance) .. " studs"
        drawings.Distance.Position = Vector2.new(vector.X, position.Y + size.Y)
        drawings.Distance.Visible = Settings.ESP.Distance

        if Settings.ESP.Tracers then
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(vector.X, vector.Y)
            drawings.Tracer.Visible = true
        else
            drawings.Tracer.Visible = false
        end
    end
end

-- Aimbot Function
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        if not character then continue end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local part = Settings.Combat.HeadOnly and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local distance = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
        if distance <= Settings.Combat.FOV then
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

-- Main Update Loop
RunService.RenderStepped:Connect(function()
    UpdateESP()
    DrawingPool.FOVCircle.Visible = Settings.Combat.Aimbot
    
    if Settings.Combat.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local character = target.Character
            if character then
                local part = Settings.Combat.HeadOnly and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                if part then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                end
            end
        end
    end
end)

-- Make Frame Draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Toggle Menu with Insert Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESPDrawings(player)
    end
end

-- Player Connections
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESPDrawings(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if DrawingPool.ESP[player] then
        for _, drawing in pairs(DrawingPool.ESP[player]) do
            drawing:Remove()
        end
        DrawingPool.ESP[player] = nil
    end
end)

-- Cleanup
CoreGui.ChildRemoved:Connect(function(child)
    if child == OwlHub then
        for _, playerDrawings in pairs(DrawingPool.ESP) do
            for _, drawing in pairs(playerDrawings) do
                drawing:Remove()
            end
        end
        DrawingPool.FOVCircle:Remove()
        
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                if head then
                    local expander = head:FindFirstChild("ExpandedHead")
                    if expander then
                        expander:Destroy()
                    end
                end
            end
        end
    end
end)

return OwlHub
