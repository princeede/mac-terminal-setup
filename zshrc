# Work setup. Loaded from one line in ~/.zshrc, so it adds to that file.

for prefix in "${HOMEBREW_PREFIX:-}" /opt/homebrew /usr/local; do
  if [ -n "$prefix" ] && [ -d "$prefix/share/zsh-autosuggestions" ]; then
    WORK_BREW_SHARE="$prefix/share"
    break
  fi
done
WORK_BREW_SHARE="${WORK_BREW_SHARE:-/opt/homebrew/share}"

# Completion
[ -d "$WORK_BREW_SHARE/zsh-completions" ] && fpath=("$WORK_BREW_SHARE/zsh-completions" $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Tools (each is skipped if not installed)
command -v mise     >/dev/null && eval "$(mise activate zsh)"
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v fzf      >/dev/null && source <(fzf --zsh)
command -v starship >/dev/null && eval "$(starship init zsh)"

# Aliases
command -v eza >/dev/null && alias ls='eza' ll='eza -la --git'
command -v bat >/dev/null && alias cat='bat --paging=never'
command -v lazygit >/dev/null && alias lg='lazygit'

# Autocomplete. Order matters: fzf-tab first, syntax highlighting last.
if command -v carapace >/dev/null; then
  export CARAPACE_BRIDGES='zsh,bash'
  source <(carapace _carapace zsh)
fi
[ -r "$WORK_BREW_SHARE/fzf-tab/fzf-tab.zsh" ] && source "$WORK_BREW_SHARE/fzf-tab/fzf-tab.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[ -r "$WORK_BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$WORK_BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -r "$WORK_BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$WORK_BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
