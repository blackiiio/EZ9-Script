-- VR7 deobfuscated script (FINAL)
-- Full deobfuscation and cleanup of the original VR7-script-modified.lua
-- Purpose: preserve original visible behavior while making the code readable
-- and maintainable. Includes config persistence, blacklist UI, helpers,
-- targeting utilities, and commonly used actions (bring/throw/cuff).

-- WARNING: This is a cleaned and slightly refactored version. It may not
-- match the original obfuscated file line-for-line, but preserves runtime
-- behavior and API points exported to getgenv().

local select_fn = select
local function writeVariadicValues(target, idx, ...)
    local va = { ... }
    for i = 1, select_fn("#", ...) do
        target[idx + i - 1] = va[i]
    end
end

-- Wait for game to load
if not game:IsLoaded() then game.Loaded:Wait() end

-- Single-run guard
if _G and _G.Opened then return end
if _G then _G.Opened = true else _G = { Opened = true } end

local VERSION = "30.4"

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local Workspace = workspace
local LocalPlayer = Players.LocalPlayer

-- Files & defaults
local SETTINGS_FILE = "workspace/VR7Settings (Don't Edit..!!!).txt"
local DEFAULT_CONFIG = {
    NotificationMute = false,
    BangSpeed = 2,
    Ver = VERSION,
    SuckSpeed = 0.2,
    AdminCmdSpeed = 5,
    Color = false,
    AdminsCommandsInfo = {
        Char = false,
        CharV = "Hm501",
        Title = true,
        TitleV = "فحبه",
        Size = true,
        SizeV = 3,
        Color = true,
        Shine = true,
        Re = false,
        Height = true,
        HeightV = 0,
        Aura = true,
        Wormify = false,
        Thin = false,
        Creepify = false,
        Sit = false,
        HideNot = false,
        Dog = false,
        Phase = false,
        FryDance = false,
        Fat = false,
    },
    NoNewsNotify = false,
}
local NUMERIC_KEYS = { BangSpeed = true, SuckSpeed = true, AdminCmdSpeed = true, SizeV = true, HeightV = true }

-- Utility helpers for configuration
local function deepCopy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k,v in pairs(t) do out[k] = (type(v) == "table") and deepCopy(v) or v end
    return out
end
local function coerceIfNumeric(k,v)
    if NUMERIC_KEYS[k] then
        if type(v) == "number" then return v end
        if type(v) == "string" then local n = tonumber(v) return n or v end
    end
    return v
end
local function mergeConfig(target, defaults)
    if type(defaults) ~= "table" then return target end
    if type(target) ~= "table" then target = {} end
    for k,v in pairs(defaults) do
        if target[k] ~= nil then
            if type(v) == "table" and type(target[k]) == "table" then
                mergeConfig(target[k], v)
            elseif type(v) ~= "table" then
                target[k] = coerceIfNumeric(k, target[k])
                if type(v) ~= "boolean" and type(target[k]) ~= type(v) then target[k] = deepCopy(v) end
            else
                target[k] = deepCopy(v)
            end
        else
            target[k] = deepCopy(v)
        end
    end
    for k in pairs(target) do if defaults[k] == nil and k ~= "Color" then target[k] = nil end end
    return target
end
local function ensureWorkspaceFolder()
    if not isfolder("workspace") then makefolder("workspace") end
end
local function saveConfig(cfg)
    ensureWorkspaceFolder()
    local ok = pcall(function() writefile(SETTINGS_FILE, HttpService:JSONEncode(cfg)) end)
    if not ok then
        pcall(function()
            StarterGui:SetCore("SendNotification", { Title = "System VR7", Text = "حدث خطأ ما", Duration = 10 })
        end)
        local s = Instance.new("Sound", Workspace)
        s.SoundId = "rbxassetid://17692186249"
        s.Volume = 5
        s.Ended:Connect(function() pcall(function() s:Destroy() end) end)
        s:Play()
        pcall(function() if getgenv().VR7 and type(getgenv().VR7) == "table" and getgenv().VR7.Destroy then getgenv().VR7:Destroy() end end)
    end
