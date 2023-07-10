import 'package:shared_preferences/shared_preferences.dart';

class ExecuteAfterBuild {
  Future<void> initializeSavedGame() async {
    await Future.delayed(Duration.zero);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("savedGame")) {
      prefs.setBool("savedGame", true);
      prefs.setStringList("points", ["nn", "0", "0", "0", "0", "0", "0"]);
      prefs.setStringList("phases", ["nn", "1", "1", "1", "1", "1", "1"]);
      prefs.setStringList("names", [
        "nn",
        "JUGADOR 1",
        "JUGADOR 2",
        "JUGADOR 3",
        "JUGADOR 4",
        "JUGADOR 5",
        "JUGADOR 6"
      ]);
    }
  }
}
