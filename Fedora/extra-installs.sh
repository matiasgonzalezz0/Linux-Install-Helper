#!/usr/bin/env bash

# Tools that are not packaged for Fedora (or are better installed with their own installer)
# Run after installing packages-dnf.txt (needs the pyenv build dependencies) and after extra-setup.sh
# (Oh My Zsh replaces ~/.zshrc, so the nvm lines must be added after it)

# nvm + latest LTS node + pnpm (Fedora's pnpm package would drag in the system nodejs)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | PROFILE="$HOME/.zshrc" bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install --lts
npm install -g pnpm

# pyenv + pyenv-virtualenv (the installer includes both)
curl -fsSL https://pyenv.run | bash

# Claude Code (native installer, auto updates)
curl -fsSL https://claude.ai/install.sh | bash

# JetBrains Mono Nerd Font (not packaged for Fedora)
_font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
mkdir -p "$_font_dir"
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C "$_font_dir"
fc-cache -f

echo "Done! Remember to add the pyenv lines to your .zshrc: https://github.com/pyenv/pyenv#b-set-up-your-shell-environment-for-pyenv"
