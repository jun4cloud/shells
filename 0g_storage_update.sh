#!/bin/bash

zgs_home="$HOME/0g"
# Stop the zgs service
sudo systemctl stop zgs

# Backup the current config file
cp $zgs_home/0g-storage-node/run/config.toml $zgs_home/0g-storage-node/run/config.toml.backup

# Navigate to the project directory
cd $zgs_home/0g-storage-node

# Stash any local changes
git stash

# Fetch all updates and tags
git fetch --all --tags

# Checkout the specific commit
git checkout 40d4355

# Update submodules
git submodule update --init

# Build the project
cargo build --release

# Restore the config file
cp $zgs_home/0g-storage-node/run/config.toml.backup $zgs_home/0g-storage-node/run/config.toml

# Reload the systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the zgs service
sudo systemctl enable zgs
sudo systemctl start zgs

# Monitor the service status
tail -f $zgs_home/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)
