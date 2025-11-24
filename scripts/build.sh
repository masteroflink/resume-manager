#!/bin/bash

# Build resume in multiple formats (PDF, HTML, DOCX, TXT)
# Usage: ./scripts/build.sh <json_file> [theme1] [theme2] ...
# Example: ./scripts/build.sh resume_full_stack_developer paper elegant

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <json_filename> [theme1] [theme2] ... | all"
    echo "Example: $0 resume_full_stack_developer paper elegant"
    echo "Example: $0 resume_full_stack_developer all"
    echo "Default theme: elegant"
    exit 1
fi

# Remove .json extension if provided
RESUME_NAME="${1%.json}"
shift

# All available themes
ALL_THEMES=("elegant" "paper" "onepage" "short" "kendall" "even" "stackoverflow" "macchiato" "spartan" "class" "classy" "slick" "caffeine" "compact")

# Default to elegant if no themes specified
if [ $# -eq 0 ]; then
    THEMES=("elegant")
elif [ "$1" = "all" ]; then
    THEMES=("${ALL_THEMES[@]}")
else
    THEMES=("$@")
fi

# Extract specialty from filename (remove "resume_" prefix)
SPECIALTY="${RESUME_NAME#resume_}"

JSON_FILE="source/json/${RESUME_NAME}.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: $JSON_FILE not found"
    exit 1
fi

for THEME in "${THEMES[@]}"; do
    OUTPUT_DIR="output/${SPECIALTY}/${THEME}"

    # Create output directory for this specialty/theme
    mkdir -p "$OUTPUT_DIR"

    echo "Building ${SPECIALTY} resume with theme: ${THEME}"

    # Generate HTML first (needed for DOCX and TXT conversion)
    echo "→ Generating HTML..."
    npx resume export "${OUTPUT_DIR}/resume.html" --resume "$JSON_FILE" --theme "$THEME"

    # Generate PDF
    echo "→ Generating PDF..."
    npx resume export "${OUTPUT_DIR}/resume.pdf" --resume "$JSON_FILE" --theme "$THEME"

    # Generate DOCX and TXT using pandoc (if available)
    if command -v pandoc &> /dev/null; then
        echo "→ Generating DOCX..."
        pandoc "${OUTPUT_DIR}/resume.html" -o "${OUTPUT_DIR}/resume.docx"

        echo "→ Generating TXT..."
        pandoc "${OUTPUT_DIR}/resume.html" -t plain -o "${OUTPUT_DIR}/resume.txt"
    else
        echo "⚠ Pandoc not installed - skipping DOCX and TXT generation"
        echo "  Install with: brew install pandoc"
    fi

    echo "✓ Done! Output in ${OUTPUT_DIR}/"
    echo ""
done
