--[[
    Optimized Roblox Trolling GUI
    Features:
    - Lightweight and efficient
    - Various trolling functions
    - Clean UI with toggle
    - Player selection
    - Anti-lag measures
]]

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables
local localPlayer = Players.LocalPlayer
local guiEnabled = false
local selectedPlayer = nil
local debounce = false

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Troll Menu v2.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local UICorner2 = UICorner:Clone()
UICorner2.Parent = Title

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = Title

local UICorner3 = UICorner:Clone()
UICorner3.Parent = CloseButton

-- Player Selection
local PlayerSelection = Instance.new("Frame")
PlayerSelection.Name = "PlayerSelection"
PlayerSelection.Size = UDim2.new(1, -20, 0, 40)
PlayerSelection.Position = UDim2.new(0, 10, 0, 50)
PlayerSelection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerSelection.Parent = MainFrame

local UICorner4 = UICorner:Clone()
UICorner4.Parent = PlayerSelection

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Name = "PlayerDropdown"
PlayerDropdown.Size = UDim2.new(1, -10, 1, -10)
PlayerDropdown.Position = UDim2.new(0, 5, 0, 5)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlayerDropdown.Text = "Select Player"
PlayerDropdown.TextColor3 = Color3.white
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 14
PlayerDropdown.Parent = PlayerSelection

local UICorner5 = UICorner:Clone()
UICorner5.Parent = PlayerDropdown

local PlayerScrollingFrame = Instance.new("ScrollingFrame")
PlayerScrollingFrame.Name = "PlayerScrollingFrame"
PlayerScrollingFrame.Size = UDim2.new(1, -10, 0, 150)
PlayerScrollingFrame.Position = UDim2.new(0, 5, 1, 5)
PlayerScrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerScrollingFrame.Visible = false
PlayerScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScrollingFrame.ScrollBarThickness = 5
PlayerScrollingFrame.Parent = PlayerSelection

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerScrollingFrame

-- Buttons Frame
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Size = UDim2.new(1, -20, 1, -120)
ButtonsFrame.Position = UDim2.new(0, 10, 0, 100)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ButtonsFrame.ScrollBarThickness = 5
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Padding = UDim.new(0, 5)
ButtonsLayout.Parent = ButtonsFrame

-- Toggle GUI Button (outside main GUI)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "Toggle Menu"
ToggleButton.TextColor3 = Color3.white
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

local UICorner6 = UICorner:Clone()
UICorner6.Parent = ToggleButton

-- Functions
local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = name
    button.TextColor3 = Color3.white
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = ButtonsFrame
    
    local corner = UICorner:Clone()
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        task.delay(0.5, function() debounce = false end)
        
        if selectedPlayer or name:find("All") then
            callback()
        else
            PlayerDropdown.Text = "SELECT PLAYER FIRST!"
            task.delay(1, function()
                PlayerDropdown.Text = selectedPlayer and selectedPlayer.Name or "Select Player"
            end)
        end
    end)
    
    return button
end

local function updatePlayerList()
    PlayerScrollingFrame:ClearAllChildren()
    
    local allPlayersButton = Instance.new("TextButton")
    allPlayersButton.Name = "AllPlayers"
    allPlayersButton.Size = UDim2.new(1, 0, 0, 30)
    allPlayersButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    allPlayersButton.Text = "ALL PLAYERS"
    allPlayersButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    allPlayersButton.Font = Enum.Font.GothamBold
    allPlayersButton.TextSize = 14
    allPlayersButton.Parent = PlayerScrollingFrame
    
    local corner = UICorner:Clone()
    corner.Parent = allPlayersButton
    
    allPlayersButton.MouseButton1Click:Connect(function()
        selectedPlayer = nil
        PlayerDropdown.Text = "ALL PLAYERS"
        PlayerScrollingFrame.Visible = false
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local playerButton = Instance.new("TextButton")
            playerButton.Name = player.Name
            playerButton.Size = UDim2.new(1, 0, 0, 30)
            playerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            playerButton.Text = player.Name
            playerButton.TextColor3 = Color3.fromRGB(200, 200, 255)
            playerButton.Font = Enum.Font.Gotham
            playerButton.TextSize = 14
            playerButton.Parent = PlayerScrollingFrame
            
            local corner = UICorner:Clone()
            corner.Parent = playerButton
            
            playerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player
                PlayerDropdown.Text = player.Name
                PlayerScrollingFrame.Visible = false
            end)
        end
    end
end

