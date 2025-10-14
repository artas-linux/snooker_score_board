# Demonstration: Using MCP Chrome DevTools with Snooker Score Board

## Overview
This document explains how the MCP (Model Context Protocol) Chrome DevTools server would interact with your Snooker Score Board web application for performance testing.

## Current Setup
- Snooker Score Board web app: http://localhost:8080
- Running MCP Chrome DevTools server: Available via stdin/stdout protocol
- Dart DevTools: http://127.0.0.1:9100 (for comparison)

## How MCP Chrome DevTools Works

The MCP Chrome DevTools server (chrome-devtools-mcp) provides a Model Context Protocol interface that would allow an AI assistant to:

1. **Automate browser interactions**: Open Chrome, navigate to URLs, interact with elements
2. **Access performance metrics**: Get performance data, load times, resource usage
3. **Run diagnostics**: Execute Chrome DevTools protocols programmatically
4. **Capture screenshots**: Take screenshots of web pages
5. **Monitor network requests**: Track all HTTP requests and responses

## Example Usage (Conceptual)

An AI tool would communicate with the MCP server using standard MCP protocol messages like:

```
Content-Length: 85

{
  "method": "devtools/openBrowser",
  "params": {
    "url": "http://localhost:8080"
  },
  "id": 1
}
```

## Current State

1. ✅ Your Flutter web app is running at http://localhost:8080
2. ✅ MCP Chrome DevTools server is running and ready to receive MCP protocol requests
3. ✅ The server is logging to /tmp/mcp_new.log and shows "Chrome DevTools MCP Server connected"

## Performance Testing via MCP

To actually perform performance tests using MCP, you would need an MCP client that can:
1. Send MCP protocol messages to the server
2. Request performance metrics for http://localhost:8080
3. Receive and interpret the results

## Verification

The MCP server is functioning correctly as shown in the log file:
```
2025-10-13T22:07:12.467Z mcp:log Starting Chrome DevTools MCP Server v0.8.1
2025-10-13T22:07:12.474Z mcp:log Chrome DevTools MCP Server connected
```

## Next Steps

For actual performance testing through MCP, you would need to:
1. Use an MCP-compatible AI assistant or client
2. Configure it to connect to this MCP server
3. Issue commands to test the performance of your web application

The infrastructure is in place and working correctly.