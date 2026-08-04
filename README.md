# convert_heic

**English** · [Magyar](README.hu.md)

Command-line tool for batch-converting HEIC/HEIF photos. Processes one or more files and entire directories, with colored progress output.

## Features

- **HEIC/HEIF conversion** — powered by ImageMagick (`magick`)
- **Multiple targets** — mix files and directories in a single invocation
- **Recursive directory search** — finds all `.heic` / `.heif` files in a folder (case-insensitive)
- **Output format selection** — `png` (default), `jpg`, `jpeg`, `webp`, `tiff`, `bmp`
- **Optional metadata stripping** — remove EXIF and other metadata with `--strip-metadata` (`exiftool`)
- **Delete originals** — remove source HEIC files after successful conversion with `--delete`
- **Duplicate filtering** — each file is processed only once
- **Help and version** — `--help`, `--version`

## Dependencies

| Tool | Required | Install (macOS) |
|------|----------|-----------------|
| [ImageMagick](https://imagemagick.org/) (`magick`) | Yes | `brew install imagemagick` |
| [ExifTool](https://exiftool.org/) (`exiftool`) | Only with `--strip-metadata` | `brew install exiftool` |

## Installation / deploy

The script can be used as a shell command when it lives in `~/bin` and that directory is on your `PATH`.

### First-time setup

```bash
mkdir -p ~/bin
cp convert_heic.sh ~/bin/convert_heic
chmod +x ~/bin/convert_heic
```

Make sure your shell `PATH` includes `~/bin` (e.g. in `~/.zshrc`):

```bash
export PATH="$HOME/bin:$PATH"
```

### Redeploy (update)

After editing `convert_heic.sh` in the project, copy it again:

```bash
cp ~/Desktop/projects/heic-converter/convert_heic.sh ~/bin/convert_heic
chmod +x ~/bin/convert_heic
```

Verify:

```bash
which convert_heic          # → /Users/<user>/bin/convert_heic
convert_heic --version      # → convert_heic v1.0.0
convert_heic --help
```

From then on, run `convert_heic` from any directory — no need for `./convert_heic.sh`.

## Usage

```bash
convert_heic [targets...] [options...]
```

**Targets:** one or more file and/or directory paths (required). With no arguments, the script prints the help message.

### Examples

```bash
# Help
convert_heic
convert_heic --help

# Convert a single file
convert_heic photo.heic

# JPG output (case-insensitive: JPG, Jpg, jpg)
convert_heic --format=JPG photo.heic

# Strip metadata before conversion
convert_heic --strip-metadata photo.heic

# Directory, WebP output, delete originals
convert_heic --format=webp --delete ./photos/

# Multiple targets at once
convert_heic img1.heic ./vacation/ ./other.heic --format=jpg
```

## Options

| Option | Description |
|--------|-------------|
| `--format=EXT` | Output format: `png`, `jpg`, `jpeg`, `webp`, `tiff`, `bmp` (case-insensitive; default: `png`) |
| `--strip-metadata` | Remove EXIF and other metadata before conversion |
| `--delete` | Delete the original HEIC/HEIF file after successful conversion |
| `--help` | Show help |
| `--version` | Show version |

Options may appear in any order alongside targets.

## How it works

For each file:

1. *(Optional)* Strip metadata — when `--strip-metadata` is set
2. Convert to the chosen format — output is written next to the source file with the same basename and new extension (e.g. `IMG_1234.heic` → `IMG_1234.png`)
3. *(Optional)* Delete the original — when `--delete` is set

## Local development

Run directly from the project directory:

```bash
./convert_heic.sh --help
./convert_heic.sh --format=jpg ./test/
```
