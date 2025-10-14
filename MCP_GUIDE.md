# How to Use MCP (Model Context Protocol) with Chrome DevTools

## Overview of MCP
The Model Context Protocol (MCP) is a standardized protocol that allows AI assistants to interact with various development tools and services. In your setup, the chrome-devtools-mcp package implements MCP to provide a bridge between AI tools and Chrome DevTools.

## Understanding Your Current MCP Setup

### Current Configuration
- MCP Server: Running and connected to Chrome (PID: 40217)
- Connection: chrome-devtools-mcp connected to Chrome at http://127.0.0.1:9222
- Purpose: Enable AI tools to programmatically interact with Chrome DevTools

### How Your MCP System Works
1. The MCP server runs as a background process
2. It implements the MCP protocol specification
3. AI tools can send MCP messages to interact with Chrome DevTools features
4. This enables automated browser interactions and performance analysis

## How to Use MCP with Your Setup

### For AI Assistant Integration
AI assistants that support MCP can connect to your running MCP server to:
- Navigate to web pages (like your Snooker Score Board at http://localhost:8080)
- Perform automated testing
- Collect performance metrics
- Capture screenshots
- Monitor network requests
- Analyze page performance

### MCP Protocol Format
MCP uses a message-based protocol with messages following this format:
```
Content-Length: [length]

{
  "method": "[method_name]",
  "params": {
    "param1": "value1"
  },
  "id": [request_id]
}
```

### Example MCP Commands (Conceptual)
These are the types of commands an MCP-compatible AI assistant could send:

1. **Navigation Command**:
```json
{
  "method": "devtools/navigate",
  "params": {
    "url": "http://localhost:8080"
  },
  "id": 1
}
```

2. **Performance Audit Command**:
```json
{
  "method": "devtools/performance/start",
  "params": {},
  "id": 2
}
```

3. **Screenshot Command**:
```json
{
  "method": "devtools/screenshot",
  "params": {
    "format": "png"
  },
  "id": 3
}
```

## How to Test MCP Functionality

### Step 1: Verify MCP Server Status
The server should be running with access to Chrome DevTools features through the protocol.

### Step 2: Connect MCP-Compatible Client
MCP works by having clients connect and send protocol messages. For example, an AI assistant with MCP support would:
1. Establish connection to the MCP server
2. Send discovery requests to see available tools
3. Send specific commands to interact with Chrome DevTools

### Step 3: MCP Discovery
An MCP client would typically start by requesting available tools:
```json
{
  "method": "core/list-tools",
  "id": 1
}
```

## Using MCP with Your Snooker Score Board

### Automated Performance Testing
Once connected, MCP-compatible tools could:
1. Navigate to http://localhost:8080
2. Simulate user interactions with your Snooker Score Board
3. Collect performance metrics
4. Generate reports on load times, rendering performance, etc.

### Automated UI Testing
MCP could also be used for:
1. Automated form submissions
2. Button clicks and interactions
3. State validation
4. Visual regression testing

## Practical Example: Manual MCP Interaction

For direct manual testing of the MCP protocol, you would typically use a specialized MCP client. However, the underlying principle works like this:

1. Write MCP messages in the proper format (with Content-Length header)
2. Send them to the MCP server's stdin
3. Receive responses from the server's stdout

## Integrating with AI Assistants

### For AI Tools Supporting MCP
Modern AI coding assistants that support MCP can:
1. Automatically discover your MCP server
2. Access Chrome DevTools capabilities
3. Perform automated testing of your Snooker Score Board
4. Provide detailed performance analysis

### Configuration
When using AI assistants that support MCP, they would typically:
1. Locate your MCP server (often through configuration)
2. Send initial discovery requests to understand available capabilities
3. Execute specific commands for testing, debugging, or analysis

## Checking MCP Status

You can verify the MCP server is running with:
```bash
pgrep -f "chrome-devtools-mcp"
```

The server is logging to /tmp/mcp_new.log and shows "Chrome DevTools MCP Server connected" when properly connected to Chrome.

## Troubleshooting MCP

### If MCP Server Isn't Responding
1. Verify Chrome is running with remote debugging: `ps aux | grep chrome`
2. Check if MCP server is running: `pgrep -f chrome-devtools-mcp`
3. Verify connection: `curl http://127.0.0.1:9222/json` should return Chrome debugging sessions

### Common Issues
- MCP server startup time is slow (5-6 seconds) due to npx
- Chrome must be running with --remote-debugging-port
- The MCP server connects to Chrome via HTTP debugging protocol

## Summary

Your MCP Chrome DevTools setup enables:
- AI-assisted automated testing
- Programmatic access to Chrome DevTools features
- Automated performance analysis of your Snooker Score Board
- Integration with MCP-compatible AI assistants

The infrastructure is fully set up. You just need MCP-compatible tools (like AI assistants) to take advantage of these capabilities.