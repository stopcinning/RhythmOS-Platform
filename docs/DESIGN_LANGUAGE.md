# RhythmOS Platform - Design Language

## Visual Philosophy

**RhythmOS is not a game interface.**

It's a professional desktop environment that happens to be a rhythm game.

Every pixel is intentional. Every interaction is purposeful. Nothing is generic Roblox UI.

## Color Palette

### DefaultDark Theme (Primary)

**Foundation Colors:**
- **Background:** `RGB(12, 14, 23)` - Deep navy black
- **BackgroundSecondary:** `RGB(19, 22, 32)` - Slightly lighter navy
- **Panel:** `RGB(24, 28, 38)` - Card/panel base
- **PanelSoft:** `RGB(31, 36, 48)` - Panel highlights
- **PanelHard:** `RGB(17, 20, 29)` - Panel shadows

**Accent Colors:**
- **Primary (Lavender):** `RGB(155, 118, 255)` - Main brand color
- **Primary Soft:** `RGB(190, 167, 255)` - Lighter variant
- **Mint:** `RGB(111, 215, 176)` - Secondary accent
- **Sky:** `RGB(122, 196, 255)` - Tertiary accent
- **Pink:** `RGB(255, 166, 196)` - Highlight accent
- **Orange:** `RGB(255, 184, 120)` - Warm accent

**Text Colors:**
- **Text:** `RGB(245, 247, 255)` - Primary text (off-white)
- **TextMuted:** `RGB(160, 168, 190)` - Secondary text
- **Border:** `RGB(80, 89, 110)` - Border/divider

**Semantic Colors:**
- **Success:** `RGB(94, 219, 148)` - Green
- **Warning:** `RGB(255, 187, 91)` - Amber
- **Danger:** `RGB(255, 112, 112)` - Red

**Effect Colors:**
- **Glow:** `RGB(172, 132, 255)` - Neon glow
- **Shadow:** `RGB(0, 0, 0)` - Deep shadow

### Why These Colors?

- **Deep navy background** reduces eye strain in dark environments
- **Lavender primary** feels modern without being harsh
- **Mint, Sky, Pink** are soft but vibrant accents
- **Soft off-white text** is easier on the eyes than pure white
- **Muted grays** create hierarchy without contrast shock

## Typography

**Font Family:** Gotham (built-in to Roblox)

**Font Weights & Sizes:**

| Component | Weight | Size | Use |
|-----------|--------|------|-----|
| Page Title | Bold | 32 | Main headings |
| Section Title | Semibold | 20 | Section headers |
| Subheading | Semibold | 16 | Sub-sections |
| Body Text | Medium | 14 | Main content |
| Small Text | Medium | 12 | Metadata, hints |
| UI Labels | Semibold | 13 | Button text |
| Code | Monospace | 12 | Code snippets |

**Line Height:** 1.5x font size for readability

**Letter Spacing:** Default (no special spacing)

## Spacing & Layout

**Base Unit:** 4px

**Spacing Scale:**
- `xs` = 4px (tight spacing)
- `sm` = 8px (standard small gap)
- `md` = 12px (standard gap)
- `lg` = 16px (standard large gap)
- `xl` = 24px (section spacing)
- `2xl` = 32px (major spacing)

**Example:**
- Button padding: 12px vertical, 16px horizontal
- Card padding: 16px
- Window margins: 12px
- Section gap: 24px

## Corner Radius

**Rounding Values:**
- **Buttons:** 12px
- **Cards:** 16px
- **Windows:** 20px
- **Panels:** 16px
- **Circles:** `UICorner.CornerRadius = UDim.new(1, 0)`

**Why?** Medium rounding feels premium without being childish.

## Shadows & Depth

**Shadow Technique:** Dark overlay with adjusted transparency

**Window Shadow:**
```lua
local shadow = Instance.new("ImageLabel")
shadow.Image = "rbxassetid://131604521"  -- Roblox built-in shadow
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.45
```

**Depth Levels:**
1. **Background** - No shadow
2. **Panels** - Subtle shadow (0.2 transparency)
3. **Cards** - Medium shadow (0.35 transparency)
4. **Windows** - Strong shadow (0.45 transparency)
5. **Modals** - Maximum shadow (0.65 transparency)

## Buttons

