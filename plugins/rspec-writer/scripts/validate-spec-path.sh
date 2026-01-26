#!/bin/bash
# Validates that Write/Edit operations only target spec files
# Used by rspec-writer agents to prevent editing application code

# Read JSON input from stdin (Claude Code passes hook input as JSON)
INPUT=$(cat)

# Extract the file path from tool_input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  # No file path means this isn't a file operation we care about
  exit 0
fi

# Check if the path is within spec/ directory
if [[ "$FILE_PATH" == */spec/* ]] || [[ "$FILE_PATH" == spec/* ]]; then
  exit 0
fi

# Block non-spec file edits
echo "Blocked: RSpec agents can only write to spec/ directory. Attempted: $FILE_PATH" >&2
exit 2
