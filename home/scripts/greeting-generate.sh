#!/usr/bin/env bash
DIR="$HOME/.local/share/greeting"
mkdir -p "$DIR"

claude -p 'Generate exactly 10 short (1-3 sentences each) tech tips about Linux, NixOS, CLI tools, or programming. Output ONLY a JSON array of strings, no markdown fences. Example: ["tip1","tip2"]' > "$DIR/tips.json.tmp"

# Validate JSON before replacing
if jq empty "$DIR/tips.json.tmp" 2>/dev/null; then
  mv "$DIR/tips.json.tmp" "$DIR/tips.json"
else
  rm -f "$DIR/tips.json.tmp"
fi
