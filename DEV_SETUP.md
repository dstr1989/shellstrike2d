# Dev setup (ta maszyna)

Stan zweryfikowany lokalnie — pipeline budowania działa end-to-end.

- **Godot 4.7** (winget `GodotEngine.GodotEngine`): `C:\Users\<user>\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64.exe`
- **Export templates 4.7.stable**: `%APPDATA%\Godot\export_templates\4.7.stable\`
- **JDK 17 (Temurin)**: `C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot`
- **Android SDK** (cmdline-tools + platform-tools + build-tools 34.0.0 + platform 34): `C:\Android\sdk`
- Ścieżki SDK/JDK skonfigurowane w edytorze Godota: `%APPDATA%\Godot\editor_settings-4.7.tres` → `export/android/java_sdk_path`, `export/android/android_sdk_path`.
- Debug keystore: auto-wygenerowany przez Godota w `%APPDATA%\Godot\keystores\debug.keystore`.

## Build APK (debug)

```
godot --headless --path . --export-debug "Android" builds/shellstrike2d.apk
```

Zbudowany i podpisany APK (~28 MB) jest gotowy do instalacji testowej (`adb install builds/shellstrike2d.apk`). `builds/` jest w `.gitignore` — nie commitujemy binarek.

## iOS

Nie da się zbudować `.ipa` na Windowsie. Preset `iOS` w `export_presets.cfg` jest gotowy — eksport projektu Xcode i właściwa kompilacja/podpis muszą się odbyć na macOS z Xcode (i kontem Apple Developer do podpisu).

## Release build

Do wydania w Google Play potrzebny będzie keystore **release** (nie debug) — wygenerować przez `keytool` i wpisać w `export_presets.cfg` (`keystore/release`), oraz zwiększać `version/code` przy każdym wydaniu.
