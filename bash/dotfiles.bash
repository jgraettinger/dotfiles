# Dotfiles shell customizations — sourced from ~/.bashrc

# Ensure ~/bin is first on PATH (neovim tarball lives here,
# and must take priority over any system-packaged nvim).
export PATH="$HOME/bin:$PATH"

# SSH agent forwarding trick for tmux reconnects.
# When SSH agent-forwarding is active, the socket path is stored in
# SSH_AUTH_SOCK which gets stale when you detach/reattach tmux.
# This symlink gives a stable path that always points to the latest socket.
if [ -S "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/auth_sock" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/auth_sock"
fi
