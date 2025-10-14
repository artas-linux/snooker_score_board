# MCP Chrome DevTools Server Setup

## Current Status

### 1. MCP Chrome DevTools Server
- **Status**: Running (PID: 29580)
- **Command**: `npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log`
- **Purpose**: Provides Model Context Protocol (MCP) interface to Chrome DevTools

### 2. Flutter Web App
- **URL**: http://localhost:8080
- **Status**: Running
- **Purpose**: The main Snooker Score Board web application

### 3. Dart DevTools
- **URL**: http://127.0.0.1:9100
- **Status**: Running
- **Purpose**: Performance and debugging tools for Dart/Flutter apps

## How MCP Chrome DevTools Works

The chrome-devtools-mcp package provides a Model Context Protocol (MCP) server that allows AI assistants to interact with Chrome DevTools programmatically. The key features are:

- Provides a command-line interface for controlling Chrome DevTools
- Enables remote debugging capabilities
- Offers programmatic access to browser debugging features
- Uses the MCP standard for AI tool integration

## Testing the MCP Server

The MCP server was successfully started and is now available for use with MCP-compatible clients. The log file at `/tmp/mcp.log` shows it started properly:

```
2025-10-13T22:07:12.467Z mcp:log Starting Chrome DevTools MCP Server v0.8.1
2025-10-13T22:07:12.474Z mcp:log Chrome DevTools MCP Server connected
```

## Managing the Services

To stop the MCP server:
```bash
kill -9 29580
```

All services are currently running and available for development and debugging.