import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/color_constants.dart';

class TwoUpLayout1 extends StatelessWidget {
  const TwoUpLayout1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: RotatedBox(
                quarterTurns: 1,
                child: PlayerWidget(
                    color: kColor1,
                    maxWidth: MediaQuery.of(context).size.height / 2))),
        const PlayersDivider(),
        Expanded(
            child: RotatedBox(
                quarterTurns: -1,
                child: PlayerWidget(
                    color: kColor2,
                    maxWidth: MediaQuery.of(context).size.height / 2))),
      ],
    );
  }
}
