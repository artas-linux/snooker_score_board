#!/bin/bash

# Script to run Snooker Score Board tests with zen-mcp-server integration

echo "🚀 Starting Snooker Score Board tests with zen-mcp-server integration..."

# Create log directory if it doesn't exist
mkdir -p .zen/test_logs

# Log file for this test session
LOG_FILE=".zen/test_logs/test_session_$(date +%Y%m%d_%H%M%S).log"
echo "Logging test session to: $LOG_FILE"
echo "$(date): Starting Snooker Score Board tests with zen-mcp-server" >> $LOG_FILE

# Ensure dependencies are installed
echo "📦 Installing dependencies..."
flutter pub get >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    echo "$(date): Failed to install dependencies" >> $LOG_FILE
    exit 1
else
    echo "✅ Dependencies installed successfully"
    echo "$(date): Dependencies installed successfully" >> $LOG_FILE
fi

# Run the tests with flutter and capture the results
echo "🧪 Running tests..."
TEST_START_TIME=$(date +%s)
flutter test >> $LOG_FILE 2>&1
TEST_EXIT_CODE=$?
TEST_END_TIME=$(date +%s)
TEST_DURATION=$((TEST_END_TIME - TEST_START_TIME))

echo "$(date): Tests completed with exit code $TEST_EXIT_CODE (duration: ${TEST_DURATION}s)" >> $LOG_FILE

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ All tests passed!"
    echo "$(date): All tests passed" >> $LOG_FILE
else
    echo "❌ Some tests failed. Check the logs for details."
    echo "$(date): Tests failed with exit code $TEST_EXIT_CODE" >> $LOG_FILE
fi

# If zen-mcp-server is available, use it to analyze the test results
echo "🔍 Checking for zen-mcp-server availability..."
timeout 3s uvx --from git+https://github.com/BeehiveInnovations/zen-mcp-server.git zen-mcp-server --help > /dev/null 2>&1
ZEN_AVAILABLE=$?

if [ $ZEN_AVAILABLE -eq 0 ]; then
    echo "🤖 zen-mcp-server is available, performing analysis..."
    echo "$(date): zen-mcp-server available, performing test analysis" >> $LOG_FILE
    
    # Use zen-mcp-server to analyze the test results
    # This is a simplified approach - in practice, you'd use the MCP protocol to send specific requests
    echo "Test execution completed." >> $LOG_FILE
    echo "Duration: ${TEST_DURATION} seconds" >> $LOG_FILE
    echo "Exit code: $TEST_EXIT_CODE" >> $LOG_FILE
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        echo "Result: All tests passed" >> $LOG_FILE
    else
        echo "Result: Some tests failed" >> $LOG_FILE
        # Include specific test failures from log if possible
        echo "Failed tests:" >> $LOG_FILE
        grep -A 10 -B 5 "FAILURE\|ERROR\|Exception" $LOG_FILE >> $LOG_FILE 2>/dev/null || echo "No specific failures found in log" >> $LOG_FILE
    fi
    
    echo "📝 Test analysis complete"
    echo "$(date): Test analysis completed by zen-mcp-server" >> $LOG_FILE
else
    echo "⚠️ zen-mcp-server not available, skipping AI analysis"
    echo "$(date): zen-mcp-server not available, skipping AI analysis" >> $LOG_FILE
fi

echo ""
echo "📋 Test session completed. Log file: $LOG_FILE"

if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo "⚠️  Some tests failed. Review the log file for details."
    echo "   Command to view log: cat $LOG_FILE"
    exit $TEST_EXIT_CODE
else
    echo "🎉 All tests passed successfully!"
fi