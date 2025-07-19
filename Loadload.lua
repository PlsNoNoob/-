-- Create the main loading screen GUI
local loadingScreen = Instance.new("ScreenGui")
loadingScreen.Name = "ExecutorLoadingScreen"
loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingScreen.ResetOnSpawn = false
loadingScreen.IgnoreGuiInset = true  -- Full screen coverage on all devices

-- Main frame that covers the entire screen
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = loadingScreen

-- Container for content (responsive sizing)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.AnchorPoint = Vector2.new(0.5, 0.5)
contentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
contentFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Make it responsive for mobile
if game:GetService("UserInputService").TouchEnabled then
    contentFrame.Size = UDim2.new(0.95, 0, 0.8, 0)
end

-- Unsupported server text (big but not too big)
local unsupportedText = Instance.new("TextLabel")
unsupportedText.Name = "UnsupportedText"
unsupportedText.Size = UDim2.new(1, 0, 0.25, 0)
unsupportedText.Position = UDim2.new(0, 0, 0.1, 0)
unsupportedText.BackgroundTransparency = 1
unsupportedText.Text = "SERVER: UNSUPPORTED"
unsupportedText.TextColor3 = Color3.fromRGB(255, 50, 50)
unsupportedText.TextScaled = true
unsupportedText.Font = Enum.Font.FredokaOne
unsupportedText.TextSize = 42  -- Larger but reasonable size
unsupportedText.TextWrapped = true

-- Add stroke to the text
local textStroke = Instance.new("UIStroke")
textStroke.Name = "TextStroke"
textStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
textStroke.Color = Color3.fromRGB(0, 0, 0)
textStroke.LineJoinMode = Enum.LineJoinMode.Round
textStroke.Thickness = 3.5
textStroke.Transparency = 0
textStroke.Parent = unsupportedText

-- Text alignment
unsupportedText.TextXAlignment = Enum.TextXAlignment.Center
unsupportedText.TextYAlignment = Enum.TextYAlignment.Center
unsupportedText.Parent = contentFrame

-- Loading bar background
local loadingBarBackground = Instance.new("Frame")
loadingBarBackground.Name = "LoadingBarBackground"
loadingBarBackground.Size = UDim2.new(1, -40, 0.15, 0)
loadingBarBackground.Position = UDim2.new(0, 20, 0.5, 0)
loadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
loadingBarBackground.BorderSizePixel = 0
loadingBarBackground.Parent = contentFrame

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Name = "LoadingBarFill"
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBackground

-- Corner radius for loading bar
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = loadingBarBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0.5, 0)
fillCorner.Parent = loadingBarFill

-- Loading text inside the bar
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "JOINING SUPPORTED SERVER PLEASE WAIT..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.FredokaOne
loadingText.TextSize = 20
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center
loadingText.Parent = loadingBarBackground

-- Additional "Loading..." text below the bar with animation
local loadingBelowText = Instance.new("TextLabel")
loadingBelowText.Name = "LoadingBelowText"
loadingBelowText.Size = UDim2.new(1, 0, 0.15, 0)
loadingBelowText.Position = UDim2.new(0, 0, 0.7, 0)
loadingBelowText.BackgroundTransparency = 1
loadingBelowText.Text = "LOADING"
loadingBelowText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingBelowText.TextScaled = true
loadingBelowText.Font = Enum.Font.FredokaOne
loadingBelowText.TextSize = 28
loadingBelowText.TextXAlignment = Enum.TextXAlignment.Center
loadingBelowText.Parent = contentFrame

-- Animation variables
local animationSpeed = 2
local pulseSpeed = 3
local dots = {".", "..", "...", ""}
local dotIndex = 1
local lastDotChange = 0

-- Main animation loop
local function animateLoading()
    local time = tick()
    
    -- Loading bar animation (continuous loop)
    local loadingProgress = (math.sin(time * animationSpeed) + 1) / 2  -- 0 to 1
    loadingBarFill.Size = UDim2.new(loadingProgress, 0, 1, 0)
    
    -- Pulsing effect for the main text
    local pulse = (math.sin(time * pulseSpeed) + 1) / 4 + 0.5  -- 0.5 to 0.75
    unsupportedText.TextTransparency = 1 - pulse
    
    -- Animated dots for "LOADING" text
    if time - lastDotChange > 0.5 then
        dotIndex = dotIndex < #dots and dotIndex + 1 or 1
        loadingBelowText.Text = "LOADING" .. dots[dotIndex]
        lastDotChange = time
    end
    
    -- Color shift for loading bar
    local hue = time % 6 / 6  -- Cycle through colors over 6 seconds
    loadingBarFill.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 0.8)
end

-- Connect animation to Heartbeat
local animationConnection = game:GetService("RunService").Heartbeat:Connect(animateLoading)

-- Function to remove the loading screen
local function removeLoadingScreen()
    animationConnection:Disconnect()
    loadingScreen:Destroy()
end

-- Add to CoreGui
loadingScreen.Parent = game:GetService("CoreGui")

-- Return the removal function
return removeLoadingScreen
