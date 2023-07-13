import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controllers/points_controller.dart';
import '../widgets/leaderboard_widget.dart';

class ViewLayout extends StatefulWidget {
  final SchemasEnum schema;
  final int layout;

  const ViewLayout(this.schema, this.layout, {super.key});

  @override
  State<ViewLayout> createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
  SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  final PointsController _pointsController = Get.find();
  bool _isResultVisible = false;

  int _players = 0;
  List<String> _names = [];
  String _userToMark = "";
  int _pointsToMark = 0;
  bool _isPhase = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  Future<void> getNames() async {
    _players = _pointsController.players.roundToDouble().toInt();
    _names = _pointsController.names.getRange(1, _players + 1).toList();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    getNames();
    await speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 5),
        partialResults: false,
        localeId: "es");
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {});
    _lastWords = result.recognizedWords;
    print(_lastWords);
    _isPhase = _lastWords.contains("phase") || _lastWords.contains("fase");
    for (String str in _lastWords.split(" ")) {
      if (_names.contains(str.toUpperCase())) {
        _userToMark = str;
        break;
      }
    }

    if (_userToMark != "") {
      int userIndex = _pointsController.names.indexOf(_userToMark.toUpperCase());
      if (_isPhase) {
        _pointsController.changePhase(userIndex, 1);
      }
      else {
        _pointsToMark = (spanishWordsToNumber(_lastWords));
        if (_pointsToMark > 0) {
          _pointsController.changePointsState(userIndex, _pointsToMark);
        }
      }
    }
  }

  int spanishWordsToNumber(String words) {
    Map<String, int> units = {
      'cero': 0,
      'uno': 1,
      'dos': 2,
      'tres': 3,
      'cuatro': 4,
      'cinco': 5,
      'seis': 6,
      'siete': 7,
      'ocho': 8,
      'nueve': 9,
      'diez': 10,
      'once': 11,
      'doce': 12,
      'trece': 13,
      'catorce': 14,
      'quince': 15,
      'dieciséis': 16,
      'diecisiete': 17,
      'dieciocho': 18,
      'diecinueve': 19
    };

    Map<String, int> tens = {
      'veinte': 20,
      'treinta': 30,
      'cuarenta': 40,
      'cincuenta': 50,
      'sesenta': 60,
      'setenta': 70,
      'ochenta': 80,
      'noventa': 90
    };

    List<String> wordsList = words.split(' ');

    int number = 0;
    int currentNumber = 0;

    for (String word in wordsList) {
      if (int.tryParse(word) == null) {
        if (units.containsKey(word)) {
          currentNumber += units[word]!;
        } else if (tens.containsKey(word)) {
          currentNumber += tens[word]!;
        } else if (word == 'cien' || word == 'ciento') {
          currentNumber += 100;
        } else if (word == 'mil') {
          currentNumber *= 1000;
        } else if (word == 'millón' || word == 'millones') {
          currentNumber *= 1000000;
          number += currentNumber;
          currentNumber = 0;
        }
      } else {
        number += int.parse(word);
        currentNumber = 0;
      }
    }

    number += currentNumber;

    return number;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          setState(() {
            _isResultVisible = true;
          });
        } else if (details.delta.dy < 0) {
          setState(() {
            _isResultVisible = false;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: _speechEnabled
            ? FloatingActionButton(
                onPressed:
                    // If not yet listening for speech start, otherwise stop
                    speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                tooltip: 'Listen',
                child: Icon(
                    speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              )
            : null,
        body: GetX<PointsController>(
          builder: (_) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                widget.schema.layoutWidgets[widget.layout],
                if (_pointsController.showingPartial)
                  Positioned(
                    top: 10,
                    child: CircleAvatar(
                      radius: 50,
                      child: FittedBox(
                        child: Text(
                          _pointsController.partialPoints.toString(),
                          style: const TextStyle(fontSize: 150),
                        ),
                      ),
                    ),
                  ),
                if (_isResultVisible)
                  GestureDetector(
                    onTap: () => setState(() {
                      _isResultVisible = false;
                    }),
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                Leaderboard(isResultVisible: _isResultVisible),
              ],
            );
          },
        ),
      ),
    );
  }
}
