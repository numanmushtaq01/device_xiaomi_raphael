#!/bin/bash
#
# Automated build environment setup for Raphael (sm8150)
# Device build helper script

GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

info() { echo -e "${BLUE}▶${NC} $1"; }
success() { echo -e "${GREEN}✔${NC} $1"; }
error() { echo -e "${RED}✖${NC} $1"; }
section() { echo -e "${GREEN}>>>> $1${NC}"; }
divider() { echo "------------------------------------------"; }

get_branch() {
    local dir="$1"
    [ ! -d "$dir/.git" ] && echo "unknown" && return
    git -C "$dir" branch --show-current
}

clone_if_missing() {

    local repo_url="$1"
    local branch="$2"
    local target_dir="$3"
    local current_branch

    if [ -d "$target_dir/.git" ]; then
        current_branch=$(get_branch "$target_dir")
        success "$target_dir already exists (${YELLOW}$current_branch${NC})"
        return
    fi

    info "Syncing $target_dir"

    git clone --quiet --depth=1 --single-branch \
    -b "$branch" "$repo_url" "$target_dir" || {
        error "Failed: $target_dir"
        return 1
    }

    current_branch=$(get_branch "$target_dir")
    success "Done: $target_dir (${YELLOW}$current_branch${NC})"
}

divider
section "Initializing Raphael build environment..."
divider


# Device / Vendor

section "Cloning device tree"

clone_if_missing \
https://github.com/yaap/device_xiaomi_raphael-kernel.git \
sixteen \
device/xiaomi/raphael-kernel


section "Cloning vendor tree"

clone_if_missing \
https://github.com/yaap/vendor_xiaomi_raphael.git \
sixteen \
vendor/xiaomi/raphael


# Kernel

divider
section "Cloning kernel"
divider

clone_if_missing \
https://github.com/SOVIET-ANDROID/kernel_xiaomi_raphael.git \
16.0 \
kernel/xiaomi/raphael


# Hardware

divider
section "Setting up hardware repos"
divider

clone_if_missing \
https://github.com/LineageOS/android_hardware_xiaomi.git \
lineage-23.2 \
hardware/xiaomi

clone_if_missing \
https://github.com/numanmushtaq01/hardware_dolby.git \
16.dolby \
hardware/dolby


# Game bar

divider
section "Cloning GameBar repo"
divider

clone_if_missing \
https://github.com/kenway214/packages_apps_GameBar.git \
lineage-23.2 \
packages/apps/GameBar


# Done

divider
success "All repositories are ready!"
divider
echo ""
