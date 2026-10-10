#!/usr/bin/env bash
# Snapshot the Trime data that lives OUTSIDE the Rime user dir into ./backup:
# the Collection ("收藏夹", collection.db) and the clipboard history
# (clipboard.db) — both Room/SQLite databases in the app's private storage.
#
# These are NOT Rime config, and they contain personal data, so ./backup is
# gitignored and must never be committed or pushed.
#
# Only works for a debuggable build (uses `run-as`). For the release build the
# only safety net is the system auto backup (the manifest sets allowBackup).
#
# Override the package with:  PKG=com.osfans.trime ./script/backup-collection.sh
set -euo pipefail

PKG="${PKG:-com.osfans.trime.debug}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/backup"

mkdir -p "$OUT"

# A consistent snapshot needs the main .db plus its -wal and -shm sidecars:
# in WAL mode the most recent writes may still only be in the -wal file.
for db in collection clipboard; do
  for suffix in "" "-wal" "-shm"; do
    file="databases/$db.db$suffix"
    if adb shell "run-as $PKG ls '$file'" >/dev/null 2>&1; then
      adb exec-out run-as "$PKG" cat "$file" > "$OUT/$db.db$suffix"
    fi
  done
done

ls -l "$OUT"
echo
echo "Snapshot written to $OUT (gitignored). It contains personal data — do not commit."
