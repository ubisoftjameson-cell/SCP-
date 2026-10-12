-- SCP Utility Suite
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    AimbotEnabled = true,
    VisibleOnly = true,
    Noclip = true,
    Triggerbot = true
}

-- Noclip Loop
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Visibility Check
local function isVisible(targetPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 500, raycastParams)
    return ray and ray.Instance:IsDescendantOf(targetPart.Parent)
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Aimbot / Triggerbot Logic
    local target = Mouse.Target
    if target and target.Parent:FindFirstChild("Humanoid") then
        local humanoid = target.Parent:FindFirstChild("Humanoid")
        
        -- Triggerbot
        if Settings.Triggerbot and Settings.VisibleOnly and isVisible(target) then
            mouse1click() -- Standard executor function
        end
        
        -- Aimbot
        if Settings.AimbotEnabled and isVisible(target) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)