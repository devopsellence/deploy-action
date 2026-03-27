#!/usr/bin/env bash
set -euo pipefail

workspace="${GITHUB_WORKSPACE:-/github/workspace}"

if command -v git >/dev/null 2>&1; then
  if [ -d "${workspace}/.git" ]; then
    git config --global --add safe.directory "${workspace}" >/dev/null 2>&1 || true
  fi

  current_dir="$(pwd)"
  if [ -d "${current_dir}/.git" ]; then
    git config --global --add safe.directory "${current_dir}" >/dev/null 2>&1 || true
  fi
fi

exec devopsellence "$@"
