import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/color_constants.dart';

class FourUpLayout1 extends StatelessWidget {
  const FourUpLayout1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: PlayerWidget(
                          color: kColor1,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: PlayerWidget(
                          color: kColor2,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: Column(
            children: [
              Expanded(
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: PlayerWidget(
                          color: kColor3,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: PlayerWidget(
                          color: kColor4,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
            ],
          ),
        ),
      ],
    );
  }
}
