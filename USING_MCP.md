# Using MCP (Model Context Protocol) with Chrome DevTools

## What is MCP (Model Context Protocol)

MCP is a standardized protocol that allows AI assistants to interact with external tools and services. It enables AI systems to securely access development tools, databases, file systems, and other resources through a standardized interface.

## MCP in Your Setup

In your environment, you have:
- MCP Chrome DevTools server running (connected to Chrome at http://127.0.0.1:9222)
- Ready to receive MCP protocol commands
- Can interact with your Snooker Score Board application via Chrome

## How to Use MCP with Chrome DevTools

### Method 1: Direct MCP Protocol Communication

The MCP server communicates via stdin/stdout using the MCP protocol format. A typical MCP message looks like:

```
Content-Length: [length]

{
  "method": "[mcp_method]",
  "params": { ... },
  "id": [integer]
}
```

Example for navigating to a URL:
```
Content-Length: 85

{
  "method": "devtools/navigate",
  "params": {
    "url": "http://localhost:8080"
  },
  "id": 1
}
```

### Method 2: Using MCP-Compatible Clients

MCP is typically used by AI assistants or tools that understand the protocol. These would:

1. Connect to the MCP server (which runs via stdin/stdout)
2. Send standardized MCP commands
3. Receive structured responses

### Method 3: Example MCP Commands for Chrome DevTools

Here are common MCP commands that could be sent to your setup:

#### Navigate to URL:
```
{
  "method": "devtools/navigate",
  "params": {
    "url": "http://localhost:8080"
  },
  "id": 1
}
```

#### Start Performance Recording:
```
{
  "method": "devtools/performance/start",
  "params": {},
  "id": 2
}
```

#### Take Screenshot:
```
{
  "method": "devtools/screenshot",
  "params": {},
  "id": 3
}
```

#### Get Page Elements:
```
{
  "method": "devtools/querySelector",
  "params": {
    "selector": "body"
  },
  "id": 4
}
```

## Practical Example Code

To communicate with your MCP server, you could use a Node.js script:

```javascript
const { spawn } = require('child_process');

// Spawn a process to communicate with MCP
const mcp = spawn('npx', ['chrome-devtools-mcp@latest', '--browserUrl', 'http://127.0.0.1:9222'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

// Send a navigation command
const command = {
  method: 'devtools/navigate',
  params: { url: 'http://localhost:8080' },
  id: 1
};

const jsonStr = JSON.stringify(command);
const length = Buffer.byteLength(jsonStr, 'utf8');
const header = `Content-Length: ${length}\r\n\r\n`;

mcp.stdin.write(header + jsonStr);

// Listen for response
mcp.stdout.on('data', (data) => {
  console.log(`MCP Response: ${data}`);
});
```

## Using MCP with AI Assistants

The primary purpose of MCP is for AI assistants to automatically interact with development tools. For example:

- An AI assistant could automatically test your web app's performance
- The AI could run automated accessibility checks
- Performance monitoring could be done automatically
- Screenshots and reports could be generated programmatically

## Current State of Your MCP Setup

Your MCP server is currently:
- Running and connected to Chrome (PID: 40217)
- Ready to receive MCP protocol commands
- Connected to your browser with the Snooker Score Board app
- Capable of performing automated browser interactions

## Limitations to Note

- MCP servers typically run as one-off processes for stdin/stdout communication
- For continuous interaction, you'd typically use an MCP-compatible client
- The npx package has a startup time (~5.6s) each time it's invoked directly

## Next Steps

1. Use an MCP-compatible AI assistant that can send proper MCP commands
2. Develop custom scripts that follow the MCP protocol
3. Integrate MCP commands into your existing development workflow

Your MCP Chrome DevTools server is properly configured and ready to receive commands!