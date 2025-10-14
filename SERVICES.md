# Development Services for Snooker Score Board

## Running Services

### 1. Flutter Web App
- **URL**: http://localhost:8080
- **Status**: Running
- **Purpose**: The main Snooker Score Board web application

### 2. Dart DevTools
- **URL**: http://127.0.0.1:9100
- **Status**: Running
- **Purpose**: Performance and debugging tools for Dart/Flutter apps

## How to Use

### Accessing the Web App
1. Open your browser and navigate to `http://localhost:8080`
2. You should see the Snooker Score Board application running

### Using DevTools
1. With your Flutter app running, navigate to `http://127.0.0.1:9100`
2. On the DevTools page, you should see an option to connect to a running app
3. If there's an issue connecting directly, you may need the observatory URI from the Flutter run command output

## Important Notes
- The Flutter web app was started with the command: `flutter run -d web-server --web-port=8080`
- The Dart DevTools was started with: `dart devtools --machine --port 9100`
- For the best debugging experience with Flutter web apps, you can also use the browser's built-in developer tools

## Stopping Services
To stop the running services:
1. Find the process IDs: `ps aux | grep flutter` and `ps aux | grep devtools`
2. Kill the processes: `kill -9 <PID>`