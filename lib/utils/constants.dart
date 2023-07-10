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

import '../models/schema_model.dart';

const List<Color> kPlayersColors = [
  Colors.purple,
  Colors.indigoAccent,
  Colors.green,
  Colors.amberAccent,
  Colors.deepOrangeAccent,
  Colors.cyanAccent
];

List<Schema> kLayouts = [
  Schema(
    players: 2,
    assetImages: [
      "assets/2_up_layout_1.svg",
      "assets/2_up_layout_2.svg",
      "assets/2_up_layout_3.svg",
    ],
    layoutWidgets: [
      const TwoUpLayout1(),
      const TwoUpLayout2(),
      const TwoUpLayout3(),
    ],
  ),
  Schema(
    players: 3,
    assetImages: [
      "assets/3_up_layout_1.svg",
      "assets/3_up_layout_2.svg",
    ],
    layoutWidgets: [
      const ThreeUpLayout1(),
      const ThreeUpLayout2(),
    ],
  ),
  Schema(
    players: 4,
    assetImages: [
      "assets/4_up_layout_1.svg",
      "assets/4_up_layout_2.svg",
    ],
    layoutWidgets: [
      const FourUpLayout1(),
      const FourUpLayout2(),
    ],
  ),
  Schema(
    players: 5,
    assetImages: [
      "assets/5_up_layout_1.svg",
      "assets/5_up_layout_2.svg",
    ],
    layoutWidgets: [
      const FiveUpLayout1(),
      const FiveUpLayout2(),
    ],
  ),
  Schema(
    players: 6,
    assetImages: [
      "assets/6_up_layout_1.svg",
      "assets/6_up_layout_2.svg",
    ],
    layoutWidgets: [
      const SixUpLayout1(),
      const SixUpLayout2(),
    ],
  ),
];
