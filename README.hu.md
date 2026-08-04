# convert_heic

[English](README.md) · **Magyar**

Parancssori eszköz HEIC/HEIF fényképek batch konvertálásához. Egy vagy több fájlt, illetve teljes mappákat dolgoz fel, és színes, progress jelzéssel mutatja az állapotot.

## Funkciók

- **HEIC/HEIF konvertálás** — ImageMagick (`magick`) segítségével
- **Több cél megadása** — fájlok és mappák keverhetők egy hívásban
- **Rekurzív mappakeresés** — mappában automatikusan megkeresi az összes `.heic` / `.heif` fájlt (kis- és nagybetű mindegy)
- **Kimeneti formátum választás** — `png` (alapértelmezett), `jpg`, `jpeg`, `webp`, `tiff`, `bmp`
- **Opcionális metaadat-törlés** — `--strip-metadata` kapcsolóval EXIF és egyéb metaadatok eltávolítása (`exiftool`)
- **Eredeti törlése** — `--delete` kapcsolóval sikeres konvertálás után törli a forrás HEIC fájlt
- **Duplikátum-szűrés** — ugyanaz a fájl csak egyszer kerül feldolgozásra
- **Help és verzió** — `--help`, `--version`

## Függőségek

| Eszköz | Kötelező | Telepítés (macOS) |
|--------|----------|-------------------|
| [ImageMagick](https://imagemagick.org/) (`magick`) | Igen | `brew install imagemagick` |
| [ExifTool](https://exiftool.org/) (`exiftool`) | Csak `--strip-metadata` esetén | `brew install exiftool` |

## Telepítés / deploy

A script parancsként használható, ha a `~/bin` mappában van, és az szerepel a `PATH`-ben.

### Első telepítés

```bash
mkdir -p ~/bin
cp convert_heic.sh ~/bin/convert_heic
chmod +x ~/bin/convert_heic
```

Győződj meg róla, hogy a shell-ed PATH-je tartalmazza a `~/bin` mappát (pl. `~/.zshrc`-ben):

```bash
export PATH="$HOME/bin:$PATH"
```

### Újra deploy (frissítés)

Ha módosítottad a projektben lévő `convert_heic.sh` fájlt, másold át újra:

```bash
cp ~/Desktop/projects/heic-converter/convert_heic.sh ~/bin/convert_heic
chmod +x ~/bin/convert_heic
```

Ellenőrzés:

```bash
which convert_heic          # → /Users/<felhasznalo>/bin/convert_heic
convert_heic --version      # → convert_heic v1.0.0
convert_heic --help
```

Innentől a `convert_heic` parancs bármely mappából futtatható — nem kell `./convert_heic.sh`-t használni.

## Használat

```bash
convert_heic [célok...] [opciók...]
```

**Célok:** egy vagy több fájl- és/vagy mappaútvonal (kötelező). Paraméter nélkül a script a súgót jeleníti meg.

### Példák

```bash
# Súgó
convert_heic
convert_heic --help

# Egy fájl konvertálása
convert_heic photo.heic

# JPG formátum (kis- és nagybetű is OK: JPG, Jpg, jpg)
convert_heic --format=JPG photo.heic

# Metaadatok törlése konvertálás előtt
convert_heic --strip-metadata photo.heic

# Mappa, WebP, eredeti törlése
convert_heic --format=webp --delete ./photos/

# Több cél egyszerre
convert_heic img1.heic ./vacation/ ./other.heic --format=jpg
```

## Opciók

| Opció | Leírás |
|-------|--------|
| `--format=EXT` | Kimeneti formátum: `png`, `jpg`, `jpeg`, `webp`, `tiff`, `bmp` (kis- és nagybetű mindegy; alapértelmezett: `png`) |
| `--strip-metadata` | EXIF és egyéb metaadatok törlése a konvertálás előtt |
| `--delete` | Eredeti HEIC/HEIF fájl törlése sikeres konvertálás után |
| `--help` | Súgó megjelenítése |
| `--version` | Verzió megjelenítése |

Az opciók tetszőleges sorrendben megadhatók a célok mellett.

## Működés

Minden fájl esetén:

1. *(Opcionális)* Metaadatok törlése — ha `--strip-metadata` be van kapcsolva
2. Konvertálás a kiválasztott formátumra — a kimenet ugyanabba a mappába kerül, az eredeti névvel és az új kiterjesztéssel (pl. `IMG_1234.heic` → `IMG_1234.png`)
3. *(Opcionális)* Eredeti fájl törlése — ha `--delete` be van kapcsolva

## Fejlesztés helyben

A projekt mappájából közvetlenül is futtatható:

```bash
./convert_heic.sh --help
./convert_heic.sh --format=jpg ./test/
```
