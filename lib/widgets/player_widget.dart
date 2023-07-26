import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/last_players_name_controller.dart';
import 'package:phase_10_points/controllers/points_controller.dart';

import '../services/speech_service.dart';
import '../utils/constants.dart';

class PlayerWidget extends StatelessWidget {
  final PointsController pointsController = Get.find();

  final double maxWidth;
  final int player;

  PlayerWidget({
    super.key,
    required this.maxWidth,
    required this.player,
  });

  Timer? _autoPoints;

  final TextEditingController _nameController = TextEditingController(text: "");

  final PointsController _pointsController = Get.find();
  final LastPlayersNameController _playersNameController = Get.find();
  final SpeechController _speechController = Get.find();

  Color _playerColor = Colors.white;

  void startSum(int x) {
    _autoPoints = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _pointsController.changePointsState(player, x);
    });
  }

  void stopSum() {
    if (_autoPoints != null) _autoPoints!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GetX<PointsController>(builder: (context) {
          _playerColor =
              kPlayersColors[_pointsController.newPlayers[player].profileColor];
          return Row(
            children: [
              SizedBox(
                width: maxWidth / 6,
                child: Center(
                  child: GestureDetector(
                    onTap: () =>
                        _pointsController.changePointsState(player, -5),
                    onLongPress: () => startSum(-10),
                    onLongPressUp: () => stopSum(),
                    child: Text(
                      "-",
                      style: TextStyle(color: _playerColor, fontSize: 70),
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
                          value: _pointsController.newPlayers[player].points,
                          textStyle: TextStyle(
                            fontSize: 100,
                            color: _playerColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: maxWidth / 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () =>
                          _pointsController.changePointsState(player, 5),
                      onLongPress: () => startSum(10),
                      onLongPressUp: () => stopSum(),
                      child: FittedBox(
                        child: Text(
                          "+",
                          style: TextStyle(color: _playerColor, fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
        buildPhase(),
        GetX<PointsController>(builder: (_) {
          return Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                _changeNameAlert(context);
              },
              child: Row(
                children: [
                  Text(
                    _pointsController.newPlayers[player].name.toUpperCase(),
                    style: TextStyle(
                        color: _playerColor,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis),
                  ),
                  GestureDetector(
                    onTap: () {
                      _changeColorAlert(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          color: _playerColor, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  Positioned buildPhase() {
    return Positioned(
      top: 0,
      child: GetX<PointsController>(builder: (_) {
        return Row(
          children: [
            GestureDetector(
              onTap: () => _pointsController.changePhase(player, -1),
              child: Text(
                "-  ",
                style: TextStyle(color: _playerColor, fontSize: 25),
              ),
            ),
            _pointsController.newPlayers[player].isClosingPhase10
                ? GestureDetector(
                    onTap: () => _pointsController.setIsGameEnded(true),
                    child: Text(
                      "CERRAR",
                      style: TextStyle(color: _playerColor, fontSize: 17),
                    ),
                  )
                : Row(
                    children: [
                      Text(
                        "Phase: ",
                        style: TextStyle(color: _playerColor, fontSize: 17),
                      ),
                      AnimatedFlipCounter(
                        value: _pointsController.newPlayers[player].phase,
                        prefix:
                            _pointsController.newPlayers[player].phase.toInt() <
                                    10
                                ? "0"
                                : null,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: _playerColor,
                        ),
                      ),
                    ],
                  ),
            GestureDetector(
              onTap: () => _pointsController.changePhase(player, 1),
              child: Text(
                "  +",
                style: TextStyle(color: _playerColor, fontSize: 25),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _changeNameAlert(BuildContext context) async {
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
                      onTap: () async {
                        _pointsController.setName(player, text);
                        Get.back();
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
              GetX<SpeechController>(builder: (context) {
                _nameController.text =
                    _pointsController.newPlayers[player].name;
                return TextField(
                  style: const TextStyle(fontSize: 23),
                  autofocus: true,
                  controller: _nameController,
                  onTapOutside: (_) {
                    if (_nameController.text != "" &&
                        !_nameController.text.contains("JUGADOR")) {
                      _pointsController.setName(
                          player, _nameController.text.trim());
                      if (!_playersNameController
                          .contains(_nameController.text.trim())) {
                        _playersNameController
                            .addUser(_nameController.text.trim());
                      }
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () => _speechController.isListening()
                          ? _speechController.stopListening
                          : _speechController.startListening(player: player),
                      child: Icon(_speechController.isListening()
                          ? Icons.mic
                          : Icons.mic_off),
                    ),
                    hintText: "Nombre jugador",
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeColorAlert(BuildContext context) async {
    double insetPadding = (MediaQuery.of(context).size.width - 265) / 2;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(insetPadding),
          content: Wrap(
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: _colorSelector(player)),
        );
      },
    );
  }

  List<Widget> _colorSelector(player) {
    List<Widget> list = [];
    int len = kPlayersColors.length;
    for (int colorIndex = 0; colorIndex < len; colorIndex++) {
      Color singleColor = kPlayersColors[colorIndex];
      list.add(
        GestureDetector(
          onTap: () => _changeColor(colorIndex),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (_pointsController.colorInUse(colorIndex) != -1)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 3),
                        color: Colors.white,
                        shape: BoxShape.circle),
                  ),
                if (_playerColor == singleColor)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: singleColor, width: 5),
                        color: Colors.white,
                        shape: BoxShape.circle),
                  ),
                Container(
                  height: 38,
                  width: 38,
                  decoration:
                      BoxDecoration(color: singleColor, shape: BoxShape.circle),
                ),
              ],
            ),
          ),
        ),
      );
    }
    list.removeAt(0);
    return list;
  }

  _changeColor(int selectedColorIndex) {
    _pointsController.changePlayersColor(player, selectedColorIndex);
    _playerColor = kPlayersColors[selectedColorIndex];
    Get.back();
  }
}
