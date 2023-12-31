import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';



class ThreeUpLayout2 extends StatelessWidget {
  const ThreeUpLayout2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: PlayerWidget(
                      player: 1,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: PlayerWidget(
                      player: 2,
                      maxWidth: MediaQuery.of(context).size.height / 2),
                ),
              ),
            ],
          ),
        ),
        const PlayersDivider(),
        PlayerWidget(
            player: 3, maxWidth: MediaQuery.of(context).size.width),
      ],
    );
  }
}
