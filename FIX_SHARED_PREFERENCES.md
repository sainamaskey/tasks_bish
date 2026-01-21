# Fix SharedPreferences MissingPluginException

## The Problem
You're seeing this error:
```
MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/shared_preferences)
```

This happens when the native plugin isn't properly registered. Hot restart doesn't register native plugins - you need a full rebuild.

## Solution

### Option 1: Full Rebuild (Recommended)
1. **Stop the app completely** (not just hot restart)
2. Run these commands in your terminal:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Option 2: If using Android Studio/VS Code
1. **Stop the app** (click the stop button)
2. Click **Run** (or press F5) to do a full rebuild
3. Don't use hot restart (R) or hot reload (r) - use full run

### Option 3: Quick Fix (if rebuild doesn't work)
1. Uninstall the app from your device/emulator
2. Run `flutter clean`
3. Run `flutter pub get`
4. Run `flutter run` (full rebuild)

## Why This Happens
- Hot restart (R) doesn't reload native plugins
- Native plugins need to be registered at app startup
- Only a full rebuild registers plugins properly

## After Fixing
Once you rebuild, SharedPreferences should work correctly. The app already has fallback in-memory storage, but with a proper rebuild, SharedPreferences will work and your data will persist.
