import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/controllers/text_to_speech_controller.dart';

import '../controllers/audio_controller.dart';
import '../controllers/points_controller.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    super.key,
    required bool isResultVisible,
  }) : _isResultVisible = isResultVisible;

  final bool _isResultVisible;

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  final PointsController _pointsController = Get.find();
  final AudioController _audioController = AudioController();
  final TextToSpeechController _textToSpeechController = TextToSpeechController();

  int _players = 0;
  List<int> _points = [];
  List<int> _phases = [];
  List<String> _names = [];

  late var _listenPlayer;

  getResults() {
    _players = (_pointsController.players.roundToDouble()).toInt();
    _points = (_pointsController.allPoints).getRange(1, _players + 1).toList();
    _phases = (_pointsController.allPhases).getRange(1, _players + 1).toList();
    _names = (_pointsController.allNames).getRange(1, _players + 1).toList();

    List<int> indices = List.generate(_points.length, (index) => index);

    indices.sort((a, b) {
      int pointsComparison = _points[a].compareTo(_points[b]);
      if (pointsComparison != 0) {
        return pointsComparison;
      } else {
        return _phases[b].compareTo(_phases[a]);
      }
    });

    _points = indices.map((index) => _points[index]).toList();
    _phases = indices.map((index) => _phases[index]).toList();
    _names = indices.map((index) => _names[index]).toList();
  }

  @override
  void didUpdateWidget(covariant Leaderboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._isResultVisible != oldWidget._isResultVisible) {
      if (widget._isResultVisible) {
        getResults();
        if (_pointsController.isGameEnded){
          _audioController.playSound('the_winner_is.mp3');
        } else {
          _textToSpeechController.speak("Está ganando ${_names[0]}");
        }
      }
    }
  }

  @override
  void initState() {
    initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: widget._isResultVisible ? 40 : -480,
      left: 20,
      right: 20,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 255, 60, 1),
              Color.fromRGBO(242, 180, 50, 1),
              Color.fromRGBO(255, 255, 60, 1),
            ],
            stops: [0, 0.53, 1],
            transform: GradientRotation(61 * 3.1415926535 / 180),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(242, 180, 50, 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(355),
              ),
              border: Border.all(color: Colors.black, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: const Text(
              "CLASIFICACIÓN",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          if (_players > 0) createResults(),
          const SizedBox(height: 20)
        ]),
      ),
    );
  }

  Column createResults() {
    List<Widget> allResults = [];
    for (int i = 0; i < _players; i++) {
      allResults.add(SingleResult(i, _points[i], _names[i], _phases[i]));
    }
    return Column(children: allResults);
  }

  Future<void> initSpeech() async {
    _listenPlayer = _audioController.audioPlayer.onPlayerStateChanged.listen((status) {
      if (status == PlayerState.completed) {
        _textToSpeechController.speak(_names[0]);
      }
    });
  }
}

class SingleResult extends StatelessWidget {
  final int i;
  final int points;
  final String name;
  final int phase;

  const SingleResult(
    this.i,
    this.points,
    this.name,
    this.phase, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(115, 84, 20, 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(355),
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${i + 1}. $name",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            "    $points  ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          CircleAvatar(
            radius: 12,
            child: Text(
              phase.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
