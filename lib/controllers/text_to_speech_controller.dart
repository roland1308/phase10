import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class TextToSpeechController {
  final _flutterTts = FlutterTts();
  TextToSpeechController() {
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setVolume(1.0);
/*
    if (!kIsWeb && Platform.isAndroid) {
      _flutterTts.setEngine("com.google.android.tts");
    }
*/
  }

  Future speak(String winner) async {
    await _flutterTts.speak(winner);
  }
}
