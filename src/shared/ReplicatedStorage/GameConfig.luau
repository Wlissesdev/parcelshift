local GameConfig = {}

GameConfig.ShiftDuration = 120
GameConfig.BreakDuration = 12
GameConfig.GateCount = 3
GameConfig.PromptDistance = 12
GameConfig.BaseDeliveryScore = 20
GameConfig.AssistScore = 3
GameConfig.AssistCooldown = 8
GameConfig.ComboWindow = 28
GameConfig.MaxComboBonus = 12
GameConfig.RouteSpacing = 42
GameConfig.DepotPosition = Vector3.new(0, 0, -150)
GameConfig.PickupPosition = Vector3.new(-10, 1, 8)

GameConfig.Gates = {
    { Name = "SIZE SHIFT", Hint = "The parcel changes size", Color = Color3.fromRGB(255, 184, 78) },
    { Name = "MOTION SHIFT", Hint = "The parcel changes your movement", Color = Color3.fromRGB(86, 220, 255) },
    { Name = "WILD SHIFT", Hint = "One last surprise", Color = Color3.fromRGB(199, 119, 255) },
}

GameConfig.Mutations = {
    { Id = "Giant", Label = "GIANT", Description = "Big parcel, slower steps", Color = Color3.fromRGB(255, 170, 55), Size = Vector3.new(6.5, 6.5, 6.5), SpeedMultiplier = 0.72, JumpMultiplier = 1 },
    { Id = "Tiny", Label = "TINY", Description = "Tiny parcel, quick steps", Color = Color3.fromRGB(93, 220, 255), Size = Vector3.new(1.25, 1.25, 1.25), SpeedMultiplier = 1.22, JumpMultiplier = 1 },
    { Id = "Bouncy", Label = "BOUNCY", Description = "Bounce into the next section", Color = Color3.fromRGB(255, 95, 145), Size = Vector3.new(3, 3, 3), SpeedMultiplier = 1, JumpMultiplier = 1.45 },
    { Id = "Floaty", Label = "FLOATY", Description = "A light parcel lifts your jump", Color = Color3.fromRGB(176, 130, 255), Size = Vector3.new(3, 3, 3), SpeedMultiplier = 1.06, JumpMultiplier = 1.28 },
}

GameConfig.GradeRewards = { A = 10, B = 5, C = 0 }

return GameConfig
