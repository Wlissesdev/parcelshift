local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local event = ReplicatedStorage:WaitForChild("ParcelShiftEvent")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

local gui = Instance.new("ScreenGui")
gui.Name = "ParcelShiftHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 10
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "RouteCard"
panel.AnchorPoint = Vector2.new(0.5, 0)
panel.Position = UDim2.new(0.5, 0, 0, 12)
panel.Size = UDim2.new(0.94, 0, 0, 160)
panel.BackgroundColor3 = Color3.fromRGB(19, 28, 42)
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel = 0
panel.Parent = gui
local panelConstraint = Instance.new("UISizeConstraint")
panelConstraint.MinSize = Vector2.new(280, 160)
panelConstraint.MaxSize = Vector2.new(570, 160)
panelConstraint.Parent = panel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 18)
panelCorner.Parent = panel
local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(92, 126, 160)
panelStroke.Transparency = 0.38
panelStroke.Thickness = 1.5
panelStroke.Parent = panel
local panelGradient = Instance.new("UIGradient")
panelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 48, 69)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(17, 25, 38)),
})
panelGradient.Rotation = 90
panelGradient.Parent = panel

local function label(parent, name, text, position, size, textSize, color, font)
    local item = Instance.new("TextLabel")
    item.Name = name
    item.Text = text
    item.Position = position
    item.Size = size
    item.BackgroundTransparency = 1
    item.TextColor3 = color or Color3.fromRGB(244, 248, 255)
    item.TextSize = textSize
    item.Font = font or Enum.Font.GothamBold
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Center
    item.TextWrapped = false
    item.TextTruncate = Enum.TextTruncate.AtEnd
    item.Parent = parent
    return item
end

label(panel, "Brand", "PARCEL SHIFT", UDim2.new(0, 16, 0, 9), UDim2.new(0.62, -16, 0, 22), 15, Color3.fromRGB(156, 199, 255), Enum.Font.GothamBlack)
local timer = label(panel, "Timer", "SHIFT  120s", UDim2.new(0.62, 0, 0, 8), UDim2.new(0.38, -16, 0, 26), 20, Color3.fromRGB(255, 216, 116), Enum.Font.GothamBlack)
timer.TextXAlignment = Enum.TextXAlignment.Right
local objective = label(panel, "Objective", "Take a glowing parcel and run it through all 3 shift gates.", UDim2.new(0, 16, 0, 34), UDim2.new(1, -32, 0, 24), 14, Color3.fromRGB(239, 244, 252), Enum.Font.GothamMedium)

local meterBack = Instance.new("Frame")
meterBack.Name = "TimeMeter"
meterBack.Position = UDim2.new(0, 16, 0, 62)
meterBack.Size = UDim2.new(1, -32, 0, 5)
meterBack.BackgroundColor3 = Color3.fromRGB(58, 72, 93)
meterBack.BorderSizePixel = 0
meterBack.Parent = panel
local meterCorner = Instance.new("UICorner")
meterCorner.CornerRadius = UDim.new(1, 0)
meterCorner.Parent = meterBack
local meter = Instance.new("Frame")
meter.Name = "TimeRemaining"
meter.Size = UDim2.fromScale(1, 1)
meter.BackgroundColor3 = Color3.fromRGB(255, 210, 111)
meter.BorderSizePixel = 0
meter.Parent = meterBack
local meterFillCorner = Instance.new("UICorner")
meterFillCorner.CornerRadius = UDim.new(1, 0)
meterFillCorner.Parent = meter

