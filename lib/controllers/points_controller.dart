import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsController extends GetxController {
  final RxDouble _players = 2.0.obs;
  final RxInt _selectedLayout = 1.obs;
  final Rx<SchemasEnum> _schema = SchemasEnum.up_2.obs;
  final RxList<String> _names = <String>[
    "nn",
    "JUGADOR 1",
    "JUGADOR 2",
    "JUGADOR 3",
    "JUGADOR 4",
    "JUGADOR 5",
    "JUGADOR 6"
  ].obs;
  final RxList<int> _points = <int>[-1, 0, 0, 0, 0, 0, 0].obs;
  final RxList<int> _phases = <int>[-1, 1, 1, 1, 1, 1, 1].obs;
  final RxnBool _hasSaved = RxnBool();

  final RxInt _partialPoints = 0.obs;
  RxBool showingPartial = false.obs;

  double get players => _players.value;
  int get selectedLayout => _selectedLayout.value;
  SchemasEnum get schema => _schema.value;
  bool? get hasSaved => _hasSaved.value;
  List<int> get points => _points;
  List<int> get phases => _phases;
  int get partialPoints => _partialPoints.value;
  List<String> get names => _names;

  late final SharedPreferences prefs;

  changePointsState(int player, int x) {
    _points[player] += x;
    if (_points[player] < 0) {
      _points[player] = 0;
    } else {
      showPartial(true);
      updatePartial(x);
    }

    List<String> newPoints = _points.map((el) => el.toString()).toList();
    prefs.setStringList("points", newPoints);
    _points.refresh();
  }

  changePhase(int player, int x) {
    _phases[player] += x;
    if (_phases[player] == 0) _phases[player] = 1;
    if (_phases[player] == 11) _phases[player] = 10;

    List<String> newPhases = _phases.map((el) => el.toString()).toList();
    prefs.setStringList("phases", newPhases);
    _phases.refresh();
  }

  updatePartial(int x) {
    _partialPoints.value += x;
  }

  resetPartial() {
    _partialPoints.value = 0;
  }

  showPartial(bool status) {
    showingPartial.value = status;
  }

  @override
  void onInit() {
    checkSaved();
    super.onInit();
  }

  void checkSaved() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {}
    _hasSaved.value = false;
    if (prefs.containsKey("savedGame")) {
      List<String> prefPoints = prefs.getStringList("points")!;
      List<String> prefPhases = prefs.getStringList("phases")!;
      List<String> prefNames = prefs.getStringList("names")!;

      _players.value = prefs.getDouble("players") ?? 2;
      _selectedLayout.value = prefs.getInt("layout") ?? 1;
      _schema.value = SchemasEnum.values[_players.value.toInt() - 2];

      bool points =
          listEquals(prefPoints, ["-1", "0", "0", "0", "0", "0", "0"]);
      bool phases =
          listEquals(prefPhases, ["-1", "1", "1", "1", "1", "1", "1"]);
      bool names = listEquals(prefNames, [
        "nn",
        "JUGADOR 1",
        "JUGADOR 2",
        "JUGADOR 3",
        "JUGADOR 4",
        "JUGADOR 5",
        "JUGADOR 6"
      ]);
      _hasSaved.value = !points || !phases || !names;
      if (_hasSaved.value ?? false) {
        _points.value = prefPoints.map((el) => int.parse(el)).toList();
        _phases.value = prefPhases.map((el) => int.parse(el)).toList();
        _names.value = prefNames;
      }
    }
  }

  void setLayout(int newLayout) {
    _selectedLayout.value = newLayout;
    prefs.setInt("layout", newLayout);
  }

  void setName(int player, String newName) {
    _names[player] = newName;
    prefs.setStringList("names", _names);
    _names.refresh();
  }

  void setGame(double newPlayers, int newSelectedLayout) {
    _players.value = newPlayers;
    setLayout(newSelectedLayout);

    prefs.setDouble("players", newPlayers);
    _schema.value = SchemasEnum.values[newPlayers.toInt() - 2];
  }

  void setNewGame(double newPlayers, int newSelectedLayout) {
    _players.value = newPlayers;
    _selectedLayout.value = newSelectedLayout;

    prefs.setDouble("players", newPlayers);
    prefs.setInt("layout", newSelectedLayout);
    prefs.remove("savedGame");
  }

  void reset() {
    _names.value = <String>[
      "nn",
      "JUGADOR 1",
      "JUGADOR 2",
      "JUGADOR 3",
      "JUGADOR 4",
      "JUGADOR 5",
      "JUGADOR 6"
    ];
    _points.value = <int>[-1, 0, 0, 0, 0, 0, 0];
    _phases.value = <int>[-1, 1, 1, 1, 1, 1, 1];

    prefs.setBool("savedGame", true);
    prefs.setStringList("points", ["-1", "0", "0", "0", "0", "0", "0"]);
    prefs.setStringList("phases", ["-1", "1", "1", "1", "1", "1", "1"]);
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
