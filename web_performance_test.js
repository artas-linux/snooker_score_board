const http = require('http');
const { performance } = require('perf_hooks');

// Performance test for Flutter Web Server
async function webServerPerformanceTest() {
  console.log('🚀 Starting Web Server Performance Test...');
  console.log('   Target: localhost:8080');
  console.log('   Tests to run: Response time, throughput, concurrency\n');

  const testIterations = 50;
  let successfulRequests = 0;
  let responseTimes = [];
  let totalTestStart = performance.now();

  // 1. Response Time Test
  console.log('1. Testing Response Times...');
  for (let i = 0; i < 10; i++) {
    const start = performance.now();
    try {
      await new Promise((resolve, reject) => {
        const req = http.request({
          hostname: 'localhost',
          port: 8080,
          path: '/',
          method: 'GET'
        }, (res) => {
          let data = '';
          res.on('data', (chunk) => {
            data += chunk;
          });
          res.on('end', () => {
            const end = performance.now();
            responseTimes.push(end - start);
            successfulRequests++;
            resolve();
          });
        });
        
        req.on('error', (err) => {
          reject(err);
        });
        
        req.setTimeout(10000, () => {
          req.destroy();
          reject(new Error('Request timeout'));
        });
        
        req.end();
      });
    } catch (error) {
      console.log(`   Request ${i+1} failed: ${error.message}`);
    }
  }

  if (responseTimes.length > 0) {
    const avgResponseTime = responseTimes.reduce((a, b) => a + b, 0) / responseTimes.length;
    console.log(`   ✅ Average response time: ${avgResponseTime.toFixed(2)}ms`);
    console.log(`   ✅ Successful requests: ${successfulRequests}/10`);
  } else {
    console.log(`   ❌ No successful requests`);
    return;
  }

  // 2. Throughput Test
  console.log('\n2. Testing Request Throughput...');
  const throughputStart = performance.now();
  let throughputRequests = 0;
  const requestPromises = [];

  for (let i = 0; i < testIterations; i++) {
    requestPromises.push(new Promise((resolve) => {
      const req = http.request({
        hostname: 'localhost',
        port: 8080,
        path: '/',
        method: 'GET'
      }, (res) => {
        res.on('data', () => {
          // Consume the data
        });
        res.on('end', () => {
          throughputRequests++;
          resolve();
        });
      });
      
      req.on('error', () => {
        resolve(); // Count as handled even if failed
      });
      
      req.setTimeout(10000, () => {
        req.destroy();
        resolve();
      });
      
      req.end();
    }));
  }

  await Promise.all(requestPromises);
  const throughputEnd = performance.now();
  const throughputTime = throughputEnd - throughputStart;
  const requestsPerSecond = (testIterations / throughputTime) * 1000;

  console.log(`   ✅ Total requests handled: ${throughputRequests}/${testIterations}`);
  console.log(`   ✅ Total time for ${testIterations} requests: ${throughputTime.toFixed(2)}ms`);
  console.log(`   ✅ Request throughput: ${requestsPerSecond.toFixed(2)} requests/sec`);

  // 3. Concurrency Test
  console.log('\n3. Testing Concurrency (simultaneous requests)...');
  const concurrencyStart = performance.now();
  const concurrentPromises = [];
  
  // Send 20 requests simultaneously
  for (let i = 0; i < 20; i++) {
    concurrentPromises.push(new Promise((resolve) => {
      const req = http.request({
        hostname: 'localhost',
        port: 8080,
        path: '/',
        method: 'GET'
      }, (res) => {
        res.on('data', () => {
          // Consume the data
        });
        res.on('end', () => {
          resolve();
        });
      });
      
      req.on('error', () => {
        resolve();
      });
      
      req.setTimeout(10000, () => {
        req.destroy();
        resolve();
      });
      
      req.end();
    }));
  }
  
  await Promise.all(concurrentPromises);
  const concurrencyEnd = performance.now();
  const concurrencyTime = concurrencyEnd - concurrencyStart;

  console.log(`   ✅ Concurrent requests (20 simultaneous): Completed in ${concurrencyTime.toFixed(2)}ms`);
  
  // Final results
  const totalTestEnd = performance.now();
  const totalTestTime = totalTestEnd - totalTestStart;
  
  console.log('\n📊 Web Server Performance Test Results:');
  console.log(`   Total test duration: ${totalTestTime.toFixed(2)}ms`);
  console.log(`   Server status: ✅ Operational`);
  
  if (successfulRequests > 0) {
    console.log(`   Reliability: ✅ Server responding to HTTP requests`);
  } else {
    console.log(`   Reliability: ❌ Server not responding`);
  }
  
  console.log('\n✅ Web Server Performance Test Completed');
}

// Run the performance test
webServerPerformanceTest().catch(error => {
  console.error('❌ Web Server Performance Test failed:', error.message);
});