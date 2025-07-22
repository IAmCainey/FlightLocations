#!/bin/bash
# Build script for Flight Locations addon
# This script helps maintain proper versioning for releases

# Set script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDON_DIR="$SCRIPT_DIR"

# Version handling
if [ "$1" = "" ]; then
    echo "Usage: $0 <version> [release-notes]"
    echo "Example: $0 1.0.1 \"Bug fixes and performance improvements\""
    echo ""
    echo "Current version: $(grep -m1 "## Version:" FlightLocations.toc | cut -d' ' -f3)"
    exit 1
fi

NEW_VERSION="$1"
RELEASE_NOTES="$2"

# Validate version format (semantic versioning)
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must follow semantic versioning (e.g., 1.0.0)"
    exit 1
fi

echo "Building Flight Locations v$NEW_VERSION"

# Update .toc file
sed -i "s/^## Version:.*/## Version: $NEW_VERSION/" FlightLocations.toc

# Update build date in main file
BUILD_DATE=$(date +%Y-%m-%d)
sed -i "s/buildDate = \".*\"/buildDate = \"$BUILD_DATE\"/" FlightLocations.lua

# Update version history (this would need manual editing for changelog)
echo "TODO: Update Core/VersionManager.lua with new version entry"

# Create release directory
RELEASE_DIR="../FlightLocations-$NEW_VERSION"
mkdir -p "$RELEASE_DIR"

# Copy addon files (excluding development files)
cp -r * "$RELEASE_DIR/" 2>/dev/null || true
rm -f "$RELEASE_DIR/build.sh"
rm -f "$RELEASE_DIR/Config.example.lua"
rm -rf "$RELEASE_DIR/.git" 2>/dev/null || true

echo "Release package created: $RELEASE_DIR"
echo ""
echo "Next steps:"
echo "1. Update Core/VersionManager.lua with version $NEW_VERSION changelog"
echo "2. Test the addon thoroughly"
echo "3. Commit changes to version control"
echo "4. Create git tag: git tag v$NEW_VERSION"
echo "5. Package for distribution"

# Optional: Create zip package
if command -v zip >/dev/null 2>&1; then
    cd ..
    zip -r "FlightLocations-$NEW_VERSION.zip" "FlightLocations-$NEW_VERSION" -x "*.git*" "*.DS_Store*"
    echo "6. Zip package created: FlightLocations-$NEW_VERSION.zip"
fi
