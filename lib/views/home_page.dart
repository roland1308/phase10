import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';
import 'package:phase_10_points/views/instructions.dart';
import 'package:phase_10_points/views/view_layout.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _players = 2;
  int _selectedLayout = 1;
  bool _visible = true;
  bool? _hasSaved;

  void checkSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasSaved = false;
    if (prefs.containsKey("savedGame")) {
      bool points = listEquals(
          prefs.getStringList("points")!, ["nn", "0", "0", "0", "0", "0", "0"]);
      bool phases = listEquals(
          prefs.getStringList("phases")!, ["nn", "1", "1", "1", "1", "1", "1"]);
      bool names = listEquals(prefs.getStringList("names")!, [
        "nn",
        "JUGADOR 1",
        "JUGADOR 2",
        "JUGADOR 3",
        "JUGADOR 4",
        "JUGADOR 5",
        "JUGADOR 6"
      ]);
      _hasSaved = !points || !phases || !names;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkSaved();
    if (!kIsWeb) {
      sleep(const Duration(milliseconds: 500));
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => FlutterNativeSplash.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasSaved == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Image.asset(
                        "assets/phase_10.png",
                        height: 200,
                      ),
                      Transform.translate(
                        offset: const Offset(20, -20),
                        child: IconButton(
                          onPressed: () => Get.to(() => (Instructions())),
                          icon: const Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Slider(
                        min: 2.0,
                        max: 6.0,
                        value: _players,
                        divisions: 8,
                        onChanged: (value) {
                          changePlayers(value);
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            _selectedLayout = 1;
                            _players = value.roundToDouble();
                            _visible = true;
                          });
                        },
                      ),
                      Text(
                        'Número de jugadores: ${_players.toInt()}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: buildSchemas(
                        kLayouts[_players.toInt() - 2].assetImages),
                  ),
                  if (_hasSaved ?? false)
                    ElevatedButton(
                      onPressed: () => loadSaved(),
                      child:
                          const Center(child: Text("CONTINUA JUEGO GUARDADO")),
                    ),
                  ElevatedButton(
                    onPressed: () => newGame(),
                    child: const Center(child: Text("EMPIEZA UN NUEVO JUEGO")),
                  ),
                ],
              ),
            ),
    );
  }

  void goToLayout() {
    Get.to(
      () => (ViewLayout(_players.toInt() - 2, _selectedLayout - 1)),
    )?.then((_) => checkSaved());
  }

  Future<void> newGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("players", _players.toInt());
    prefs.setInt("layout", _selectedLayout);
    prefs.remove("savedGame");
    goToLayout();
  }

  Future<void> loadSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _players = (prefs.getInt("players") ?? 2).toDouble();
      _selectedLayout = prefs.getInt("layout") ?? 1;
    });
    goToLayout();
  }

  Future<void> changePlayers(double value) async {
    setState(() {
      _visible = false;
    });
    if (value == value.round()) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _selectedLayout = 1;
        _players = value;
        _visible = true;
      });
    }
  }

  buildSchemas(List<String> layouts) {
    List<Widget> result = [];
    for (int i = 0; i < layouts.length; i++) {
      result.add(
        GestureDetector(
          onTap: () => setState(() {
            _selectedLayout = i + 1;
          }),
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              layouts[i],
              colorFilter: i == _selectedLayout - 1
                  ? const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
                  : const ColorFilter.mode(Colors.blueGrey, BlendMode.srcIn),
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ),
      );
    }
    return result;
  }
}
