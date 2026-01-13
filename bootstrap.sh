#!/bin/bash

# macOS Bootstrap Script
# Sets up a new Mac with all necessary tools and configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is only for macOS"
    exit 1
fi

print_step "🚀 Starting macOS bootstrap process..."

# Detect machine type from hostname
detect_machine_type() {
    local hostname=$(hostname -s)
    case "$hostname" in
        own-*)
            echo "own"
            ;;
        workato-*)
            echo "workato"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Ask for machine type (environment > hostname > interactive)
if [ -n "$MACHINE_TYPE" ]; then
    print_step "Using machine type from environment: $MACHINE_TYPE"
else
    MACHINE_TYPE=$(detect_machine_type)
    if [ -n "$MACHINE_TYPE" ]; then
        print_step "Detected machine type from hostname: $MACHINE_TYPE"
    else
        echo "What type of machine is this?"
        echo "  1) own (personal machine)"
        echo "  2) workato (Workato work machine)"
        read -p "Select [1-2]: " -n 1 -r
        echo

        case $REPLY in
            1)
                MACHINE_TYPE="own"
                ;;
            2)
                MACHINE_TYPE="workato"
                ;;
            *)
                MACHINE_TYPE="own"
                print_warning "Invalid choice, defaulting to own (personal) machine..."
                ;;
        esac
    fi
fi

print_step "Configuring as $MACHINE_TYPE machine..."

# Get the directory where this script is located (the dotfiles repo)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_step "Dotfiles directory: $DOTFILES_DIR"

# Step 1: Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    print_step "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode installation in the dialog and run this script again."
    exit 0
else
    print_step "Xcode Command Line Tools already installed"
fi

# Step 2: Install Homebrew
if ! command -v brew &>/dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_step "Homebrew already installed"
fi

# Step 3: Update Homebrew
print_step "Updating Homebrew..."
brew update

# Step 4: Install essential tools first
print_step "Installing essential tools..."
brew install git chezmoi 1password-cli

# Step 5: Install packages from Brewfile
if [ -f "Brewfile" ]; then
    print_step "Installing packages from Brewfile..."
    brew bundle --file=Brewfile

    # Install machine-specific packages
    if [ "$MACHINE_TYPE" = "workato" ] && [ -f "Brewfile.workato" ]; then
        print_step "Installing workato-specific packages from Brewfile.workato..."
        brew bundle --file=Brewfile.workato
    elif [ "$MACHINE_TYPE" = "own" ] && [ -f "Brewfile.own" ]; then
        print_step "Installing personal packages from Brewfile.own..."
        brew bundle --file=Brewfile.own
    fi
else
    print_warning "Brewfile not found, skipping package installation"
fi

# Step 6: Set up Chezmoi
CHEZMOI_SOURCE_DIR="$HOME/.local/share/chezmoi"

if [ ! -d "$CHEZMOI_SOURCE_DIR" ]; then
    print_step "Initializing chezmoi..."

    # If this is being run from a git repo, use it as the source
    if git rev-parse --git-dir > /dev/null 2>&1; then
        REPO_URL=$(git config --get remote.origin.url)
        if [ -n "$REPO_URL" ]; then
            print_step "Initializing from repository: $REPO_URL"
            chezmoi init "$REPO_URL"
        else
            chezmoi init
        fi
    else
        chezmoi init
    fi
else
    print_step "Chezmoi already initialized"
fi

# Step 7: Copy dotfiles structure to chezmoi
if [ -d "$CHEZMOI_SOURCE_DIR/home" ]; then
    print_step "Chezmoi initialized from repository, using existing structure..."
    # Move files from home/ subdirectory to root
    cp -r "$CHEZMOI_SOURCE_DIR/home/"* "$CHEZMOI_SOURCE_DIR/"
    # Clean up the home directory to avoid confusion
    rm -rf "$CHEZMOI_SOURCE_DIR/home"
fi

