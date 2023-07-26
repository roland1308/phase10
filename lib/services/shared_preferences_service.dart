import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/player_model.dart';

class SharedPrefService {

  Future<bool> hasSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("savedGame");
  }

    read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key) ?? "");
  }

  readToList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var response =
        convertListDynamicToListPlayer(json.decode(prefs.getString(key) ?? ""));
    return response;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  List<Player> convertListDynamicToListPlayer(List<dynamic> dynamicList) {
    return dynamicList.map((playerData) {
      return Player.fromJson(playerData);
    }).toList();
  }
}
