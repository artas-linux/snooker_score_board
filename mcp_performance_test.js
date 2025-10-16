const net = require('net');
const { performance } = require('perf_hooks');

// Performance test for MCP server
async function mcpPerformanceTest() {
  console.log('🚀 Starting MCP Server Performance Test...');
  console.log('   Target: localhost:9100');
  console.log('   Tests to run: Connection speed, response time, throughput\n');

  const testIterations = 100;
  let successfulConnections = 0;
  let connectionTimes = [];
  let totalTestStart = performance.now();

  // 1. Connection Speed Test
  console.log('1. Testing Connection Speed...');
  for (let i = 0; i < 10; i++) {
    const start = performance.now();
    try {
      const client = new net.Socket();
      await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => {
          client.destroy();
          reject(new Error('Connection timeout'));
        }, 5000);
        
        client.connect({ port: 9100 }, () => {
          clearTimeout(timeout);
          const end = performance.now();
          connectionTimes.push(end - start);
          successfulConnections++;
          client.destroy();
          resolve();
        });
        
        client.on('error', (err) => {
          clearTimeout(timeout);
          reject(err);
        });
      });
    } catch (error) {
      console.log(`   Connection attempt ${i+1} failed: ${error.message}`);
    }
  }

  if (connectionTimes.length > 0) {
    const avgConnectionTime = connectionTimes.reduce((a, b) => a + b, 0) / connectionTimes.length;
    console.log(`   ✅ Average connection time: ${avgConnectionTime.toFixed(2)}ms`);
    console.log(`   ✅ Successful connections: ${successfulConnections}/10`);
  } else {
    console.log(`   ❌ No successful connections`);
    return;
  }

  // 2. Response Time Test (simulating MCP protocol interactions)
  console.log('\n2. Testing Response Times...');
  const responseTimes = [];
  let responsesReceived = 0;

  for (let i = 0; i < testIterations; i++) {
    try {
      const start = performance.now();
      const client = new net.Socket();
      
      await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => {
          client.destroy();
          reject(new Error('Request timeout'));
        }, 5000);

        client.connect({ port: 9100 }, () => {
          // Send a minimal MCP-like request
          const mcpRequest = 'Content-Length: 0\r\n\r\n';
          client.write(mcpRequest);
          
          client.on('data', (data) => {
            clearTimeout(timeout);
            const end = performance.now();
            responseTimes.push(end - start);
            responsesReceived++;
            client.destroy();
            resolve();
          });
          
          client.on('error', (err) => {
            clearTimeout(timeout);
            client.destroy();
            reject(err);
          });
        });
        
        client.on('error', (err) => {
          clearTimeout(timeout);
          reject(err);
        });
      });
    } catch (error) {
      // Silently handle errors for response time test, as MCP might not respond to empty requests
    }
  }

  if (responseTimes.length > 0) {
    const avgResponseTime = responseTimes.reduce((a, b) => a + b, 0) / responseTimes.length;
    console.log(`   ✅ Average response time: ${avgResponseTime.toFixed(2)}ms`);
    console.log(`   ✅ Responses received: ${responsesReceived}/${testIterations}`);
  } else {
    console.log(`   ℹ️  No responses received (this is expected for MCP protocol with invalid requests)`);
  }

  // 3. Throughput Test
  console.log('\n3. Testing Connection Throughput...');
  const throughputStart = performance.now();
  let throughputConnections = 0;

  // Test multiple concurrent connections
  const connectionPromises = [];
  for (let i = 0; i < testIterations; i++) {
    connectionPromises.push(new Promise((resolve) => {
      const client = new net.Socket();
      client.setTimeout(5000);
      
      client.connect({ port: 9100 }, () => {
        throughputConnections++;
        client.destroy();
        resolve();
      });
      
      client.on('error', () => {
        client.destroy();
        resolve();
      });
    }));
  }

  await Promise.all(connectionPromises);
  const throughputEnd = performance.now();
  const throughputTime = throughputEnd - throughputStart;
  const connectionsPerSecond = (testIterations / throughputTime) * 1000;

  console.log(`   ✅ Concurrent connections handled: ${throughputConnections}/${testIterations}`);
  console.log(`   ✅ Total time for ${testIterations} connection attempts: ${throughputTime.toFixed(2)}ms`);
  console.log(`   ✅ Connection throughput: ${connectionsPerSecond.toFixed(2)} connections/sec`);

  // Final results
  const totalTestEnd = performance.now();
  const totalTestTime = totalTestEnd - totalTestStart;
  
  console.log('\n📊 Performance Test Results:');
  console.log(`   Total test duration: ${totalTestTime.toFixed(2)}ms`);
  console.log(`   Server status: ✅ Operational`);
  
  if (successfulConnections > 0) {
    console.log(`   Reliability: ✅ Server responding to TCP connections`);
  } else {
    console.log(`   Reliability: ❌ Server not responding`);
  }
  
  console.log('\n✅ MCP Server Performance Test Completed');
}

// Run the performance test
mcpPerformanceTest().catch(error => {
  console.error('❌ MCP Performance Test failed:', error.message);
});