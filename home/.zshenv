. "$HOME/.cargo/env"

# asdf (0.16+: Go binary from Homebrew, no script to source)
export ASDF_DATA_DIR="$HOME/.asdf"
case ":$PATH:" in
  *":$ASDF_DATA_DIR/shims:"*) ;;
  *) export PATH="$ASDF_DATA_DIR/shims:$PATH" ;;
esac

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
