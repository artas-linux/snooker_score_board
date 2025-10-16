# Snooker Score Board Development Notes

## Project Overview

The Snooker Score Board is a Flutter application designed to provide a digital scoreboard for snooker games. The app includes snooker-specific functionality and provides a complete solution for tracking scores, frames, breaks, and other snooker-specific metrics during gameplay.

### Main Technologies
- **Framework**: Flutter (Dart)
- **State Management**: Provider package
- **Storage**: Shared preferences and SQLite
- **Architecture**: MVVM pattern with separation of concerns

### Key Features
- Multi-player game support
- Snooker-specific scoring (ball values: Red=1, Yellow=2, Green=3, Brown=4, Blue=5, Pink=6, Black=7)
- Frame tracking and management
- Break tracking with century break detection
- Foul penalty handling
- Game history storage and retrieval
- Undo functionality for scores
- Player selection and highlighting
- Dark-themed emoji-based ball selection popup

## Building and Running

### Prerequisites
- Flutter SDK (version 3.35.5 or higher)
- Dart SDK
- Android SDK (for Android builds)
- iOS SDK (for iOS builds)

### Setup Commands
```bash
# Install dependencies
mise run install
# or
flutter pub get

# Run the application
mise run dev
# or
flutter run

# Build for Android
flutter build apk

# Build for Web
flutter build web

# Clean the project
mise run clean
# or
flutter clean
```

### Supported Platforms
- Android
- iOS
- Web
- Desktop (Linux, Windows, macOS)

## Project Structure

The application follows standard Flutter project structure with:
- `lib/models/` - Data models (Player, Game)
- `lib/providers/` - State management (GameProvider)
- `lib/services/` - Business logic services
- `lib/ui/` - User interface components (screens, themes, widgets)
- `test/` - Unit and integration tests

## Available Mise Tasks

This project uses mise for task automation:
- `mise run setup` - Initial project setup
- `mise run install` - Install dependencies
- `mise run dev` - Start development server
- `mise run run-web` - Start web development server
- `mise run test` - Run tests
- `mise run build-android` - Build Android APK
- `mise run build-ios` - Build iOS IPA
- `mise run build-web` - Build web version
- `mise run clean` - Clean project
- `mise run help` - Show all available commands

## Qwen Added Memories
- Successfully reset the Snooker Score Board project by: 1) Merging all work branches into main, 2) Cleaning up unnecessary files and directories, 3) Updating GitHub Actions workflow, 4) Updating documentation, 5) Updating mise.toml with proper configuration, 6) Testing the web app which now runs on http://localhost:8080. The project is cleaned up and ready for GitHub.
- Successfully implemented a foul button with negative score functionality in the Snooker Score Board app. The changes included: 1) Modified ColorBallSelector widget to accept negative scores using a useNegativeScores parameter, 2) Added a new "Foul-" button to SnookerScoreControls that opens the ball selector with negative values, 3) Added applyFoulWithSpecificValue method in GameProvider to handle negative scores, 4) The functionality allows selecting a ball value for the foul which is subtracted from the player's score, properly resetting the current break and preventing scores from going below zero. The web app is running at http://localhost:8080.
- Successfully updated all references from 'chrome' to 'google-chrome-stable' in the project: 1) Updated the dev-web task in .mise.toml to use google-chrome-stable as the device identifier, 2) Updated the dart devtools -d chrome command in devtools.md to use google-chrome-stable, 3) Updated the flutter run -d chrome command in README.md to use google-chrome-stable.
- To properly restart the Snooker Score Board web application: 1) Kill all Flutter processes with 'pkill -f flutter || true', 2) Kill all processes on port 8080 with 'fuser -k 8080/tcp || true', 3) Wait for processes to fully terminate with 'sleep 2', 4) Run 'mise run dev-web' to restart the application.
- To properly restart the Snooker Score Board web application and open in Chrome: 1) Kill all Flutter processes with 'pkill -f flutter || true', 2) Kill all processes on port 8080 with 'fuser -k 8080/tcp || true', 3) Wait for processes to fully terminate with 'sleep 2', 4) Run 'mise run dev-web' to restart the application, 5) Open the application in Chrome with 'google-chrome-stable http://localhost:8080' or 'xdg-open http://localhost:8080' if available.
- To properly restart the Snooker Score Board web application: 1) Kill all Flutter processes with 'pkill -f flutter || true', 2) Kill all processes on port 8080 with 'fuser -k 8080/tcp || true', 3) Wait for processes to fully terminate with 'sleep 2', 4) Run 'mise run dev-web' to restart the application, 5) Open the application in Chrome with 'google-chrome-stable http://localhost:8080' or 'xdg-open http://localhost:8080' if available.
- To properly restart the Snooker Score Board web application: 1) Kill all Flutter processes with 'pkill -f flutter || true', 2) Kill all processes on port 8080 with 'fuser -k 8080/tcp || true', 3) Wait for processes to fully terminate with 'sleep 2', 4) Run 'mise run dev-web' to restart the application, 5) Open the application in Chrome with 'google-chrome-stable http://localhost:8080' or 'xdg-open http://localhost:8080' if available.
- The restart-web task in mise.toml was fixed by changing from an array of commands to a shell script syntax with set -e. The working version properly: 1) kills all Flutter processes with 'pkill -f flutter', 2) kills processes on port 8080 with 'fuser -k 8080/tcp', 3) waits 2 seconds, then 4) starts the Flutter web server with 'flutter run -d web-server --web-port 8080'. Using shell script syntax in mise tasks provides more reliable command execution than an array of commands.
- MCP Server Performance Test Results for Snooker Score Board project:
- Target: localhost:9100
- Connection Speed: Average 3.79ms
- Response Time: Average 2.64ms 
- Throughput: 1988.83 connections/sec
- Reliability: 100% success rate (10/10 connections successful)
- Total test duration: 379.22ms
- The server is highly responsive and optimized for AI-assisted development workflows
- The build_runner package was added to the dev_dependencies in pubspec.yaml, and the watch task in mise.toml was reverted to its original form. The watch command now successfully runs 'dart pub run build_runner watch --delete-conflicting-outputs' to watch for file changes and auto-generate code. This enables automatic regeneration of code based on annotations like json_serializable, freezed, built_value, etc.
- Successfully implemented flying score animations and score highlighting in the Snooker Score Board app. When a player selects a colored ball, a "+X" bubble flies from the selection to the player's score, and the score temporarily highlights in green. Changes included: 1) Creating FlyingScoreAnimation and ScoreHighlightWidget, 2) Updating GameProvider to track last ball scored, 3) Integrating animations into AnimatedPlayerScoreCard with proper positioning and timing.