local gates = {}
local gateNames = {"SIZE", "MOTION", "WILD"}
for index = 1, 3 do
    local segment = Instance.new("Frame")
    segment.Name = "Gate" .. index
    segment.Position = UDim2.new((index - 1) / 3, 0, 0, 77)
    segment.Size = UDim2.new(1 / 3, -7, 0, 27)
    segment.BackgroundColor3 = Color3.fromRGB(52, 65, 84)
    segment.BackgroundTransparency = 0.18
    segment.BorderSizePixel = 0
    segment.Parent = panel
    local segmentCorner = Instance.new("UICorner")
    segmentCorner.CornerRadius = UDim.new(0, 8)
    segmentCorner.Parent = segment
    local pip = Instance.new("Frame")
    pip.Name = "Pip"
    pip.Position = UDim2.new(0, 8, 0.5, -4)
    pip.Size = UDim2.fromOffset(8, 8)
    pip.BackgroundColor3 = Color3.fromRGB(117, 134, 158)
    pip.BorderSizePixel = 0
    pip.Parent = segment
    local pipCorner = Instance.new("UICorner")
    pipCorner.CornerRadius = UDim.new(1, 0)
    pipCorner.Parent = pip
    local gateLabel = label(segment, "Label", gateNames[index], UDim2.new(0, 23, 0, 0), UDim2.new(1, -27, 1, 0), 11, Color3.fromRGB(204, 215, 231), Enum.Font.GothamBlack)
    gateLabel.TextXAlignment = Enum.TextXAlignment.Center
    gates[index] = { frame = segment, pip = pip, label = gateLabel }
end

local statsLine = label(panel, "CollectionStats", "STAMPS  0/4     •     DELIVERIES  0", UDim2.new(0, 16, 0, 110), UDim2.new(1, -32, 0, 20), 12, Color3.fromRGB(182, 205, 232), Enum.Font.GothamBold)
local careerLine = label(panel, "CareerStats", "STREAK  0     •     BEST  0     •     SCORE  0", UDim2.new(0, 16, 0, 132), UDim2.new(1, -32, 0, 20), 12, Color3.fromRGB(182, 205, 232), Enum.Font.GothamBold)

local toast = Instance.new("TextLabel")
toast.Name = "MomentToast"
toast.AnchorPoint = Vector2.new(0.5, 1)
toast.Position = UDim2.new(0.5, 0, 1, 82)
toast.Size = UDim2.new(0.9, 0, 0, 58)
toast.BackgroundColor3 = Color3.fromRGB(22, 34, 49)
toast.BackgroundTransparency = 0.06
toast.BorderSizePixel = 0
toast.Text = ""
toast.TextColor3 = Color3.new(1, 1, 1)
toast.TextSize = 17
toast.TextWrapped = true
toast.Font = Enum.Font.GothamBlack
toast.Visible = false
toast.Parent = gui
local toastConstraint = Instance.new("UISizeConstraint")
toastConstraint.MinSize = Vector2.new(250, 58)
toastConstraint.MaxSize = Vector2.new(500, 58)
toastConstraint.Parent = toast
local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 15)
toastCorner.Parent = toast
local toastStroke = Instance.new("UIStroke")
toastStroke.Color = Color3.fromRGB(112, 191, 255)
toastStroke.Thickness = 2
toastStroke.Transparency = 0.18
toastStroke.Parent = toast

local bookButton = Instance.new("TextButton")
bookButton.Name = "StampBookButton"
bookButton.AnchorPoint = Vector2.new(0.5, 0)
bookButton.Position = UDim2.new(0.5, 0, 0, 175)
bookButton.Size = UDim2.fromOffset(152, 32)
bookButton.BackgroundColor3 = Color3.fromRGB(41, 63, 83)
bookButton.Text = "STAMP BOOK  0/4"
bookButton.TextColor3 = Color3.fromRGB(215, 237, 255)
bookButton.TextSize = 12
bookButton.Font = Enum.Font.GothamBlack
bookButton.AutoButtonColor = true
bookButton.Parent = gui
local bookButtonCorner = Instance.new("UICorner")
bookButtonCorner.CornerRadius = UDim.new(0, 10)
bookButtonCorner.Parent = bookButton

local bookPanel = Instance.new("Frame")
bookPanel.Name = "MutationJournal"
bookPanel.AnchorPoint = Vector2.new(0.5, 0)
bookPanel.Position = UDim2.new(0.5, 0, 0, 212)
bookPanel.Size = UDim2.new(0.92, 0, 0, 276)
bookPanel.BackgroundColor3 = Color3.fromRGB(20, 31, 46)
bookPanel.BorderSizePixel = 0
bookPanel.Visible = false
bookPanel.Parent = gui
local bookConstraint = Instance.new("UISizeConstraint")
bookConstraint.MinSize = Vector2.new(280, 276)
bookConstraint.MaxSize = Vector2.new(420, 276)
bookConstraint.Parent = bookPanel
local bookCorner = Instance.new("UICorner")
bookCorner.CornerRadius = UDim.new(0, 16)
bookCorner.Parent = bookPanel
local bookStroke = Instance.new("UIStroke")
bookStroke.Color = Color3.fromRGB(115, 159, 200)
bookStroke.Transparency = 0.35
bookStroke.Thickness = 1.5
bookStroke.Parent = bookPanel

