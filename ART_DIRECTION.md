# Art Direction — Shellstrike2D

## Reference blend
- **Silhouette/readability/colour:** Brawl Stars — chunky chibi proportions, thick black outlines (6-8% of sprite width), flat-shaded with one hard highlight + one hard shadow, no gradients, very saturated palette.
- **Energy/FX/world tone:** Jazz Jackrabbit 2 — bright candy-colored environments, glossy "cartoon sci-fi" props, punchy speed/impact FX (motion streaks, spark bursts), upbeat non-grim violence (pellets/poofs, not gore).
- **Top-down gameplay read:** units are drawn as a 3/4-top-down chibi blob (head dominant, ~60% of sprite height) so they stay readable at small size on a phone screen, à la Brawl Stars top-down portraits.

## Palette
- Tortoise (defenders): shell teal `#2E9E6B` → highlight `#5FD79A`, belly cream `#F4E9C9`, bandana navy `#274C77`.
- Rabbit (attackers): fur cream `#F2C9A0` → highlight `#FFE6BF`, ear-inner pink `#F08FA2`, tactical bandana rust `#C1502E`.
- World neutrals: sandy ground `#E8D9A8`, packed dirt path `#C9B27C`, crate wood `#A9743B`, outline ink `#1B1B1F` (never pure black — keeps it soft/cartoon).
- FX accent: carrot-energy glow `#FF8A1E` → `#FFD166`.

## Construction rules (apply to every sprite)
1. Outline every silhouette edge with a single 4px ink stroke (scaled with sprite size).
2. Max 3 shading steps per shape: base / highlight / shadow. No gradients except the Carrot Charge glow.
3. Eyes are big, simple, two-tone (white + pupil) — primary source of "cute/marketable mascot" appeal.
4. Every character carries one silhouette-defining prop: Tortoise = round riot-shield-shaped shell plate + blaster; Rabbit = tall ears (one notched/battle-worn) + lightweight blaster.
5. Asset sizes: gameplay top-down sprites at 128×128 source (downscaled at runtime); mascot/portrait art at 512×512 for store icon / future merch use.

## Map kit (CS-layout-inspired, not copied)
Logistics borrowed from CS map theory (two sites fed by 3 lanes: A-lane, mid, B-lane; chokepoints + one flank rotation) but every map gets its own original geometry, names and dressing:
- `de_burrow` — village-burrow theme (current Main map → being reworked), wood/straw cover, two "Dens" dug into hillsides.
- `de_warren` — denser maze of tunnels/hedgerows, inspired by mid-control-heavy layouts (Inferno-like flow), reskinned as a rabbit warren with reed-hedge cover.

No texture, callout name, or map silhouette is copied 1:1 from any existing game — only the abstract lane/site logistics are reused, which is genre convention (every CS-like tac-shooter uses 2-site/3-lane logistics).
