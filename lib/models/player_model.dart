class Player {
  String name;
  int points;
  int phase;
  bool isClosingPhase10;
  Player({
    required this.name,
    required this.points,
    required this.phase,
    required this.isClosingPhase10,
  });

  Player.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        points = json['points'],
        phase = json['phase'],
        isClosingPhase10 = json['isClosingPhase10'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points,
        'phase': phase,
        'isClosingPhase10': isClosingPhase10
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          points == other.points &&
          phase == other.phase &&
          isClosingPhase10 == other.isClosingPhase10;

  @override
  int get hashCode =>
      name.hashCode ^
      points.hashCode ^
      phase.hashCode ^
      isClosingPhase10.hashCode;
}
