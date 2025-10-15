# 🎱 Snooker Score Board

🏆 A Flutter application for maintaining a scoreboard while playing snooker. Supports 2+ players to track scores in real-time, detect and highlight century breaks, and persist game history. The app features a professional, aesthetically pleasing UI with Flutter-based animations. 🎯

## ✨ Features

- 👥 Multi-player support (2+ players)
- 🎯 Snooker-specific scoring (ball values: Red=1, Yellow=2, Green=3, Brown=4, Blue=5, Pink=6 🌸, Black=7)
- 🏆 Frame tracking and management
- 🔥 Break tracking with century break detection
- ⚠️ Foul penalty handling
- 📊 Game history storage and retrieval
- ↩️ Undo functionality for scores
- 👆 Player selection and highlighting
- 🌙 Dark-themed emoji-based ball selection popup

## 🚀 Getting Started

### 🛠️ Prerequisites

- Flutter SDK (version 3.35.5 or higher) 
- Dart SDK

### 📥 Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/snooker_score_board.git
   ```

2. Navigate to the project directory:
   ```
   cd snooker_score_board
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```
   
   Or using mise:
   ```
   mise run install
   ```

### ▶️ Running the Application

To run the application in development mode:

```
flutter run
```

Or using mise:
```
mise run dev
```

To run the web version:
```
flutter run -d chrome
```

Or using mise:
```
mise run run-web
```

### 📦 Building for Production

To build for Android:
```
flutter build apk --release
```

To build for iOS:
```
flutter build ipa --release
```

To build for Web:
```
flutter build web --release
```

## 🏗️ Project Structure

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

## ⚙️ Available Mise Tasks

This project uses mise for task automation. Here are the available commands:

### 🛠️ Daily Development
- `mise run setup` - Initial project setup
- `mise run install` - Install dependencies
- `mise run dev` - Start development server
- `mise run run-web` - Start web development server
- `mise run test` - Run tests
- `mise run fix` - Code analysis and formatting

### 🔄 Development Support
- `mise run gen` - Run code generation
- `mise run watch` - Watch files for code generation
- `mise run coverage` - Generate HTML coverage report

### 📦 Build
- `mise run build-android` - Build Android APK/AAB
- `mise run build-ios` - Build iOS IPA
- `mise run build-web` - Build web version

### 🧹 Maintenance
- `mise run clean` - Clean project
- `mise run upgrade` - Upgrade dependencies
- `mise run help` - Show available commands

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 🙌

## 📋 License

This project is available as-is without any warranty. It is not licensed for commercial use without explicit permission. ⚖️

## 🌐 Live Demo

Check out the live demo: https://artas-linux.github.io/snooker_score_board/ 🌟