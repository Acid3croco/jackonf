#!/usr/bin/env bash
# Bootstrap jackonf on a fresh Debian/Ubuntu machine.
#   git clone https://github.com/Acid3croco/jackonf.git ~/projects/jackonf
#   ~/projects/jackonf/install.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_VERSION="v0.12.2"

if ! command -v apt-get >/dev/null; then
  echo "This installer targets Debian/Ubuntu. Adapt for other systems."
  exit 1
fi

echo "==> Installing system packages"
sudo apt-get update
sudo apt-get install -y \
  git curl tmux zsh \
  ripgrep fd-find gcc make build-essential \
  fzf zoxide lazygit eza bat git-delta

if ! command -v nvim >/dev/null || ! nvim --version | head -1 | grep -qE 'v0\.(1[1-9]|[2-9])'; then
  echo "==> Installing Neovim $NVIM_VERSION to ~/.local/nvim"
  TMP="$(mktemp -d)"
  curl -fsSL "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz" -o "$TMP/nvim.tar.gz"
  rm -rf "$HOME/.local/nvim"
  mkdir -p "$HOME/.local/nvim" "$HOME/.local/bin"
  tar -xzf "$TMP/nvim.tar.gz" -C "$HOME/.local/nvim" --strip-components=1
  ln -sf "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"
  rm -rf "$TMP"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "  backed up existing $dst"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "  $dst -> $src"
}

echo "==> Symlinking dotfiles"
link "$REPO/.zshrc"            "$HOME/.zshrc"
link "$REPO/.tmux.conf"        "$HOME/.tmux.conf"
link "$REPO/.gitconfig"        "$HOME/.gitconfig"
link "$REPO/nvim"              "$HOME/.config/nvim"
link "$REPO/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "==> Setting zsh as default shell (may prompt for password)"
  chsh -s "$(command -v zsh)" || echo "  chsh failed — set manually: chsh -s $(command -v zsh)"
fi

echo "==> Bootstrapping Neovim plugins"
"$HOME/.local/bin/nvim" --headless "+Lazy! sync" "+qa" >/dev/null 2>&1 || true

echo
echo "==> Done. Open a new shell. Treesitter parsers finish on first nvim launch."
