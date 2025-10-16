import 'package:flutter/material.dart';
import 'package:snooker_score_board/utils/accessibility_utils.dart';

class ColorBallSelector extends StatelessWidget {
  final Function(int points) onBallSelected;
  final bool useNegativeScores; // Whether to show negative scores (for fouls)

  const ColorBallSelector({
    super.key,
    required this.onBallSelected,
    this.useNegativeScores = false,
  });

  @override
  Widget build(BuildContext context) {
    final snookerBalls = [
      {'emoji': '🔴', 'points': 1},
      {'emoji': '🟡', 'points': 2},
      {'emoji': '🟢', 'points': 3},
      {'emoji': '🟤', 'points': 4},
      {'emoji': '🔵', 'points': 5},
      {
        'emoji': '🌸',
        'points': 6,
      }, // Changed from purple to pink using flower emoji
      {'emoji': '⚫', 'points': 7},
    ];

    // Create balls with negative points if using negative scores
    final displayedBalls = useNegativeScores
        ? snookerBalls
              .map(
                (ball) => {
                  'emoji': ball['emoji'],
                  'points': -(ball['points'] as int),
                },
              )
              .toList()
        : snookerBalls;

    return Container(
      width: 320, // Slightly wider to accommodate larger balls
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900, // Dark background
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              useNegativeScores ? 'SELECT FOUL VALUE' : 'SELECT BALL VALUE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text on dark background
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16.0, // Increased spacing
            runSpacing: 16.0, // Increased spacing
            alignment: WrapAlignment.center,
            children: displayedBalls.map((ball) {
              int points = ball['points'] as int;
              String label = AccessibilityUtils.generateBallLabel(points.abs());

              return Semantics(
                button: true,
                label: label,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the modal
                    onBallSelected(points);
                  },
                  child: Container(
                    width: 64, // Larger size for better visibility
                    height: 64, // Larger size for better visibility
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800, // Dark container for emoji
                      borderRadius: BorderRadius.circular(16), // More rounded
                      border: Border.all(
                        color: Colors.grey.shade600, // Darker border
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Center the emoji
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            ball['emoji'] as String,
                            style: const TextStyle(
                              fontSize:
                                  32, // Much larger emoji for better visibility
                            ),
                          ),
                        ),
                        // Display the point value in the bottom right corner
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              points
                                  .abs()
                                  .toString(), // Show absolute value of points
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // White text
              backgroundColor: Colors.red.shade700, // Red cancel button
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              minimumSize: const Size(
                double.infinity,
                0,
              ), // Makes the button full width
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // More rounded
              ),
            ),
            child: const Text(
              'CANCEL',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
