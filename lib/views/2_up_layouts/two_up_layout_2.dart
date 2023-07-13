import 'package:flutter/material.dart';
import 'package:phase_10_points/widgets/player_widget.dart';
import 'package:phase_10_points/utils/players_divider.dart';



class TwoUpLayout2 extends StatelessWidget {
  const TwoUpLayout2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 2,
            child: PlayerWidget(
                player: 1, maxWidth: MediaQuery.of(context).size.width),
          ),
        ),
        const PlayersDivider(),
        Expanded(
          child: PlayerWidget(
              player: 2, maxWidth: MediaQuery.of(context).size.width),
        ),
      ],
    );
  }
}
