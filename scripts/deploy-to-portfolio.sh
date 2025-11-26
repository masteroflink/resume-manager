#!/bin/bash

# Deploy resume PDF to portfolio website
# Usage: ./scripts/deploy-to-portfolio.sh <resume_name> [theme]
# Example: ./scripts/deploy-to-portfolio.sh resume_full_stack_developer elegant

set -e

PORTFOLIO_REPO="https://github.com/masteroflink/portfolio.git"
PORTFOLIO_PDF_PATH="public/bruce_bruno_f_resume.pdf"
TEMP_DIR="/tmp/portfolio-deploy-$$"

if [ -z "$1" ]; then
    echo "Usage: $0 <resume_name> [theme]"
    echo "Example: $0 resume_full_stack_developer stackoverflow"
    echo "Default theme: stackoverflow"
    exit 1
fi

RESUME_NAME="${1%.json}"
THEME="${2:-stackoverflow}"

# Extract specialty from filename
SPECIALTY="${RESUME_NAME#resume_}"

# Path to the generated PDF
PDF_SOURCE="output/${SPECIALTY}/${THEME}/resume.pdf"

# First, build the resume if it doesn't exist or force rebuild
echo "Building resume with theme: ${THEME}..."
./scripts/build.sh "$RESUME_NAME" "$THEME"

# Verify PDF was created
if [ ! -f "$PDF_SOURCE" ]; then
    echo "Error: PDF not found at $PDF_SOURCE"
    exit 1
fi

echo ""
echo "Deploying to portfolio..."

# Clone portfolio repo to temp directory
echo "→ Cloning portfolio repository..."
git clone --depth 1 "$PORTFOLIO_REPO" "$TEMP_DIR"

# Copy the PDF
echo "→ Copying resume PDF..."
cp "$PDF_SOURCE" "$TEMP_DIR/$PORTFOLIO_PDF_PATH"

# Commit and push
cd "$TEMP_DIR"
git add "$PORTFOLIO_PDF_PATH"

if git diff --staged --quiet; then
    echo "→ No changes detected - resume is already up to date"
else
    echo "→ Committing changes..."
    git commit -m "Update resume PDF

Built from: ${RESUME_NAME}.json
Theme: ${THEME}

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

    echo "→ Pushing to GitHub..."
    git push origin main
    echo ""
    echo "✓ Resume deployed successfully!"
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo ""
echo "Portfolio will update at: https://masteroflink.github.io/portfolio/"
