#!/bin/bash

# Install Homebrew packages before applying dotfiles

set -e

echo "Installing Homebrew packages..."

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Please run bootstrap.sh first."
    exit 1
fi

# Navigate to the source directory
cd "{{ .chezmoi.sourceDir }}/.."

# Install common packages
echo "Installing common packages from Brewfile..."
brew bundle --file=Brewfile

# Install machine-specific packages
{{- if eq .machineType "workato" }}
if [ -f "Brewfile.workato" ]; then
    echo "Installing workato-specific packages from Brewfile.workato..."
    brew bundle --file=Brewfile.workato
fi
{{- else if eq .machineType "own" }}
if [ -f "Brewfile.own" ]; then
    echo "Installing personal packages from Brewfile.own..."
    brew bundle --file=Brewfile.own
fi
{{- end }}

echo "Homebrew packages installed successfully"
