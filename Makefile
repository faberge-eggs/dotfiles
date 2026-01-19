.PHONY: help install update config ansible clean check doctor test

# Default shell
SHELL := /bin/bash

# Detect machine type from hostname (own-m1 -> own, workato-m4 -> workato)
HOSTNAME := $(shell hostname -s)
MACHINE_TYPE := $(if $(filter own-%,$(HOSTNAME)),own,$(if $(filter workato-%,$(HOSTNAME)),workato,))

# Colors for output
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

# Help target
help: ## Show this help message
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "  ${YELLOW}%-15s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

## Installation Commands
install: ## Full installation (bootstrap everything)
	@echo "${GREEN}Running bootstrap...${RESET}"
	@./bootstrap.sh

install-brew: ## Install Homebrew packages from Brewfile
	@echo "${GREEN}Installing Homebrew packages...${RESET}"
	@echo "Machine type: ${MACHINE_TYPE}"
	@brew bundle --file=Brewfile
ifneq ($(MACHINE_TYPE),)
	@if [ -f "Brewfile.$(MACHINE_TYPE)" ]; then \
		echo "${GREEN}Installing ${MACHINE_TYPE}-specific packages...${RESET}"; \
		brew bundle --file=Brewfile.$(MACHINE_TYPE); \
	fi
endif

install-chezmoi: ## Initialize and apply chezmoi dotfiles
	@echo "${GREEN}Applying dotfiles with chezmoi...${RESET}"
	@chezmoi init --apply
	@chezmoi apply -v

## Update Commands
update: ## Update everything (Homebrew, packages, dotfiles)
	@echo "${GREEN}Updating Homebrew...${RESET}"
	@brew update
	@echo "${GREEN}Upgrading packages...${RESET}"
	@brew upgrade
	@echo "${GREEN}Updating dotfiles...${RESET}"
	@chezmoi update -v
	@echo "${GREEN}Update complete!${RESET}"

update-brew: ## Update Homebrew and upgrade packages
	@echo "${GREEN}Updating Homebrew...${RESET}"
	@brew update
	@brew upgrade

update-dotfiles: ## Update dotfiles with chezmoi
	@echo "${GREEN}Updating dotfiles...${RESET}"
	@chezmoi update -v

update-brewfile: ## Update Brewfile from currently installed packages
	@echo "${GREEN}Updating Brewfile...${RESET}"
	@brew bundle dump --force --file=Brewfile
	@echo "${GREEN}Brewfile updated${RESET}"

## Configuration Commands
config: ansible ## Configure macOS system settings with Ansible

ansible: ## Run Ansible playbook for macOS configuration
	@echo "${GREEN}Running Ansible playbook...${RESET}"
	@echo "Machine type: ${MACHINE_TYPE}"
	@sudo -v
	@ansible-playbook playbook.yml --become
ifneq ($(MACHINE_TYPE),)
	@echo "${GREEN}Running ${MACHINE_TYPE}-specific playbook...${RESET}"
	@sudo -v
	@ansible-playbook playbook.$(MACHINE_TYPE).yml --become
endif

ansible-check: ## Dry-run Ansible playbook
	@echo "${GREEN}Running Ansible playbook (dry-run)...${RESET}"
	@echo "Machine type: ${MACHINE_TYPE}"
	@sudo -v
	@ansible-playbook playbook.yml --check
ifneq ($(MACHINE_TYPE),)
	@sudo -v
	@ansible-playbook playbook.$(MACHINE_TYPE).yml --check
endif

## Chezmoi Commands
diff: ## Show diff of dotfiles changes
	@chezmoi diff

apply: ## Apply dotfiles changes
	@chezmoi apply -v

edit: ## Edit dotfiles with chezmoi
	@chezmoi edit

cd-chezmoi: ## Navigate to chezmoi source directory
	@chezmoi cd

## Cleanup Commands
clean: ## Clean up old packages and cache
	@echo "${GREEN}Cleaning up Homebrew...${RESET}"
	@brew cleanup
	@brew autoremove
	@echo "${GREEN}Cleanup complete${RESET}"

clean-all: clean ## Deep clean (remove packages not in Brewfile)
	@echo "${YELLOW}Removing packages not in Brewfile...${RESET}"
	@brew bundle cleanup --force
	@echo "${GREEN}Deep clean complete${RESET}"

## Health Check Commands
check: doctor ## Run all health checks

