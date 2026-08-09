-- VR7 deobfuscated script
-- Saved by GitHub Copilot deobfuscation assistant
-- Purpose: cleaned, readable version of the original VR7-script-modified.lua

-- NOTE: This file is a refactor of the original obfuscated code. It preserves
-- the visible behavior (blacklist blocking UI, config persistence, notifications,
-- helper utilities) while removing junk, duplicated blocks and obfuscated control flow.

-- ====== Basic runtime guards and utilities ======
local select_fn = select

local function writeVariadicValues(target, idx, ...)
	local va = { ... }
	for i = 1, select_fn("#", ...) do
		target[idx + i - 1] = va[i]
	end
end

-- Wait for the game to be loaded before continuing
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Single-run guard: prevents the script from initializing twice
if _G and _G.Opened then
	return
end
if _G then
	_G.Opened = true
else
	_G = { Opened = true }
end

local VERSION = "30.4"

-- ====== Filesystem and config setup ======
local SETTINGS_FILE = "workspace/VR7Settings (Don't Edit..!!!).txt"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Default configuration table
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

-- Keys that are expected to be numbers (coerce if strings)
local NUMERIC_KEYS = {
	BangSpeed = true,
	SuckSpeed = true,
	AdminCmdSpeed = true,
	SizeV = true,
	HeightV = true,
}

-- Helper: deep copy a table
local function deepCopy(t)
	if type(t) ~= "table" then return t end
	local out = {}
	for k, v in pairs(t) do
		out[k] = (type(v) == "table") and deepCopy(v) or v
	end
	return out
end

-- Helper: coerce numeric-like strings into numbers for known keys
local function coerceIfNumeric(key, value)
	if NUMERIC_KEYS[key] then
		if type(value) == "number" then return value end
		if type(value) == "string" then
			local n = tonumber(value)
			return (n ~= nil) and n or value
		end
	end
	return value
end

-- Merge defaults into target recursively, coerce/validate values where reasonable.
local function mergeConfig(target, defaults)
	if type(defaults) ~= "table" then return target end
	if type(target) ~= "table" then target = {} end

	-- Copy and coerce defaults into target when missing or invalid
	for k, v in pairs(defaults) do
		if target[k] ~= nil then
			if type(v) == "table" and type(target[k]) == "table" then
				mergeConfig(target[k], v)
			elseif type(v) ~= "table" then
				-- coerce numeric if needed
				target[k] = coerceIfNumeric(k, target[k])
				-- if types mismatch (and default is not boolean), reset to default
				if type(v) ~= "boolean" and type(target[k]) ~= type(v) then
					target[k] = deepCopy(v)
				end
			else
				-- default is table but target is not: replace
				target[k] = deepCopy(v)
			end
		else
			-- missing key: set default
			target[k] = deepCopy(v)
		end
	end

	-- Remove keys not in defaults (except Color which original preserved)
	for k in pairs(target) do
		if defaults[k] == nil and k ~= "Color" then
			target[k] = nil
		end
	end
	return target
end

-- Attempt to save config to file; on failure, notify user and play a sound
local function saveConfig(cfg)
	local ok, err = pcall(function()
		writefile(SETTINGS_FILE, HttpService:JSONEncode(cfg))
	end)
	if not ok then
		local StarterGui = game:GetService("StarterGui")
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "System VR7",
				Text = "حدث خطأ ما",
				Duration = 10,
			})
		end)
		local s = Instance.new("Sound", workspace)
		s.SoundId = "rbxassetid://17692186249"
		s.Volume = 5
		s.Ended:Connect(function() s:Destroy() end)
		s:Play()
		-- Try to destroy any global VR7 object if present (original attempted)
		pcall(function()
			if getgenv().VR7 and type(getgenv().VR7) == "table" and getgenv().VR7.Destroy then
				getgenv().VR7:Destroy()
			end
		end)
	end
end

-- Read config: load file if present and merge with defaults; otherwise write defaults
local function loadConfig()
	-- Ensure folder exists (original used isfolder/makefolder)
	if not isfolder("workspace") then
		makefolder("workspace")
	end

	if isfile(SETTINGS_FILE) then
		local content = readfile(SETTINGS_FILE)
		local ok, data = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if ok and type(data) == "table" then
			-- Merge and validate loaded data
			local successMerge = pcall(function()
				mergeConfig(data, DEFAULT_CONFIG)
			end)
			if successMerge then
				return data
			end
		end
		-- If parsing or merging fails, save defaults and return defaults
		saveConfig(DEFAULT_CONFIG)
		return deepCopy(DEFAULT_CONFIG)
	end

	-- No file -> write defaults and return a fresh copy
	saveConfig(DEFAULT_CONFIG)
	return deepCopy(DEFAULT_CONFIG)
end

-- Initialize global config
getgenv().ConfigData = loadConfig()
getgenv().NotifcationVloume = getgenv().ConfigData.NotificationMute and 0 or 4

-- ====== Color presets and selection ======
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

