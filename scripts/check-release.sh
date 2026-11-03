#!/usr/bin/env bash
#
# release.yml runs this first, so a tag that doesn't match __version__ or a
# commit off main stops the run before anything is built. Writes the version
# to build and whether it is a release candidate to $GITHUB_OUTPUT.
set -euo pipefail

version=$(sed -n 's/^__version__ = "\(.*\)"$/\1/p' src/covgate/__init__.py)
if [ -z "$version" ]; then
  echo "::error::src/covgate/__init__.py holds no __version__ line"
  exit 1
fi

case $GITHUB_EVENT_NAME in
  push)
    if [ "$GITHUB_REF" != "refs/tags/v$version" ]; then
      echo "::error::$GITHUB_REF does not match __version__; the tag must be v$version"
      exit 1
    fi
    ;;
  workflow_dispatch)
    if [ "$GITHUB_REF" != refs/heads/main ]; then
      echo "::error::A manual run starts from main, not $GITHUB_REF"
      exit 1
    fi
    # TestPyPI never accepts a file name twice, so each manual run builds a
    # development release of its own.
    version=$version.dev$GITHUB_RUN_NUMBER
    ;;
  *)
    echo "::error::$GITHUB_EVENT_NAME is neither a tag push nor a manual run"
    exit 1
    ;;
esac

if ! git merge-base --is-ancestor HEAD origin/main; then
  echo "::error::Commit $(git rev-parse --short HEAD) is not on main"
  exit 1
fi

[[ $version == *rc* ]] && prerelease=true || prerelease=false
{
  echo "version=$version"
  echo "prerelease=$prerelease"
} >> "$GITHUB_OUTPUT"
