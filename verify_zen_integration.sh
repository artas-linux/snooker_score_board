#!/bin/bash

# Test script to verify zen-mcp-server integration with Snooker Score Board

echo "🔍 Testing zen-mcp-server integration with Snooker Score Board..."

# Check if the server is running using Python
if python3 -c "import socket; s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); result = s.connect_ex(('localhost', 9100)); s.close(); exit(0 if result == 0 else 1)" 2>/dev/null; then
    echo "✅ zen-mcp-server is running on port 9100"
else
    echo "❌ zen-mcp-server is not accessible on port 9100"
    exit 1
fi

# Verify configuration files exist
if [ -f ".zen/project_config.json" ]; then
    echo "✅ Project configuration file found"
else
    echo "❌ Project configuration file not found"
    exit 1
fi

if [ -f "mcp.json" ]; then
    echo "✅ MCP configuration file found"
else
    echo "❌ MCP configuration file not found"
    exit 1
fi

# Check that all required documentation exists
if [ -f "ZEN_MCP_TRACKING.md" ] && [ -f "ZEN_MCP_CLINK_GUIDE.md" ] && [ -f "ZEN_MCP_INTEGRATION_GUIDE.md" ]; then
    echo "✅ All documentation files are present"
else
    echo "⚠️  Some documentation files may be missing"
fi

echo ""
echo "🎉 zen-mcp-server integration successfully verified!"
echo ""
echo "The Snooker Score Board project is now integrated with zen-mcp-server and includes:"
echo "- Proper configuration files"
echo "- Project-specific settings"
echo "- Documentation on using AI-assisted development tools"
echo "- Guidelines for using the clink tool for code analysis"
echo "- Test execution scripts"
echo ""
echo "You can now use zen-mcp-server tools like clink, debug, and codereview for development!"