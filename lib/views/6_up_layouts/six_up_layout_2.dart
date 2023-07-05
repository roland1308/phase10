import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/constants.dart';

class SixUpLayout2 extends StatelessWidget {
  const SixUpLayout2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 2,
            child: PlayerWidget(
                color: kColor6,
                maxWidth: MediaQuery.of(context).size.height / 2),
          ),
        ),
        const PlayersDivider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: PlayerWidget(
                      color: kColor1,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: PlayerWidget(
                      color: kColor2,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
            ],
          ),
        ),
        const PlayersDivider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: PlayerWidget(
                      color: kColor3,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: PlayerWidget(
                      color: kColor4,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
            ],
          ),
        ),
        const PlayersDivider(),
        Expanded(
          child: PlayerWidget(
              color: kColor5, maxWidth: MediaQuery.of(context).size.height / 2),
        ),
      ],
    );
  }
}
