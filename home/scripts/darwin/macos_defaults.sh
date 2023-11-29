#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not MacOS"
	exit 1
fi

# General UI/UX

## Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

## Reveal IP address, hostname, OS version, etc. when clicking the clock
## in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Dock

## Set the icon size of Dock items in pexels
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

# Hot corner

## Bottom left screen corner : Launchpad
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 0


## Bottom right screen corner : Launchpad
defaults write com.apple.dock wvous-br-corner -int 11
defaults write com.apple.dock wvous-br-modifier -int 0


echo "Reboot to take affect settings"
