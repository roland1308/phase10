import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final audioPlayer = AudioPlayer();

  Future<void> playSound(String soundPath) async {
    await audioPlayer.play(AssetSource(soundPath));
  }
}
