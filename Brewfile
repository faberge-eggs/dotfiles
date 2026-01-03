# Homebrew Bundle
# Manages all macOS packages, casks, and Mac App Store apps
#
# Usage:
#   brew bundle          # Install everything
#   brew bundle cleanup  # Remove packages not in this file
#   brew bundle dump     # Generate from current installation

# ===== Taps =====
# Note: Most taps are deprecated and no longer needed
# Homebrew now includes casks, fonts, and services by default

# ===== Essential Tools =====
brew "mas"                      # Mac App Store CLI
brew "chezmoi"                  # Dotfiles manager
cask "1password-cli"            # 1Password CLI for secrets

# ===== Shell & Terminal =====
brew "zsh"                      # Modern shell
brew "zsh-autosuggestions"      # Fish-like autosuggestions
brew "zsh-syntax-highlighting"  # Syntax highlighting for Zsh
brew "starship"                 # Cross-shell prompt
brew "tmux"                     # Terminal multiplexer

# ===== Editors =====
brew "vim"                      # Classic text editor
brew "neovim"                   # Modern Vim fork (LazyVim)

# ===== Development Tools - Version Control =====
brew "git"                      # Version control
brew "gh"                       # GitHub CLI
brew "git-lfs"                  # Git Large File Storage
brew "git-delta"                # Better git diff
brew "lazygit"                  # Terminal UI for git

# ===== Development Tools - Languages & Runtimes =====
brew "node"                     # JavaScript runtime
brew "python@3.11"              # Python 3.11
brew "go"                       # Go language
brew "rust"                     # Rust language
brew "ruby"                     # Ruby language

# ===== Development Tools - Containers & Infrastructure =====
cask "docker-desktop"           # Docker Desktop (includes CLI)
brew "kubernetes-cli"           # Kubernetes CLI
brew "helm"                     # Kubernetes package manager
brew "terraform"                # Infrastructure as code
brew "ansible"                  # Automation tool

# ===== Development Tools - Build & Package Managers =====
brew "make"                     # Build automation

# ===== Modern CLI Utilities - File Operations =====
brew "bat"                      # Better cat with syntax highlighting
brew "eza"                      # Better ls (maintained fork of exa)
brew "fd"                       # Better find
brew "ripgrep"                  # Better grep (faster)
brew "fzf"                      # Fuzzy finder
brew "the_silver_searcher"      # Code search tool (ag)

# ===== Modern CLI Utilities - System & Monitoring =====
brew "htop"                     # Interactive process viewer
brew "btop"                     # Better top/htop
brew "ncdu"                     # Disk usage analyzer
brew "glances"                  # System monitoring
brew "duf"                      # Better df

# ===== Modern CLI Utilities - Text & Data Processing =====
brew "jq"                       # JSON processor
brew "yq"                       # YAML processor
brew "fx"                       # JSON viewer
brew "glow"                     # Markdown renderer

# ===== Modern CLI Utilities - Network =====
brew "httpie"                   # Better curl
brew "wget"                     # File downloader
brew "curl"                     # Transfer data
# Note: dig is built-in on macOS, use 'doggo' if you need a modern alternative

# ===== Modern CLI Utilities - Other =====
brew "tldr"                     # Simplified man pages
brew "tree"                     # Directory tree viewer
brew "watch"                    # Execute commands periodically
brew "rename"                   # Rename files
brew "tokei"                    # Count lines of code
brew "procs"                    # Better ps

# ===== Development Casks =====
cask "visual-studio-code"       # Code editor
cask "iterm2"                   # Better terminal
cask "warp"                     # Modern terminal
cask "postman"                  # API testing
cask "tableplus"                # Database GUI

# ===== Productivity Apps - Utilities =====
cask "alfred"                   # Spotlight replacement
cask "rectangle"                # Window management
cask "raycast"                  # Launcher and productivity tool
cask "bartender"                # Menu bar organizer
cask "cleanshot"                # Screenshot tool
cask "appcleaner"               # App uninstaller

# ===== Productivity Apps - Communication =====
cask "slack"                    # Team communication
cask "zoom"                     # Video conferencing
cask "telegram"                 # Messaging
cask "whatsApp"

# ===== Browsers =====
cask "firefox"                  # Firefox browser
cask "brave-browser"            # Privacy-focused browser

# ===== Security & Privacy =====
cask "1password"                # Password manager
cask "little-snitch"            # Firewall
cask "mullvad-vpn"              # VPN client

# ===== Media & Graphics =====
cask "vlc"                      # Media player
cask "spotify"                  # Music streaming
cask "imageoptim"               # Image optimizer
cask "gimp"                     # Image editor

# ===== Fonts =====
# Note: Fonts now use "homebrew-cask-fonts" prefix in newer Homebrew
cask "font-fira-code"           # Fira Code with ligatures
cask "font-jetbrains-mono"      # JetBrains Mono
cask "font-hack-nerd-font"      # Hack Nerd Font
cask "font-meslo-lg-nerd-font"  # Meslo for Powerlevel10k
cask "font-source-code-pro"     # Source Code Pro
cask "font-cascadia-code"       # Cascadia Code

# ===== Mac App Store Apps =====
# Find app IDs with: mas search "App Name"
# NOTE: Sign into Mac App Store GUI first (open -a "App Store")
# Verify sign-in by running: mas list
# Uncomment the apps you want to install:

mas "Xcode", id: 497799835
mas "1Password for Safari", id: 1569813296
mas "The Unarchiver", id: 425424353
mas "Amphetamine", id: 937984704  # Keep-awake utility
mas "copyclip", id: 595191960

cask "chatgpt"

# Custom tap for apps not in official Homebrew
tap "faberge-eggs/custom", "#{File.dirname(__FILE__)}/homebrew-custom"

# Custom casks from local tap
cask "cleanmymac"

