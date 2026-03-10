#!/bin/bash
set -euo pipefail

# Sync Contributions Script
# This script updates CONTRIBUTIONS.md with recent work from the workspace

WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/.openclaw/workspace}"
CONTRIB_FILE="CONTRIBUTIONS.md"

echo "=== Syncing Contributions ==="
echo "Workspace: $WORKSPACE_ROOT"
echo "Target: $CONTRIB_FILE"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_MONTH=$(date +%Y-%m)

# Check if we need to add a new month section
if ! grep -q "## $CURRENT_MONTH" "$CONTRIB_FILE"; then
    echo "Adding new month section: $CURRENT_MONTH"
    
    # Insert new month section after the header
    sed -i.bak "/^# Contributions/a\\
\\
## $CURRENT_MONTH\\
\\
_Contributions for this month will be added here._\\
" "$CONTRIB_FILE"
    
    rm -f "$CONTRIB_FILE.bak"
fi

# Check for recent git commits in workspace
if [ -d "$WORKSPACE_ROOT/.git" ]; then
    echo "Checking workspace git history..."
    
    # Get commits from last 7 days
    RECENT_COMMITS=$(cd "$WORKSPACE_ROOT" && git log --since="7 days ago" --pretty=format:"- %s (%ad)" --date=short 2>/dev/null || echo "")
    
    if [ -n "$RECENT_COMMITS" ]; then
        echo "Found recent commits:"
        echo "$RECENT_COMMITS"
    fi
fi

# Update last sync timestamp
if grep -q "_Last synced:" "$CONTRIB_FILE"; then
    sed -i.bak "s/_Last synced:.*/_Last synced: $CURRENT_DATE_/" "$CONTRIB_FILE"
    rm -f "$CONTRIB_FILE.bak"
else
    echo "" >> "$CONTRIB_FILE"
    echo "---" >> "$CONTRIB_FILE"
    echo "_Last synced: $CURRENT_DATE_" >> "$CONTRIB_FILE"
fi

echo "=== Sync Complete ==="
