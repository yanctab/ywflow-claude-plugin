#!/bin/bash

# Test suite for plugin manifest fields
# Validates plugin.json after separation of marketplace into its own repo

PLUGIN_JSON=".claude-plugin/plugin.json"
ERRORS=0

check_criterion() {
    local name="$1"
    local check="$2"

    if eval "$check"; then
        echo "PASS: $name"
        return 0
    else
        echo "FAIL: $name"
        ERRORS=$((ERRORS + 1))
        return 1
    fi
}

check_criterion 'plugin.json name is "ywflow"' \
    "[ \"\$(jq -r '.name' '$PLUGIN_JSON')\" = 'ywflow' ]"

check_criterion 'plugin.json version is semver (X.Y.Z)' \
    "jq -r '.version' '$PLUGIN_JSON' | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'"

check_criterion 'plugin.json repository is "https://github.com/yanctab/ywflow-claude-plugin"' \
    "[ \"\$(jq -r '.repository' '$PLUGIN_JSON')\" = 'https://github.com/yanctab/ywflow-claude-plugin' ]"

check_criterion 'plugin.json description unchanged' \
    "[ \"\$(jq -r '.description' '$PLUGIN_JSON')\" = 'Repeatable, deterministic development workflow for new projects via a Makefile contract' ]"

check_criterion 'plugin.json license is "MIT"' \
    "[ \"\$(jq -r '.license' '$PLUGIN_JSON')\" = 'MIT' ]"

check_criterion 'plugin.json author.name is "yanctab"' \
    "[ \"\$(jq -r '.author.name' '$PLUGIN_JSON')\" = 'yanctab' ]"

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "All manifest tests passed."
    exit 0
else
    echo "$ERRORS test(s) failed."
    exit 1
fi
