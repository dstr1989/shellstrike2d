# Shellstrike2D — droga do wydania (żywy plan)

Lista tego, co trzeba do pełnej, wydawalnej gry. Aktualizuję ją na bieżąco —
gdy odpalasz grę i widzisz czego brakuje, dopisujemy tutaj.

## ✅ Zrobione
- Rdzeń rozgrywki: ruch, celowanie (świat), strzał hitscan + smugi/błysk/iskra, HP + paski + flash trafienia.
- Rundy: timer, ekonomia zwycięstw, plant/defuse Carrot Charge przy Den, warunki końca.
- Boty (proste AI) 2v2, gracz po stronie Królików (atak).
- Postacie z AI-grafiki (żółw/królik), broń (marchewkowy blaster), system skinów (`assets/skins/*.tres`).
- Rzut „Brawl-like": ciało pionowo + flip, broń obraca się za celem.
- Pionowość: skok (grawitacja, cień), vault nad niską osłoną, **rampy góra/dół** (ElevationZone), platformy/zapadnięte doły.
- Animacja proceduralna: oddech, bujanie w biegu, rozciąganie w skoku, odrzut broni.
- Kill feed (jak w CS).
- Mapa `de_oasis` (grafika AI + kolizje, rampy góra/dół, woda, wraki jako osłony, tunele).
- Wybór strony w menu (gra Królik/Żółw, 2v2 z botem-kolegą).
- **Skorupa-tarcza żółwia** (blok z przodu, wolniejszy ruch, brak strzału, slot prawy myszy / przycisk TARCZA).
- **Walka po wysokości** — chowanie się w zapadniętych tunelach (concealment po z).
- Build na Androida (APK), preset iOS, repo na GitHub.

## 🔜 Następne (gameplay)
- [ ] **Osłona za autami/wysokością bardziej dopracowana** — pełne LOS po z, kucanie.
- [ ] **Pociski + różne bronie** — pistolet/SMG/shotgun/„karabin marchewkowy"; statystyki, rozrzut, magazynek, przeładowanie.
- [ ] **Animacja szkieletowa** (cutout) — części postaci z ChatGPT → rig w Godot dla prawdziwego ruchu nóg/rąk.
- [ ] **Dźwięk** — strzały, trafienia, kroki, plant/defuse, muzyka menu/rundy.
- [ ] **Granaty / umiejętności** (opcjonalnie, à la Brawl super).

## 🔜 Następne (meta / oprawa — „jak w CS/Brawl")
- [ ] **Menu główne** porządne: ekran startowy, wybór postaci, ustawienia, granie.
- [ ] **Sklep** — kupowanie skinów (waluta z meczów), podgląd 3D/portret, ceny.
- [ ] **System skinów** rozbudowany — wybór skina per drużyna, ekwipunek gracza, zapisywanie.
- [ ] **System rang (jak w CS)** — ranga rośnie/spada z wynikami meczu, ikona rangi.
- [ ] **Tablica wyników (scoreboard)** — K/D na drużynę i gracza, jak w CS (TAB).
- [ ] **Ekran końca meczu** — MVP, statystyki, zmiana rangi.
- [ ] **Profil gracza** — poziom, waluta, odblokowania (zapis lokalny → potem chmura).

## 🔜 Techniczne / wydanie
- [ ] **Multiplayer online** (dedykowany serwer / Godot multiplayer) — docelowy tryb jak CS.
- [ ] Balans, ustawienia sterowania (czułość, układ przycisków), wibracje.
- [ ] Ikona aplikacji, splash, nazwa, lokalizacja (PL/EN).
- [ ] Google Play: keystore release, polityka prywatności, listing, testy.
- [ ] iOS: build na macOS + Xcode (nie da się z Windows), konto Apple Developer.

## Mapy (robi je użytkownik)
- `de_oasis` wg `MAP_DESIGN_oasis.md` (tło z ChatGPT). Ja wpinam tło + kolizje + rampy, gdy gotowe.
