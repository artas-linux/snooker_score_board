const http = require('http');
const { performance } = require('perf_hooks');

// Performance test for Flutter Web Server
async function flutterWebPerformanceTest() {
  console.log('🚀 Starting Flutter Web Server Performance Test...');
  console.log('   Target: localhost:8080');
  console.log('   Tests to run: Response time, throughput, stability\n');

  const testIterations = 100;
  let successfulRequests = 0;
  let responseTimes = [];
  let totalTestStart = performance.now();

  // 1. Response Time Test
  console.log('1. Testing Response Times...');
  for (let i = 0; i < 10; i++) {
    const start = performance.now();
    try {
      await new Promise((resolve, reject) => {
        const req = http.get('http://localhost:8080', (res) => {
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
      });
    } catch (error) {
      console.log(`   Request attempt ${i+1} failed: ${error.message}`);
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
  let throughputErrors = 0;

  // Test multiple concurrent requests
  const requestPromises = [];
  for (let i = 0; i < testIterations; i++) {
    requestPromises.push(new Promise((resolve) => {
      const req = http.get('http://localhost:8080', (res) => {
        throughputRequests++;
        resolve();
      });
      
      req.on('error', () => {
        throughputErrors++;
        resolve();
      });
      
      req.setTimeout(10000, () => {
        req.destroy();
        resolve();
      });
    }));
  }

  await Promise.all(requestPromises);
  const throughputEnd = performance.now();
  const throughputTime = throughputEnd - throughputStart;
  const requestsPerSecond = (testIterations / throughputTime) * 1000;

  console.log(`   ✅ Successful requests: ${throughputRequests}/${testIterations}`);
  if (throughputErrors > 0) {
    console.log(`   ⚠️  Failed requests: ${throughputErrors}/${testIterations}`);
  }
  console.log(`   ✅ Total time for ${testIterations} requests: ${throughputTime.toFixed(2)}ms`);
  console.log(`   ✅ Request throughput: ${requestsPerSecond.toFixed(2)} requests/sec`);

  // 3. Stability Test - Continuous requests over time
  console.log('\n3. Testing Stability (Continuous requests)...');
  const stabilityStart = performance.now();
  let stabilityRequests = 0;
  let stabilityErrors = 0;
  
  for (let i = 0; i < 20; i++) {
    try {
      await new Promise((resolve, reject) => {
        const req = http.get('http://localhost:8080', (res) => {
          stabilityRequests++;
          resolve();
        });
        
        req.on('error', (err) => {
          stabilityErrors++;
          resolve();
        });
        
        req.setTimeout(10000, () => {
          req.destroy();
          resolve();
        });
      });
      
      // Small delay between requests to simulate real usage
      await new Promise(resolve => setTimeout(resolve, 100));
    } catch (error) {
      stabilityErrors++;
    }
  }
  
  const stabilityEnd = performance.now();
  const stabilityTime = stabilityEnd - stabilityStart;
  
  console.log(`   ✅ Stability test results: ${stabilityRequests} successful, ${stabilityErrors} failed`);
  console.log(`   ✅ Stability test duration: ${stabilityTime.toFixed(2)}ms`);

  // Final results
  const totalTestEnd = performance.now();
  const totalTestTime = totalTestEnd - totalTestStart;
  
  console.log('\n📊 Performance Test Results for Flutter Web Server:');
  console.log(`   Total test duration: ${totalTestTime.toFixed(2)}ms`);
  console.log(`   Server status: ${successfulRequests > 0 ? '✅ Operational' : '❌ Not responding'}`);
  
  if (successfulRequests > 0) {
    console.log(`   Reliability: ${((successfulRequests / 10) * 100).toFixed(1)}% success rate`);
  }
  
  console.log('\n✅ Flutter Web Server Performance Test Completed');
}

// Run the performance test
flutterWebPerformanceTest().catch(error => {
  console.error('❌ Flutter Web Performance Test failed:', error.message);
});