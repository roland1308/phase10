import 'package:get/get.dart';
import 'package:phase_10_points/controllers/audio_controller.dart';
import 'package:phase_10_points/controllers/points_controller.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final Rx<SpeechToText> _speechToText = SpeechToText().obs;

  final PointsController _pointsController = Get.find();

  final AudioController _audioController = AudioController();

  String _lastWords = '';
  int _players = 0;
  List<String> _names = [];
  String _userToMark = "";
  int _pointsToMark = 0;
  bool _isPhase = false;

  final RxBool _speechEnabled = false.obs;

  bool get speechEnabled => _speechEnabled.value;
  SpeechToText get speechToText => _speechToText.value;

  @override
  void onInit() {
    initSpeech();
    super.onInit();
  }

  /// This has to happen only once per app
  void initSpeech() async {
    _speechEnabled.value = await _speechToText.value.initialize();
  }

  bool isListening() {
    return _speechToText.value.isListening;
  }

  /// Each time to start a speech recognition session
  void startListening({int? player}) async {
    _getNames();
    Future.delayed(Duration(seconds: (player ?? -1) > 0 ? 2 : 4), () {
      stopListening();
    });
    await _speechToText.value.listen(
        onResult: (player ?? 0) > 0
            ? (result) => _onNameSpeech(result, player!)
            : _onSpeechResult,
        listenFor: Duration(seconds: (player ?? -1) > 0 ? 3 : 5),
        partialResults: false,
        listenMode: ListenMode.search,
        localeId: "es");
    _speechToText.refresh();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    _speechToText.refresh();
    await _speechToText.value.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    _speechToText.refresh();

    _lastWords = result.recognizedWords;
    bool hasFound = false;

    _isPhase = _lastWords.contains("phase") || _lastWords.contains("fase");
    for (String str in _lastWords.split(" ")) {
      if (_names.contains(str.toUpperCase())) {
        _userToMark = str;
        break;
      }
    }

    if (_userToMark != "") {
      int userIndex =
          _pointsController.names.indexOf(_userToMark.toUpperCase());
      if (_isPhase) {
        _pointsController.changePhase(userIndex, 1);
        hasFound = true;
      } else {
        _pointsToMark = (_spanishWordsToNumber(_lastWords));
        if (_pointsToMark > 0) {
          _pointsController.changePointsState(userIndex, _pointsToMark);
          hasFound = true;
        }
      }
    }
    if (!hasFound) {
      _audioController.playSound('wrong-buzzer-6268.mp3');
    }
  }

  Future<void> _onNameSpeech(SpeechRecognitionResult result, int player) async {
    _speechToText.refresh();

    _lastWords = result.recognizedWords;
    _pointsController.setName(player, _lastWords.split(" ")[0].toUpperCase());
  }

  void _getNames() {
    _players = _pointsController.players.roundToDouble().toInt();
    _names = _pointsController.names.getRange(1, _players + 1).toList();
  }

  int _spanishWordsToNumber(String words) {
    Map<String, int> units = {
      'cinco': 5,
      'diez': 10,
      'quince': 15,
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
        }
      } else {
        number += int.parse(word);
        currentNumber = 0;
      }
    }
    number += currentNumber;
    return number;
  }
}