**Primary Button**
- Background: `RGB(155, 118, 255)` (Lavender)
- Text: `RGB(255, 255, 255)` (White)
- Padding: 12px vertical, 16px horizontal
- Border Radius: 12px
- Font: Gotham Semibold, 14px

**Hover State**
- Background brightens: `RGB(190, 167, 255)`
- Scale: 1.02x
- Glow: Subtle lavender glow

**Active State**
- Background darkens
- Scale: 0.98x
- Immediate feedback

**Disabled State**
- Opacity: 0.5
- Text: Muted gray
- No interactions

## Cards & Panels

**Card Structure:**
```
┌─────────────────────┐
│ Icon  Title    ✕    │  ← Header (gradient bg)
├─────────────────────┤
│                     │
│   Content Area      │
│                     │
└─────────────────────┘
```

**Panel Styling:**
- Background: `RGB(24, 28, 38)` with subtle gradient
- Border: 1px of `RGB(80, 89, 110)`
- Padding: 16px
- Border Radius: 16px
- Shadow: Medium (0.35)

## Windows

**Window Chrome:**
- Title bar: `RGB(31, 36, 48)` with gradient down
- Title text: `RGB(245, 247, 255)` bold 15px
- Close button: Red, 24x24, top-right
- Draggable by title bar
- Resizable from corners
- Minimizable/maximizable

**Window Interior:**
- Background: `RGB(24, 28, 38)`
- Content padding: 16px
- Scrollable if content overflows

## Animations

**Easing Functions:**
- **Entrance:** `Quad.easeOut` (quick, bouncy start)
- **Exit:** `Quad.easeIn` (quick fade)
- **Hover:** `Cubic.easeOut` (smooth)
- **Transitions:** `Quart.easeInOut` (balanced)

**Timing:**
- Button hover: 0.15 seconds
- Window open: 0.3 seconds
- Panel fade: 0.2 seconds
- Large transitions: 0.4 seconds
- Delicate animations: 0.5+ seconds

**Animation Types:**

1. **Entrance** - Elements slide/fade in from edges
2. **Hover** - Buttons scale 1.02x, glow appears
3. **Click** - Instant 0.98x scale, then back
4. **Window Drag** - Smooth position update
5. **Scroll** - Momentum-based scrolling

## Motion Design

**Core Principle:** Motion has purpose. Nothing is abrupt.

**Button Click Flow:**
1. Instant scale down to 0.98x
2. Feedback sound plays
3. Smooth scale back to 1.0x (0.1s)
4. Action executes

**Window Open Flow:**
1. Scale from 0.9x, opacity 0
2. Animate to 1.0x, opacity 1 (0.3s)
3. Shadow fades in simultaneously

**Theme Switch Flow:**
1. All colors fade to new theme (0.4s)
2. No abrupt changes
3. Smooth experience across all UI

## Accessibility

**ColorblindMode:**
- Replace soft pastels with high-contrast alternatives
- Ensure all info is not color-only
- Add labels to color-coded elements

**LargeTextMode:**
- Scale all text 1.25x
- Maintain hierarchy
- Adjust spacing proportionally

**HighContrastTheme:**
- Maximum color separation
- Thick borders
- Large text
- No subtle effects

## Examples

### Dashboard Card
```lua
local card = Card:Create({
    title = "Current Rank",
    icon = "⭐",
    content = {
        value = "#12 Global",
        subtitle = "Top 1% players",
    },
    accentColor = ThemeManager:GetColor("Primary"),
    width = 240,
    height = 150,
})
```

### Modal Dialog
```lua
local modal = Modal:Create({
    title = "Confirm Action",
    message = "Are you sure?",
    buttons = {
        { text = "Cancel", style = "secondary" },
        { text = "Confirm", style = "primary", onClick = function() ... end },
    },
})
```

### Song Card
```lua
local songCard = Card:Create({
    background = songArtwork,
    title = "Lunar Bloom",
    subtitle = "Artist • 180 BPM • 4K",
    actions = {
        { icon = "▶", onClick = playFunction },
        { icon = "❤", onClick = favoriteFunction },
    },
})
```

## Design Principles

1. **Intentional** - Every element has purpose
2. **Consistent** - Visual patterns repeat
3. **Responsive** - Feedback for every action
4. **Accessible** - Usable by everyone
5. **Premium** - Feels high-quality
6. **Alive** - Motion and personality
7. **Efficient** - Professional, not cluttered
8. **Delightful** - Small surprises and polish
