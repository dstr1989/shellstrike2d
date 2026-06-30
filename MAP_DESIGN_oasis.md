# Mapa `de_oasis` — projekt (inspirowana dust2, ale ORYGINALNA)

Bierzemy tylko **logikę rozgrywki** klasycznego układu 2-bombsite (genre standard:
long / short / mid / tunele, dwa sites), ale **geometria, nazwy, motyw i grafika są
nasze** — żeby nie było zarzutu o kopię 1:1. Motyw: pustynna **oaza-nora** (woda,
trzciny/krzaki dla królików, wraki aut jako osłony, kamienne platformy z rampami,
zapadnięte tunele do których „schodzi się w dół" i można się schować).

## Układ świata (do tego dopasuję kolizje i Ty dopasujesz grafikę)

- Rozmiar planszy: **2600 × 2600** (świat Godota; lewy-górny = 0,0).
- **Spawn Królików (atak), dół:** ~(1300, 2380)
- **Spawn Żółwi (obrona), góra:** ~(1300, 240)

### Linie natarcia (jak w klasyku, ale nasze)
- **WSCHÓD = „Długa" (Long A):** szeroka, długa linia ognia prawą krawędzią (x≈2150) z dołu na górę do Site A.
- **Site A (Den A): podniesione kamienne plateau**, ~(2050, 720), wejście **rampą w górę** od południa + wąski „catwalk/Short" ze środka.
- **ŚRODEK (Mid):** pionowy korytarz x≈1300 z **chokepointem („wrota")** ~(1300,1300) i **zapadniętym kanałem z wodą (oczko oazy)** ~(1300,1600) — przechodzi się **rampą w dół** i mostkiem.
- **ZACHÓD = Tunele B:** **zapadnięte tunele** (ramp w dół ~ -40, potem ramp w górę do site) prowadzące do **Site B (Den B)** ~(550, 720), lekko podniesionego.
- **Łącznik (mid→B):** krótki przesmyk z krzakami (koncealment królików).

### Wysokości (system ElevationZone — już działa)
- Site A plateau: +44 (wejście rampą od (2050,1000)).
- Site B: +30, poprzedzone tunelem -40 (ramp w dół z (550,1400) → tunel -40 → ramp w górę do site).
- Mid water channel: -36 (ramp w dół z obu stron, mostek na środku jako most/kładka).

### Osłony
- **Wraki aut** = niska osłona „do przeskoczenia" (warstwa kolizji 16, vault skokiem). Pozycje: Long A (2150,1500), mid przy wrotach (1200,1250) i (1400,1350), przed B (700,1100).
- **Skrzynie/kamienie** = pełne bloki widoczności (warstwa 1) na sites i w mid.
- **Krzaki/trzciny** = dekoracja + (docelowo) koncealment przy wodzie i łączniku B.

## Co wygenerować w ChatGPT (tło mapy)

**1 obraz tła, widok z góry (top-down ortho), kwadrat.** Najlepiej **1536×1536** (ja przeskaluję do 2600 i dopasuję). Pełne tło (bez przezroczystości).

**Prompt do wklejenia:**
> Top-down orthographic 2D game map for a cute mobile tactical shooter, desert oasis theme. Square layout. Sandy desert ground with stone-paved paths forming lanes. Two raised stone platforms (bomb sites) in the upper-left and upper-right corners, each with a visible ramp leading up. A central vertical avenue with a stone chokepoint gate in the middle and a sunken blue water pool (oasis) crossed by a small wooden bridge. On the left side, sunken tunnel openings going underground. Green bushes, reeds and a few palm trees around the water and edges. A couple of wrecked cartoon cars used as cover. Bright, saturated, Brawl Stars / Supercell mobile game art style, thick clean outlines, soft shadows, highly readable from above, no characters, no UI, no text.

Jak wygenerujesz — wrzuć do `assets/incoming/` jako `map_oasis_bg.png` i napisz; ja:
1. przeskaluję/dopasuję do siatki 2600×2600 (mam Pillow),
2. nałożę pod niego kolizje, rampy (góra/dół), wraki-osłony, strefy Den A/B, spawny,
3. dorobię „chowanie się" w tunelach (widoczność zależna od wysokości — osobny krok).

## Kolejność prac (następne kroki)
1. **Budowa geometrii `de_oasis`** (kolizje + rampy góra/dół + wraki) na placeholderze — gotowe do gry nawet bez Twojej grafiki.
2. **Podmiana tła** na obraz z ChatGPT + wyłączenie debug-ramek stref.
3. **Walka zależna od wysokości** — realne „schowanie się" w tunelach/za autami (LOS po z).
4. **Pociski + różne bronie + animacje** (osobny duży etap: system broni, klatki ruchu).
