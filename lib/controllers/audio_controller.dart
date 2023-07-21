import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final audioPlayer = AudioPlayer();

  Future<void> playSound(String soundPath) async {
    await audioPlayer.play(AssetSource(soundPath));
  }
}
