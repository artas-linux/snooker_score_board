#!/usr/bin/env node

const { spawn } = require('child_process');

// Function to send message to MCP server with proper protocol formatting
function sendMCPMessage(server, method, params = {}, id = 1) {
  const message = {
    method: method,
    params: params,
    id: id
  };

  const jsonStr = JSON.stringify(message);
  const length = Buffer.byteLength(jsonStr, 'utf8');
  const header = `Content-Length: ${length}\r\n\r\n`;

  server.stdin.write(header + jsonStr);
}

// Start the MCP server
const mcpServer = spawn('npx', ['chrome-devtools-mcp@latest', '--browserUrl', 'http://127.0.0.1:9222']);

// Set up data handlers
mcpServer.stdout.on('data', (data) => {
  console.log('MCP Server Output:', data.toString());
});

mcpServer.stderr.on('data', (data) => {
  console.error('MCP Server Error:', data.toString());
});

mcpServer.on('close', (code) => {
  console.log(`MCP Server process exited with code ${code}`);
});

// Wait for server to initialize, then send a discovery message
setTimeout(() => {
  console.log('Sending discovery message to MCP server...');
  // Try to discover what tools are available
  sendMCPMessage(mcpServer, 'core/list-tools');
}, 3000);

// Wait a bit more and try another common MCP method
setTimeout(() => {
  console.log('Sending ping message to MCP server...');
  sendMCPMessage(mcpServer, 'mcp/ping');
}, 5000);

// Clean up after testing
setTimeout(() => {
  console.log('Shutting down MCP server...');
  mcpServer.kill();
}, 8000);