# Always copy local files to get latest changes (overwrite repo version)
if [ -d "home" ]; then
    print_step "Copying latest dotfiles from local directory..."
    cp -r home/* "$CHEZMOI_SOURCE_DIR/"
fi

# Step 7.5: Set up host-specific chezmoi data file
HOSTNAME=$(hostname -s)
HOST_DATA_FILE=".chezmoidata_${HOSTNAME}.yaml"
HOST_DATA_PATH="$CHEZMOI_SOURCE_DIR/$HOST_DATA_FILE"

if [ ! -f "$HOST_DATA_PATH" ]; then
    print_step "Creating host-specific configuration for $HOSTNAME..."

    # Get user information from git config if available
    GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    GITHUB_USER=$(git config --global github.user 2>/dev/null || echo "")

    # Prompt for information if not available
    if [ -z "$GIT_NAME" ]; then
        read -p "Enter your full name: " GIT_NAME
    fi

    if [ -z "$GIT_EMAIL" ]; then
        read -p "Enter your email: " GIT_EMAIL
    fi

    if [ -z "$GITHUB_USER" ]; then
        read -p "Enter your GitHub username: " GITHUB_USER
    fi

    # Create the host data file
    cat > "$HOST_DATA_PATH" <<EOF
type: "$MACHINE_TYPE"
email: "$GIT_EMAIL"
name: "$GIT_NAME"
githubUsername: "$GITHUB_USER"
repoPath: "$DOTFILES_DIR"
EOF

    print_step "Created $HOST_DATA_FILE with:"
    echo "  - Name: $GIT_NAME"
    echo "  - Email: $GIT_EMAIL"
    echo "  - GitHub: $GITHUB_USER"
    echo "  - Machine Type: $MACHINE_TYPE"
    echo "  - Repo Path: $DOTFILES_DIR"
    echo ""
    print_warning "Consider adding this file to your dotfiles repo:"
    echo "  cd $DOTFILES_DIR && git add home/$HOST_DATA_FILE"
else
    print_step "Using existing host configuration: $HOST_DATA_FILE"
fi

# Step 7.6: Configure chezmoi with user data
print_step "Configuring chezmoi..."
mkdir -p "$HOME/.config/chezmoi"

# Get user information from git config if available
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
GITHUB_USER=$(git config --global github.user 2>/dev/null || echo "")

# Create chezmoi config with all required data
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
# Use dotfiles repo directly as source
sourceDir = "$DOTFILES_DIR/home"

[data]
    email = "${GIT_EMAIL:-user@example.com}"
    name = "${GIT_NAME:-Your Name}"
    githubUsername = "${GITHUB_USER:-yourusername}"
    machineType = "$MACHINE_TYPE"

[edit]
    command = "code"
    args = ["--wait"]

[diff]
    command = "code"
    args = ["--wait", "--diff"]

[git]
    autoCommit = false
    autoPush = false

[data.onepassword]
    enabled = true
EOF

print_step "Chezmoi configured with:"
echo "  - Name: ${GIT_NAME:-Your Name}"
echo "  - Email: ${GIT_EMAIL:-user@example.com}"
echo "  - GitHub: ${GITHUB_USER:-yourusername}"
echo "  - Machine: $MACHINE_TYPE"

# Step 8: Apply chezmoi configuration
print_step "Applying dotfiles with chezmoi..."
chezmoi apply

# Step 9: Run Ansible if available
if [ -f "playbook.yml" ] && command -v ansible-playbook &>/dev/null; then
    print_step "Running Ansible playbook..."
    ansible-playbook playbook.yml --ask-become-pass

    # Run machine-specific playbook
    if [ "$MACHINE_TYPE" = "workato" ] && [ -f "playbook.workato.yml" ]; then
        print_step "Running workato-specific Ansible playbook..."
        ansible-playbook playbook.workato.yml --ask-become-pass
    elif [ "$MACHINE_TYPE" = "own" ] && [ -f "playbook.own.yml" ]; then
        print_step "Running personal Ansible playbook..."
        ansible-playbook playbook.own.yml --ask-become-pass
    fi
fi

# Step 10: Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    print_step "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# Step 11: Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ""
print_step "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Sign in to 1Password and enable CLI access"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Review and customize configs with: chezmoi edit ~/.zshrc"
echo "  4. Run 'make update' to keep everything up to date"

if [ "$MACHINE_TYPE" = "workato" ]; then
    echo ""
    echo "Workato machine specific:"
    echo "  - Edit Brewfile.workato to add workato-specific packages"
    echo "  - Customize ~/.gitconfig.workato for workato git settings"
    echo "  - Source ~/.workato.env for workato environment variables"
    echo "  - Create ~/workato/ directory for workato projects"
elif [ "$MACHINE_TYPE" = "own" ]; then
    echo ""
    echo "Own machine specific:"
    echo "  - Edit Brewfile.own to add personal packages"
    echo "  - Customize ~/.gitconfig.own for personal git settings"
    echo "  - Source ~/.own.env for personal environment variables"
    echo "  - Projects in ~/Developer/personal/ use personal git config"
fi

echo ""
