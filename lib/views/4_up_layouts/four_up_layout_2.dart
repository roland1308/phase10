import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/constants.dart';

class FourUpLayout2 extends StatelessWidget {
  const FourUpLayout2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotatedBox(
          quarterTurns: 2,
          child: PlayerWidget(
              color: kColor1, maxWidth: MediaQuery.of(context).size.width),
        ),
        const PlayersDivider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: PlayerWidget(
                      color: kColor2,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: PlayerWidget(
                      color: kColor3,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
            ],
          ),
        ),
        const PlayersDivider(),
        PlayerWidget(
            color: kColor4, maxWidth: MediaQuery.of(context).size.width),
      ],
    );
  }
}
