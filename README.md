# Shellstrike2D

Taktyczna strzelanka 2D z widokiem z góry na Androida, inspirowana mechaniką CS:GO / CS2 — ale ze świata zwierząt.

## Lore / motyw

- **Tortoises (Żółwie)** — drużyna obronna (odpowiednik CT). Pancerne, wolniejsze, ale wytrzymałe.
- **Rabbits (Króliki)** — drużyna atakująca (odpowiednik T). Szybkie, zwiewne, słabszy pancerz.
- Zamiast bomby C4: **Carrot Charge** — przegrzana kapsuła energii marchewkowej, którą króliki plantują w jednym z dwóch *Den* (Den A / Den B — odpowiednik bombsite A/B). Żółwie muszą ją rozbroić (`defuse`) zanim wybuchnie.
- Mapy nazywane są jak nory/tereny: `de_burrow`, `de_warren`, `de_pond` itd. (nawiązanie do `de_dust2` itp., ale bez 1:1 kopiowania nazw/contentu).

## Core loop (rundy, jak w CS)

1. **Faza zakupu** (skip w MVP / bots-only) — kupowanie broni i sprzętu za walutę zdobywaną z rund.
2. **Faza akcji** — Rabbits muszą zaplantować Carrot Charge i jej obronić, albo wybić Tortoises. Tortoises muszą obronić Deny / rozbroić ładunek / wybić Rabbits.
3. **Koniec rundy** — wybuch ładunku / rozbrojenie / eliminacja drużyny / koniec czasu.
4. Ekonomia i `swap stron` po połowie meczu (jak w CS).

## MVP (ten etap)

- Ruch top-down (wirtualny joystick na dotyk), strzelanie hitscan (raycast).
- Jedna prowizoryczna mapa z 2 Den (A/B).
- Boty (proste AI) jako przeciwnicy/sojusznicy do testowania mechaniki solo.
- Round manager: timer, warunki zwycięstwa, respawn na start rundy.
- Plant/Defuse na Carrot Charge.
- HP, prosta broń (pistolet startowy), dźwięki/grafika placeholder.

## Poza MVP (later)

- Multiplayer online (dedykowany serwer / Godot high-level multiplayer API).
- Pełna ekonomia, sklep broni, więcej broni (shotgun, "karabin marchewkowy" etc.).
- Skiny, progresja, ranking.
- Więcej map.

## Tech stack

- **Godot 4.7** (GDScript), renderer `mobile`.
- Eksport: Android (APK/AAB) — w pełni skonfigurowany i testowany w tym repo.
- Eksport: **iOS** — preset (`export_presets.cfg`) jest gotowy, ale samego `.ipa` (kompilacja przez Xcode + podpis) **nie da się zrobić na Windowsie**. Godot eksportuje na iOS projekt Xcode, który trzeba zbudować i podpisać na maku z zainstalowanym Xcode (potrzebne Apple Developer account do podpisu/dystrybucji). Gdy będzie dostępny Mac, eksport: `Godot → Export → iOS → Export Project`, potem otworzyć wygenerowany `.xcodeproj` w Xcode i zrobić Archive.
- Fizyka 2D, warstwy kolizji zdefiniowane w `project.godot`.

## Struktura projektu

```
scenes/      - scena Main, Player, Bot, CarrotCharge, UI, VirtualJoystick
scripts/     - logika gry (GDScript)
assets/      - sprites, audio, mapy (placeholdery na start)
```

## Jak otworzyć

1. Zainstaluj [Godot 4.3+](https://godotengine.org/download).
2. Otwórz folder `shellstrike2d` jako projekt.
3. Uruchom scenę `Main.tscn`.

## Status

Wczesny szkielet projektu — mechanika ruchu/strzelania/plant-defuse działa w wersji bots-only, single-player.
