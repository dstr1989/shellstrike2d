# Shellstrike2D — przewodnik wznowienia (czytaj to najpierw)

Jak usiądziesz przy innym komputerze (np. domowym), zacznij tutaj.

## Co to za projekt
Mobilna (Android, docelowo iOS) strzelanka 2D z góry, mechaniką inspirowana CS:GO/CS2,
ale w świecie zwierząt — **Żółwie (obrona, jak CT)** vs **Króliki (atak, jak T)**.
Zamiast bomby C4: **Carrot Charge** plantowana w strefach **Den A/B**. Styl wizualny:
Brawl Stars (chibi, grube kontury), grafika generowana w ChatGPT i wpinana przeze mnie.
Repo: https://github.com/dstr1989/shellstrike2d (branch `master`).

## Stack i wymagania (do zainstalowania na nowym kompie)
- **Godot 4.7** (Windows: `winget install GodotEngine.GodotEngine`).
- **Szablony eksportu 4.7.stable** → `%APPDATA%/Godot/export_templates/4.7.stable/`
  (pobierz `Godot_v4.7-stable_export_templates.tpz` z GitHuba Godota, zmień rozszerzenie na .zip, rozpakuj `templates/*` do tego folderu).
- **JDK 17** (Temurin) — do buildu Androida.
- **Android SDK** (cmdline-tools + platform-tools + build-tools;34.0.0 + platforms;android-34).
  Ścieżki ustawia się w edytorze Godota (Editor Settings → export/android). Patrz `DEV_SETUP.md`.
- Python 3 + Pillow (do obróbki grafik z ChatGPT — usuwanie tła itp.).

## Jak uruchomić / zbudować
- **Edytor/gra:** otwórz folder `shellstrike2d` w Godot 4.7, uruchom (F5). Scena startowa: `scenes/MainMenu.tscn`.
- **Headless test (bez błędów?):** `godot --headless --path . "res://scenes/MapOasis.tscn" --quit-after 6`
- **APK (debug):** `godot --headless --path . --export-debug "Android" builds/shellstrike2d.apk`

## Sterowanie (PC zamiennik dotyku)
- WASD ruch, **mysz** celowanie, **LPM** strzał, **PPM / przycisk TARCZA** tarcza (żółw),
  **Spacja / SKOK** skok+vault nad niską osłoną, **E** plant/defuse przy Den, **F1** podgląd kolizji (debug).

## Struktura
- `scenes/` — MainMenu, MapOasis (główna mapa), Main (de_burrow), MapWarren, Unit/Player/Bot, CarrotCharge, HUD, Door.
- `scripts/` — autoloady: `global.gd`(enumy/teamy), `game_manager.gd`(rundy/kill feed),
  `touch_input.gd`, `skin_manager.gd`, `loadout.gd`(wybór strony). Logika: `unit.gd`(serce gry),
  `bot_ai.gd`, `carrot_charge.gd`, `elevation_zone.gd`, `water_zone.gd`, `door.gd`, `debug_overlay.gd`.
- `assets/sprites/` — grafika w grze. `assets/skins/*.tres` — skiny (wpinanie grafik bez zmian w kodzie).
- `assets/incoming/` — wrzucane grafiki z ChatGPT (do obróbki/wpięcia).

## Dokumenty
- `RELEASE_ROADMAP.md` — co zrobione i co zostało (żywy plan).
- `CONVERSATION_LOG.md` — historia decyzji i prac (cała sesja).
- `ASSETS_SPEC_v2.md` — MASTER brief grafik/animacji do ChatGPT (części postaci, efekty, drzwi, tunele).
- `MAP_DESIGN_oasis.md`, `ART_DIRECTION.md`, `DEV_SETUP.md`.

## Stan na teraz (skrót)
Działa: rdzeń rozgrywki, strzał+FX+HP, rundy/plant/defuse, boty 2v2, wybór strony,
postacie z AI-grafiki + skiny, skok/vault, rampy góra/dół, woda (żółw pływa/nie strzela,
królik tonie w głębinie), tarcza-skorupa (strzela do tyłu), kill feed, mapa `de_oasis`,
podgląd kolizji F1, system drzwi, build Androida.
W toku/następne: **prawdziwa animacja szkieletowa** (są już części postaci w `assets/incoming/`),
dostrojenie tuneli/drzwi do grafiki (użyj F1), efekty (muzzle/impact/splash/dust/death — assety są),
potem: sklep/skiny UI, rangi, scoreboard, ekran końca meczu, dźwięk, multiplayer. Szczegóły w roadmapie.
