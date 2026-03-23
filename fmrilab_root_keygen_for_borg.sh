#!/bin/bash

# 1. Root check
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root."
   exit 1
fi

KEY_FILE="/root/.ssh/backup-key-${HOSTNAME}"

# 2. Generate key only if it doesn't exist (prevents overwriting)
if [[ ! -f "$KEY_FILE" ]]; then
    echo "Generating new Ed25519 key for ${HOSTNAME}..."
    ssh-keygen -t ed25519 -C "backup-key-${HOSTNAME}" -f "$KEY_FILE" -N ""
else
    echo "Key already exists at $KEY_FILE. Skipping generation."
fi

# 3. Copy the key to Tesla
# NOTE: This will prompt for soporte@tesla's password once.
echo "Copying key to Tesla (please enter soporte@tesla password if prompted)..."
ssh-copy-id -i "$KEY_FILE" soporte@tesla

# 4. Update SSH config (safely)
# We check if 'Host tesla-backup' already exists to avoid duplicate blocks.
if ! grep -q "Host tesla-backup" /root/.ssh/config 2>/dev/null; then
    echo "Adding tesla-backup entry to /root/.ssh/config..."
    cat <<EOF >> /root/.ssh/config

Host tesla-backup
    HostName tesla
    User soporte
    IdentityFile $KEY_FILE
    ServerAliveInterval 60
    ServerAliveCountMax 30
EOF
else
    echo "Config for 'tesla-backup' already exists. Skipping."
fi

ssh-keyscan -H tesla >> /root/.ssh/known_hosts

echo "Done! You can now use 'tesla-backup' in your Borg scripts."