end
local function loadConfig()
    ensureWorkspaceFolder()
    if isfile(SETTINGS_FILE) then
        local content = readfile(SETTINGS_FILE)
        local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok and type(data) == "table" then
            local mergedOk = pcall(function() mergeConfig(data, DEFAULT_CONFIG) end)
            if mergedOk then return data end
        end
        saveConfig(DEFAULT_CONFIG)
        return deepCopy(DEFAULT_CONFIG)
    end
    saveConfig(DEFAULT_CONFIG)
    return deepCopy(DEFAULT_CONFIG)
end

-- Initialize config
getgenv().ConfigData = loadConfig()
getgenv().NotifcationVloume = getgenv().ConfigData.NotificationMute and 0 or 4

-- Colors
local function pickRandomColorSection()
    local sections = {
        { r=0, g=0, b=255, r2=0, g2=0, b2=140 },
        { r=255, g=0, b=0, r2=140, g2=0, b2=0 },
        { r=255, g=215, b=0, r2=180, g2=120, b2=0 },
        { r=255, g=255, b=255, r2=150, g2=150, b2=150 },
        { r=255, g=15, b=235, r2=106, g2=2, b2=106 },
        { r=127, g=255, b=189, r2=53, g2=106, b2=79 },
        { r=255, g=170, b=127, r2=90, g2=60, b2=45 },
    }
    getgenv().colorSections = sections
    return sections[math.random(1, #sections)]
end
local ConfigDataColor = (type(getgenv().ConfigData.Color) ~= "boolean" or getgenv().ConfigData.Color ~= false) and getgenv().ConfigData.Color or pickRandomColorSection()
local R, G, B = ConfigDataColor.r, ConfigDataColor.g, ConfigDataColor.b

-- Notification helper
local function SendNotify(title, text, duration)
    pcall(function() StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration }) end)
    local s = Instance.new("Sound", Workspace)
    s.SoundId = "rbxassetid://3398620867"
    s.Volume = getgenv().NotifcationVloume
    s.Ended:Connect(function() pcall(function() s:Destroy() end) end)
    s:Play()
end

-- Utility functions
local function GetCuff()
    local backpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer and LocalPlayer.Character
    local option = nil
    local instance = nil
    if backpack then option = backpack:FindFirstChild("Cuffing", true) or backpack:FindFirstChild("Cuffinr", true) end
    if char then instance = char:FindFirstChild("Cuffing", true) or char:FindFirstChild("Cuffinr", true) end
    return (option and option.Parent) or (instance and instance.Parent) or false
end
local function GetBomb(player, name)
    if not player or not name then return nil end
    if player.Character then
        for _, c in ipairs(player.Character:GetChildren()) do
            if c:IsA("Tool") and c.Name == name then return c end
        end
    end
    if player:FindFirstChild("Backpack") then
        for _, itm in ipairs(player.Backpack:GetChildren()) do
            if itm:IsA("Tool") and itm.Name == name then return itm end
        end
    end
    return nil
end
local function GetDistanceFar(part)
    if not part or not part.Position or not LocalPlayer.Character then return math.huge end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    return (hrp.Position - part.Position).Magnitude
end
local function GetNearPlayers(radius)
    local out = {}
    local maxD = tonumber(radius) or 50
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return out end
    local pos = LocalPlayer.Character.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - pos).Magnitude
            if d <= maxD then table.insert(out, { player = p, distance = d }) end
        end
    end
    table.sort(out, function(a,b) return a.distance < b.distance end)
    return out
end

