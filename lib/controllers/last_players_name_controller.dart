import 'dart:collection';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastPlayersNameController extends GetxController {
  Rx<Queue<String>> lastUsers = Queue<String>.from([]).obs;

  addUser(String newName) async {
    if (lastUsers.value.isNotEmpty && lastUsers.value.length == 6) {
      lastUsers.value.removeLast();
    }
    lastUsers.value.addFirst(newName.toUpperCase());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("lastUsers", lastUsers.value.toList());
    update();
  }

  contains(String name) {
    return lastUsers.value.contains(name.toUpperCase());
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    lastUsers.value =
        Queue<String>.from(prefs.getStringList("lastUsers") ?? []);
    super.onInit();
  }
}
