local MyUiLibrary = {}

function MyUiLibrary:CreateWindow(hubName, hubSubtitle)
    local uniqueName = "Potassium_Custom_Hub"
    local coreGui = game:GetService("CoreGui")
    
    -- Auto-destroy old UI if it exists
    local oldUi = coreGui:FindFirstChild(uniqueName)
    if oldUi then oldUi:Destroy() end

    -- Main ScreenGui Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = uniqueName
    pcall(function() ScreenGui.Parent = coreGui end)
    
    -- Main Window Frame (Slightly larger to fit the sidebar comfortably)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = MainFrame

    -- ==========================================
    -- TOP HEADER BAR (Window Controls Left, Titles Right)
    -- ==========================================
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, 0, 0, 50)
    HeaderBar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    HeaderBar.BorderSizePixel = 0
    HeaderBar.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = HeaderBar

    -- [LEFT SIDE] Window Control Buttons (Close / Minimize)
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Name = "Controls"
    ControlsContainer.Size = UDim2.new(0, 60, 1, 0)
    ControlsContainer.Position = UDim2.new(0, 15, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = HeaderBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 16, 0, 16)
    CloseButton.Position = UDim2.new(0, 0, 0.5, -8)
    CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68) -- Pastel Red
    CloseButton.Text = ""
    CloseButton.Parent = ControlsContainer
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 16, 0, 16)
    MinimizeButton.Position = UDim2.new(0, 24, 0.5, -8)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(245, 158, 11) -- Pastel Yellow
    MinimizeButton.Text = ""
    MinimizeButton.Parent = ControlsContainer
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)

    local MainContainer = Instance.new("Frame") -- Grouping body content for minimization toggling
    MainContainer.Size = UDim2.new(1, 0, 1, -50)
    MainContainer.Position = UDim2.new(0, 0, 0, 50)
    MainContainer.BackgroundTransparency = 1
    MainContainer.Parent = MainFrame

    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainContainer.Visible = not minimized
        MainFrame:TweenSize(minimized and UDim2.new(0, 550, 0, 50) or UDim2.new(0, 550, 0, 360), "Out", "Quad", 0.2, true)
    end)

    -- [RIGHT SIDE] Titles and Description
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    TitleLabel.Position = UDim2.new(0.4, -15, 0.1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = hubName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Right
    TitleLabel.Parent = HeaderBar

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
    SubtitleLabel.Position = UDim2.new(0.4, -15, 0.5, 0)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = hubSubtitle or "Auto-Mission Client"
    SubtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubtitleLabel.TextSize = 12
    SubtitleLabel.Font = Enum.Font.SourceSans
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Right
    SubtitleLabel.Parent = HeaderBar

    -- ==========================================
    -- BODY LAYOUT (Left Sidebar, Right Content)
    -- ==========================================
    
    -- Left Sidebar for Navigation Tabs
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainContainer

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = Sidebar
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

    -- Right Content Window Container
    local ContentDisplay = Instance.new("Frame")
    ContentDisplay.Name = "ContentDisplay"
    ContentDisplay.Size = UDim2.new(1, -155, 1, -15)
    ContentDisplay.Position = UDim2.new(0, 148, 0, 8)
    ContentDisplay.BackgroundTransparency = 1
    ContentDisplay.Parent = MainContainer

    local WindowFeatures = {}
    local sectionsCreated = 0

    -- Function to create a clean Section Tab inside the Sidebar
    function WindowFeatures:CreateSection(sectionName)
        sectionsCreated = sectionsCreated + 1
        
        -- Container where elements for this tab live
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = sectionName .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.Visible = (sectionsCreated == 1) -- Only show the very first page by default
        TabPage.Parent = ContentDisplay

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = TabPage

        -- Sidebar Navigation Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -16, 0, 32)
        TabButton.Position = UDim2.new(0, 8, 0, 0)
        TabButton.BackgroundColor3 = (sectionsCreated == 1) and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(28, 28, 28)
        TabButton.Text = "  " .. sectionName
        TabButton.TextColor3 = (sectionsCreated == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSansSemibold
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)

        -- Handle switching views when clicking tabs
        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(ContentDisplay:GetChildren()) do
                page.Visible = false
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    btn.TextColor3 = Color3.fromRGB(160, 160, 160)
                end
            end
            TabPage.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local SectionFeatures = {}

        -- Add Button directly inside this specific Section page
        function SectionFeatures:CreateButton(buttonText, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -5, 0, 36)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.Text = buttonText
            Button.TextColor3 = Color3.fromRGB(230, 230, 230)
            Button.TextSize = 14
            Button.Font = Enum.Font.SourceSans
            Button.Parent = TabPage
            
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
            
            Button.MouseEnter:Connect(function() Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end)
            Button.MouseLeave:Connect(function() Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end)
            Button.MouseButton1Click:Connect(function() task.spawn(callback) end)
        end

        return SectionFeatures
    end

    return WindowFeatures
end

return MyUiLibrary
