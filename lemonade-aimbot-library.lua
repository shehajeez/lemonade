local players = game:GetService("Players")
local lp = players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")

getgenv().teamcheck = true
getgenv().wallcheck = true

local function getclosest()
    local closest, dist = nil, math.huge
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().teamcheck and p.Team == lp.Team then
                continue
            end
            local mag = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).magnitude
            if mag < dist then
                if getgenv().wallcheck then
                    local origin = cam.CFrame.Position
                    local direction = (p.Character.HumanoidRootPart.Position - origin).unit * mag
                    local ray = Ray.new(origin, direction)
                    local hit = ws:FindPartOnRay(ray, lp.Character)
                    if hit and hit:IsDescendantOf(p.Character) then
                        dist, closest = mag, p
                    end
                else
                    dist, closest = mag, p
                end
            end
        end
    end
    return closest
end

local function updatecam()
    local closest = getclosest()
    if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
        cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.HumanoidRootPart.Position)
    end
end

rs.RenderStepped:Connect(updatecam)
