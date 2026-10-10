#!/usr/bin/env bash
# Push ./rime back to the device. Open Trime and tap "Deploy" (部署) afterwards.
#
# Override the defaults with environment variables:
#   PKG=com.osfans.trime        ./script/push.sh
#   DEV=/some/other/rime/dir    ./script/push.sh
set -euo pipefail

PKG="${PKG:-com.osfans.trime.debug}"
DEV="${DEV:-/sdcard/Android/data/$PKG/files/rime}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIST="$ROOT/script/files.txt"

while read -r f; do
  [ -z "$f" ] && continue
  if [ ! -f "$ROOT/rime/$f" ]; then
    echo "skip (not in the working tree): rime/$f" >&2
    continue
  fi
  adb shell "mkdir -p '$DEV/$(dirname "$f")'" </dev/null
  adb push "$ROOT/rime/$f" "$DEV/$f" </dev/null
done < "$LIST"

echo
echo "Pushed. Now open Trime and tap Deploy (部署)."
