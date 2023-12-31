import 'package:flutter/material.dart';

import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

class TwoUpLayout1 extends StatelessWidget {
  const TwoUpLayout1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.height / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 1,
            child: PlayerWidget(player: 1, maxWidth: maxWidth),
          ),
        ),
        const PlayersDivider(),
        Expanded(
          child: RotatedBox(
            quarterTurns: -1,
            child: PlayerWidget(player: 2, maxWidth: maxWidth),
          ),
        ),
      ],
    );
  }
}
