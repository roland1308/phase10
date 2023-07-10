import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/players_name_controller.dart';
import 'package:phase_10_points/controllers/points_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class PlayerWidget extends StatefulWidget {
  final double maxWidth;
  final int player;

  const PlayerWidget({
    super.key,
    required this.maxWidth,
    required this.player,
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  int _points = 0;
  Timer? _autoPoints;
  Timer? _hidePartial;
  int _phase = 1;
  final TextEditingController _nameController = TextEditingController(text: "");
  String _name = "JUGADOR";

  final _pointsController = Get.put(PointsController());
  final _playersNameController = Get.put(PlayersNameController());

  void changePoints(int x) {
    resetPartial();
    changePointsState(x);
  }

  void startSum(int x) {
    _autoPoints = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      resetPartial();
      changePoints(x);
    });
  }

  Future<void> changePointsState(int x) async {
    setState(() {
      _points += x;
      if (_points < 0) {
        _points = 0;
      } else {
        _pointsController.showPartial(true);
        _pointsController.updatePartial(x);
      }
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> actualPoints = prefs.getStringList("points")!;
    actualPoints[widget.player] = _points.toString();
    prefs.setStringList("points", actualPoints);
  }

  void resetPartial() {
    if (_hidePartial != null) _hidePartial!.cancel();
    _hidePartial = Timer(const Duration(seconds: 1), () {
      _pointsController.showPartial(false);
      _pointsController.resetPartial();
    });
  }

  void stopSum() {
    if (_autoPoints != null) _autoPoints!.cancel();
  }

  Future<void> changePhase(int x) async {
    setState(() {
      _phase += x;
      if (_phase == 0) _phase = 1;
      if (_phase == 11) _phase = 10;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> actualPhases = prefs.getStringList("phases")!;
    actualPhases[widget.player] = _phase.toString();
    prefs.setStringList("phases", actualPhases);
  }

  Future<void> getInitialState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("savedGame")) {
      setState(() {
        _points = int.parse(prefs.getStringList("points")![widget.player]);
        _phase = int.parse(prefs.getStringList("phases")![widget.player]);
        _name = prefs.getStringList("names")![widget.player];
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _name = "JUGADOR ${widget.player}";
    getInitialState();
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
                    style: TextStyle(
                        color: kPlayersColors[widget.player], fontSize: 70),
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
                          color: kPlayersColors[widget.player],
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
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onLongPress: () {
              _changeName(context);
            },
            child: Text(
              _name.toUpperCase(),
              style: TextStyle(
                  color: kPlayersColors[widget.player],
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis),
            ),
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
              style:
                  TextStyle(color: kPlayersColors[widget.player], fontSize: 25),
            ),
          ),
          Text(
            "Phase:  ",
            style:
                TextStyle(color: kPlayersColors[widget.player], fontSize: 17),
          ),
          AnimatedFlipCounter(
            value: _phase,
            prefix: _phase < 10 ? "0" : null,
            textStyle: TextStyle(
              fontSize: 20,
              color: kPlayersColors[widget.player],
            ),
          ),
          GestureDetector(
            onTap: () => changePhase(1),
            child: Text(
              "  +",
              style:
                  TextStyle(color: kPlayersColors[widget.player], fontSize: 25),
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
                      onTap: () async {
                        setState(() {
                          _name = text;
                          Get.back();
                        });
                        await updateSharedPrefs(text);
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
                    _playersNameController.addUser(_nameController.text.trim());
                  }
                },
                onChanged: (value) async {
                  setState(() {
                    if (value == "") {
                      value = "JUGADOR ${widget.player}";
                    }
                    _name = value.trim();
                  });
                  await updateSharedPrefs(value.trim());
                },
                decoration: const InputDecoration(
                  hintText: "Nombre jugador",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateSharedPrefs(String text) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> actualNames = prefs.getStringList("names")!;
    actualNames[widget.player] = text.toUpperCase();
    prefs.setStringList("names", actualNames);
  }
}
