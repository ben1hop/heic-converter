#!/bin/bash

# Colors and symbols
GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
CHECKMARK="\xE2\x9C\x94"
CROSS="\xE2\x9D\x8C"
ARROW="\xE2\x9E\x9C"
FOLDER="\xF0\x9F\x93\x81"

# Spinner
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid > /dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
}

# Help menu
show_help() {
  echo -e "${BLUE}Usage:${NC} ./convert_heic.sh [directory] [--format=png|jpg|webp] [--delete]"
  echo
  echo "Options:"
  echo "  directory        Optional. Path to the folder containing .heic files (default: current dir)"
  echo "  --format=EXT     Optional. Output image format (default: png)"
  echo "  --delete         Delete original .heic files after successful conversion"
  echo "  --help           Show this help message"
  echo "  --version        Show script version"
  exit 0
}

# Version
if [[ "$1" == "--version" ]]; then
  echo "convert_heic v1.0.0"
  exit 0
fi

# Defaults
TARGET_DIR="."
OUTPUT_FORMAT="png"
DELETE_ORIGINAL=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --help)
      show_help
      ;;
    --version)
      echo "convert_heic v1.0.0"
      exit 0
      ;;
    --format=*)
      OUTPUT_FORMAT="${arg#*=}"
      ;;
    --delete)
      DELETE_ORIGINAL=true
      ;;
    *)
      TARGET_DIR="$arg"
      ;;
  esac
done

# Validate output format
case "$OUTPUT_FORMAT" in
  png|jpg|jpeg|webp|tiff|bmp) ;;
  *)
    echo -e "${RED}${CROSS} Unsupported format: $OUTPUT_FORMAT${NC}"
    echo -e "Use --help to see supported formats."
    exit 1
    ;;
esac

# Tool checks
if ! command -v exiftool &> /dev/null; then
  echo -e "${RED}${CROSS} 'exiftool' not found.${NC}"
  echo -e "${YELLOW}  → Install with:${NC}"
  echo "    macOS: brew install exiftool"
  echo "    Debian/Ubuntu: sudo apt install libimage-exiftool-perl"
  echo "    Arch: sudo pacman -S exiftool"
  echo "    Windows: https://exiftool.org/"
  exit 1
fi

if ! command -v magick &> /dev/null; then
  echo -e "${RED}${CROSS} 'magick' (ImageMagick) not found.${NC}"
  echo -e "${YELLOW}  → Install with:${NC}"
  echo "    macOS: brew install imagemagick"
  echo "    Debian/Ubuntu: sudo apt install imagemagick"
  echo "    Arch: sudo pacman -S imagemagick"
  echo "    Windows: https://imagemagick.org/"
  exit 1
fi

# Announce start
echo -e "${BLUE}${FOLDER} Processing directory: $TARGET_DIR"
echo -e "${BLUE}${ARROW} Output format: $OUTPUT_FORMAT${NC}"
$DELETE_ORIGINAL && echo -e "${YELLOW}${ARROW} Source files will be deleted after conversion.${NC}"

# Find files
FILES=()
while IFS= read -r -d $'\0' file; do
  FILES+=("$file")
done < <(find "$TARGET_DIR" -type f -iname "*.heic" -print0)

TOTAL=${#FILES[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo -e "${YELLOW}${CROSS} No HEIC files found in directory.${NC}"
  exit 0
fi

# Process files
COUNT=0
for file in "${FILES[@]}"; do
  COUNT=$((COUNT + 1))
  base_name=$(basename "$file")
  output="${file%.*}.${OUTPUT_FORMAT}"

  echo -e "\n${BLUE}${ARROW} [$COUNT/$TOTAL] ${base_name}${NC}"

  printf "  Stripping metadata..."
  (exiftool -overwrite_original -all= "$file" >/dev/null 2>&1) &
  spinner
  if [ $? -eq 0 ]; then
    echo -e " ${GREEN}${CHECKMARK} Done${NC}"
  else
    echo -e " ${RED}${CROSS} Failed${NC}"
    continue
  fi

  printf "  Converting to $OUTPUT_FORMAT..."
  (magick "$file" "$output" >/dev/null 2>&1) &
  spinner
  if [ $? -eq 0 ]; then
    echo -e " ${GREEN}${CHECKMARK} Saved as $(basename "$output")${NC}"
    if [ "$DELETE_ORIGINAL" = true ]; then
      rm -f "$file" && echo -e "  🗑️  Deleted original ${file##*/}"
    fi
  else
    echo -e " ${RED}${CROSS} Conversion failed${NC}"
  fi
done

echo -e "\n${GREEN}${CHECKMARK} All done! Processed $TOTAL file(s).${NC}"
# --version support
if [[ "$1" == "--version" ]]; then
  echo "$SCRIPT_NAME v1.0.0"
  exit 0
fi
