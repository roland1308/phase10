import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';

import '../../utils/execute_after_build.dart';

class FiveUpLayout1 extends StatelessWidget {
  const FiveUpLayout1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ExecuteAfterBuild().initializeSavedGame();
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
            ],
          ),
        ),
      ],
    );
  }
}
