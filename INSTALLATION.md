# RhythmOS Platform - Installation Guide

## Quick Start

You have two options:

### Option 1: Rojo (Recommended for Developers)

1. Install Rojo: https://rojo.space/docs/installation/
2. Clone this repo:
   ```
   git clone https://github.com/stopcinning/RhythmOS-Platform.git
   cd RhythmOS-Platform
   ```
3. Create `default.project.json`:
   ```json
   {
     "name": "RhythmOS Platform",
     "tree": {
       "$className": "DataModel",
       "StarterPlayer": {
         "$className": "StarterPlayer",
         "StarterPlayerScripts": {
           "$path": "src"
         }
       }
     }
   }
   ```
4. Run Rojo server:
   ```
   rojo serve
   ```
5. Open Roblox Studio, install Rojo plugin, click "Connect"
6. Press Play

### Option 2: Manual Import (Simplest)

1. Open Roblox Studio
2. Create a new baseplate
3. In Explorer, find: **StarterPlayer > StarterPlayerScripts**
4. Create the folder structure:
   - Modules
     - Core
     - UI
       - Components
       - Shell
       - Dialogs
     - Apps
     - Services
     - Utils
   - Themes
   - Charts
   - Assets
5. Copy all `.lua` files from `src/` into the corresponding folders
6. Create a **Script** (not ModuleScript) called `LocalClient` in `StarterPlayerScripts`
7. Paste the code from `src/LocalClient.lua`
8. Press Play

## File Structure in Roblox Studio

Your Explorer should look like:

```
StarterPlayer
└── StarterPlayerScripts
    ├── LocalClient (Script)
    ├── Modules (Folder)
    │   ├── Core (Folder)
    │   │   ├── AppManager (ModuleScript)
    │   │   ├── WindowManager (ModuleScript)
    │   │   ├── ThemeManager (ModuleScript)
    │   │   ├── DataStore (ModuleScript)
    │   │   ├── EventBus (ModuleScript)
    │   │   └── Settings (ModuleScript)
    │   ├── UI (Folder)
    │   │   ├── Components (Folder)
    │   │   ├── Shell (Folder)
    │   │   └── Dialogs (Folder)
    │   ├── Apps (Folder)
    │   ├── Services (Folder)
    │   └── Utils (Folder)
    ├── Themes (Folder)
    ├── Charts (Folder)
    └── Assets (Folder)
```

## What You'll See

1. **Dark desktop environment** with soft pastel accents
2. **Dock** on the left with app buttons
3. **Taskbar** at the bottom
4. **Home/Dashboard** window with widgets
5. **Fully interactive** - click to open other apps

## Troubleshooting

### "Script error: Module not found"
- Make sure folder structure matches exactly
- Check that all ModuleScripts are in the right folders
- Make sure LocalClient is a **Script**, not a ModuleScript

### "Nothing appears on screen"
- Make sure you pressed Play
- Check Output for errors (View > Output)
- Verify all files are present

### "Apps don't open"
- Check that app modules are in `Modules/Apps/`
- Make sure app names match in the code
- Check console for error messages

## Next Steps

1. Read `docs/DESIGN_LANGUAGE.md` to understand the visual style
2. Read `docs/ARCHITECTURE.md` to understand the system
3. Explore individual app modules to customize
4. Start building your own apps

## Support

If you run into issues:
- Check the docs folder
- Look at example apps
- Review the error messages in Output