local bookTitle = label(bookPanel, "Title", "MUTATION STAMP BOOK", UDim2.new(0, 14, 0, 8), UDim2.new(1, -58, 0, 28), 15, Color3.fromRGB(255, 218, 132), Enum.Font.GothamBlack)
local closeBook = Instance.new("TextButton")
closeBook.Name = "Close"
closeBook.Position = UDim2.new(1, -42, 0, 7)
closeBook.Size = UDim2.fromOffset(32, 30)
closeBook.BackgroundColor3 = Color3.fromRGB(50, 64, 82)
closeBook.Text = "×"
closeBook.TextColor3 = Color3.new(1, 1, 1)
closeBook.TextSize = 22
closeBook.Font = Enum.Font.GothamBold
closeBook.Parent = bookPanel
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBook

local journalRows = {}
for index, mutation in ipairs(Config.Mutations) do
    local row = Instance.new("Frame")
    row.Name = "Mutation" .. index
    row.Position = UDim2.new(0, 12, 0, 44 + (index - 1) * 56)
    row.Size = UDim2.new(1, -24, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(35, 47, 65)
    row.BorderSizePixel = 0
    row.Parent = bookPanel
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 10)
    rowCorner.Parent = row
    local swatch = Instance.new("Frame")
    swatch.Name = "Swatch"
    swatch.Position = UDim2.new(0, 9, 0.5, -9)
    swatch.Size = UDim2.fromOffset(18, 18)
    swatch.BackgroundColor3 = mutation.Color
    swatch.BorderSizePixel = 0
    swatch.Parent = row
    local swatchCorner = Instance.new("UICorner")
    swatchCorner.CornerRadius = UDim.new(0, 5)
    swatchCorner.Parent = swatch
    local nameLabel = label(row, "MutationName", "UNKNOWN PARCEL", UDim2.new(0, 36, 0, 5), UDim2.new(1, -48, 0, 18), 12, Color3.fromRGB(239, 244, 252), Enum.Font.GothamBlack)
    local descLabel = label(row, "MutationDescription", "Pass a shift gate to discover a mutation.", UDim2.new(0, 36, 0, 24), UDim2.new(1, -48, 0, 18), 10, Color3.fromRGB(161, 180, 204), Enum.Font.GothamMedium)
    journalRows[mutation.Id] = { name = nameLabel, description = descLabel, mutation = mutation }
end

bookButton.Activated:Connect(function()
    bookPanel.Visible = not bookPanel.Visible
end)
closeBook.Activated:Connect(function()
    bookPanel.Visible = false
end)
local snapshot = {
    shiftActive = false, shiftSeconds = 0, breakSeconds = 0,
    gateCount = 0, gates = {false, false, false},
    uniqueMutationCount = 0, deliveries = 0, routeScore = 0,
    combo = 0, bestCombo = 0, jobState = "Idle", journal = {},
}
local function updateAssistPromptVisibility()
    for _, instance in ipairs(workspace:GetDescendants()) do
        if instance:IsA("ProximityPrompt") and instance.ActionText == "Stabilize teammate" then
            local ownerId = instance.Parent and instance.Parent:GetAttribute("OwnerUserId")
            instance.Enabled = ownerId ~= player.UserId and snapshot.jobState ~= "Carrying"
        end
    end
end

for _, instance in ipairs(workspace:GetDescendants()) do
    if instance:IsA("ProximityPrompt") and instance.ActionText == "Stabilize teammate" then
        local ownerId = instance.Parent and instance.Parent:GetAttribute("OwnerUserId")
        instance.Enabled = ownerId ~= player.UserId and snapshot.jobState ~= "Carrying"
    end
end
workspace.DescendantAdded:Connect(function(instance)
    if instance:IsA("ProximityPrompt") and instance.ActionText == "Stabilize teammate" then
        task.defer(function()
            if instance.Parent then
                local ownerId = instance.Parent:GetAttribute("OwnerUserId")
                instance.Enabled = ownerId ~= player.UserId and snapshot.jobState ~= "Carrying"
            end
        end)
    end
end)
local toastToken = 0

