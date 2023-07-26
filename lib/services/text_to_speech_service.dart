import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final _flutterTts = FlutterTts();
  TextToSpeechService() {
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setVolume(1.0);
  }

  Future speak(String winner) async {
    await _flutterTts.speak(winner);
  }
}
