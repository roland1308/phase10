import 'package:flutter/material.dart';

class Player {
  String name;
  int points;
  int phase;
  bool isClosingPhase10;
  int profileColor;

  Player(
      {required this.name,
      required this.points,
      required this.phase,
      required this.isClosingPhase10,
      required this.profileColor});

  Player.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        points = json['points'],
        phase = json['phase'],
        isClosingPhase10 = json['isClosingPhase10'],
        profileColor = json['profileColor'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points,
        'phase': phase,
        'isClosingPhase10': isClosingPhase10,
        'profileColor': profileColor
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          points == other.points &&
          phase == other.phase &&
          isClosingPhase10 == other.isClosingPhase10 &&
          profileColor == other.profileColor;

  @override
  int get hashCode =>
      name.hashCode ^
      points.hashCode ^
      phase.hashCode ^
      isClosingPhase10.hashCode ^
      profileColor.hashCode;
}
