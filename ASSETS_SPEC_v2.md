# Shellstrike2D — MASTER brief grafik/animacji do ChatGPT

Wszystko PNG, **przezroczyste tło** ("die-cut sticker, transparent background"),
ten sam styl: *"Brawl Stars / Supercell mobile game art style, thick dark outline,
smooth cel shading, vibrant saturated colors, clean, transparent background, no text, no UI"*.
Jeśli ChatGPT nie umie w przezroczystość → jednolite tło **#00FF00**, ja usunę (mam Pillow).
Wrzucaj do `assets/incoming/`. Trzymaj spójną skalę i oświetlenie (z góry) we wszystkim.

================================================================
## A. POSTACIE — części do animacji szkieletowej (NAJWAŻNIEJSZE)
================================================================
Potrzebuję każdej postaci **rozłożonej na części** (paper-doll), każda część jako
osobny plik, wyśrodkowana, pełna (bez ucięć), ten sam rozmiar/proporcje co dotąd.
Widok 3/4 z góry, postać „patrzy" w dół ekranu.

### Żółw (Tortoise)
- `tort_head.png` (256×256) — głowa z niebieską bandaną i twarzą.
- `tort_shell.png` (320×320) — sam tułów/skorupa od przodu (bez głowy, bez kończyn).
- `tort_shell_back.png` (320×320) — **skorupa od TYŁU** (żółw odwrócony plecami) — do trybu tarczy i obracania.
- `tort_arm.png` (160×160) — jedna ręka (zlustruję drugą).
- `tort_leg.png` (160×160) — jedna noga/stopa (zlustruję drugą).

Prompt:
> Cute cartoon tortoise soldier with navy bandana, Brawl Stars style, top-down 3/4 view. Generate it as a flat paper-doll cutout: produce SEPARATE pieces, each fully drawn with gaps between them on a transparent background — (1) head with bandana, (2) front body shell only, (3) the same shell seen from BEHIND, (4) one arm, (5) one leg. Thick dark outline, smooth cel shading, vibrant colors, transparent background, no text.

### Królik (Rabbit)
- `rab_head.png` (256×256) — głowa z rdzawą bandaną + twarz (BEZ uszu).
- `rab_ear.png` (200×200) — jedno ucho (zlustruję drugie, animuję osobno).
- `rab_torso.png` (320×320) — tułów z taktyczną kamizelką.
- `rab_arm.png` (160×160) — jedna ręka.
- `rab_leg.png` (160×160) — jedna noga.

Prompt:
> Cute cartoon rabbit commando with rust tactical bandana and vest, Brawl Stars style, top-down 3/4 view. Generate as a flat paper-doll cutout: SEPARATE pieces with gaps on transparent background — (1) head with bandana and face WITHOUT ears, (2) one long ear, (3) torso with vest, (4) one arm, (5) one leg. Thick dark outline, smooth cel shading, vibrant colors, transparent background, no text.

> Z tych części zrobię w Godocie: chód (nogi/ręce), celowanie ręką z bronią,
> odrzut, obrót, podskok/vault, oraz tryb tarczy (żółw chowa się w skorupie / odwraca plecami).

================================================================
## B. EFEKTY — paski klatek (sprite sheety, poziomo, równe klatki, przezroczyste)
================================================================
Jeśli model nie zrobi czystego paska, dawaj klatki osobno — poskładam. (W razie czego zrobię część proceduralnie.)

- `fx_muzzle.png` — błysk wystrzału, 4 klatki 64×64 (pasek 256×64), żółto-pomarańczowy.
  > Cartoon muzzle flash, 4-frame horizontal sprite strip, yellow-orange burst, transparent background, no text.
- `projectile.png` (64×32) — pocisk energetyczny, lufa w prawo, zielono-pomarańczowa „marchewkowa" energia.
  > Cartoon energy bolt projectile pointing right, green-orange carrot energy, Brawl Stars style, transparent background.
- `fx_impact.png` — trafienie, 4 klatki 64×64, iskra+dym.
  > Cartoon bullet impact spark, 4-frame horizontal strip, transparent background.
- `fx_splash.png` — plusk wody, 5 klatek 96×96, niebieskie krople+pierścień.
  > Cartoon water splash, 5-frame horizontal strip, blue droplets and ripple ring, transparent background.
- `fx_dust.png` — obłok kurzu (skok/vault/lądowanie), 5 klatek 96×96, piaskowy.
  > Cartoon sandy dust puff, 5-frame horizontal strip, beige, transparent background.
- `fx_death.png` — „pyk" po śmierci, 6 klatek 128×128, kreskówkowy dym+gwiazdki (neutralny kolorystycznie).
  > Cartoon poof cloud with stars, 6-frame horizontal strip, grey smoke, transparent background, no blood.

================================================================
## C. MAPA / OTOCZENIE
================================================================
- `door_oasis.png` (128×256) — pojedynczy panel drzwi pasujący do oazy (kamień+drewno), pionowy, przezroczysty. Ja zrobię przesuwanie/otwieranie.
  > Top-down stone-and-wood gate door panel, desert oasis style, vertical, Brawl Stars style, thick outline, transparent background, no text.
- `tunnel_entrance.png` (256×256) — wejście do tunelu z góry: ciemna dziura/schody w dół w piaskowcu, do oznaczenia wlotu tuneli.
  > Top-down entrance to an underground tunnel: dark hole with stone steps going down into sandstone, desert style, Brawl Stars style, transparent background, no text.
- (opcjonalnie) `water_foam.png` (256×64) — pasek piany/brzegu wody do nakładki.

================================================================
## D. DOSTAWA
================================================================
Wrzuć pliki do `shellstrike2d/assets/incoming/` (mogą być partiami) i napisz „gotowe".
Najpierw warto zrobić **sekcję A (części postaci)** — od niej zależy prawdziwa animacja.
