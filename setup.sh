#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
NVIM_VERSION="0.11.0"

# --- Architecture detection ---
ARCH="$(uname -m)"
case "$ARCH" in
    aarch64) NVIM_ARCH="arm64" ;;
    x86_64)  NVIM_ARCH="x86_64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# --- Symlink helper ---
make_link() {
    local src="$1"
    local dst="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        local current
        current="$(readlink "$dst")"
        if [ "$current" = "$src" ]; then
            echo "  ok: $dst"
            return
        fi
        echo "  update: $dst (was -> $current)"
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "  CONFLICT: $dst exists and is not a symlink — skipping"
        return
    else
        echo "  link: $dst"
    fi

    ln -s "$src" "$dst"
}

# --- Install neovim ---
echo "==> Neovim $NVIM_VERSION"
mkdir -p "$HOME/bin"

NVIM_DIR="$HOME/bin/nvim-linux-${NVIM_ARCH}"
if [ -x "$NVIM_DIR/bin/nvim" ]; then
    echo "  already installed at $NVIM_DIR"
else
    TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
    URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${TARBALL}"
    echo "  downloading $URL ..."
    curl -fsSL "$URL" -o "/tmp/$TARBALL"
    echo "  extracting to $NVIM_DIR ..."
    mkdir -p "$NVIM_DIR"
    tar xzf "/tmp/$TARBALL" -C "$HOME/bin/"
    rm "/tmp/$TARBALL"
fi

# Symlink nvim binary
ln -sf "$NVIM_DIR/bin/nvim" "$HOME/bin/nvim"
echo "  nvim -> $NVIM_DIR/bin/nvim"

# --- Install Nerd Font ---
echo "==> Nerd Font (JetBrainsMono)"
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono"
FONT_VERSION="3.3.0"

if ls "$FONT_DIR"/${FONT_NAME}*.ttf &>/dev/null; then
    echo "  already installed in $FONT_DIR"
else
    FONT_ZIP="${FONT_NAME}.zip"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/${FONT_ZIP}"
    echo "  downloading $FONT_URL ..."
    curl -fsSL "$FONT_URL" -o "/tmp/$FONT_ZIP"
    echo "  extracting to $FONT_DIR ..."
    mkdir -p "$FONT_DIR"
    python3 -c "
import zipfile, sys, os
with zipfile.ZipFile(sys.argv[1]) as z:
    for name in z.namelist():
        if name.endswith('.ttf'):
            z.extract(name, sys.argv[2])
" "/tmp/$FONT_ZIP" "$FONT_DIR"
    rm "/tmp/$FONT_ZIP"
    # Rebuild font cache if fc-cache is available
    if command -v fc-cache &>/dev/null; then
        fc-cache -f "$FONT_DIR"
    fi
    echo "  installed JetBrainsMono Nerd Font"
fi

# --- Create symlinks ---
echo "==> Symlinks"
make_link "$DOTFILES/nvim"            "$HOME/.config/nvim"
make_link "$DOTFILES/tmux/tmux.conf"  "$HOME/.tmux.conf"
make_link "$DOTFILES/git/gitconfig"   "$HOME/.gitconfig"
make_link "$DOTFILES/claude/agents"   "$HOME/.claude/agents"
make_link "$DOTFILES/claude/skills"  "$HOME/.claude/skills"

# --- Source dotfiles.bash from .bashrc ---
echo "==> Shell config"
SOURCE_LINE="source \"$DOTFILES/bash/dotfiles.bash\""
if [ -f "$HOME/.bashrc" ] && grep -qF "$SOURCE_LINE" "$HOME/.bashrc"; then
    echo "  ok: .bashrc already sources dotfiles.bash"
else
    echo "" >> "$HOME/.bashrc"
    echo "# Added by dotfiles/setup.sh" >> "$HOME/.bashrc"
    echo "$SOURCE_LINE" >> "$HOME/.bashrc"
    echo "  added source line to ~/.bashrc"
fi

# --- Install gopls if Go is available ---
echo "==> Language servers"
if command -v go &>/dev/null; then
    if command -v gopls &>/dev/null; then
        echo "  gopls already installed"
    else
        echo "  installing gopls..."
        go install golang.org/x/tools/gopls@latest
    fi
else
    echo "  go not found — skipping gopls install"
fi

# --- Summary ---
echo ""
echo "Done! Next steps:"
echo "  1. Reload your shell:    exec bash -l"
echo "  2. Launch neovim:        nvim"
echo "     (lazy.nvim will auto-install plugins on first launch)"
echo "  3. Start tmux:           tmux new -s main"
