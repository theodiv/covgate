#!/usr/bin/env bash
#
# Prints a release's notes from CHANGELOG.md: the [<version>] section, or
# [Unreleased] for a release candidate, whose entries stay there until the
# final release.
set -euo pipefail

version=${1:?usage: scripts/release-notes.sh <version>}
[[ $version == *rc* ]] && section=Unreleased || section=$version

# A section runs to the next release heading, or to the link definitions after
# the last one. GitHub renders every newline in release notes as a line break,
# so an entry's wrapped lines are joined back into one.
notes=$(awk -v heading="## [$section]" '
  found && (/^## / || /^\[[^]]*\]: /) { exit }
  found && !started && !NF { next }
  found && NF && pending ~ /^[^#]/ && /^[ \t]/ &&
    !/^[ \t]*([-*+]|[0-9]+[.)])[ \t]/ {
    sub(/^[ \t]+/, "")
    pending = pending " " $0
    next
  }
  found { if (started) print pending; started = 1; pending = NF ? $0 : "" }
  $0 == heading || index($0, heading " ") == 1 { found = 1 }
  END { if (started) print pending }
' CHANGELOG.md)

if [ -z "$notes" ]; then
  echo "::error::CHANGELOG.md holds no entries under [$section]" >&2
  exit 1
fi
printf "%s\n" "$notes"
