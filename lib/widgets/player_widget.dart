import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/players_name_controller.dart';
import 'package:phase_10_points/controllers/points_controller.dart';

import '../controllers/speech_controller.dart';
import '../utils/constants.dart';

class PlayerWidget extends StatefulWidget {
  final PointsController pointsController = Get.find();

  final double maxWidth;
  final int player;

  PlayerWidget({
    super.key,
    required this.maxWidth,
    required this.player,
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  Timer? _autoPoints;

  final TextEditingController _nameController = TextEditingController(text: "");

  final PointsController _pointsController = Get.find();
  final PlayersNameController _playersNameController = Get.find();
  final SpeechController _speechController = Get.find();

  void startSum(int x) {
    _autoPoints = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _pointsController.changePointsState(widget.player, x);
    });
  }

  void stopSum() {
    if (_autoPoints != null) _autoPoints!.cancel();
  }

  @override
  void initState() {
    super.initState();
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
                  onTap: () =>
                      _pointsController.changePointsState(widget.player, -5),
                  onLongPress: () => startSum(-10),
                  onLongPressUp: () => stopSum(),
                  child: Text(
                    "-",
                    style: TextStyle(
                        color: kPlayersColors[widget.player], fontSize: 70),
                  ),
                ),
              ),
            ),
            GetX<PointsController>(builder: (context) {
              return Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Center(
                      child: FittedBox(
                        child: AnimatedFlipCounter(
                          value: _pointsController.newPlayers[widget.player].points,
                          textStyle: TextStyle(
                            fontSize: 100,
                            color: kPlayersColors[widget.player],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              width: widget.maxWidth / 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () =>
                        _pointsController.changePointsState(widget.player, 5),
                    onLongPress: () => startSum(10),
                    onLongPressUp: () => stopSum(),
                    child: FittedBox(
                      child: Text(
                        "+",
                        style: TextStyle(
                            color: kPlayersColors[widget.player], fontSize: 60),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        buildPhase(),
        GetX<PointsController>(builder: (_) {
          return Positioned(
            bottom: 0,
            child: GestureDetector(
              onLongPress: () {
                _changeName(context);
              },
              child: Text(
                _pointsController.newPlayers[widget.player].name.toUpperCase(),
                style: TextStyle(
                    color: kPlayersColors[widget.player],
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis),
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
              onTap: () => _pointsController.changePhase(widget.player, -1),
              child: Text(
                "-  ",
                style: TextStyle(
                    color: kPlayersColors[widget.player], fontSize: 25),
              ),
            ),
            _pointsController.newPlayers[widget.player].isClosingPhase10
                ? GestureDetector(
              onTap: ()=> _pointsController.setIsGameEnded(true),
                  child: Text("CERRAR", style:TextStyle(
                  color: kPlayersColors[widget.player], fontSize: 17),),
                )
                : Row(
                    children: [
                      Text(
                        "Phase: ",
                        style: TextStyle(
                            color: kPlayersColors[widget.player], fontSize: 17),
                      ),
                      AnimatedFlipCounter(
                        value: _pointsController.newPlayers[widget.player].phase,
                        prefix:
                            _pointsController.newPlayers[widget.player].phase.toInt() < 10
                                ? "0"
                                : null,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: kPlayersColors[widget.player],
                        ),
                      ),
                    ],
                  ),
            GestureDetector(
              onTap: () => _pointsController.changePhase(widget.player, 1),
              child: Text(
                "  +",
                style: TextStyle(
                    color: kPlayersColors[widget.player], fontSize: 25),
              ),
            ),
          ],
        );
      }),
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
                      onTap: () async {
                        _pointsController.setName(widget.player, text);
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
                _nameController.text = _pointsController.newPlayers[widget.player].name;
                return TextField(
                  style: const TextStyle(fontSize: 23),
                  autofocus: true,
                  controller: _nameController,
                  onTapOutside: (_) {
                    if (_nameController.text != "" &&
                        !_nameController.text.contains("JUGADOR")) {
                      _pointsController.setName(
                          widget.player, _nameController.text.trim());
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
                          : _speechController.startListening(
                              player: widget.player),
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
}
