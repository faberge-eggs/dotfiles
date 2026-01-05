#!/bin/bash
# Install Tmux Plugin Manager (TPM) and setup tmux directories

TPM_DIR="$HOME/.tmux/plugins/tpm"
RESURRECT_DIR="$HOME/.tmux/resurrect"

# Install TPM
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "TPM installed. Press prefix + I in tmux to install plugins."
else
    echo "TPM already installed"
fi

# Create resurrect directory for tmux-resurrect/continuum
mkdir -p "$RESURRECT_DIR"
