local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

local event = ReplicatedStorage:FindFirstChild("ParcelShiftEvent")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "ParcelShiftEvent"
    event.Parent = ReplicatedStorage
end

local oldWorld = workspace:FindFirstChild("ParcelShiftWorld")
if oldWorld then oldWorld:Destroy() end
local world = Instance.new("Folder")
world.Name = "ParcelShiftWorld"
world.Parent = workspace

local jobs = {}
local playerRecords = {}
local shiftActive = false
local shiftEndsAt = 0
local shiftNumber = 0
local serial = 0

Lighting.ClockTime = 16.4
Lighting.Brightness = 2.2
Lighting.Ambient = Color3.fromRGB(125, 143, 168)
Lighting.OutdoorAmbient = Color3.fromRGB(156, 174, 192)
local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
atmosphere.Density = 0.24
atmosphere.Offset = 0.08
atmosphere.Color = Color3.fromRGB(199, 222, 255)
atmosphere.Decay = Color3.fromRGB(109, 137, 173)
atmosphere.Glare = 0.15
atmosphere.Haze = 1.1
atmosphere.Parent = Lighting

local function makePart(parent, name, size, position, color, material, anchored)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.Anchored = anchored ~= false
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = parent or world
    return part
end

local function addCorner(part, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = part
end

local function makeBillboard(adornee, text, color, width, height)
    local gui = Instance.new("BillboardGui")
    gui.Name = "WorldLabel"
    gui.Size = UDim2.fromOffset(width or 260, height or 58)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    gui.AlwaysOnTop = true
    gui.Adornee = adornee
    gui.Parent = adornee

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(21, 29, 43)
    label.BackgroundTransparency = 0.08
    label.Text = text
    label.TextColor3 = color or Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Parent = gui
    addCorner(label, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.new(1, 1, 1)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Parent = label
    return label
end

local function addPrompt(parent, action, object, distance)
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = action
    prompt.ObjectText = object
    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = distance or Config.PromptDistance
    prompt.RequiresLineOfSight = false
    prompt.Parent = parent
    return prompt
end

-- Bright, readable blockout with a clear start, route, landmarks, and destination.
makePart(world, "Island", Vector3.new(240, 2, 240), Vector3.new(0, -5, -64), Color3.fromRGB(61, 119, 96), Enum.Material.Grass)
makePart(world, "Route", Vector3.new(36, 1, 176), Vector3.new(0, -0.6, -64), Color3.fromRGB(47, 60, 78), Enum.Material.Asphalt)
makePart(world, "StartPlaza", Vector3.new(48, 1, 34), Vector3.new(0, -0.1, 18), Color3.fromRGB(70, 168, 124), Enum.Material.SmoothPlastic)
makePart(world, "DepotPlaza", Vector3.new(48, 1, 34), Vector3.new(0, -0.1, -150), Color3.fromRGB(70, 144, 211), Enum.Material.SmoothPlastic)

for _, side in ipairs({-1, 1}) do
    makePart(world, "RouteRail", Vector3.new(1, 2.4, 174), Vector3.new(side * 18.5, 1.1, -64), Color3.fromRGB(91, 112, 140), Enum.Material.Metal)
    makePart(world, "StartRail", Vector3.new(1, 2.4, 32), Vector3.new(side * 24, 1.1, 18), Color3.fromRGB(89, 193, 146), Enum.Material.Metal)
end

for dash = 1, 13 do
    local z = 12 - dash * 12
    local stripe = makePart(world, "RouteStripe", Vector3.new(0.45, 0.08, 5), Vector3.new(0, -0.04, z), Color3.fromRGB(121, 151, 185), Enum.Material.Neon)
    stripe.CanCollide = false
end

-- The pickup kiosk gives the first action a strong landmark.
local kioskBase = makePart(world, "ParcelKioskBase", Vector3.new(11, 2, 10), Vector3.new(-11, 1, 10), Color3.fromRGB(31, 47, 61), Enum.Material.Metal)
local pickup = makePart(world, "ParcelPickup", Vector3.new(5, 4, 5), Vector3.new(-11, 4, 10), Color3.fromRGB(255, 190, 74), Enum.Material.WoodPlanks)
pickup.Shape = Enum.PartType.Block
local pickupLight = Instance.new("PointLight")
pickupLight.Color = Color3.fromRGB(255, 202, 92)
pickupLight.Brightness = 2.2
pickupLight.Range = 16
pickupLight.Parent = pickup
makeBillboard(pickup, "TAKE A PARCEL", Color3.fromRGB(255, 214, 119), 250, 54)
local pickupPrompt = addPrompt(pickup, "Take parcel", "Next delivery")

-- Depot frame, glowing door, and clear finish sign.
local depotColor = Color3.fromRGB(44, 102, 157)
makePart(world, "DepotLeft", Vector3.new(4, 12, 4), Vector3.new(-12, 6, -159), depotColor, Enum.Material.Metal)
makePart(world, "DepotRight", Vector3.new(4, 12, 4), Vector3.new(12, 6, -159), depotColor, Enum.Material.Metal)
makePart(world, "DepotTop", Vector3.new(28, 4, 4), Vector3.new(0, 12, -159), depotColor, Enum.Material.Metal)
local depotGlow = makePart(world, "DepotDoor", Vector3.new(16, 8, 1), Vector3.new(0, 4, -156), Color3.fromRGB(74, 205, 255), Enum.Material.Neon)
depotGlow.Transparency = 0.24
depotGlow.CanCollide = false
makeBillboard(depotGlow, "DELIVERY DEPOT", Color3.fromRGB(155, 231, 255), 300, 62)
local depotPrompt = addPrompt(depotGlow, "Deliver parcel", "Finish the route")

local spawn = Instance.new("SpawnLocation")
spawn.Name = "ParcelShiftSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(7, 0.8, 22)
spawn.Anchored = true
spawn.Neutral = true
spawn.Color = Color3.fromRGB(120, 255, 185)
spawn.Material = Enum.Material.Neon
spawn.Parent = world

-- Gate frames and server-side touch volumes are separate so the visual arch never blocks the courier.
local gates = {}
for index, spec in ipairs(Config.Gates) do
    local z = 4 - index * Config.RouteSpacing
    local left = makePart(world, "GatePost", Vector3.new(1.3, 13, 1.3), Vector3.new(-15.5, 6.5, z), spec.Color, Enum.Material.Neon)
    local right = makePart(world, "GatePost", Vector3.new(1.3, 13, 1.3), Vector3.new(15.5, 6.5, z), spec.Color, Enum.Material.Neon)
    local top = makePart(world, "GateHeader", Vector3.new(32.3, 1.3, 1.3), Vector3.new(0, 12.5, z), spec.Color, Enum.Material.Neon)
    left.CanCollide = false
    right.CanCollide = false
    top.CanCollide = false
    local sign = makePart(world, "GateSign", Vector3.new(10, 2.3, 0.8), Vector3.new(0, 15, z), Color3.fromRGB(24, 32, 47), Enum.Material.SmoothPlastic)
    sign.CanCollide = false
    local signLabel = makeBillboard(sign, "SHIFT " .. index .. "  •  " .. spec.Name, spec.Color, 350, 62)
    signLabel.TextWrapped = true

    local trigger = makePart(world, "ShiftGate" .. index, Vector3.new(31, 13, 3), Vector3.new(0, 6.5, z), spec.Color, Enum.Material.Neon)
    trigger.Transparency = 1
    trigger.CanCollide = false
    trigger.CanTouch = true
    trigger:SetAttribute("GateIndex", index)
    gates[index] = trigger

    for _, side in ipairs({-1, 1}) do
        local lamp = makePart(world, "GateLamp", Vector3.new(1, 0.65, 1), Vector3.new(side * 15.5, 13.8, z), spec.Color, Enum.Material.Neon)
        lamp.CanCollide = false
        local light = Instance.new("PointLight")
        light.Color = spec.Color
        light.Brightness = 1.2
        light.Range = 12
        light.Parent = lamp
    end
end

-- Alternating lane walls make runners read the route and weave instead of holding forward.
-- The open lane is wide enough for touch players and can be jumped by boosted mutations.
local routeWalls = {
    { Z = -59, OpenSide = 1, Color = Color3.fromRGB(255, 142, 93) },
    { Z = -101, OpenSide = -1, Color = Color3.fromRGB(255, 204, 91) },
}
for index, spec in ipairs(routeWalls) do
    local blockedSideCenter = spec.OpenSide == 1 and -5.25 or 5.25
    local barrier = makePart(world, "RouteBarrier", Vector3.new(25, 7, 2.5), Vector3.new(blockedSideCenter, 3.4, spec.Z), Color3.fromRGB(53, 64, 82), Enum.Material.Metal)
    local topEdge = makePart(world, "BarrierGlow", Vector3.new(25, 0.35, 2.7), Vector3.new(blockedSideCenter, 7.1, spec.Z), spec.Color, Enum.Material.Neon)
    topEdge.CanCollide = false
    local openingX = spec.OpenSide * 13
    local marker = makePart(world, "OpenLaneMarker", Vector3.new(0.3, 0.3, 0.3), Vector3.new(openingX, 4.5, spec.Z + 5), spec.Color, Enum.Material.Neon)
    marker.Transparency = 1
    marker.CanCollide = false
    makeBillboard(marker, "OPEN LANE  " .. (spec.OpenSide == 1 and "→" or "←"), spec.Color, 220, 48)
    local warning = makePart(world, "BarrierWarning", Vector3.new(12, 0.3, 1), Vector3.new(0, 0.02, spec.Z + 5), spec.Color, Enum.Material.Neon)
    warning.CanCollide = false
end
-- Decorative route markers make direction obvious from third person.
for marker = 1, 8 do
    local z = -8 - marker * 19
    for _, side in ipairs({-1, 1}) do
        local post = makePart(world, "RouteBeacon", Vector3.new(0.5, 4, 0.5), Vector3.new(side * 15.5, 2, z), Color3.fromRGB(103, 192, 255), Enum.Material.Neon)
        post.CanCollide = false

    end
end

local function getCharacterRoot(player)
    local character = player.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not root then return nil end
    return character, humanoid, root
end

local function getStats(player)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then return nil end
    return stats:FindFirstChild("Deliveries"), stats:FindFirstChild("RouteScore"), stats:FindFirstChild("BestCombo")
end

local function sendStatus(player, kind, extra)
    local record = playerRecords[player]
    local job = jobs[player]
    local deliveries, score, bestCombo = getStats(player)
    local payload = {
        kind = kind,
        shiftActive = shiftActive,
        shiftSeconds = shiftActive and math.max(0, math.ceil(shiftEndsAt - os.clock())) or 0,
        jobState = job and "Carrying" or "Idle",
        gateCount = job and job.gateCount or 0,
        gates = job and { job.gates[1] == true, job.gates[2] == true, job.gates[3] == true } or { false, false, false },
        uniqueMutationCount = record and record.mutationCount or 0,
        journal = record and record.seen or {},
        deliveries = deliveries and deliveries.Value or 0,
        routeScore = score and score.Value or 0,
        combo = record and record.combo or 0,
        bestCombo = bestCombo and bestCombo.Value or 0,
    }
    if extra then
        for key, value in pairs(extra) do payload[key] = value end
    end
    event:FireClient(player, payload)
end

local function resetMovement(job)
    local humanoid = job and job.humanoid
    if humanoid and humanoid.Parent and humanoid.Health > 0 then
        humanoid.WalkSpeed = job.baseWalkSpeed
        humanoid.UseJumpPower = true
        humanoid.JumpPower = job.baseJumpPower
    end
end

local function clearJob(player, reason)
    local job = jobs[player]
    if not job then return end
    resetMovement(job)
    if job.parcel and job.parcel.Parent then job.parcel:Destroy() end
    jobs[player] = nil
    if reason then sendStatus(player, "JobEnded", { message = reason }) end
end

local function applyMutation(player, index)
    local job = jobs[player]
    if not job or not shiftActive or job.gates[index] then return end
    local character, humanoid, root = getCharacterRoot(player)
    if not character or character ~= player.Character then return end
    local gate = gates[index]
    if (root.Position - gate.Position).Magnitude > 25 then return end

    job.gates[index] = true
    job.gateCount += 1
    local mutationIndex = ((index + shiftNumber + job.serial - 3) % #Config.Mutations) + 1
    local mutation = Config.Mutations[mutationIndex]
    job.mutations[mutation.Id] = true
    local record = playerRecords[player]
    if record and not record.seen[mutation.Id] then
        record.seen[mutation.Id] = true
        record.mutationCount += 1
    end

    if job.parcel and job.parcel.Parent then
        job.parcel.Size = mutation.Size
        job.parcel.Color = mutation.Color
        job.parcel:SetAttribute("Mutation", mutation.Id)
        job.parcel:SetAttribute("MutationLabel", mutation.Label)
        local parcelFace = job.parcel:FindFirstChild("ParcelFace", true)
        if parcelFace then parcelFace.Text = mutation.Label end
        local highlight = job.parcel:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight.FillColor = mutation.Color
            highlight.OutlineColor = Color3.new(1, 1, 1)
        end
    end

    humanoid.WalkSpeed = job.baseWalkSpeed * mutation.SpeedMultiplier
    humanoid.UseJumpPower = true
    humanoid.JumpPower = job.baseJumpPower * mutation.JumpMultiplier
    if mutation.Id == "Bouncy" then
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 28, root.AssemblyLinearVelocity.Z)
    elseif mutation.Id == "Floaty" then
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 19, root.AssemblyLinearVelocity.Z)
    end

    sendStatus(player, "Mutation", {
        lastMutation = mutation.Label,
        mutationDescription = mutation.Description,
        gateCount = job.gateCount,
        message = "PARCEL SHIFT: " .. mutation.Label,
    })
end

for index, gate in ipairs(gates) do
    gate.Touched:Connect(function(hit)
        local character = hit:FindFirstAncestorOfClass("Model")
        local player = character and Players:GetPlayerFromCharacter(character)
        if player then applyMutation(player, index) end
    end)
end

local function createParcel(owner, root, humanoid)
    local parcel = Instance.new("Part")
    parcel.Name = "CarriedParcel"
    parcel.Size = Vector3.new(3, 3, 3)
    parcel.Color = Color3.fromRGB(255, 190, 74)
    parcel.Material = Enum.Material.WoodPlanks
    parcel.CanCollide = false
    parcel.Massless = true
    parcel.Anchored = false
    parcel.CFrame = root.CFrame * CFrame.new(0, 1.4, -3)
    parcel:SetAttribute("OwnerUserId", owner.UserId)
    parcel.Parent = world

    local face = Instance.new("SurfaceGui")
    face.Name = "ParcelFaceGui"
    face.Face = Enum.NormalId.Front
    face.AlwaysOnTop = true
    face.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    face.PixelsPerStud = 45
    face.Parent = parcel
    local faceLabel = Instance.new("TextLabel")
    faceLabel.Name = "ParcelFace"
    faceLabel.Size = UDim2.fromScale(1, 1)
    faceLabel.BackgroundColor3 = Color3.fromRGB(38, 48, 61)
    faceLabel.BackgroundTransparency = 0.18
    faceLabel.Text = "UNSTABLE"
    faceLabel.TextColor3 = Color3.new(1, 1, 1)
    faceLabel.TextScaled = true
    faceLabel.Font = Enum.Font.GothamBlack
    faceLabel.Parent = face

    local highlight = Instance.new("Highlight")
    highlight.FillColor = parcel.Color
    highlight.FillTransparency = 0.72
    highlight.OutlineColor = Color3.fromRGB(255, 242, 205)
    highlight.OutlineTransparency = 0.05
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = parcel

    local assistPrompt = addPrompt(parcel, "Stabilize teammate", "Unstable parcel", 9)
    assistPrompt.Triggered:Connect(function(helper)
        local job = jobs[owner]
        if not job or not shiftActive then return end
        if helper == owner then
            sendStatus(helper, "Hint", { message = "Keep moving — a teammate can stabilize your parcel." })
            return
        end
        if jobs[helper] then
            sendStatus(helper, "Hint", { message = "Finish your delivery before helping a teammate." })
            return
        end
        local _, _, helperRoot = getCharacterRoot(helper)
        if not helperRoot or (helperRoot.Position - parcel.Position).Magnitude > 11 then return end
        local now = os.clock()
        local nextAssistAt = job.assistCooldowns[helper.UserId] or 0
        if now < nextAssistAt then
            sendStatus(helper, "Hint", { message = "Give your teammate a moment before stabilizing again." })
            return
        end
        job.assistCooldowns[helper.UserId] = now + Config.AssistCooldown
        job.assists += 1
        sendStatus(owner, "Assist", { message = helper.DisplayName .. " stabilized your parcel!", assistCount = job.assists })
        sendStatus(helper, "Assist", { message = "Parcel stabilized! Keep running with your teammate." })
    end)

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = parcel
    weld.Part1 = root
    weld.Parent = parcel

    return parcel
end

pickupPrompt.Triggered:Connect(function(player)
    if not shiftActive or jobs[player] then return end
    local character, humanoid, root = getCharacterRoot(player)
    if not character or (root.Position - pickup.Position).Magnitude > Config.PromptDistance + 5 then return end

    serial += 1
    local parcel = createParcel(player, root, humanoid)
    jobs[player] = {
        parcel = parcel,
        gates = {},
        gateCount = 0,
        mutations = {},
        assists = 0,
        assistCooldowns = {},
        startedAt = os.clock(),
        serial = serial,
        humanoid = humanoid,
        baseWalkSpeed = humanoid.WalkSpeed,
        baseJumpPower = humanoid.JumpPower,
    }
    sendStatus(player, "JobStarted", { message = "Carry it through all three shift gates!" })
end)

local function gradeJob(job, elapsed)
    if job.gateCount == Config.GateCount and elapsed <= 65 then return "A" end
    if job.gateCount == Config.GateCount or job.gateCount >= 2 then return "B" end
    return "C"
end

depotPrompt.Triggered:Connect(function(player)
    local job = jobs[player]
    if not shiftActive or not job then return end
    local _, _, root = getCharacterRoot(player)
    if not root or (root.Position - depotGlow.Position).Magnitude > Config.PromptDistance + 8 then return end
    if not job.parcel or not job.parcel.Parent then
        clearJob(player, "Parcel missing. Pick up another one!")
        return
    end

    local deliveries, score, bestCombo = getStats(player)
    local record = playerRecords[player]
    if not deliveries or not score or not record then return end

    local elapsed = os.clock() - job.startedAt
    local grade = gradeJob(job, elapsed)
    local isCombo = record.lastDeliveryAt and (os.clock() - record.lastDeliveryAt) <= Config.ComboWindow
    record.combo = isCombo and (record.combo + 1) or 1
    record.lastDeliveryAt = os.clock()
    local comboBonus = math.min(math.max(record.combo - 1, 0) * 2, Config.MaxComboBonus)
    local gradeBonus = Config.GradeRewards[grade] or 0
    local assistBonus = math.min(job.assists, 3) * Config.AssistScore
    local completeRouteBonus = job.gateCount == Config.GateCount and 5 or 0
    local points = Config.BaseDeliveryScore + gradeBonus + assistBonus + comboBonus + completeRouteBonus

    deliveries.Value += 1
    score.Value += points
    if bestCombo then bestCombo.Value = math.max(bestCombo.Value, record.combo) end

    local mutationList = {}
    for mutationId in pairs(job.mutations) do table.insert(mutationList, mutationId) end
    table.sort(mutationList)

    local message = string.format("DELIVERED  •  GRADE %s  •  +%d ROUTE POINTS", grade, points)
    clearJob(player)
    sendStatus(player, "Delivered", {
        message = message,
        grade = grade,
        points = points,
        elapsed = math.floor(elapsed),
        mutationList = mutationList,
        assistCount = job.assists,
        combo = record.combo,
    })
end)

local function setupPlayer(player)
    if playerRecords[player] then return end

    local stats = Instance.new("Folder")
    stats.Name = "leaderstats"
    stats.Parent = player
    local deliveries = Instance.new("IntValue")
    deliveries.Name = "Deliveries"
    deliveries.Parent = stats
    local score = Instance.new("IntValue")
    score.Name = "RouteScore"
    score.Parent = stats
    local combo = Instance.new("IntValue")
    combo.Name = "BestCombo"
    combo.Parent = stats

    playerRecords[player] = { seen = {}, mutationCount = 0, combo = 0, lastDeliveryAt = nil }
    player.CharacterRemoving:Connect(function()
        clearJob(player, "Run ended. Grab a fresh parcel!")
    end)
    task.defer(function()
        if player.Parent then sendStatus(player, "Snapshot") end
    end)
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerRemoving:Connect(function(player)
    clearJob(player)
    jobs[player] = nil
    playerRecords[player] = nil
end)

while true do
    shiftNumber += 1
    shiftActive = true
    shiftEndsAt = os.clock() + Config.ShiftDuration
    for _, player in ipairs(Players:GetPlayers()) do
        sendStatus(player, "ShiftStarted", { message = "New shift! Take a parcel and run the route." })
    end

    while os.clock() < shiftEndsAt do
        task.wait(1)
        for _, player in ipairs(Players:GetPlayers()) do
            local record = playerRecords[player]
            if record and record.lastDeliveryAt and (os.clock() - record.lastDeliveryAt) > Config.ComboWindow then
                record.combo = 0
            end
            sendStatus(player, "Tick")
        end
    end

    shiftActive = false
    for _, player in ipairs(Players:GetPlayers()) do
        clearJob(player, "Shift over. Your stamp book is safe; next shift soon.")
        sendStatus(player, "Break", { message = "Shift break — stretch, then run it back." })
    end

    for remaining = Config.BreakDuration, 1, -1 do
        for _, player in ipairs(Players:GetPlayers()) do
            sendStatus(player, "BreakTick", { breakSeconds = remaining })
        end
        task.wait(1)
    end
end






