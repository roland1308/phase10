import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/points_controller.dart';

class PlayerWidget extends StatefulWidget {
  final double maxWidth;
  final Color color;

  const PlayerWidget({super.key, required this.maxWidth, required this.color});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  int points = 0;
  Timer? autoPoints;
  Timer? hidePartial;
  int phase = 1;

  final pointsController = Get.put(PointsController());

  changePoints(int x) {
    resetPartial();
    changePointsState(x);
  }

  startSum(int x) {
    autoPoints = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      resetPartial();
      changePoints(x);
    });
  }

  void changePointsState(int x) {
    setState(() {
      points += x;
      if (points < 0) {
        points = 0;
      } else {
        pointsController.showPartial(true);
        pointsController.updatePartial(x);
      }
    });
  }

  void resetPartial() {
    if (hidePartial != null) hidePartial!.cancel();
    hidePartial = Timer(const Duration(seconds: 1), () {
      pointsController.showPartial(false);
      pointsController.resetPartial();
    });
  }

  stopSum() {
    if (autoPoints != null) autoPoints!.cancel();
  }

  changePhase(int x) {
    setState(() {
      phase += x;
      if (phase == 0) phase = 1;
      if (phase == 11) phase = 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Row(
          children: [
            SizedBox(
              width: widget.maxWidth / 6,
              child: Center(
                child: GestureDetector(
                  onTap: () => changePoints(-1),
                  onLongPress: () => startSum(-10),
                  onLongPressUp: () => stopSum(),
                  child: Text(
                    "-",
                    style: TextStyle(color: widget.color, fontSize: 70),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Center(
                    child: FittedBox(
                      child: Text(
                        points.toString(),
                        style: TextStyle(color: widget.color, fontSize: 80),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: widget.maxWidth / 6,
              child: Center(
                child: GestureDetector(
                  onTap: () => changePoints(1),
                  onLongPress: () => startSum(10),
                  onLongPressUp: () => stopSum(),
                  child: Text(
                    "+",
                    style: TextStyle(color: widget.color, fontSize: 70),
                  ),
                ),
              ),
            )
          ],
        ),
        buildPhase(),
      ],
    );
  }

  Positioned buildPhase() {
    return Positioned(
      top: 0,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => changePhase(-1),
            child: Text(
              "-  ",
              style: TextStyle(color: widget.color, fontSize: 25),
            ),
          ),
          Text(
            "Phase:  ",
            style: TextStyle(color: widget.color, fontSize: 20),
          ),
          Text(
            ((phase / 80).toStringAsFixed(2)).substring(2),
            style: TextStyle(color: widget.color, fontSize: 20),
          ),
          GestureDetector(
            onTap: () => changePhase(1),
            child: Text(
              "  +",
              style: TextStyle(color: widget.color, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
