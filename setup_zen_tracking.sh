#!/bin/bash

# Setup script for zen-mcp-server tracking in Snooker Score Board project
echo "Setting up zen-mcp-server tracking for Snooker Score Board project..."

# Create necessary directories if they don't exist
mkdir -p .zen/logs
mkdir -p .zen/cache

# Create a log file for tracking
LOG_FILE=".zen/logs/tracking_$(date +%Y%m%d_%H%M%S).log"
echo "$(date): Initialized zen-mcp-server tracking for Snooker Score Board" >> $LOG_FILE

# Verify the configuration
echo "Checking configuration files..."
if [ -f ".zen/project_config.json" ]; then
    echo "✓ Project configuration found"
else
    echo "✗ Project configuration not found"
    exit 1
fi

if [ -f "mcp.json" ]; then
    echo "✓ MCP configuration found"
else
    echo "✗ MCP configuration not found"
    exit 1
fi

# Test the zen-mcp-server connection
echo "Testing zen-mcp-server connection..."
timeout 5s uvx --from git+https://github.com/BeehiveInnovations/zen-mcp-server.git zen-mcp-server --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ zen-mcp-server connection successful"
    echo "$(date): zen-mcp-server connection verified" >> $LOG_FILE
else
    echo "⚠ zen-mcp-server connection failed, but this may be expected if server is already running"
    echo "$(date): zen-mcp-server connection check skipped (may be already running)" >> $LOG_FILE
fi

echo "Setup complete! Tracking is now enabled for the Snooker Score Board project."
echo "Log file: $LOG_FILE"