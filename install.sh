#!/usr/bin/env bash
# Work laptop setup. Safe to rerun. It adds to existing config and never replaces it.
#   ./install.sh                 install tools and config
#   ./install.sh --config-only   config only, no Homebrew or runtimes
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.work-setup"
CONFIG_ONLY=false
[ "${1:-}" = "--config-only" ] && CONFIG_ONLY=true

add_line() {
  touch "$1"
  if grep -qxF "$2" "$1"; then
    echo "ok      $1"
  else
    printf '\n# Work setup\n%s\n' "$2" >> "$1"
    echo "added   $1"
  fi
}

# Only sets a value you don't already have
set_git() {
  if git config --global --get "$1" >/dev/null 2>&1; then
    echo "kept    git $1"
  else
    git config --global "$1" "$2"
    echo "set     git $1"
  fi
}

ask_git() {
  local value=""
  if git config --global --get "$1" >/dev/null 2>&1; then
    echo "kept    git $1"
    return
  fi
  read -r -p "$2: " value || true
  if [ -n "$value" ]; then
    git config --global "$1" "$value"
    echo "set     git $1"
  else
    echo "WARNING: git $1 not set"
  fi
}

if [ "$CONFIG_ONLY" = false ]; then
  BREW=""
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then BREW="$candidate"; break; fi
  done
  if [ -z "$BREW" ]; then
    echo "Homebrew isn't installed, so nothing was changed."
    echo "Check with IT how command-line tools should be installed on this laptop."
    exit 1
  fi
  eval "$("$BREW" shellenv)"
  brew bundle --file "$SRC/Brewfile" || echo "WARNING: some tools failed. See the output above."
  # zsh refuses completions from group-writable folders
  chmod go-w "$(brew --prefix)/share" || true
fi

# Config
mkdir -p "$DEST"
cp "$SRC/zshrc" "$SRC/gitignore_global" "$DEST/"
add_line "$HOME/.zshrc" '[ -r "$HOME/.work-setup/zshrc" ] && source "$HOME/.work-setup/zshrc"'
add_line "$HOME/.zshenv" '[ -d "$HOME/.local/share/mise/shims" ] && export PATH="$HOME/.local/share/mise/shims:$PATH"'

ask_git user.name "Name for git commits"
ask_git user.email "Work email for git commits"
set_git init.defaultBranch main
set_git push.autoSetupRemote true
set_git fetch.prune true
set_git merge.conflictstyle zdiff3
set_git core.excludesFile "$DEST/gitignore_global"
if command -v delta >/dev/null; then
  set_git core.pager delta
  set_git interactive.diffFilter "delta --color-only"
  set_git delta.navigate true
fi

# Node, only if this laptop doesn't already have it
if [ "$CONFIG_ONLY" = false ]; then
  if command -v node >/dev/null; then
    echo "kept    existing Node $(node -v)"
  else
    mise use -g node@lts pnpm@latest || echo "WARNING: Node install failed. The network may block it."
  fi
fi

echo
echo "Done. Open a new terminal window."
