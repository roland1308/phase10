import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/players_name_controller.dart';
import 'package:phase_10_points/controllers/points_controller.dart';

class PlayerWidget extends StatefulWidget {
  final double maxWidth;
  final Color color;

  const PlayerWidget({super.key, required this.maxWidth, required this.color});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  int _points = 0;
  Timer? _autoPoints;
  Timer? _hidePartial;
  int _phase = 1;
  TextEditingController _nameController = TextEditingController(text: "");
  String _name = "player";

  final _pointsController = Get.put(PointsController());
  final _playersNameController = Get.put(PlayersNameController());

  changePoints(int x) {
    resetPartial();
    changePointsState(x);
  }

  startSum(int x) {
    _autoPoints = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      resetPartial();
      changePoints(x);
    });
  }

  void changePointsState(int x) {
    setState(() {
      _points += x;
      if (_points < 0) {
        _points = 0;
      } else {
        _pointsController.showPartial(true);
        _pointsController.updatePartial(x);
      }
    });
  }

  void resetPartial() {
    if (_hidePartial != null) _hidePartial!.cancel();
    _hidePartial = Timer(const Duration(seconds: 1), () {
      _pointsController.showPartial(false);
      _pointsController.resetPartial();
    });
  }

  stopSum() {
    if (_autoPoints != null) _autoPoints!.cancel();
  }

  changePhase(int x) {
    setState(() {
      _phase += x;
      if (_phase == 0) _phase = 1;
      if (_phase == 11) _phase = 10;
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
                  onTap: () => changePoints(-5),
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
                      child: AnimatedFlipCounter(
                        value: _points,
                        textStyle: TextStyle(
                          fontSize: 100,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: widget.maxWidth / 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => changePoints(5),
                    onLongPress: () => startSum(10),
                    onLongPressUp: () => stopSum(),
                    child: FittedBox(
                      child: Text(
                        "+",
                        style: TextStyle(color: widget.color, fontSize: 60),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        buildPhase(),
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onLongPress: () {
              _changeName(context);
            },
            child: Text(_name.toUpperCase(),
                style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis)),
          ),
        )
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
            style: TextStyle(color: widget.color, fontSize: 17),
          ),
          AnimatedFlipCounter(
            value: _phase,
            prefix: _phase < 10 ? "0" : null,
            textStyle: TextStyle(
              fontSize: 20,
              color: widget.color,
            ),
          ),
/*
          Text(
            _phase.toString(),
            style: TextStyle(color: widget.color, fontSize: 20),
          ),
*/
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

  Future<void> _changeName(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    for (var text in _playersNameController.lastUsers.value)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _name = text;
                            Get.back();
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              text,
                              style: const TextStyle(fontSize: 23),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(),
                          ],
                        ),
                      )
                  ],
                ),
                TextField(
                  style: const TextStyle(fontSize: 23),
                  autofocus: true,
                  controller: _nameController,
                  onTapOutside: (_) {
                    if (_nameController.text != "" &&
                        !_playersNameController
                            .contains(_nameController.text.trim())) {
                      _playersNameController
                          .addUser(_nameController.text.trim());
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value == "") {
                        value = "PLAYER";
                      }
                      _name = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Nombre jugador",
                  ),
                ),
              ],
            ),
          );
        });
  }
}
