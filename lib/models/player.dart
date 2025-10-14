class Player {
  final String id;
  String name;
  int score;
  int framesWon;
  List<int> centuryBreaks;
  int currentBreak;
  int highestBreak;
  int lastScore; // For undo functionality
  List<int> scoreHistory; // History of scores for undo

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.framesWon = 0,
    this.centuryBreaks = const [],
    this.currentBreak = 0,
    this.highestBreak = 0,
    this.lastScore = 0,
    this.scoreHistory = const [],
  });

  // Factory constructor for creating a Player from a map (e.g., from JSON/database)
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      name: map['name'] as String,
      score: map['score'] as int,
      framesWon: map['framesWon'] as int? ?? 0,
      centuryBreaks: List<int>.from(map['centuryBreaks'] as List),
      currentBreak: map['currentBreak'] as int? ?? 0,
      highestBreak: map['highestBreak'] as int? ?? 0,
      lastScore: map['lastScore'] as int? ?? 0,
      scoreHistory: List<int>.from(map['scoreHistory'] as List? ?? []),
    );
  }

  // Method for converting a Player to a map (e.g., for JSON/database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'framesWon': framesWon,
      'centuryBreaks': centuryBreaks,
      'currentBreak': currentBreak,
      'highestBreak': highestBreak,
      'lastScore': lastScore,
      'scoreHistory': scoreHistory,
    };
  }

  // For easy debugging and logging
  @override
  String toString() => 'Player(id: $id, name: $name, score: $score, centuryBreaks: $centuryBreaks)';
}
