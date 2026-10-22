# Added by ForgeCode installer
export PATH="$HOME/.local/bin:$PATH"
# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# ------------------------------------------------------------------------------

#
# ~/.zshrc
#
# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

# Export path to root of dotfiles repo
export DOTFILES=${DOTFILES:="$HOME/.dotfiles"}

# Ensure Java 17 is the default
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
# export JAVA_HOME=$(/usr/libexec/java_home -v 11)

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PATH=/opt/homebrew/bin:$PATH

# Personal aliases and env live in custom/ (loaded further down via zgen) so
# that upstream merges never conflict with them.

# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# Extend $PATH without duplicates
_extend_path() {
  [[ -d "$1" ]] || return

  if ! echo "$PATH" | tr ":" "\n" | grep -qx "$1" ; then
    export PATH="$1:$PATH"
  fi
}

# Add custom bin to $PATH
_extend_path "$HOME/.local/bin" # local bins
_extend_path "$DOTFILES/bin" # custom scripts
_extend_path "$HOME/.npm-global/bin" # npm global packages
_extend_path "$HOME/.rvm/bin" # RVM
_extend_path "$HOME/.yarn/bin" # Yarn
_extend_path "$HOME/.config/yarn/global/node_modules/.bin" # Yarn global packages
_extend_path "$HOME/.bun/bin" # Bun
_extend_path "$HOME/.rd/bin" # Rancher Desktop

# Extend $NODE_PATH
if [ -d "$HOME/.npm-global" ]; then
  export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"
fi

# Default pager
export PAGER='less'

# less options
less_opts=(
  # Quit if entire file fits on first screen.
  -FX
  # Ignore case in searches that do not contain uppercase.
  --ignore-case
  # Allow ANSI colour escapes, but no other escapes.
  --RAW-CONTROL-CHARS
  # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
  --quiet
  # Do not complain when we are on a dumb terminal.
  --dumb
)
export LESS="${less_opts[*]}"

# Default editor for local and remote sessions
if [[ -n "$SSH_CONNECTION" ]]; then
  # on the server
  if command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
else
  export EDITOR='vim'
fi

# Better formatting for time command
export TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------
export ZSH_DISABLE_COMPFIX=true

# SSH agent lazy loading and quiet mode
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes

# NOTE: upstream also sets `zstyle ':omz:plugins:nvm' autoload true` here. Node
# comes from asdf on this machine and the nvm plugin is not loaded, so it is
# omitted deliberately.

# Use passphase from macOS keychain
if [[ "$OSTYPE" == "darwin"* ]]; then
  zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
fi

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

# Spaceship project directory (for local development)
SPACESHIP_PROJECT="$HOME/Projects/Repos/spaceship/spaceship-prompt"

