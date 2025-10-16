# Flutter DevTools Setup for Snooker Score Board

## Overview
Flutter DevTools is a suite of performance and debugging tools for Dart and Flutter applications. It is included as part of the Flutter SDK.

## Launching Flutter DevTools

### Method 1: From VS Code
1. Make sure you have the Dart and Flutter extensions installed in VS Code
2. Start your Flutter application with `flutter run`
3. In VS Code, click on the "Flutter Inspector" tab in the Debug view
4. Click the "Open DevTools in Browser" button

### Method 2: From Android Studio/IntelliJ
1. Start your Flutter application with `flutter run`
2. In the Flutter Inspector tab, click on the "Open DevTools" button

### Method 3: From Command Line
1. Start your Flutter application with `flutter run`
2. In a new terminal, run:
   ```bash
   dart devtools
   ```

### Method 4: Direct Command Line Launch
1. After starting your app with `flutter run`, you'll see a message like:
   ```
   Running with unsound null safety
   For build performance, unsound null safety is preferred.
   To remove this banner, use the --no-sound-null-safety flag.
   An Observatory debugger and profiler on Chrome is available at: http://127.0.0.1:xxxxx/
   ```
2. Note the Observatory URL and run:
   ```bash
   dart devtools -d google-chrome-stable
   # or
   dart devtools --machine --port 9100
   ```

### Troubleshooting
If you get a null safety error when trying to activate devtools, use `dart devtools` directly instead of installing it with `flutter pub global activate devtools`.

## Key Features of Flutter DevTools

- **Performance**: Examine your app's performance and identify jank
- **Widget Inspector**: Interactively explore and debug your widget tree
- **Memory**: Monitor your app's memory usage
- **Network**: Examine network traffic
- **Logging**: View logs and diagnostics
- **Debugger**: Source-level debugging
- **Code Size**: Analyze code and app size

## Using DevTools with Your App

1. Start your Snooker Score Board app:
   ```bash
   cd snooker_score_board
   flutter run
   ```

2. Launch DevTools using one of the methods above

3. Connect to your running app and start debugging

## Notes
- DevTools connects to your running Flutter app separately and doesn't require adding any packages to your pubspec.yaml
- For the most up-to-date DevTools functionality, ensure you keep your Flutter SDK updated with `flutter upgrade`