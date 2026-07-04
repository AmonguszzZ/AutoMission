local MyUiLibrary = {}

-- Function to create the main Hub Window
function MyUiLibrary:CreateWindow(hubName)
    local uniqueName = "Potassium_Custom_Hub"
    local coreGui = game:GetService("CoreGui")
    
    -- --- AUTO-DESTROY OLD UI ---
    local oldUi = coreGui:FindFirstChild(uniqueName)
    if oldUi then
        oldUi:Destroy()
    end
    -- ----------------------------

    -- Create the ScreenGui container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = uniqueName -- Set the unique name so we can find it next execution
    
    pcall(function()
        ScreenGui.Parent = coreGui
    end)
    
    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = hubName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame

    -- Container for buttons
    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ButtonContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ButtonContainer

    local WindowFeatures = {}

    -- Function to add a Button
    function WindowFeatures:CreateButton(buttonText, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.Text = buttonText
        Button.TextColor3 = Color3.fromRGB(230, 230, 230)
        Button.TextSize = 16
        Button.Font = Enum.Font.SourceSans
        Button.Parent = ButtonContainer
        
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        Button.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    return WindowFeatures
end

return MyUiLibrary
