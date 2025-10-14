// Constants for accessibility features
class AccessibilityConstants {
  // Text scale factor thresholds
  static const double smallTextThreshold = 0.8;
  static const double largeTextThreshold = 1.3;
  
  // Minimum touch target sizes (in dp)
  static const double minTouchTargetSize = 48.0;
  
  // Semantic label prefixes
  static const String scorePrefix = "Score for ";
  static const String framePrefix = "Frames won: ";
  static const String breakPrefix = "Current break: ";
  static const String centuryBreakPrefix = "Century breaks: ";
  static const String playerPrefix = "Player ";
}

// Accessibility utilities
class AccessibilityUtils {
  // Check if text scaling is enabled at a significant level
  static bool isTextScalingSignificant(double textScaleFactor) {
    return textScaleFactor < AccessibilityConstants.smallTextThreshold || 
           textScaleFactor > AccessibilityConstants.largeTextThreshold;
  }
  
  // Generate semantic labels for scores
  static String generateScoreLabel(String playerName, int score) {
    return '${AccessibilityConstants.scorePrefix}$playerName is $score points';
  }
  
  // Generate semantic labels for frames
  static String generateFrameLabel(int framesWon) {
    return '${AccessibilityConstants.framePrefix}$framesWon';
  }
  
  // Generate semantic labels for breaks
  static String generateBreakLabel(int currentBreak) {
    if (currentBreak > 0) {
      return '${AccessibilityConstants.breakPrefix}$currentBreak points';
    }
    return 'No current break';
  }
  
  // Generate semantic labels for century breaks
  static String generateCenturyBreakLabel(int centuryBreaksCount) {
    if (centuryBreaksCount > 0) {
      return '${AccessibilityConstants.centuryBreakPrefix}$centuryBreaksCount';
    }
    return 'No century breaks achieved';
  }
  
  // Generate semantic labels for players
  static String generatePlayerLabel(int playerIndex, String playerName) {
    return '${AccessibilityConstants.playerPrefix}${playerIndex + 1}: $playerName';
  }
  
  // Generate semantic label for snooker ball selection
  static String generateBallLabel(int points) {
    String pointsStr = points == 1 ? 'one' : points.toString();
    return 'Snooker ball worth $pointsStr point${points == 1 ? "" : "s"}';
  }
}