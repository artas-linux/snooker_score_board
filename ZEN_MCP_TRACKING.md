# Zen-MCP Server Integration for Snooker Score Board

This document explains how the Snooker Score Board project is integrated with the zen-mcp-server for AI-assisted development workflows and tracking.

## Overview

The Snooker Score Board project uses zen-mcp-server to enable advanced AI-assisted development capabilities, including:
- Intelligent code suggestions and completions
- Context-aware assistance based on project structure
- Session tracking and analytics
- Enhanced debugging and code review capabilities

## Configuration Files

### 1. Main MCP Configuration (`mcp.json`)

The project's main MCP configuration is located in `mcp.json` and includes the zen server configuration:
```json
{
  "mcpServers": {
    "zen": {
      "command": "bash",
      "args": [
        "-c",
        "for p in $(which uvx 2>/dev/null) $HOME/.local/share/mise/installs/uv/latest/uv-x86_64-unknown-linux-musl/uvx $HOME/.local/bin/uvx /opt/homebrew/bin/uvx /usr/local/bin/uvx uvx; do [ -x \\\"$p\\\" ] && exec \\\"$p\\\" --from git+https://github.com/BeehiveInnovations/zen-mcp-server.git zen-mcp-server; done; echo 'uvx not found' >&2; exit 1"
      ],
      "cwd": "/home/archbtw/dev/projects/zen-mcp-server",
      "env": {
        "PATH": "/home/archbtw/.local/share/mise/installs/uv/latest/uv-x86_64-unknown-linux-musl:/home/archbtw/.local/share/mise/installs/bun/latest/bin:/home/archbtw/.local/share/mise/installs/flutter/latest/bin:/home/archbtw/.local/share/mise/installs/dart/latest/bin:/home/archbtw/.local/share/mise/installs/node/latest/bin:/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:~/.local/bin",
        "GEMINI_API_KEY": "${GEMINI_API_KEY}"
      }
    }
  }
}
```

### 2. Qwen Settings (`/.qwen/settings.json`)

The Qwen-specific settings file contains the same configuration to ensure consistent behavior across different tools.

### 3. Project Configuration (`/.zen/project_config.json`)

Contains project-specific settings for tracking and AI behavior:
- Project name, type and description
- Tracking settings (session tracking, analytics)
- Enabled/disabled tools
- AI model preferences

## Setup and Usage

### Initial Setup

Run the setup script to initialize tracking:
```bash
./setup_zen_tracking.sh
```

This script will:
1. Create necessary directories (`.zen/logs`, `.zen/cache`)
2. Initialize a tracking log file
3. Verify configuration files
4. Test the connection to the zen-mcp-server

### Logging

Tracking logs are stored in `.zen/logs/` with timestamps. Each session creates a new log file with information about:
- Connection status
- Tool usage
- Error occurrences
- Usage patterns

## Features

### Session Tracking
- Tracks development sessions for the Snooker Score Board project
- Records tool usage patterns
- Monitors error occurrences and recovery

### Analytics
- Collects usage statistics (with user consent)
- Gathers error reports to improve the system
- Provides insights into development patterns

### Available Tools
The zen-mcp-server provides access to various AI-powered tools:
- **Chat**: Natural language interactions
- **Clink**: Code linking and relationship analysis
- **ThinkDeep**: Deep analysis and reasoning
- **Planner**: Project planning and task organization
- **Consensus**: Multi-model verification
- **CodeReview**: Automated code review
- **Debug**: Intelligent debugging assistance
- **API lookup**: Documentation and API reference
- And more...

## Troubleshooting

If you encounter issues with the zen-mcp-server connection:

1. Verify that `uvx` is installed: `which uvx`
2. Check that you have the required API keys in your environment
3. Confirm internet connectivity for downloading the server if needed
4. Check the log files in `.zen/logs/` for error details

## Maintenance

- Log files are automatically rotated based on date
- Cache files may need occasional cleanup if they grow too large
- Configuration files should be updated when the project structure changes