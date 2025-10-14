# Launch Guide for Snooker Score Board Development Environment

## Overview

This guide explains how to launch all services in your development environment for the Snooker Score Board project, including the Flutter web app, DevTools, and the MCP Chrome DevTools server.

## Services Overview

1. **Flutter Web App**: The main application running on http://localhost:8080
2. **Dart DevTools**: Performance and debugging tools at http://127.0.0.1:9100
3. **MCP Chrome DevTools Server**: Model Context Protocol interface for Chrome DevTools

## Method 1: Manual Launch (Step by Step)

### 1. Launch Flutter Web App
```bash
cd snooker_score_board
flutter run -d web-server --web-port=8080
```

### 2. Launch Dart DevTools
In a new terminal:
```bash
dart devtools --machine --port 9100
```

### 3. Launch MCP Chrome DevTools Server
In another terminal:
```bash
npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log
```

## Method 2: Using Background Processes

### 1. Launch all services using background processes:
```bash
# Launch Flutter Web App
cd snooker_score_board && flutter run -d web-server --web-port=8080 &

# Wait a moment for the app to start
sleep 5

# Launch Dart DevTools
dart devtools --machine --port 9100 &

# Wait a moment for DevTools to start
sleep 3

# Launch MCP Chrome DevTools Server
npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log &
```

## Method 3: Using mise Tasks (Recommended)

Add these tasks to your `.mise.toml` file:

```toml
# Start all development services
[tasks.dev-all]
run = [
  "cd snooker_score_board && flutter run -d web-server --web-port=8080 &",
  "sleep 5",
  "dart devtools --machine --port 9100 &",
  "sleep 3", 
  "npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log &"
]
description = "Start all development services"

# Stop all services
[tasks.stop-all]
run = [
  "pkill -f 'flutter.*web-server' || echo 'Flutter server not running'",
  "pkill -f 'dart.*devtools' || echo 'DevTools not running'",
  "pkill -f 'chrome-devtools-mcp' || echo 'MCP server not running'"
]
description = "Stop all development services"
```

Then launch with:
```bash
mise run dev-all
```

## Method 4: Using a Shell Script

Create a script `launch_dev.sh`:

```bash
#!/bin/bash

# Start Flutter Web App
echo "Starting Flutter Web App..."
cd snooker_score_board && flutter run -d web-server --web-port=8080 &
FLUTTER_PID=$!
sleep 5

# Start Dart DevTools
echo "Starting Dart DevTools..."
dart devtools --machine --port 9100 &
DEVTOOLS_PID=$!
sleep 3

# Start MCP Chrome DevTools Server
echo "Starting MCP Chrome DevTools Server..."
npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log &
MCP_PID=$!

echo "All services started!"
echo "Flutter Web App: http://localhost:8080"
echo "Dart DevTools: http://127.0.0.1:9100"
echo "MCP Chrome DevTools Server: PID $MCP_PID"

# Save PIDs for later cleanup if needed
echo "$FLUTTER_PID" > .flutter_pid
echo "$DEVTOOLS_PID" > .devtools_pid
echo "$MCP_PID" > .mcp_pid

# Wait for all processes to finish
wait $FLUTTER_PID $DEVTOOLS_PID $MCP_PID
```

Make it executable and run:
```bash
chmod +x launch_dev.sh
./launch_dev.sh
```

## Verifying Services are Running

### Check if services are running:
```bash
# Check Flutter app
curl -s http://localhost:8080 | head -5

# Check DevTools
curl -s http://127.0.0.1:9100 | head -5

# Check MCP server process
pgrep -f chrome-devtools-mcp
```

### Check process status:
```bash
# List running services
ps aux | grep -E "(flutter|devtools|chrome-devtools-mcp)" | grep -v grep
```

## Accessing the Services

1. **Snooker Score Board Web App**: http://localhost:8080
2. **Dart DevTools**: http://127.0.0.1:9100
3. **MCP Chrome DevTools**: Available through MCP-compatible clients

## Stopping Services

### Method 1: Kill specific processes
```bash
# Kill by process names
pkill -f "flutter.*web-server"
pkill -f "dart.*devtools"
pkill -f "chrome-devtools-mcp"
```

### Method 2: Kill by saved PIDs (if using script method)
```bash
kill $(cat .flutter_pid) $(cat .devtools_pid) $(cat .mcp_pid)
```

### Method 3: Using mise tasks (if added to .mise.toml)
```bash
mise run stop-all
```

## Troubleshooting

### If Flutter app doesn't start:
- Make sure you have the Flutter SDK installed and in your PATH
- Run `flutter doctor` to check for missing dependencies
- Verify the project directory is correct

### If DevTools doesn't start:
- Run `dart --version` to ensure Dart SDK is available
- Try `flutter pub global activate devtools` first

### If MCP server doesn't start:
- Ensure Node.js and npm are installed
- Run `npx chrome-devtools-mcp@latest --help` to test package availability
- Check `/tmp/mcp.log` for error details

## Quick Start Command

For a quick start with the recommended approach, run these commands:

```bash
cd snooker_score_board
flutter run -d web-server --web-port=8080 &

sleep 5
dart devtools --machine --port 9100 &

sleep 3
npx chrome-devtools-mcp@latest --headless --logFile /tmp/mcp.log &
```

After a few seconds, your development environment will be fully operational!