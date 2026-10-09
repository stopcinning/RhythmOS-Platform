# RhythmOS Platform - Architecture Document

## System Overview

RhythmOS Platform is built on a **modular app-based architecture** similar to modern operating systems (Windows, macOS, iOS).

### Core Principles

1. **Apps are isolated** - Each app runs independently
2. **Communication via EventBus** - Apps talk through events, not direct references
3. **Centralized theme system** - All UI respects the active theme
4. **Window management** - Windows are created, destroyed, resized, dragged by WindowManager
5. **Data persistence** - All player data stored and synced via DataStore

## Layer Architecture

```
┌─────────────────────────────────────────────────┐
│           APPS LAYER                            │
│  (Home, SongBrowser, Gameplay, Profile, etc.)   │
├─────────────────────────────────────────────────┤
│           UI LAYER                              │
│  (Components, Windows, Dialogs, Shell)          │
├─────────────────────────────────────────────────┤
│           SERVICES LAYER                        │
│  (Audio, Input, Scoring, Network, Analytics)   │
├─────────────────────────────────────────────────┤
│           CORE LAYER                            │
│  (AppManager, WindowManager, Theme, DataStore)  │
├─────────────────────────────────────────────────┤
│           UTILS LAYER                           │
│  (Math, Color, Tween, Table utilities)          │
└─────────────────────────────────────────────────┘
```

## Core Modules

### AppManager
**Responsibility:** Lifecycle management of applications

```lua
AppManager:RegisterApp("SongBrowser", SongBrowserModule)
AppManager:OpenApp("SongBrowser", { params })
AppManager:CloseApp("SongBrowser")
AppManager:GetActiveApp()
```

**Why:** Centralized control over which apps are running, prevents duplicates, manages app state

### WindowManager
**Responsibility:** Create, manage, resize, drag windows

```lua
local window = WindowManager:CreateWindow({
    title = "Song Browser",
    width = 800,
    height = 600,
    resizable = true,
    draggable = true,
})
```

**Why:** Every app is a window. Windows must be draggable, resizable, minimizable. Centralized logic prevents code duplication.

### ThemeManager
**Responsibility:** Store and apply themes globally

```lua
ThemeManager:SetTheme("DefaultDark")
local color = ThemeManager:GetColor("Accent")
ThemeManager:ApplyToObject(frame, "Panel")
```

**Why:** Consistent styling across all apps. Switching themes updates everything instantly.

### EventBus
**Responsibility:** Inter-app communication

```lua
EventBus:Emit("ScoreSubmitted", { score = 1000, accuracy = 98.5 })
EventBus:On("ScoreSubmitted", function(data)
    -- Update leaderboard
end)
```

**Why:** Apps don't know about each other. Communication is decoupled and maintainable.

### DataStore
**Responsibility:** Persist player data

```lua
DataStore:Set("playerStats", { score = 1000, rank = 5 })
local stats = DataStore:Get("playerStats")
```

**Why:** Player data survives between sessions. Single source of truth for player information.

## UI Components

### Reusable Components

Every UI element is a reusable component to maintain consistency:

#### Button
```lua
local button = Button:Create({
    text = "Play",
    size = UDim2.new(0, 120, 0, 40),
    onClick = function() print("clicked") end,
    theme = "primary",  -- primary, secondary, danger, success
})
```

#### Card
```lua
local card = Card:Create({
    title = "Recent Score",
    content = { /* child elements */ },
    width = 300,
    height = 200,
})
```

#### Panel
```lua
local panel = Panel:Create({
    title = "Settings",
    content = { /* elements */ },
    closeable = true,
})
```

**Why:** Consistent look and feel. Easy to maintain. Updates propagate everywhere.

## Services

### ScoreService
**Calculates accuracy and points**

```lua
local accuracy, points = ScoreService:CalculateHit(timeDifference)
```

### AudioService
**Manages music and SFX**

```lua
AudioService:PlaySong(songId, volume)
AudioService:PlaySFX("hit_perfect", volume)
```

### ReplayService
**Records and plays back inputs**

```lua
ReplayService:StartRecording()
ReplayService:RecordInput(lane, time, inputType)  -- "press" or "release"
ReplayService:StopRecording()
ReplayService:Playback(replayData)
```

### AnalyticsService
**Generates heatmaps and graphs**

```lua
local heatmap = AnalyticsService:GenerateHeatmap(scores)
local graph = AnalyticsService:GenerateProgressGraph(playerStats)
```

### CommunityService
**Manages social features**

```lua
CommunityService:FollowPlayer(userId)
CommunityService:PostComment(profileId, comment)
CommunityService:GetActivityFeed()
```

## App Structure

Every app follows this pattern:

```lua
local MyApp = {}

MyApp.title = "My App"
MyApp.icon = "♫"
MyApp.defaultWidth = 800
MyApp.defaultHeight = 600

function MyApp:Initialize()
    -- Called when app is first loaded
    EventBus:On("SomeEvent", function(data)
        self:HandleEvent(data)
    end)
end

function MyApp:Build(container)
    -- Build UI in container
    local button = Button:Create({ text = "Click me" })
    button.Parent = container
end

function MyApp:Destroy()
    -- Clean up when app closes
    EventBus:RemoveAllListeners()
end

return MyApp
```

## Data Flow

```
User Input
    ↓
InputService (handles keyboard/mouse)
    ↓
App (processes input)
    ↓
Service (does calculations)
    ↓
DataStore (persists data)
    ↓
EventBus (notifies other apps)
    ↓
Other Apps (update accordingly)
```

## Theme System

Themes are defined as Lua tables:

```lua
local DefaultDark = {
    Background = Color3.fromRGB(12, 14, 23),
    Panel = Color3.fromRGB(24, 28, 38),
    Primary = Color3.fromRGB(155, 118, 255),
    Text = Color3.fromRGB(245, 247, 255),
    -- ... more colors
}
```

Components use theme colors:

```lua
frame.BackgroundColor3 = ThemeManager:GetColor("Panel")
label.TextColor3 = ThemeManager:GetColor("Text")
```

Switching themes updates everything:

```lua
ThemeManager:SetTheme("LightMode")  -- All UI updates instantly
```

## Performance Considerations

### Object Pooling
- Notes for gameplay are pooled and reused
- UI elements are cached when possible

### Lazy Loading
- Apps only load when opened
- Data only fetches when needed
- Assets stream on demand

### Memory Management
- Apps clean up when closed
- Event listeners are removed
- Connections are disconnected

## Extensibility

### Adding a New App

1. Create `Modules/Apps/MyApp.lua`
2. Follow the app structure
3. Register in `AppManager`
4. Add button to taskbar/dock

### Adding a New Theme

1. Create `Themes/MyTheme.lua`
2. Define all color variables
3. Register in `ThemeManager`
4. Add to theme selector UI

### Adding a New Service

1. Create `Modules/Services/MyService.lua`
2. Initialize in `LocalClient`
3. Expose API functions
4. Use in apps via service reference
