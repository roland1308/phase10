import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/constants.dart';


class SixUpLayout1 extends StatelessWidget {
  const SixUpLayout1({
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
                          player: 1,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: PlayerWidget(
                          player: 2,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: PlayerWidget(
                          player: 3,
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
                          player: 4,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: PlayerWidget(
                          player: 5,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const PlayersDivider()),
              Expanded(
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: PlayerWidget(
                          player: 6,
                          maxWidth: MediaQuery.of(context).size.height / 2))),
            ],
          ),
        ),
      ],
    );
  }
}