# Reset zgen on change
export ZGEN_RESET_ON_CHANGE=(
  "${HOME}/.zshrc"
  "${DOTFILES}"/lib/*.zsh
  "${DOTFILES}"/custom/*.zsh
)
# Load zgen
source "${HOME}/.zgen/zgen.zsh"

# Load zgen init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # Oh-My-Zsh plugins
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/tmux
    zgen oh-my-zsh plugins/history-substring-search
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/yarn
    zgen oh-my-zsh plugins/fnm
    zgen oh-my-zsh plugins/pyenv
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/ssh-agent
    zgen oh-my-zsh plugins/gpg-agent
    zgen oh-my-zsh plugins/macos
    zgen oh-my-zsh plugins/vscode
    zgen oh-my-zsh plugins/gh
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/node
    zgen oh-my-zsh plugins/deno
    zgen oh-my-zsh plugins/bun
    zgen oh-my-zsh plugins/tldr
    zgen oh-my-zsh plugins/fzf

    # Like cd but with z-zsh capabilities
    if command -v zoxide >/dev/null 2>&1; then
      zgen oh-my-zsh plugins/zoxide
    fi

    # Per-directory env vars
    if command -v direnv >/dev/null 2>&1; then
      zgen oh-my-zsh plugins/direnv
    fi

    # Custom plugins
    zgen load chriskempson/base16-shell
    zgen load djui/alias-tips
    zgen load hlissner/zsh-autopair
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load Aloxaf/fzf-tab

    # Files
    zgen load $DOTFILES/lib
    zgen load $DOTFILES/custom

    # Load Spaceship prompt from remote
    if [[ ! -d "$SPACESHIP_PROJECT" ]]; then
      zgen load spaceship-prompt/spaceship-prompt spaceship
    fi

    # Completions
    zgen load zsh-users/zsh-completions src

    # Save all to init script
    zgen save
fi

# Load Spaceship form local project
if [[ -d "$SPACESHIP_PROJECT" ]]; then
  source "$SPACESHIP_PROJECT/spaceship.zsh"
fi

# ------------------------------------------------------------------------------
# Init tools
# ------------------------------------------------------------------------------

# asdf version manager (0.16+ is a Go binary — nothing to source; it works off
# ASDF_DATA_DIR from .zshenv plus $ASDF_DATA_DIR/shims on PATH). Completions
# ship with the Homebrew formula.
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# NOTE: zoxide is initialised by upstream's `plugins/zoxide` above, so it is
# deliberately not re-initialised here.

# ------------------------------------------------------------------------------
# Load additional zsh files
# ------------------------------------------------------------------------------

# OpenAI Codex CLI completions
if _exists codex; then
  eval "$(codex completion zsh)"
fi

# Bazel environment variables
if [[ -f "$HOME/.bazelenv" ]]; then
  source "$HOME/.bazelenv"
fi

# ------------------------------------------------------------------------------
# Overrides
# ------------------------------------------------------------------------------

# Source local configuration
if [[ -f "$HOME/.zshlocal" ]]; then
  source "$HOME/.zshlocal"
fi

# ------------------------------------------------------------------------------

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
source /Users/aryan.singhal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Added by `rbenv init` on Thu Jan 16 11:24:55 IST 2025
eval "$(rbenv init - --no-rehash zsh)"
export PATH=/usr/local/bin:/Users/aryan.singhal/.rbenv/shims:/Users/aryan.singhal/.bun/bin:/Users/aryan.singhal/.bun/bin:/Users/aryan.singhal/.config/yarn/global/node_modules/.bin:/Users/aryan.singhal/.yarn/bin:/Users/aryan.singhal/.dotfiles/bin:/opt/homebrew/bin:/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin:/Users/aryan.singhal/.rbenv/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/aryan.singhal/Library/Android/sdk/platform-tools:/Users/aryan.singhal/Library/Android/sdk/tools/bin:/Users/aryan.singhal/Library/Android/sdk/tools:/Users/aryan.singhal/Library/Android/sdk/emulator:/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/usr/local/go/bin

# asdf 0.16+ has no bin/ dir — the binary comes from Homebrew. Only the shims
# need re-adding here, since the hardcoded PATH above drops what .zshenv set.
_extend_path "$ASDF_DATA_DIR/shims"

# pnpm — PNPM_HOME is exported from .zshenv; re-add to PATH because the
# hardcoded `export PATH=...` above drops everything .zshenv set up.
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/Users/aryan.singhal/.opencode/bin:$PATH

# kilo
export PATH=/Users/aryan.singhal/.kilo/bin:$PATH

# >>> forge initialize >>>
# !! Contents within this block are managed by 'forge zsh setup' !!
# !! Do not edit manually - changes will be overwritten !!

# Add required zsh plugins if not already present
if [[ ! " ${plugins[@]} " =~ " zsh-autosuggestions " ]]; then
    plugins+=(zsh-autosuggestions)
fi
if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
    plugins+=(zsh-syntax-highlighting)
fi

# Load forge shell plugin (commands, completions, keybindings) if not already loaded
if command -v forge >/dev/null 2>&1 && [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
    eval "$(forge zsh plugin)"
fi

# Load forge shell theme (prompt with AI context) if not already loaded
if command -v forge >/dev/null 2>&1 && [[ -z "$_FORGE_THEME_LOADED" ]]; then
    eval "$(forge zsh theme)"
fi

# Disable Nerd Fonts (set during setup - icons not displaying correctly)
# To re-enable: remove this line and install a Nerd Font from https://www.nerdfonts.com/
export NERD_FONT=0
# <<< forge initialize <<<

# Added by Antigravity
export PATH="/Users/aryan.singhal/.antigravity/antigravity/bin:$PATH"

# Drop cmux's claude wrapper if it was injected without _CMUX_CLAUDE_WRAPPER set
claude_unwrap() {
  if typeset -f claude >/dev/null 2>&1 && [[ -z "$_CMUX_CLAUDE_WRAPPER" ]]; then
    unfunction claude
  fi
}
claude_unwrap
# Re-check just before each prompt — cmux may inject the wrapper after .zshrc runs
autoload -Uz add-zsh-hook && add-zsh-hook precmd claude_unwrap
export PATH="$HOME/.local/bin:$PATH"

# Rust/cargo — re-add after the hardcoded PATH reset above (line ~227) drops it.
# .cargo/env is idempotent (no-op if already on PATH).
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Homebrew curl (keg-only) ahead of /usr/bin/curl, whose CA bundle Apple hasn't updated.
# Kept last because the hardcoded PATH above drops what .zshenv set.
case ":$PATH:" in
  *":/opt/homebrew/opt/curl/bin:"*) ;;
  *) export PATH="/opt/homebrew/opt/curl/bin:$PATH" ;;
esac
