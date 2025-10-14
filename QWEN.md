# QWEN.md - Snooker Score Board Project

## Project Overview

The Snooker Score Board is a Flutter application designed to provide a digital scoreboard for snooker games. The app has been significantly enhanced with snooker-specific functionality while maintaining all existing features. It provides a complete solution for tracking scores, frames, breaks, and other snooker-specific metrics during gameplay.

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

## Project Structure

```
snooker_score_board/
├── lib/
│   ├── models/           # Data models (Player, Game)
│   ├── providers/        # State management (GameProvider)
│   ├── services/         # Business logic services
│   ├── ui/              # User interface components
│   │   ├── screens/     # Game screens (NewGame, GameBoard, Results, History)
│   │   ├── themes/      # App theming
│   │   └── widgets/     # Reusable UI components (SnookerScoreControls, ColorBallSelector)
│   └── utils/           # Utility functions
├── test/                # Unit and integration tests
├── pubspec.yaml         # Project dependencies and config
└── .mise.toml          # Task automation
```

## Building and Running

### Prerequisites
- Flutter SDK (version 3.9.2 or higher)
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
mise run build
# or
flutter build apk

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

## Development Conventions

### Code Structure
- **Models**: Pure Dart classes with serialization/deserialization methods
- **Providers**: Business logic and state management using ChangeNotifier
- **UI Components**: Separated into screens, themes, and reusable widgets
- **Services**: Data access and business logic layer

### UI Components
- **SnookerScoreControls**: Custom widget for snooker-specific score controls
- **ColorBallSelector**: Emoji-based ball selection popup with compact dark theme
- **GameProvider**: Central state management for game state

### State Management
- Uses Provider pattern with ChangeNotifier
- Game state is managed through GameProvider
- UI components interact with provider methods for updates

### Testing
- Unit tests in the `test/` directory
- Integration tests for UI flows
- Code follows Flutter best practices for testability

## Enhanced Features

### Player Controls
- **Two dedicated buttons per player**: Clean UI with just two main action buttons
- **Red Foul button**: Apply foul penalties that subtract points from the current player
- **Green Add Score button**: Opens emoji-based ball selector popup for intuitive scoring
- **Undo button**: Orange undo button (Icons.undo) for each player to undo their last score
- **Player Selection**: Tap on any player's card to highlight them with visual effects

### Scoring System
- **Snooker-specific scoring**: Quick buttons for standard ball values (Red=1, Yellow=2, Green=3, Brown=4, Blue=5, Pink=6, Black=7)
- **Foul penalties**: Dedicated buttons for common foul values (4, 5, 6, 7+ points)
- **Visual ball selector popup**: Compact dark popup (300px wide) with enlarged emoji representations
- **Emoji containers**: 52x52 size with 28px emoji for better visibility

### Tracking Features
- **Frame tracking**: Track and award frames to players with frame counter
- **Break tracking**: Track current and highest breaks for each player
- **Century break detection**: Automatically detect and record breaks of 100+ points

### UI Enhancements
- **Theme**: Dark-themed popup with fixed width and large emojis
- **Visual feedback**: Selected player cards get dark grey background with white text
- **Responsive design**: Works across different screen sizes and orientations

## MCP Integration

The project includes integration with Model Context Protocol (MCP) Chrome DevTools, allowing for advanced debugging and development features:
- Chrome DevTools MCP Server v0.8.1
- Remote debugging capabilities
- AI-assisted development tools integration
- Performance analysis tools

## Files and Documentation

The project includes extensive documentation and enhancement files:
- `ENHANCEMENTS_SUMMARY.md`: Complete summary of all added features
- `LAUNCH_GUIDE.md`: Detailed instructions on how to launch all services
- `COMPREHENSIVE_TEST_REPORT.md`: Full system analysis and test results
- `PERFORMANCE_REPORT.md`: Performance metrics and analysis
- `MCP_SETUP.md`: MCP Chrome DevTools setup instructions

## Qwen Added Memories
- The Snooker Score Board is a Flutter application with snooker-specific functionality including player scoring, frame tracking, break tracking, and foul penalties. It supports multiple platforms and includes a dark-themed emoji-based ball selection popup. The project uses mise for task automation and includes integration with Model Context Protocol (MCP) Chrome DevTools.
- Key project paths for Snooker Score Board: /home/archbtw/dev/projects/snooker_score_board (root), /home/archbtw/dev/projects/snooker_score_board/snooker_score_board (Flutter app directory), /home/archbtw/dev/projects/snooker_score_board/.mise.toml (task configuration), /home/archbtw/dev/projects/snooker_score_board/snooker_score_board/pubspec.yaml (dependencies), /home/archbtw/dev/projects/snooker_score_board/LAUNCH_GUIDE.md (launch instructions).
- When running the Snooker Score Board project, use google-chrome-stable instead of the default Zen browser to ensure compatibility with important extensions. Command: google-chrome-stable http://localhost:8080
- Complete setup for Snooker Score Board project: 1) Flutter web server on http://localhost:8080, 2) Dart DevTools on http://127.0.0.1:9100, 3) MCP Chrome DevTools server, 4) Opened in Google Chrome using google-chrome-stable to avoid Zen browser.
- I added the following tasks to the .mise.toml file for the Snooker Score Board project: dev-all (starts all development services in background), stop-all (stops all development services), web (runs Flutter web server), and web-bg (runs Flutter web server in background).
