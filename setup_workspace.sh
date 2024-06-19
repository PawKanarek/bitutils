#!/bin/zsh

# Function to open an app and move it to a specific workspace
move_to_workspace() {
  app_name="$1"
  workspace="$2"
  open -na "$app_name"
  sleep 2  # Adjust sleep duration as necessary
  aerospace move-node-to-workspace "$workspace"
}

# Workspace 1: Chrome
move_to_workspace "Google Chrome" 1

# Workspace 2: VSCode + Chrome
move_to_workspace "Visual Studio Code" 2
move_to_workspace "Google Chrome" 2

# Workspace 3: Signal, Discord, Chrome
move_to_workspace "Signal" 3
move_to_workspace "Discord" 3
move_to_workspace "Google Chrome" 3

# Workspace 4: Obsidian
move_to_workspace "Obsidian" 4

# Workspace 5: Tonkeeper, Spotify, Chrome
move_to_workspace "Tonkeeper" 5
move_to_workspace "Spotify" 5
move_to_workspace "Google Chrome" 5