-- Trolling Functions (Optimized)
local trollingFunctions = {
    FakeLag = function(target)
        if target then
            local character = target.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    for i = 1, 10 do
                        task.wait(0.1)
                        humanoid.WalkSpeed = math.random(-16, 16)
                    end
                    humanoid.WalkSpeed = 16
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.FakeLag, player)
                end
            end
        end
    end,
    
    SpinCharacter = function(target)
        if target then
            local character = target.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local spin = Instance.new("BodyAngularVelocity")
                    spin.AngularVelocity = Vector3.new(0, 50, 0)
                    spin.MaxTorque = Vector3.new(0, math.huge, 0)
                    spin.Parent = humanoidRootPart
                    
                    task.delay(3, function()
                        spin:Destroy()
                    end)
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.SpinCharacter, player)
                end
            end
        end
    end,
    
    InvisibleFloor = function(target)
        local parts = {}
        local function createPart(pos)
            local part = Instance.new("Part")
            part.Size = Vector3.new(50, 1, 50)
            part.Position = pos
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = true
            part.Parent = workspace
            table.insert(parts, part)
            return part
        end
        
        if target then
            local character = target.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    createPart(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    local character = player.Character
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            createPart(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                        end
                    end
                end
            end
        end
        
        task.delay(10, function()
            for _, part in ipairs(parts) do
                part:Destroy()
            end
        end)
    end,
    
    FakeTeleport = function(target)
        if target then
            local character = target.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local originalPos = humanoidRootPart.Position
                    
                    -- Flash effect
                    local flash = Instance.new("Part")
                    flash.Size = Vector3.new(5, 5, 5)
                    flash.Position = originalPos
                    flash.Anchored = true
                    flash.CanCollide = false
                    flash.Material = Enum.Material.Neon
                    flash.Color = Color3.fromRGB(255, 255, 0)
                    flash.Transparency = 0.5
                    flash.Shape = Enum.PartType.Ball
                    flash.Parent = workspace
                    
                    -- Fake teleport
                    humanoidRootPart.CFrame = CFrame.new(originalPos + Vector3.new(0, 0.1, 0))
                    
                    task.delay(0.5, function()
                        flash:Destroy()
                        humanoidRootPart.CFrame = CFrame.new(originalPos)
                    end)
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.FakeTeleport, player)
                end
            end
        end
    end,
    
    GravityChange = function(target)
        if target then
            local character = target.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    workspace.Gravity = 5
                    task.delay(3, function()
                        workspace.Gravity = 196.2
                    end)
                end
            end
        else
            workspace.Gravity = 5
            task.delay(3, function()
                workspace.Gravity = 196.2
            end)
        end
    end,
    
    FakeKick = function(target)
        if target then
            local gui = Instance.new("ScreenGui")
            gui.Parent = target.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.Parent = gui
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 0, 50)
            text.Position = UDim2.new(0, 0, 0.5, -25)
            text.Text = "You have been kicked from the game"
            text.TextColor3 = Color3.fromRGB(255, 0, 0)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 24
            text.BackgroundTransparency = 1
            text.Parent = frame
            
            task.delay(3, function()
                gui:Destroy()
            end)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.FakeKick, player)
                end
            end
        end
    end,
    
    CameraShake = function(target)
        if target then
            local camera = workspace.CurrentCamera
            local originalCF = camera.CFrame
            
            for i = 1, 30 do
                camera.CFrame = originalCF * CFrame.new(
                    math.random(-1, 1),
                    math.random(-1, 1),
                    math.random(-1, 1)
                )
                RunService.RenderStepped:Wait()
            end
            
            camera.CFrame = originalCF
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.CameraShake, player)
                end
            end
        end
    end,
    
    ReverseControls = function(target)
        if target then
            local character = target.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
                    
                    local connection
                    connection = humanoid.Running:Connect(function(speed)
                        humanoid:Move(-humanoid.MoveDirection)
                    end)
                    
                    task.delay(5, function()
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                        connection:Disconnect()
                    end)
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    task.spawn(trollingFunctions.ReverseControls, player)
                end
            end
        end
    end
}

-- Create trolling buttons
for funcName, func in pairs(trollingFunctions) do
    createButton(funcName, function()
        func(selectedPlayer)
    end)
    
    -- Create "All" version for each function
    if not funcName:find("All") then
        createButton(funcName.." (ALL)", function()
            func()
        end)
    end
end

-- UI Events
ToggleButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    MainFrame.Visible = guiEnabled
    
    if guiEnabled then
        updatePlayerList()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    guiEnabled = false
    MainFrame.Visible = false
end)

PlayerDropdown.MouseButton1Click:Connect(function()
    PlayerScrollingFrame.Visible = not PlayerScrollingFrame.Visible
    updatePlayerList()
end)

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
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
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Player join/leave events
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Initial update
updatePlayerList()

-- Anti-afk
local VirtualUser = game:GetService("VirtualUser")
localPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("Troll GUI loaded successfully!")
