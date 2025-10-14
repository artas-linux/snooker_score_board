import 'package:flutter/material.dart';
import 'package:snooker_score_board/utils/accessibility_utils.dart';

class ColorBallSelector extends StatelessWidget {
  final Function(int points) onBallSelected;

  const ColorBallSelector({
    super.key,
    required this.onBallSelected,
  });

  @override
  Widget build(BuildContext context) {
    final snookerBalls = [
      {'emoji': '🔴', 'points': 1},
      {'emoji': '🟡', 'points': 2},
      {'emoji': '🟢', 'points': 3},
      {'emoji': '🟤', 'points': 4},
      {'emoji': '🔵', 'points': 5},
      {'emoji': '🟣', 'points': 6},
      {'emoji': '⚫', 'points': 7},
    ];

    return Container(
      width: 300,  // Fixed width to make it smaller
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900, // Dark background
        borderRadius: const BorderRadius.all(Radius.circular(16)), // Rounded corners all around
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SELECT BALL',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              color: Colors.white // White text on dark background
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: snookerBalls.map((ball) {
              int points = ball['points'] as int;
              String label = AccessibilityUtils.generateBallLabel(points);
              
              return Semantics(
                button: true,
                label: label,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the modal
                    onBallSelected(ball['points'] as int);
                  },
                  child: Container(
                    width: 52,  // Larger size
                    height: 52,  // Larger size
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800, // Dark container for emoji
                      borderRadius: BorderRadius.circular(12), // More rounded
                      border: Border.all(
                        color: Colors.grey.shade600, // Darker border
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ball['emoji'] as String,
                        style: const TextStyle(
                          fontSize: 28, // Much larger emoji
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // White text
              backgroundColor: Colors.grey.shade700, // Darker button
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Slightly rounded
              ),
            ),
            child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}