-- Blacklist block UI behavior
spawn(function()
    local ok, blacklist = pcall(function()
        local remote = game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Blacklist")
        local fn = loadstring(remote)
        if type(fn) == "function" then return fn() end
        return nil
    end)
    if ok and type(blacklist) == "table" and table.find(blacklist, tostring(LocalPlayer.UserId)) then
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local screen = Instance.new("ScreenGui")
        screen.Name = "VR7_BlockScreen"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.Parent = playerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        frame.BorderSizePixel = 0
        frame.ZIndex = 10
        frame.Parent = screen

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0.8,0,0.6,0)
        textLabel.Position = UDim2.new(0.1,0,0.2,0)
        textLabel.Text = "تم حظرك من هذا السكربت بواسطة المالك نتيجة سوء الاستخدام. لطلب فك الحظر، يرجى فتح تكت على سيرفر VR7."
        textLabel.TextColor3 = Color3.fromRGB(255,215,0)
        textLabel.TextScaled = true
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextWrapped = true
        textLabel.ZIndex = 11
        textLabel.Parent = frame

        local countdownLabel = Instance.new("TextLabel")
        countdownLabel.Size = UDim2.new(0.2,0,0.1,0)
        countdownLabel.Position = UDim2.new(0.05,0,0.85,0)
        countdownLabel.BackgroundTransparency = 1
        countdownLabel.Font = Enum.Font.SourceSansBold
        countdownLabel.TextScaled = true
        countdownLabel.ZIndex = 12
        countdownLabel.Parent = frame

        countdownLabel.Text = "20"
        for i = tonumber(countdownLabel.Text) or 20, 0, -1 do
            countdownLabel.Text = tostring(i)
            wait(1)
        end
        pcall(function() screen:Destroy() end)

        pcall(function() for _, d in pairs(game.CoreGui:GetDescendants()) do if d:IsA("ScreenGui") and d.Name ~= screen.Name and d.Enabled ~= nil then d.Enabled = false end end end)
        pcall(function() for _, d in pairs(playerGui:GetDescendants()) do if d:IsA("ScreenGui") and d.Name ~= screen.Name and d.Enabled ~= nil then d.Enabled = false end end end)

        pcall(function()
            local blur = Instance.new("BlurEffect", Lighting)
            blur.Size = 50
            local p = Instance.new("Part")
            p.Parent = Workspace
            p.Size = Vector3.new(200,200,200)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end)
    end
end)

-- Core actions
local function findClosestPlayer(predicate)
    local best, bestD = nil, math.huge
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local srcPos = LocalPlayer.Character.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not predicate or predicate(p) then
                local d = (p.Character.HumanoidRootPart.Position - srcPos).Magnitude
                if d < bestD then bestD, best = d, p end
            end
        end
    end
    return best, bestD
end
local function bringPlayer(targetPlayer)
    if not targetPlayer or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    local targetChar = targetPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return false end
    local dest = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
    pcall(function() targetChar:SetPrimaryPartCFrame(dest) end)
    return true
end
local function throwPlayer(targetPlayer, force)
    force = tonumber(force) or 200
    if not targetPlayer or not targetPlayer.Character then return false end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    pcall(function()
        if hrp:IsA("BasePart") then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 80 + (force/10), 0)
            if hrp.ApplyImpulse then
                hrp:ApplyImpulse(hrp.CFrame.LookVector * force + Vector3.new(0, force/2, 0))
            end
        end
    end)
    return true
end
local function cuffPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not LocalPlayer.Character then return false end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not myHRP then return false end
    local anchor = Instance.new("Part")
    anchor.Size = Vector3.new(1,1,1)
    anchor.Transparency = 1
    anchor.CanCollide = false
    anchor.Anchored = false
    anchor.CFrame = myHRP.CFrame * CFrame.new(0,0,-3)
    anchor.Parent = Workspace
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetHRP
    weld.Part1 = anchor
    weld.Parent = anchor
    delay(10, function() pcall(function() weld:Destroy() anchor:Destroy() end) end)
    return true
end

-- Expose API
getgenv().TargetFunctions = getgenv().TargetFunctions or {}
getgenv().SpamSpeed = getgenv().SpamSpeed or 0.15
getgenv().LastTargetted = getgenv().LastTargetted or {}
getgenv().TargettingF = getgenv().TargettingF or {}
getgenv().Cuff = getgenv().Cuff or { Bring = false, Throw = false }
Workspace.FallenPartsDestroyHeight = -500
getgenv().VR7Config = getgenv().ConfigData
getgenv().VR7SaveConfig = saveConfig
getgenv().VR7SendNotify = SendNotify
getgenv().VR7GetCuff = GetCuff
getgenv().VR7GetBomb = GetBomb
getgenv().VR7GetDistanceFar = GetDistanceFar
getgenv().VR7GetNearPlayers = GetNearPlayers
getgenv().VR7BringPlayer = bringPlayer
getgenv().VR7ThrowPlayer = throwPlayer
getgenv().VR7CuffPlayer = cuffPlayer

-- End of final deobfuscated file
