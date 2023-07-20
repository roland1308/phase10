import 'package:audioplayers/audioplayers.dart';
import 'package:phase_10_points/controllers/text_to_speech_controller.dart';

class AudioController {
  final audioPlayer = AudioPlayer();

  Future<void> playSound(String soundPath) async {
    await audioPlayer.play(AssetSource(soundPath));
  }
}