local function render()
    if snapshot.shiftActive then
        timer.Text = string.format("SHIFT  %02ds", snapshot.shiftSeconds or 0)
        local remaining = math.clamp((snapshot.shiftSeconds or 0) / 120, 0, 1)
        meter.Size = UDim2.new(remaining, 0, 1, 0)
        meter.BackgroundColor3 = remaining <= 0.2 and Color3.fromRGB(255, 106, 108) or Color3.fromRGB(255, 210, 111)
        if snapshot.jobState == "Carrying" then
            objective.Text = "CARRY THE PARCEL TO THE DEPOT  •  " .. tostring(snapshot.gateCount or 0) .. "/3 gates"
        else
            objective.Text = "Take a glowing parcel and run it through all 3 shift gates."
        end
    else
        timer.Text = string.format("NEXT SHIFT  %02ds", snapshot.breakSeconds or 0)
        meter.Size = UDim2.new(0, 0, 1, 0)
        objective.Text = "Your stamp book is safe. The next delivery shift is coming up."
    end

    for index, gate in ipairs(gates) do
        local completed = snapshot.gates and snapshot.gates[index] == true
        gate.frame.BackgroundColor3 = completed and Color3.fromRGB(48, 111, 99) or Color3.fromRGB(52, 65, 84)
        gate.pip.BackgroundColor3 = completed and Color3.fromRGB(113, 255, 192) or Color3.fromRGB(117, 134, 158)
        gate.label.TextColor3 = completed and Color3.fromRGB(193, 255, 221) or Color3.fromRGB(204, 215, 231)
        gate.label.Text = completed and (gateNames[index] .. "  ✓") or gateNames[index]
    end

    statsLine.Text = string.format("STAMPS  %d/4     •     DELIVERIES  %d", snapshot.uniqueMutationCount or 0, snapshot.deliveries or 0)
    bookButton.Text = string.format("STAMP BOOK  %d/4", snapshot.uniqueMutationCount or 0)
    for mutationId, row in pairs(journalRows) do
        local found = snapshot.journal and snapshot.journal[mutationId] == true
        row.name.Text = found and row.mutation.Label or "UNKNOWN PARCEL"
        row.description.Text = found and row.mutation.Description or "Pass a shift gate to discover a mutation."
        row.swatch.BackgroundTransparency = found and 0 or 0.65
        row.name.TextColor3 = found and row.mutation.Color or Color3.fromRGB(173, 185, 201)
    end
    careerLine.Text = string.format("STREAK  %d     •     BEST  %d     •     SCORE  %d", snapshot.combo or 0, snapshot.bestCombo or 0, snapshot.routeScore or 0)
end

local function showToast(text, color)
    if not text or text == "" then return end
    toastToken += 1
    local token = toastToken
    toast.Text = text
    toastStroke.Color = color or Color3.fromRGB(112, 191, 255)
    toast.Position = UDim2.new(0.5, 0, 1, 76)
    toast.Visible = true
    TweenService:Create(toast, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 1, -26),
    }):Play()
    task.delay(3.1, function()
        if token ~= toastToken then return end
        local tween = TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 1, 76),
        })
        tween:Play()
        tween.Completed:Wait()
        if token == toastToken then toast.Visible = false end
    end)
end

event.OnClientEvent:Connect(function(payload)
    for key, value in pairs(payload) do snapshot[key] = value end
    render()
    if payload.kind == "Mutation" then
        showToast(payload.lastMutation .. "  •  " .. (payload.mutationDescription or "Parcel changed!"), Color3.fromRGB(255, 186, 98))
        local scale = panel:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        scale.Parent = panel
        scale.Scale = 1
        TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.035}):Play()
        task.delay(0.13, function()
            if scale.Parent then
                TweenService:Create(scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end
        end)
    elseif payload.kind == "Delivered" then
        showToast(payload.message, Color3.fromRGB(112, 255, 184))
    elseif payload.kind == "Assist" or payload.kind == "JobStarted" or payload.kind == "JobEnded" or payload.kind == "ShiftStarted" or payload.kind == "Hint" then
        showToast(payload.message, payload.kind == "Assist" and Color3.fromRGB(115, 220, 255) or Color3.fromRGB(255, 216, 116))
    end
end)

render()





