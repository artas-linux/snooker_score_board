#!/usr/bin/env python3
"""
Test script to connect to zen-mcp-server using the Model Context Protocol (MCP)
and list available tools.
"""
import json
import socket
import sys


def connect_to_mcp_server(host='localhost', port=9100):
    """Connect to the MCP server and send a request to list tools."""
    try:
        # Create a socket connection to the MCP server
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(10)  # 10 second timeout
            sock.connect((host, port))
            
            # Prepare a request to list tools (this is an MCP protocol request)
            # We're sending an MCP request to get available tools
            request = {
                "method": "tools/list",
                "params": {},
                "id": 1,
                "jsonrpc": "2.0"
            }
            
            # Convert to JSON and send with newline termination (as per MCP spec)
            request_json = json.dumps(request)
            request_bytes = (request_json + '\n').encode('utf-8')
            
            print(f"Sending request: {request_json}")
            sock.sendall(request_bytes)
            
            # Receive response
            response_bytes = sock.recv(4096)
            response_str = response_bytes.decode('utf-8').strip()
            
            print(f"Received response: {response_str}")
            
            try:
                response = json.loads(response_str.split('\n')[0])  # Take first line if multiple
                if 'result' in response:
                    tools = response['result']['tools']
                    print(f"\n📋 Available tools:")
                    for tool in tools:
                        print(f"  - {tool['name']}")
                    return True
                else:
                    print(f"❌ Unexpected response format: {response}")
                    return False
            except json.JSONDecodeError as e:
                print(f"❌ Error parsing JSON response: {e}")
                print(f"   Raw response: {response_str}")
                return False
                
    except Exception as e:
        print(f"❌ Error connecting to MCP server: {e}")
        return False


if __name__ == "__main__":
    print("📡 Connecting to zen-mcp-server via MCP protocol...")
    
    success = connect_to_mcp_server()
    
    if success:
        print("\n✅ Successfully connected to zen-mcp-server and retrieved tools!")
        print("You can now use tools like clink, debug, codereview, etc. for your Snooker Score Board project.")
    else:
        print("\n❌ Failed to connect to zen-mcp-server or retrieve tools.")
        sys.exit(1)