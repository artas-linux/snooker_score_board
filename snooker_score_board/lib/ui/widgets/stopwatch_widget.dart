import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snooker_score_board/providers/game_provider.dart';

class StopwatchWidget extends StatelessWidget {
  const StopwatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.currentGame == null) {
          return const Text(
            '00:00',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        final Duration elapsed = gameProvider.getGameDuration();

        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(elapsed.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(elapsed.inSeconds.remainder(60));

        String timeString = '${twoDigits(elapsed.inHours)}:$twoDigitMinutes:$twoDigitSeconds';

        return Text(
          timeString,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        );
      },
    );
  }
}