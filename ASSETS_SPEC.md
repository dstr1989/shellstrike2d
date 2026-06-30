# Specyfikacja grafik do wygenerowania w ChatGPT (Shellstrike2D)

Silnik jest już gotowy na te grafiki. Gdy je wygenerujesz, wrzuć pliki do
`assets/incoming/` i napisz mi — ja je obrobię (usunę tło jeśli trzeba) i wepnę
przez system skinów. **Nic nie musisz robić w kodzie.**

## ⚙️ Zasady wspólne (WAŻNE — trzymaj się ich, inaczej postacie nie będą pasować)

1. **Widok:** rzut z góry pod lekkim kątem ~35° (kamera jak w **Brawl Stars**) — postać **stoi na dwóch nogach**, widziana z góry-przodu.
2. **Postać patrzy w stronę kamery (w dół ekranu)** i stoi pionowo. **NIE rysuj broni w ręce** — broń jest osobnym, obracanym elementem (silnik ją dokłada i obraca w stronę celu). Ręce mogą być przy ciele lub wyciągnięte do przodu (bez broni).
3. **Tło: przezroczyste** (PNG, "die-cut sticker, transparent background"). Jeśli ChatGPT nie umie zrobić przezroczystości — zrób **jednolite tło czyste zielone `#00FF00`** (ja je usunę).
4. **Bez cienia na ziemi / bez podłoża / bez sceny** — sama postać. Cień dokłada silnik.
5. **Format:** kwadrat **512×512 px** (postać wypełnia ~80% wysokości, wyśrodkowana, nogi przy dolnej krawędzi).
6. **Styl (wklej do każdego promptu):** *"Brawl Stars / Supercell mobile game art style, thick dark outline, smooth cel shading, vibrant saturated colors, cute chibi mascot, big expressive eyes, clean, high detail, centered, full body, standing on two legs, facing camera, transparent background"*.
7. **Spójność:** to samo oświetlenie (z góry), ta sama skala i proporcje we wszystkich postaciach/skinach.

---

## 1. Postać: ŻÓŁW (drużyna obrony — odpowiednik CT) — PRIORYTET

**Plik:** `tortoise_default_body.png` (512×512)

**Prompt do ChatGPT:**
> Cute bipedal cartoon tortoise soldier standing on two legs, facing the camera, top-down 3/4 view (Brawl Stars camera angle, ~35° aerial tilt). Green armored shell on its back visible over the shoulders, cream-colored belly, navy-blue tactical bandana around the head, big friendly expressive eyes, sturdy defender vibe. No weapon in hands, hands empty at the sides. Brawl Stars / Supercell mobile game art style, thick dark outline, smooth cel shading, vibrant saturated colors, cute chibi mascot, clean, high detail, centered, full body, transparent background.

## 2. Postać: KRÓLIK (drużyna ataku — odpowiednik T) — PRIORYTET

**Plik:** `rabbit_default_body.png` (512×512)

**Prompt:**
> Cute bipedal cartoon rabbit commando standing on two legs, facing the camera, top-down 3/4 view (Brawl Stars camera angle, ~35° aerial tilt). Cream/tan fur, long ears (one ear slightly notched/battle-worn), rust-orange tactical bandana, big expressive eyes, lean and fast attacker vibe. No weapon in hands, hands empty at the sides. Brawl Stars / Supercell mobile game art style, thick dark outline, smooth cel shading, vibrant saturated colors, cute chibi mascot, clean, high detail, centered, full body, transparent background.

---

## 3. (Opcjonalne, ale ładne) Portrety do menu / sklepu

512×512, popiersie postaci (ładniejsze, bardziej szczegółowe). Mogą mieć broń, dynamiczną pozę.
- `tortoise_default_icon.png`
- `rabbit_default_icon.png`

## 4. (Opcjonalne) Broń — "Marchewkowy Blaster"

**Plik:** `weapon_blaster.png` (256×128) — **widok z boku, lufa skierowana w PRAWO**, chwyt w dolnej-lewej części, przezroczyste tło.
> Cartoon sci-fi blaster gun, side view, barrel pointing right, orange energy core, Brawl Stars style, thick outline, transparent background.

## 5. Zdolność żółwia: SKORUPA-TARCZA (do mechaniki "tarcza jak w CS")

**Plik:** `tortoise_shellshield.png` (256×256) — duża okrągła skorupa używana jako tarcza frontalna (jak tarcza antyterrorysty w CS, ale to skorupa żółwia). **Skierowana w PRAWO**, przezroczyste tło.
> Big round tortoise shell used as a riot shield, front-facing battle shield, green armored plates, side view facing right, Brawl Stars style, thick dark outline, transparent background.

---

## 🎨 Skiny (na przyszłość)

Każdy nowy skin = ten sam zestaw co wyżej, inna nazwa, np.:
`tortoise_gold_body.png`, `tortoise_ninja_body.png`, `rabbit_cyber_body.png`…
Wystarczy że trzymasz te same zasady (512×512, twarzą do kamery, bez broni, przezroczyste).
Ja dla każdego tworzę plik skina i pojawia się w grze/sklepie.

## 📦 Jak dostarczyć

1. Wygeneruj PNG wg powyższego.
2. Wrzuć do `shellstrike2d/assets/incoming/`.
3. Napisz mi „grafiki gotowe" — resztę zrobię ja.
