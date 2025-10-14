# Performance Checking with Chrome DevTools

## Overview
Your setup is configured for performance checking using Chrome DevTools in multiple ways: direct browser tools and MCP protocol integration.

## Method 1: Direct Chrome DevTools Performance Analysis (Immediate)

### Step 1: Open Your Application in Chrome
1. Navigate to `http://localhost:8080` in your Chrome browser
2. Make sure this is the same Chrome instance running with remote debugging
3. The Snooker Score Board should load

### Step 2: Open Chrome DevTools
1. Right-click on the page and select "Inspect" OR
2. Press `Ctrl+Shift+I` (or `Cmd+Option+I` on Mac) OR
3. Press `F12`

### Step 3: Navigate to Performance Tab
1. Click on the "Performance" tab in DevTools
2. You'll see options for recording performance metrics

### Step 4: Record Performance
1. Click the "Record" button (circle icon) in the Performance tab
2. Interact with your Snooker Score Board application
3. Click "Stop" to end the recording
4. Chrome will analyze the performance data

### Step 5: Analyze Results
In the Performance tab, you'll see detailed information about:
- **FPS (Frames Per Second)**: How smoothly the app renders
- **CPU Usage**: Processing power consumption
- **Network Activity**: All network requests and timing
- **Rendering**: Paint times and rendering bottlenecks
- **Memory**: Memory usage over time

## Method 2: Automated Performance Testing via MCP (Advanced)

### Prerequisites
- Your MCP Chrome DevTools server is running and connected to Chrome
- Chrome is running with remote debugging enabled

### How MCP Performance Testing Works
Instead of manual testing, you can use AI tools that understand MCP protocol to:
1. Programmatically navigate to your app
2. Perform automated interactions
3. Collect performance metrics
4. Generate performance reports

Example MCP command for navigation:
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

## Method 3: Network Performance Analysis

### Step 1: Open Network Tab
1. With DevTools open, click the "Network" tab
2. Reload your application to capture initial load

### Step 2: Analyze Network Metrics
- **Load Time**: How long each resource takes to load
- **Request/Response Size**: How much data is transferred
- **Waterfall**: Visual representation of loading sequence
- **Connection Timing**: DNS lookup, connection time, etc.

## Method 4: Lighthouse Performance Audit

### Step 1: Access Lighthouse
1. Open DevTools (F12)
2. Click on the "Lighthouse" tab (if not visible, click "..." menu and select "Lighthouse")
3. Or click "Audit" in the "Lighthouse" panel

### Step 2: Run Performance Audit
1. Select categories (Performance, Accessibility, Best Practices, SEO, PWA)
2. Select device (Desktop or Mobile)
3. Click "Generate report"

### Step 3: Review Report
The Lighthouse report includes:
- **Performance Score**: 0-100 score
- **Detailed Metrics**: Largest Contentful Paint, First Input Delay, Cumulative Layout Shift
- **Opportunities**: Suggestions for improvement
- **Diagnostics**: Technical insights about performance

## Method 5: Memory and Rendering Analysis

### Memory Analysis
1. In DevTools, go to "Memory" tab
2. Take heap snapshots to see memory usage
3. Use "Record Allocation Timeline" to see memory allocation over time

### Rendering Analysis
1. Go to "Rendering" settings (three dots menu → More Tools → Rendering)
2. Enable "Paint flashing" to see what's being repainted
3. Enable "Layer borders" to see composition layers

## Quick Performance Checks

### Console Performance Timing
1. In DevTools Console tab, run:
```javascript
performance.getEntriesByType('navigation')[0]
```
This shows navigation timing details.

### Mobile Simulation
1. In DevTools, click the mobile device icon or press `Ctrl+Shift+M`
2. Select different devices to simulate mobile performance
3. Adjust network conditions in the Network tab to simulate slower connections

## Performance Metrics to Watch

- **First Contentful Paint (FCP)**: Time to first render
- **Largest Contentful Paint (LCP)**: Time to render the largest content
- **First Input Delay (FID)**: Time from user input to browser response
- **Cumulative Layout Shift (CLS)**: Stability of content while loading
- **Time to Interactive (TTI)**: When page becomes fully interactive

## Best Practices During Testing

1. **Clear Cache**: Use "Clear storage" in Application tab before testing for consistent results
2. **Disable Extensions**: Use Incognito mode for testing to prevent extension interference
3. **Consistent Environment**: Test under similar conditions for comparable results
4. **Multiple Runs**: Run tests multiple times and take averages for more accurate results

## Troubleshooting Common Issues

If performance tools aren't working:
1. Verify Chrome is running with `--remote-debugging-port=9222`
2. Check that your app is accessible at `http://localhost:8080`
3. Ensure no other instances of Chrome are interfering
4. Try disabling browser extensions that might affect performance

Your environment is fully configured for comprehensive performance analysis!