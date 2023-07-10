import 'package:flutter/material.dart';
import 'package:phase_10_points/views/2_up_layouts/two_up_layout_1.dart';
import 'package:phase_10_points/views/2_up_layouts/two_up_layout_2.dart';
import 'package:phase_10_points/views/2_up_layouts/two_up_layout_3.dart';
import 'package:phase_10_points/views/3_up_layouts/three_up_layout_1.dart';
import 'package:phase_10_points/views/3_up_layouts/three_up_layout_2.dart';
import 'package:phase_10_points/views/4_up_layouts/four_up_layout_1.dart';
import 'package:phase_10_points/views/4_up_layouts/four_up_layout_2.dart';
import 'package:phase_10_points/views/5_up_layouts/five_up_layout_1.dart';
import 'package:phase_10_points/views/5_up_layouts/five_up_layout_2.dart';
import 'package:phase_10_points/views/6_up_layouts/six_up_layout_1.dart';
import 'package:phase_10_points/views/6_up_layouts/six_up_layout_2.dart';

const List<Color> kPlayersColors = [
  Colors.white,
  Colors.purple,
  Colors.indigoAccent,
  Colors.green,
  Colors.amberAccent,
  Colors.deepOrangeAccent,
  Colors.cyanAccent
];

enum SchemasEnum {
  up_2(
    players: 2,
    assetImages: [
      "assets/2_up_layout_1.svg",
      "assets/2_up_layout_2.svg",
      "assets/2_up_layout_3.svg"
    ],
    layoutWidgets: [TwoUpLayout1(), TwoUpLayout2(), TwoUpLayout3()],
  ),
  up_3(
    players: 3,
    assetImages: [
      "assets/3_up_layout_1.svg",
      "assets/3_up_layout_2.svg",
    ],
    layoutWidgets: [ThreeUpLayout1(), ThreeUpLayout2()],
  ),
  up_4(
    players: 4,
    assetImages: [
      "assets/4_up_layout_1.svg",
      "assets/4_up_layout_2.svg",
    ],
    layoutWidgets: [FourUpLayout1(), FourUpLayout2()],
  ),
  up_5(
    players: 5,
    assetImages: [
      "assets/5_up_layout_1.svg",
      "assets/5_up_layout_2.svg",
    ],
    layoutWidgets: [FiveUpLayout1(), FiveUpLayout2()],
  ),
  up_6(
    players: 6,
    assetImages: [
      "assets/6_up_layout_1.svg",
      "assets/6_up_layout_2.svg",
    ],
    layoutWidgets: [SixUpLayout1(), SixUpLayout2()],
  ),
  ;

  const SchemasEnum({
    required this.players,
    required this.assetImages,
    required this.layoutWidgets,
  });
  final int players;
  final List<String> assetImages;
  final List<Widget> layoutWidgets;

  int get nrOfPlayers => players;
  List<String> get layouts => assetImages;
  List<Widget> get widgets => layoutWidgets;
}