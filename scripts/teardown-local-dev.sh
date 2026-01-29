#!/bin/bash
#
# Revert Claude Code to load this marketplace from GitHub instead of local directory
#
# This script:
# 1. Updates ~/.claude/plugins/known_marketplaces.json to use GitHub source
#
# Usage: ./scripts/teardown-local-dev.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MARKETPLACE_NAME="claude-code-in-avinyc"
GITHUB_REPO="elvinra/claude-code-in-avinyc"
KNOWN_MARKETPLACES="$HOME/.claude/plugins/known_marketplaces.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "Reverting to GitHub source for $MARKETPLACE_NAME..."
echo ""

if [ ! -f "$KNOWN_MARKETPLACES" ]; then
    echo -e "${RED}Error: $KNOWN_MARKETPLACES not found${NC}"
    echo "Nothing to revert."
    exit 1
fi

# Check current source type
current_source=$(grep -A3 "\"$MARKETPLACE_NAME\"" "$KNOWN_MARKETPLACES" | grep '"source":' | head -1 | grep -o '"source": *"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' || echo "not found")

if [ "$current_source" = "github" ]; then
    echo -e "${GREEN}Already configured for GitHub${NC}"
    exit 0
fi

if [ "$current_source" = "not found" ]; then
    echo -e "${YELLOW}Marketplace not found in known_marketplaces.json${NC}"
    exit 0
fi

# Use node to update JSON properly
if command -v node &> /dev/null; then
    node -e "
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('$KNOWN_MARKETPLACES', 'utf8'));
if (data['$MARKETPLACE_NAME']) {
    data['$MARKETPLACE_NAME'].source = {
        source: 'github',
        repo: '$GITHUB_REPO'
    };
    data['$MARKETPLACE_NAME'].lastUpdated = new Date().toISOString();
    fs.writeFileSync('$KNOWN_MARKETPLACES', JSON.stringify(data, null, 2));
}
"
    echo -e "${GREEN}Reverted to GitHub source${NC}"
else
    echo -e "${YELLOW}Node.js not found. Please manually update $KNOWN_MARKETPLACES${NC}"
    echo "Change source from 'directory' to 'github' with repo: $GITHUB_REPO"
    exit 1
fi

echo ""
echo -e "${GREEN}Teardown complete.${NC}"
echo ""
echo "Next steps:"
echo "  1. Start a new Claude Code session"
echo "  2. Plugins will now load from GitHub"
