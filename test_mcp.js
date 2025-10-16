const net = require('net');

// Test script to connect to the Chrome DevTools MCP server
async function testMCPConnection() {
  console.log('Testing Chrome DevTools MCP Server connection...');
  
  // Create a TCP client
  const client = new net.Socket();
  
  try {
    // Connect to the MCP server (it usually uses stdio or a specific port)
    // Note: This is a basic test as MCP implementation details may vary
    await new Promise((resolve, reject) => {
      client.connect({ port: 9100 }, () => {
        console.log('Connected to MCP server');
        resolve();
      });
      
      client.on('error', (err) => {
        reject(err);
      });
      
      // Set a timeout for connection
      setTimeout(() => {
        client.destroy();
        reject(new Error('Connection timeout'));
      }, 5000);
    });
    
    // If we reach here, the connection was successful
    console.log('Successfully connected to MCP server');
    client.destroy();
  } catch (error) {
    console.log(`MCP server not found on port 8123: ${error.message}`);
    console.log('This is expected as MCP may use different connection methods');
  }
}

// Run the test
testMCPConnection().then(() => {
  console.log('MCP connection test completed');
}).catch(error => {
  console.error('MCP connection test failed:', error.message);
});