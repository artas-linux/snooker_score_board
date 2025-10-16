const net = require('net');
const { spawn } = require('child_process');
const { performance } = require('perf_hooks');

// Test script to connect to the zen-mcp-server
async function testZenMCPConnection() {
  console.log('Testing zen-mcp-server connection...');
  
  try {
    // Try to spawn the zen-mcp-server process
    const serverProcess = spawn('bash', ['-c', 
      'for p in $(which uvx 2>/dev/null) $HOME/.local/share/mise/installs/uv/latest/uv-x86_64-unknown-linux-musl/uvx $HOME/.local/bin/uvx /opt/homebrew/bin/uvx /usr/local/bin/uvx uvx; do [ -x "$p" ] && exec "$p" --from git+https://github.com/BeehiveInnovations/zen-mcp-server.git zen-mcp-server --port 9101; done; echo "uvx not found" >&2; exit 1'
    ], {
      env: {
        ...process.env,
        PATH: '/home/archbtw/.local/share/mise/installs/uv/latest/uv-x86_64-unknown-linux-musl:/home/archbtw/.local/share/mise/installs/bun/latest/bin:/home/archbtw/.local/share/mise/installs/flutter/latest/bin:/home/archbtw/.local/share/mise/installs/dart/latest/bin:/home/archbtw/.local/share/mise/installs/node/latest/bin:/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:~/.local/bin',
        GEMINI_API_KEY: process.env.GEMINI_API_KEY
      }
    });

    // Handle process errors
    serverProcess.on('error', (err) => {
      console.error('Failed to start zen-mcp-server:', err.message);
      return false;
    });

    // Wait a bit for the server to start
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Test connection to default port (or the one we specified)
    const client = new net.Socket();
    
    return new Promise((resolve, reject) => {
      client.setTimeout(5000); // 5 second timeout
      
      client.connect(9101, 'localhost', () => {
        console.log('Successfully connected to zen-mcp-server on port 9101');
        client.write('{"method":"initialize","params":{"clientInfo":{"name":"snooker-score-board-test","version":"1.0.0"}}}\n');
      });
      
      client.on('data', (data) => {
        console.log('Received from zen-mcp-server:', data.toString());
        client.destroy();
        serverProcess.kill();
        resolve(true);
      });
      
      client.on('error', (err) => {
        console.error('Connection error:', err.message);
        serverProcess.kill();
        resolve(false);
      });
      
      client.on('timeout', () => {
        console.log('Connection to zen-mcp-server timed out');
        client.destroy();
        serverProcess.kill();
        resolve(false);
      });
    });
  } catch (error) {
    console.error('Error testing zen-mcp-server:', error);
    return false;
  }
}

// Run the test
testZenMCPConnection()
  .then(success => {
    if (success) {
      console.log('✓ zen-mcp-server connection test passed');
    } else {
      console.log('✗ zen-mcp-server connection test failed');
    }
  })
  .catch(err => {
    console.error('Error running test:', err);
  });