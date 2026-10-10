#!/usr/bin/env bash
# Pull the hand-written Rime/Trime config from a connected device into ./rime.
#
# Override the defaults with environment variables:
#   PKG=com.osfans.trime        ./script/pull.sh
#   DEV=/some/other/rime/dir    ./script/pull.sh
set -euo pipefail

PKG="${PKG:-com.osfans.trime.debug}"
DEV="${DEV:-/sdcard/Android/data/$PKG/files/rime}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIST="$ROOT/script/files.txt"

while read -r f; do
  [ -z "$f" ] && continue
  mkdir -p "$ROOT/rime/$(dirname "$f")"
  adb pull -a "$DEV/$f" "$ROOT/rime/$f" </dev/null || rm -f "$ROOT/rime/$f"
done < "$LIST"

echo
echo "Done. Review the changes:"
git -C "$ROOT" status --short
