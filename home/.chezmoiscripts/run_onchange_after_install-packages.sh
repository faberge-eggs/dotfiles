#!/bin/bash

# Run whenever Brewfile changes

set -e

echo "Brewfile changed, updating packages..."

cd "{{ .chezmoi.sourceDir }}/.."

# Update common packages
brew bundle --file=Brewfile

# Update machine-specific packages
{{- if eq .machineType "workato" }}
if [ -f "Brewfile.workato" ]; then
    echo "Updating workato-specific packages from Brewfile.workato..."
    brew bundle --file=Brewfile.workato
fi
{{- else if eq .machineType "own" }}
if [ -f "Brewfile.own" ]; then
    echo "Updating personal packages from Brewfile.own..."
    brew bundle --file=Brewfile.own
fi
{{- end }}

echo "Packages updated successfully"

# Hash of Brewfile to detect changes
# Brewfile hash: {{ include (joinPath .chezmoi.sourceDir "../Brewfile") | sha256sum }}
{{- if eq .machineType "workato" }}
# Brewfile.workato hash: {{ include (joinPath .chezmoi.sourceDir "../Brewfile.workato") | sha256sum }}
{{- else if eq .machineType "own" }}
# Brewfile.own hash: {{ include (joinPath .chezmoi.sourceDir "../Brewfile.own") | sha256sum }}
{{- end }}
