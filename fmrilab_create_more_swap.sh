#!/bin/bash

################################################################################
# Swap File Creation Script for Ubuntu 22.04
# 
# Usage: sudo ./create_swap.sh <size_in_GB> <location>
# 
# Examples:
#   sudo ./create_swap.sh 4 /mnt/swap
#   sudo ./create_swap.sh 8 /var/cache/swap
#
# Requirements:
#   - Must be run as root or with sudo
#   - Target location must have sufficient free space
#   - Ubuntu 22.04 or compatible Linux system
################################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# ============================================================================
# Check Root Privileges
# ============================================================================

if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root or with sudo"
    echo "Usage: sudo $0 <size_in_GB> <location>"
    exit 1
fi

# ============================================================================
# Validate Arguments
# ============================================================================

if [[ $# -lt 2 ]]; then
    print_error "Insufficient arguments"
    echo ""
    echo "Usage: $0 <size_in_GB> <location>"
    echo ""
    echo "Arguments:"
    echo "  size_in_GB  - Size of swap file in gigabytes (e.g., 4, 8, 16)"
    echo "  location    - Full path where swap file will be created (e.g., /swapfile, /mnt/swap)"
    echo ""
    echo "Examples:"
    echo "  sudo $0 4 /swapfile"
    echo "  sudo $0 8 /mnt/swap"
    exit 1
fi

SIZE_GB="$1"
SWAP_FILE="$2"

# Validate size argument
if ! [[ "$SIZE_GB" =~ ^[0-9]+$ ]] || [[ $SIZE_GB -lt 1 ]]; then
    print_error "Size must be a positive integer (in GB)"
    exit 1
fi

print_info "Swap file size: ${SIZE_GB} GB"
print_info "Swap file location: ${SWAP_FILE}"

# ============================================================================
# Check if swap file already exists
# ============================================================================

if [[ -f "$SWAP_FILE" ]]; then
    print_warning "Swap file already exists at: $SWAP_FILE"
    read -p "Do you want to overwrite it? (yes/no): " confirm
    if [[ ! "$confirm" =~ ^[Yy][Ee][Ss]?$ ]]; then
        print_info "Operation cancelled"
        exit 0
    fi
    
    # Disable existing swap file if active
    if swapon -s | grep -q "$SWAP_FILE"; then
        print_info "Disabling existing swap file..."
        swapoff "$SWAP_FILE" || print_warning "Could not disable existing swap"
    fi
    
    rm -f "$SWAP_FILE"
    print_info "Removed existing swap file"
fi

# ============================================================================
# Create Swap File Directory if needed
# ============================================================================

SWAP_DIR=$(dirname "$SWAP_FILE")
if [[ ! -d "$SWAP_DIR" ]]; then
    print_info "Creating directory: $SWAP_DIR"
    mkdir -p "$SWAP_DIR" || {
        print_error "Failed to create directory: $SWAP_DIR"
        exit 1
    }
fi

# ============================================================================
# Check Available Disk Space
# ============================================================================

AVAILABLE_SPACE=$(df "$SWAP_DIR" | awk 'NR==2 {print $4}')
REQUIRED_SPACE=$((SIZE_GB * 1024 * 1024))

if [[ $AVAILABLE_SPACE -lt $REQUIRED_SPACE ]]; then
    print_error "Insufficient disk space"
    echo "Required: ${SIZE_GB} GB (${REQUIRED_SPACE} KB)"
    echo "Available: $((AVAILABLE_SPACE / 1024 / 1024)) GB (${AVAILABLE_SPACE} KB)"
    exit 1
fi

print_info "Available disk space: $((AVAILABLE_SPACE / 1024 / 1024)) GB - OK"

# ============================================================================
# Create Swap File
# ============================================================================

print_info "Creating ${SIZE_GB} GB swap file..."

if command -v fallocate &> /dev/null; then
    # fallocate is faster and better for this purpose
    fallocate -l "${SIZE_GB}G" "$SWAP_FILE" || {
        print_error "Failed to create swap file with fallocate"
        exit 1
    }
    print_success "Swap file created (using fallocate)"
else
    # Fallback to dd if fallocate is not available
    print_warning "fallocate not found, using dd (this may take longer)"
    dd if=/dev/zero of="$SWAP_FILE" bs=1G count="$SIZE_GB" || {
        print_error "Failed to create swap file with dd"
        exit 1
    }
    print_success "Swap file created (using dd)"
fi

# ============================================================================
# Set Proper Permissions
# ============================================================================

print_info "Setting permissions..."
chmod 600 "$SWAP_FILE" || {
    print_error "Failed to set permissions"
    exit 1
}

chown root:root "$SWAP_FILE" || {
    print_error "Failed to change ownership"
    exit 1
}

print_success "Permissions set correctly (600, root:root)"

# ============================================================================
# Format as Swap Space
# ============================================================================

print_info "Formatting as swap space..."
mkswap "$SWAP_FILE" || {
    print_error "Failed to format as swap"
    exit 1
}

print_success "Swap file formatted"

# ============================================================================
# Enable Swap
# ============================================================================

print_info "Enabling swap..."
swapon "$SWAP_FILE" || {
    print_error "Failed to enable swap"
    exit 1
}

print_success "Swap enabled"

# ============================================================================
# Add to /etc/fstab for Persistence
# ============================================================================

print_info "Adding to /etc/fstab for persistence..."

# Check if already in fstab
if grep -q "$SWAP_FILE" /etc/fstab; then
    print_warning "Swap file already exists in /etc/fstab"
else
    # Create backup
    cp /etc/fstab /etc/fstab.backup
    print_info "Created backup: /etc/fstab.backup"
    
    # Add swap file to fstab
    echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
    print_success "Added to /etc/fstab"
fi

# ============================================================================
# Display Summary
# ============================================================================

echo ""
echo "=========================================="
print_success "Swap file setup completed!"
echo "=========================================="
echo ""

print_info "Swap File Details:"
echo "  Location: $SWAP_FILE"
echo "  Size: ${SIZE_GB} GB"
echo "  Permissions: 600"
echo "  Owner: root:root"
echo ""

print_info "Current Swap Status:"
swapon -s

echo ""
print_info "Memory Information:"
free -h

echo ""
print_warning "Note: If you reboot, the swap will be automatically enabled via /etc/fstab"
echo ""