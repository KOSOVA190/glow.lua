
local Players = game:GetService("Players")
local RemoteEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
RemoteEvent.Name = "ToggleGlowEvent"

-- Function to create a red glow on a character
local function addRedGlow(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "RedGlow"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.5
    highlight.Adornee = character
    highlight.Parent = character
end

-- Function to create a name tag above the head
local function addNameTag(character, playerName)
    local head = character:FindFirstChild("Head")
    if not head then return end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "NameTag"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 100, 0, 25) -- Fixed size
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billboardGui.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = playerName
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboardGui

    billboardGui.Parent = head
end

-- Function to setup character with glow and name tag
local function setupCharacter(player, character)
    addRedGlow(character)
    addNameTag(character, player.Name)
end

-- Toggle glow and name tag visibility for all players
local function toggleAllPlayersGlow(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("RedGlow")
            if highlight then
                highlight.Enabled = state
            end

            local head = player.Character:FindFirstChild("Head")
            if head then
                local nameTag = head:FindFirstChild("NameTag")
                if nameTag then
                    nameTag.Enabled = state
                end
            end
        end
    end
end

-- Handle player addition and setup
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        setupCharacter(player, character)        
    end)
end)

-- Initialize existing players when the script runs
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        setupCharacter(player, player.Character)
    end
end

-- Listen for the remote event to toggle the glow and name tags
RemoteEvent.OnServerEvent:Connect(function(player)
    local currentState = player.Character:FindFirstChild("RedGlow").Enabled
    toggleAllPlayersGlow(not currentState)
end)
