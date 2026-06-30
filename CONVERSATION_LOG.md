# Shellstrike2D — historia prac (podsumowanie sesji)

Skrót chronologiczny decyzji i zmian, żeby dało się wznowić pracę na innym komputerze.
(To streszczenie rozmowy, nie surowy zapis.)

## Założenia ustalone z użytkownikiem
- Gra: kopia mechaniki CS (CS:GO/CS2) jako szybka, grywalna strzelanka **2D top-down** na Androida (potem iOS jak się da).
- Motyw zamiast praw autorskich: **Żółwie (CT/obrona)** vs **Króliki (T/atak)**; zamiast bomby — **Carrot Charge** plantowana w **Den A/B**.
- Silnik: **Godot 4** (wybór użytkownika). Start: prototyp single-player / boty (multiplayer później).
- Styl: **Brawl Stars** + energia **Jazz Jackrabbit 2**. Grafiki: użytkownik generuje w **ChatGPT**, ja wpinam (system skinów). Mapy: użytkownik dostarcza tła z ChatGPT.
- WAŻNE: mapy/„dust2" robimy **inspirowane, nie 1:1** (świadomie, żeby uniknąć roszczeń praw).

## Co powstało (kolejno)
1. Repo `dstr1989/shellstrike2d`, szkielet Godot 4: autoloady (Global, GameManager, TouchInput), HealthComponent, Unit/Player/Bot, CarrotCharge, wirtualny joystick + HUD, mapa placeholder, round manager, eksport Android, push.
2. Środowisko: zainstalowany Godot 4.7 + szablony eksportu, JDK17, Android SDK; **zbudowany działający debug APK** (cały pipeline OK). Naprawiony input map.
3. Grafika v1 (placeholdery SVG) + kierunek artystyczny (`ART_DIRECTION.md`), druga mapa `de_warren`, menu wyboru mapy, preset iOS (build .ipa tylko na macOS).
4. Naprawa grywalności: celowanie w świecie (nie ekranie), smugi/błysk/iskra strzału, paski HP + flash trafienia, gracz przeniesiony do atakujących + plant przy Den + podpowiedzi.
5. Przebudowa renderu pod Brawl: **ciało pionowo + flip, broń obraca się za celem**; odsunięcie kamery (zoom 0.6); **system skinów** (`CharacterSkin` .tres) — grafiki wchodzą bez zmian w kodzie.
6. Wgranie grafik postaci z ChatGPT (żółw/królik body+icon, marchewkowy blaster, skorupa-tarcza); dobór skali.
7. **Pionowość:** skok (z-height, grawitacja, cień), **vault** nad niską osłoną; **rampy góra/dół** (`ElevationZone`), platformy/doły; powiększona mapa `de_burrow`; przycisk SKOK.
8. **Animacja proceduralna** (oddech, bujanie, squash/stretch, odrzut), **kill feed (CS)** + K/D; `RELEASE_ROADMAP.md`.
9. **Mapa `de_oasis`**: tło z ChatGPT + niewidzialne kolizje (sites, woda, środkowy choke, auta=osłona vault, rampy na plateau, tunel po lewej); dodana do menu jako główna.
10. **Gameplay:** tarcza-skorupa żółwia + **walka po wysokości** (chowanie w zagłębieniach); **wybór strony** w menu (Królik/Żółw, 2v2 z botem-kolegą); przycisk TARCZA.
11. Przeróbka tarczy: żółw **skorupą do przodu, wolniej, strzela do tyłu**; **woda** (żółw pływa szybko/nie strzela, królik tylko płycizna, w głębinie tonie po ~2 s); kołysanie w animacji.
12. **Podgląd kolizji F1** (debug_overlay) do wyrównywania mapy z grafiką; **system drzwi** (otwierają się przy podejściu) + drzwi na `de_oasis`; wyraźniejsza tarcza (chowa broń, duża skorupa).
13. MASTER brief grafik/animacji `ASSETS_SPEC_v2.md`; użytkownik dostarczył komplet części postaci + efekty + drzwi/tunel (w `assets/incoming/`).

## Otwarte tematy / następne kroki
- **Animacja szkieletowa** z dostarczonych części (chód, celowanie ręką, obrót, tryb skorupy) — najwyższy priorytet jakości.
- Wpięcie efektów (muzzle/impact/splash/dust/death) z `assets/incoming/`.
- Dostrojenie **tuneli i drzwi** do grafiki mapy (klawisz F1 do podglądu) — tunele po lewej do przesunięcia.
- Meta: sklep + UI skinów, rangi (CS), scoreboard, ekran końca meczu, profil/waluta.
- Dźwięk, balans, ustawienia sterowania; docelowo multiplayer online; wydanie (Google Play / iOS).
