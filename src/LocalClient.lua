-- RhythmOS Platform | Main Client Entry Point
-- This initializes the entire operating system

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Load all core modules first
local Modules = script.Parent:WaitForChild("Modules")
local CoreModules = Modules:WaitForChild("Core")
local UIModules = Modules:WaitForChild("UI")
local AppModules = Modules:WaitForChild("Apps")
local ServiceModules = Modules:WaitForChild("Services")
local Utils = Modules:WaitForChild("Utils")

-- ===== CORE MANAGERS =====
local ThemeManager = require(CoreModules:WaitForChild("ThemeManager"))
local WindowManager = require(CoreModules:WaitForChild("WindowManager"))
local EventBus = require(CoreModules:WaitForChild("EventBus"))
local AppManager = require(CoreModules:WaitForChild("AppManager"))
local DataStore = require(CoreModules:WaitForChild("DataStore"))
local Settings = require(CoreModules:WaitForChild("Settings"))

-- ===== UI SHELL =====
local Desktop = require(UIModules:WaitForChild("Shell"):WaitForChild("Desktop"))
local Taskbar = require(UIModules:WaitForChild("Shell"):WaitForChild("Taskbar"))
local Dock = require(UIModules:WaitForChild("Shell"):WaitForChild("Dock"))
local TopMenu = require(UIModules:WaitForChild("Shell"):WaitForChild("TopMenu"))

-- ===== SERVICES =====
local AudioService = require(ServiceModules:WaitForChild("AudioService"))
local AnimationService = require(ServiceModules:WaitForChild("AnimationService"))
local InputService = require(ServiceModules:WaitForChild("InputService"))
local ScoreService = require(ServiceModules:WaitForChild("ScoreService"))
local AnalyticsService = require(ServiceModules:WaitForChild("AnalyticsService"))
local NotificationService = require(ServiceModules:WaitForChild("NotificationService"))

-- ===== APPS =====
local HomeApp = require(AppModules:WaitForChild("Home"))
local SongBrowserApp = require(AppModules:WaitForChild("SongBrowser"))
local ProfileApp = require(AppModules:WaitForChild("Profile"))
local LeaderboardApp = require(AppModules:WaitForChild("Leaderboard"))
local SettingsApp = require(AppModules:WaitForChild("Settings"))

-- ===== MAIN SYSTEM =====
local RhythmOS = {
	version = "1.0.0",
	isInitialized = false,
	screenGui = nil,
}

print("[RhythmOS] Initializing system...")

-- ===== CREATE SCREEN GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RhythmOS"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

RhythmOS.screenGui = screenGui

-- ===== INITIALIZE MANAGERS =====
print("[RhythmOS] Loading theme system...")
ThemeManager:Initialize()
ThemeManager:SetTheme("DefaultDark")
ThemeManager:ApplyToGui(screenGui)

print("[RhythmOS] Loading user settings...")
Settings:Load()

print("[RhythmOS] Loading persistent data...")
DataStore:Initialize(player)

print("[RhythmOS] Initializing window manager...")
WindowManager:Initialize(screenGui)

print("[RhythmOS] Initializing app manager...")
AppManager:Initialize(WindowManager, EventBus)

print("[RhythmOS] Initializing services...")
AudioService:Initialize()
AnimationService:Initialize()
InputService:Initialize()
ScoreService:Initialize()
AnalyticsService:Initialize()
NotificationService:Initialize(screenGui)

-- ===== BUILD DESKTOP SHELL =====
print("[RhythmOS] Building desktop shell...")

-- Create desktop background
local desktopBg = Instance.new("Frame")
desktopBg.Name = "DesktopBackground"
desktopBg.Size = UDim2.new(1, 0, 1, 0)
desktopBg.BackgroundColor3 = ThemeManager:GetColor("Background")
desktopBg.BorderSizePixel = 0
desktopBg.ZIndex = 1
desktopBg.Parent = screenGui

-- Create shell elements
local topMenu = TopMenu:Create(screenGui)
local dock = Dock:Create(screenGui, AppManager)
local taskbar = Taskbar:Create(screenGui, AppManager)

-- ===== REGISTER APPS =====
print("[RhythmOS] Registering applications...")

AppManager:RegisterApp("Home", HomeApp)
AppManager:RegisterApp("SongBrowser", SongBrowserApp)
AppManager:RegisterApp("Profile", ProfileApp)
AppManager:RegisterApp("Leaderboard", LeaderboardApp)
AppManager:RegisterApp("Settings", SettingsApp)

-- ===== SETUP EVENT HANDLERS =====
print("[RhythmOS] Setting up event handlers...")

EventBus:On("AppOpened", function(appName)
	NotificationService:ShowToast("Opened " .. appName, "info", 2)
end)

EventBus:On("ScoreSubmitted", function(data)
	print("Score recorded: " .. data.score)
	DataStore:AddScore(data)
	EventBus:Emit("LeaderboardUpdated")
end)

EventBus:On("ThemeChanged", function(themeName)
	Settings:SetSetting("theme", themeName)
	DataStore:Save()
end)

-- ===== SETUP HOTKEYS =====
print("[RhythmOS] Setting up global hotkeys...")

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Global hotkeys (Ctrl+Key)
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
		if input.KeyCode == Enum.KeyCode.H then
			AppManager:OpenApp("Home")
		elseif input.KeyCode == Enum.KeyCode.S then
			AppManager:OpenApp("SongBrowser")
		elseif input.KeyCode == Enum.KeyCode.P then
			AppManager:OpenApp("Profile")
		elseif input.KeyCode == Enum.KeyCode.L then
			AppManager:OpenApp("Leaderboard")
		else
			-- Ctrl+Tab to cycle apps
			if input.KeyCode == Enum.KeyCode.Tab then
				AppManager:CycleApps()
			end
		end
	end
end)

-- ===== STARTUP SEQUENCE =====
print("[RhythmOS] System ready!")
print("[RhythmOS] Opening home application...")

AppManager:OpenApp("Home")

print("[RhythmOS] ✓ Platform loaded successfully")
print("[RhythmOS] Use Ctrl+H to go home, Ctrl+S for songs, Ctrl+P for profile")

RhythmOS.isInitialized = true

-- ===== RUNTIME LOOP =====
RunService.RenderStepped:Connect(function(deltaTime)
	if not RhythmOS.isInitialized then return end
	
	-- Update services each frame
	AnimationService:Update(deltaTime)
	AudioService:Update(deltaTime)
end)

return RhythmOS
