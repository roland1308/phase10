import 'dart:collection';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayersNameController extends GetxController {
  Rx<Queue<String>> lastUsers =
      Queue<String>.from(List.generate(6, (index) => "", growable: false)).obs;

  addUser(String newName) async {
    lastUsers.value.addFirst(newName.toUpperCase());
    lastUsers.value.removeLast();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("lastUsers", lastUsers.value.toList());
    update();
  }

  contains(String name) {
    return lastUsers.value.contains(name.toUpperCase());
  }

  @override
  Future<void> onInit() async {
    print("QI");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lastUsers.value.clear();
    lastUsers.value.addAll(prefs.getStringList("lastUsers") ?? []);
    super.onInit();
  }
}
