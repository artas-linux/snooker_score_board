# Performance Checking via MCP Chrome DevTools

## Current Setup
- Chrome browser is running with multiple processes
- Snooker Score Board app is accessible at http://localhost:8080
- MCP Chrome DevTools server is running and ready for connections
- Dart DevTools is available at http://127.0.0.1:9100

## Setting up Chrome for MCP Performance Checking

### Method 1: Launch Chrome with Remote Debugging (Recommended)

To connect MCP Chrome DevTools for performance checking, you'll need to run Chrome with remote debugging enabled:

```bash
# Close existing Chrome instance first
pkill chrome

# Launch Chrome with remote debugging (port 9222 is standard)
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome_dev_session
```

### Method 2: Connect MCP to Existing Chrome instance

If Chrome is already running with debugging enabled, you can connect the MCP server directly:

First, check if Chrome is running with debugging:
```bash
# Check if any process is listening on debugging port
ss -tuln | grep 9222
```

If Chrome is running with debugging enabled, you can connect MCP to it:
```bash
npx chrome-devtools-mcp@latest --browserUrl http://127.0.0.1:9222
```

### Method 3: Use MCP to Launch Chrome with Debugging

You can also use the MCP server to launch Chrome directly:

```bash
# Stop the current headless MCP server
pkill -f chrome-devtools-mcp

# Start MCP server that will launch Chrome with debugging
npx chrome-devtools-mcp@latest --headless=false
```

## Performance Checking Process

Once properly connected, the MCP Chrome DevTools would allow performance checking by:

1. **Navigating to your app**: 
   - The MCP client would send commands to navigate to http://localhost:8080

2. **Running performance audits**:
   - Collecting timing metrics
   - Measuring load times
   - Checking resource usage
   - Analyzing rendering performance

3. **Accessing Chrome DevTools features**:
   - Performance timeline
   - Network analysis
   - Memory usage
   - Rendering metrics

## Verification Steps

To verify that MCP can interact with Chrome for performance checking:

1. Start Chrome with debugging enabled (using --remote-debugging-port=9222)
2. Start MCP server connected to that Chrome instance
3. Use an MCP client to send commands like:
   ```json
   {
     "method": "devtools/navigate",
     "params": {
       "url": "http://localhost:8080"
     }
   }
   ```

## Current Status

Currently, your setup has:
- ✅ Snooker Score Board app running at http://localhost:8080
- ✅ MCP Chrome DevTools server running and ready
- ❌ Chrome not configured for remote debugging (most likely)

## Next Steps

To enable performance checking via MCP:

1. Close current Chrome: `pkill chrome`
2. Start Chrome with remote debugging:
   ```bash
   google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome_dev_session
   ```
3. Navigate to http://localhost:8080 in that Chrome instance
4. MCP will then be able to interact with this Chrome instance for performance analysis

The infrastructure is in place; you just need to ensure Chrome is running with remote debugging enabled to connect it with the MCP server for performance checking.