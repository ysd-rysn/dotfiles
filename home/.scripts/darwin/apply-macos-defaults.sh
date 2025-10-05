#!/bin/bash

set -euo pipefail

# Source common utilities
source "$HOME/.scripts/lib/util.sh"

# Setup error trap
setup_error_trap

# Check macOS
check_macos || exit 1

script_header "macOS System Defaults"

# General UI/UX

## Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Appearance

## Use Dark Mode
defaults write NSGlobalDomain "AppleInterfaceStyle" -string "Dark"

## Enable automatic dark mode switching
defaults write NSGlobalDomain "AppleInterfaceStyleSwitchesAutomatically" -bool "true"

# Dock

## Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock "tilesize" -int "36"

## Autohide the Dock
defaults write com.apple.dock "autohide" -bool "true"

## Do not display recent apps in the Dock
defaults write com.apple.dock "show-recents" -bool "false"

# Trackpad

## Enable dragging without drag lock
defaults write com.apple.AppleMultitouchTrackpad "Dragging" -bool "true"

## Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Mission Control

## Group windows by application
defaults write com.apple.dock "expose-group-apps" -bool "true"

## Do not automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corner

## Bottom left screen corner: Launchpad
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 0

## Bottom right screen corner: Launchpad
defaults write com.apple.dock wvous-br-corner -int 11
defaults write com.apple.dock wvous-br-modifier -int 0

# Keyboard

## Disable auto-correct
defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool "false"

## Disable automatic capitalization
defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool "false"

# Finder

## Show all filename extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

## Use list view in all Finder windows by default
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

## New Finder windows show home directory
defaults write com.apple.finder "NewWindowTarget" -string "PfHm"
defaults write com.apple.finder "NewWindowTargetPath" -string "file://$HOME/"

script_footer "macOS System Defaults"
log_warning "Some settings require a reboot to take effect"
