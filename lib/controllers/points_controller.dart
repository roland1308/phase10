import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:phase_10_points/controllers/shared_preferences_controller.dart';
import 'package:phase_10_points/utils/constants.dart';

import '../models/player_model.dart';

class PointsController extends GetxController {
  final SharedPrefController _sharedPref = SharedPrefController();

  List<Player> initialPlayers = List.generate(
    7,
    (index) => Player(
      name: "JUGADOR $index",
      points: 0,
      phase: 0,
      isClosingPhase10: false,
    ),
  );
  final RxList<Player> _newPlayers = List.generate(
    7,
    (index) => Player(
      name: "JUGADOR $index",
      points: 0,
      phase: 0,
      isClosingPhase10: false,
    ),
  ).obs;

  final RxDouble _players = 2.0.obs;
  final RxInt _selectedLayout = 1.obs;
  final Rx<SchemasEnum> _schema = SchemasEnum.up_2.obs;
  final RxnBool _hasSaved = RxnBool();

  final RxInt _partialPoints = 0.obs;
  final RxBool _showingPartial = false.obs;

  final RxBool _isLeaderBoardShowed = false.obs;
  final RxBool _isGameEnded = false.obs;

  double get players => _players.value;
  int get selectedLayout => _selectedLayout.value;
  SchemasEnum get schema => _schema.value;
  bool? get hasSaved => _hasSaved.value;
  int get partialPoints => _partialPoints.value;
  bool get showingPartial => _showingPartial.value;
  bool get isLeaderBoardShowed => _isLeaderBoardShowed.value;
  bool get isGameEnded => _isGameEnded.value;
  List<Player> get newPlayers => _newPlayers;

  List<String> get allNames =>
      _newPlayers.map((player) => player.name).toList();
  List<int> get allPoints =>
      _newPlayers.map((player) => player.points).toList();
  List<int> get allPhases => _newPlayers.map((player) => player.phase).toList();

  Timer? _hidePartial;

  @override
  void onInit() {
    checkSaved();
    super.onInit();
  }

  setIsLeaderboardShowed(bool value) {
    _isLeaderBoardShowed.value = value;
  }

  setIsGameEnded(bool value) {
    _isGameEnded.value = value;
    _isLeaderBoardShowed.value = true;
  }

  void checkSaved() async {
    _hasSaved.value = await _sharedPref.hasSaved();
    if (_hasSaved.value ?? false) {
      List<Player> prefPlayers = await _sharedPref.readToList("newplayers");

      _players.value = await _sharedPref.read("players") ?? 2.0;
      _selectedLayout.value = await _sharedPref.read("layout") ?? 1;
      _schema.value = SchemasEnum.values[_players.value.toInt() - 2];

      _hasSaved.value = !arePlayerListsEqual(prefPlayers, initialPlayers);
      if (_hasSaved.value ?? false) {
        _newPlayers.value = prefPlayers;
      }
    }
    _hasSaved.refresh();
  }

  changePointsState(int player, int x) {
    resetPartial();
    _newPlayers[player].points += x;
    if (_newPlayers[player].points < 0) {
      _newPlayers[player].points += 0;
    } else {
      _showingPartial.value = true;
      updatePartial(x);
    }

    _sharedPref.save("newplayers", _newPlayers);
    _newPlayers.refresh();
  }

  changePhase(int player, int x) {
    _newPlayers[player].isClosingPhase10 = false;
    _newPlayers[player].phase += x;
    if (_newPlayers[player].phase == 0) _newPlayers[player].phase = 1;
    if (_newPlayers[player].phase >= 11) {
      _newPlayers[player].phase = 10;
      _newPlayers[player].isClosingPhase10 = true;
    }

    _sharedPref.save("newplayers", _newPlayers);
    _newPlayers.refresh();
  }

  updatePartial(int x) {
    _partialPoints.value += x;
  }

  resetPartial() {
    if (_hidePartial != null) _hidePartial!.cancel();
    _hidePartial = Timer(const Duration(seconds: 1), () {
      _showingPartial.value = false;
      _partialPoints.value = 0;
    });
  }

  void setLayout(int newLayout) {
    _selectedLayout.value = newLayout;
    //prefs.setInt("layout", newLayout);
  }

  void setName(int player, String newName) {
    _newPlayers[player].name = newName.toUpperCase();
    _sharedPref.save("newplayers", _newPlayers);
    _newPlayers.refresh();
  }

  void setGame(double newPlayers, int newSelectedLayout) {
    _players.value = newPlayers;
    setLayout(newSelectedLayout);

    //prefs.setDouble("players", newPlayers);
    _schema.value = SchemasEnum.values[newPlayers.toInt() - 2];
  }

  void setGameInPrefs() {
    _sharedPref.save("layout", _selectedLayout.value);
    _sharedPref.save("players", _players.value);
  }

  void setNewGame(double newPlayers, int newSelectedLayout) {
    _players.value = newPlayers;
    _selectedLayout.value = newSelectedLayout;

    _sharedPref.save("players", newPlayers);
    _sharedPref.save("layout", newSelectedLayout);
    _sharedPref.remove("savedGame");
  }

  void reset() {
    _newPlayers.value = List.generate(
      7,
      (index) => Player(
        name: "JUGADOR $index",
        points: 0,
        phase: 0,
        isClosingPhase10: false,
      ),
    );
    _sharedPref.save("savedGame", true);
    _sharedPref.save("newplayers", initialPlayers);
    _newPlayers.refresh();
  }

  bool arePlayerListsEqual(List<Player> list1, List<Player> list2) {
    if (jsonEncode(list1) == jsonEncode(list2)) {
      return true;
    }
    return false;
  }
}