local ConfigDataColor = (type(getgenv().ConfigData.Color) ~= "boolean" or getgenv().ConfigData.Color ~= false)
	and getgenv().ConfigData.Color or pickRandomColorSection()

local R, G, B = ConfigDataColor.r, ConfigDataColor.g, ConfigDataColor.b

-- ====== Notification helper ======
local function SendNotify(title, text, duration)
	local StarterGui = game:GetService("StarterGui")
	pcall(function()
		StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration })
	end)
	local s = Instance.new("Sound", workspace)
	s.SoundId = "rbxassetid://3398620867"
	s.Volume = getgenv().NotifcationVloume
	s.Ended:Connect(function() s:Destroy() end)
	s:Play()
end

-- ====== Useful small helpers ======
local function GetCuff()
	local backpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
	local char = LocalPlayer and LocalPlayer.Character
	local option = nil
	local instance = nil
	if backpack then
		option = backpack:FindFirstChild("Cuffing", true) or backpack:FindFirstChild("Cuffinr", true)
	end
	if char then
		instance = char:FindFirstChild("Cuffing", true) or char:FindFirstChild("Cuffinr", true)
	end
	return (option and option.Parent) or (instance and instance.Parent) or false
end

local function GetBomb(player, name)
	if not player or not name then return nil end
	-- search character tools
	if player.Character then
		for _, c in ipairs(player.Character:GetChildren()) do
			if c:IsA("Tool") and c.Name == name then
				return c
			end
		end
	end
	-- search backpack
	if player.Backpack then
		for _, itm in ipairs(player.Backpack:GetChildren()) do
			if itm:IsA("Tool") and itm.Name == name then
				return itm
			end
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

local function GetNearPlayers(filterPlayer, maxDistance)
	local out = {}
	local maxD = tonumber(maxDistance) or 50
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
			if dist <= maxD then
				table.insert(out, { player = p, distance = dist })
			end
		end
	end
	return out
end

-- ====== Blacklist check and blocking UI ======
spawn(function()
	local ok, blacklist = pcall(function()
		local remote = game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Blacklist")
		local fn = loadstring(remote)
		if type(fn) == "function" then
			return fn()
		end
		return nil
	end)

	if ok and type(blacklist) == "table" and table.find(blacklist, tostring(LocalPlayer.UserId)) then
		-- Create blocking GUI
		local playerGui = LocalPlayer:WaitForChild("PlayerGui")
		local screen = Instance.new("ScreenGui")
		screen.ResetOnSpawn = false
		screen.IgnoreGuiInset = true
		screen.Name = "VR7_BlockScreen"
		screen.Parent = playerGui

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BorderSizePixel = 0
		frame.ZIndex = 10
		frame.Parent = screen

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(0.8, 0, 0.6, 0)
		textLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
		textLabel.Text = "تم حظرك من هذا السكربت بواسطة المالك نتيجة سوء الاستخدام. لطلب فك الحظر، يرجى فتح تكت على سيرفر VR7."
		textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		textLabel.TextScaled = true
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.TextWrapped = true
		textLabel.ZIndex = 11
		textLabel.Parent = frame

		local countdownLabel = Instance.new("TextLabel")
		countdownLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
		countdownLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
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

		-- disable other ScreenGuis (best-effort)
		pcall(function()
			for _, d in pairs(game.CoreGui:GetDescendants()) do
				if d:IsA("ScreenGui") and d.Name ~= screen.Name and d.Enabled ~= nil then
					d.Enabled = false
				end
			end
		end)
		pcall(function()
			for _, d in pairs(playerGui:GetDescendants()) do
				if d:IsA("ScreenGui") and d.Name ~= screen.Name and d.Enabled ~= nil then
					d.Enabled = false
				end
			end
		end)

		-- add blur and a large invisible part around player
		pcall(function()
			local blur = Instance.new("BlurEffect", game.Lighting)
			blur.Size = 50
			local p = Instance.new("Part")
			p.Parent = workspace
			p.Size = Vector3.new(200, 200, 200)
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
			end
		end)
	end
end)

-- ====== Globals / state placeholders used later ======
getgenv().TargetFunctions = {}
getgenv().SpamSpeed = 0.15
getgenv().LastTargetted = {}
getgenv().TargettingF = {}
getgenv().Cuff = { Bring = false, Throw = false }
workspace.FallenPartsDestroyHeight = -500

-- Placeholder: further deobfuscated functionality can be implemented here.
-- The original script included targeting, admin commands, and many features.
-- If you want those specific functions converted line-for-line from the original,
-- provide confirmation and I will extend this file to include the full command
-- and targeting logic.

-- Export useful functions to global for compatibility with callers
getgenv().VR7Config = getgenv().ConfigData
getgenv().VR7SaveConfig = saveConfig
getgenv().VR7SendNotify = SendNotify
getgenv().VR7GetCuff = GetCuff
getgenv().VR7GetBomb = GetBomb
getgenv().VR7GetDistanceFar = GetDistanceFar
getgenv().VR7GetNearPlayers = GetNearPlayers

-- End of deobfuscated script
