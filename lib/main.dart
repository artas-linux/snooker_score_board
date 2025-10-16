import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';
import 'package:snooker_score_board/ui/screens/new_game_screen.dart';
import 'package:snooker_score_board/ui/themes/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GameProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snooker Score Board. from GNG boys',
      theme: AppTheme.lightTheme, // Placeholder for light theme
      darkTheme: AppTheme.darkTheme, // Placeholder for dark theme
      themeMode: ThemeMode.system, // Use system theme by default
      home: const NewGameScreen(), // Our starting screen
    );
  }
}
