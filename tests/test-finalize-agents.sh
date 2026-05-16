#!/bin/bash

# Test suite for finalize agents - verifies ${CLAUDE_PLUGIN_ROOT} replacement
# in claude-plugin-finalize.md and rust-cli-finalize.md

CLAUDE_PLUGIN_AGENT="agents/claude-plugin-finalize.md"
RUST_CLI_AGENT="agents/rust-cli-finalize.md"
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

# Criterion 1: claude-plugin-finalize.md command value uses ${CLAUDE_PLUGIN_ROOT}
check_criterion "claude-plugin-finalize: command uses \${CLAUDE_PLUGIN_ROOT}" \
    "grep -q '\${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-lint.sh' '$CLAUDE_PLUGIN_AGENT'"

# Criterion 2: claude-plugin-finalize.md instruction says to expand at write time
check_criterion "claude-plugin-finalize: instruction says expand \$CLAUDE_PLUGIN_ROOT at write time" \
    "grep -qi 'expand.*CLAUDE_PLUGIN_ROOT.*write\|CLAUDE_PLUGIN_ROOT.*expand.*write\|expand.*at write' '$CLAUDE_PLUGIN_AGENT'"

# Criterion 3: rust-cli-finalize.md command value uses ${CLAUDE_PLUGIN_ROOT}
check_criterion "rust-cli-finalize: command uses \${CLAUDE_PLUGIN_ROOT}" \
    "grep -q '\${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-lint.sh' '$RUST_CLI_AGENT'"

# Criterion 4: rust-cli-finalize.md instruction says to expand at write time
check_criterion "rust-cli-finalize: instruction says expand \$CLAUDE_PLUGIN_ROOT at write time" \
    "grep -qi 'expand.*CLAUDE_PLUGIN_ROOT.*write\|CLAUDE_PLUGIN_ROOT.*expand.*write\|expand.*at write' '$RUST_CLI_AGENT'"

# Criterion 5: Neither agent contains the old hardcoded path
check_criterion "claude-plugin-finalize: no hardcoded cache path" \
    "! grep -q 'plugins/cache/yanct-claude-plugin/yanct-claude-plugin/.*hooks/post-edit-lint.sh' '$CLAUDE_PLUGIN_AGENT'"

check_criterion "rust-cli-finalize: no hardcoded cache path" \
    "! grep -q 'plugins/cache/yanct-claude-plugin/yanct-claude-plugin/.*hooks/post-edit-lint.sh' '$RUST_CLI_AGENT'"

# Criterion 6: Both agents instruct NOT to leave literal ${CLAUDE_PLUGIN_ROOT} in output file
check_criterion "claude-plugin-finalize: output must not contain unexpanded variable" \
    "grep -qi 'must not.*appear\|not.*appear.*output\|literal.*must not\|\\\$CLAUDE_PLUGIN_ROOT.*must not' '$CLAUDE_PLUGIN_AGENT'"

check_criterion "rust-cli-finalize: output must not contain unexpanded variable" \
    "grep -qi 'must not.*appear\|not.*appear.*output\|literal.*must not\|\\\$CLAUDE_PLUGIN_ROOT.*must not' '$RUST_CLI_AGENT'"

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "All finalize-agent tests passed."
    exit 0
else
    echo "$ERRORS test(s) failed."
    exit 1
fi