doctor: ## Check system health
	@echo "${GREEN}==> Checking Homebrew${RESET}"
	@brew doctor || true
	@echo ""
	@echo "${GREEN}==> Checking Brewfile${RESET}"
	@brew bundle check --verbose || true
	@echo ""
	@echo "${GREEN}==> Checking chezmoi${RESET}"
	@chezmoi verify || true
	@echo ""
	@echo "${GREEN}==> Checking git${RESET}"
	@git --version
	@echo ""
	@echo "${GREEN}==> Checking 1Password CLI${RESET}"
	@op --version || echo "1Password CLI not installed or not signed in"

## Testing Commands
test: ## Test the setup on current machine
	@echo "${GREEN}Testing bootstrap script...${RESET}"
	@bash -n bootstrap.sh && echo "✓ bootstrap.sh syntax OK"
	@echo "${GREEN}Testing Ansible playbook...${RESET}"
	@ansible-playbook playbook.yml --syntax-check && echo "✓ playbook.yml syntax OK"
	@echo "${GREEN}Testing chezmoi config...${RESET}"
	@chezmoi verify && echo "✓ chezmoi config OK"

## Information Commands
info: ## Show system information
	@echo "${CYAN}System Information${RESET}"
	@echo "macOS Version: $$(sw_vers -productVersion)"
	@echo "Hostname: $(HOSTNAME)"
	@echo "Machine Type: $(MACHINE_TYPE)"
	@echo "Architecture: $$(uname -m)"
	@echo ""
	@echo "${CYAN}Tool Versions${RESET}"
	@echo "Homebrew: $$(brew --version | head -n1)"
	@echo "Git: $$(git --version)"
	@echo "Chezmoi: $$(chezmoi --version 2>/dev/null || echo 'not installed')"
	@echo "Ansible: $$(ansible --version 2>/dev/null | head -n1 || echo 'not installed')"
	@echo "1Password CLI: $$(op --version 2>/dev/null || echo 'not installed')"
	@echo ""
	@echo "${CYAN}Package Stats${RESET}"
	@echo "Installed formulae: $$(brew list --formula | wc -l | xargs)"
	@echo "Installed casks: $$(brew list --cask | wc -l | xargs)"

## Backup Commands
backup: ## Backup current dotfiles
	@echo "${GREEN}Backing up dotfiles...${RESET}"
	@mkdir -p backups
	@tar -czf backups/dotfiles-backup-$$(date +%Y%m%d-%H%M%S).tar.gz \
		~/.zshrc ~/.gitconfig ~/.ssh/config 2>/dev/null || true
	@echo "${GREEN}Backup complete${RESET}"

## Repository Management
clone-repos: ## Clone all repositories from repos.txt
	@echo "${GREEN}Cloning repositories...${RESET}"
	@bash -c 'set -e; \
	REPOS_DIR="$$HOME/repos"; \
	mkdir -p "$$REPOS_DIR"; \
	clone_if_missing() { \
		local url=$$1; \
		[[ -z "$$url" || "$$url" =~ ^[[:space:]]*\# ]] && return; \
		local name=$$(basename "$$url" .git); \
		local path="$$REPOS_DIR/$$name"; \
		if [ ! -d "$$path" ]; then \
			echo "Cloning $$name..."; \
			git clone "$$url" "$$path"; \
		else \
			echo "$$name already exists"; \
		fi; \
	}; \
	while IFS= read -r url; do clone_if_missing "$$url"; done < repos.txt; \
	if [ -f "repos.$(MACHINE_TYPE).txt" ]; then \
		echo "${GREEN}Cloning $(MACHINE_TYPE)-specific repositories...${RESET}"; \
		while IFS= read -r url; do clone_if_missing "$$url"; done < repos.$(MACHINE_TYPE).txt; \
	fi'

update-repos: ## Pull latest changes in all cloned repositories
	@echo "${GREEN}Updating repositories in ~/repos...${RESET}"
	@for dir in ~/repos/*/; do \
		if [ -d "$$dir/.git" ]; then \
			echo "${CYAN}Updating $$(basename $$dir)...${RESET}"; \
			git -C "$$dir" pull || true; \
		fi; \
	done
	@echo "${GREEN}Repository update complete${RESET}"

## Git Commands
commit: ## Commit dotfiles changes
	@echo "${GREEN}Committing changes...${RESET}"
	@git add -A
	@git status
	@echo ""
	@read -p "Enter commit message: " msg; \
	git commit -m "$$msg"

push: ## Push dotfiles to remote
	@echo "${GREEN}Pushing to remote...${RESET}"
	@git push

sync: commit push ## Commit and push changes

.DEFAULT_GOAL := help
