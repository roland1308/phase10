import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/services/speech_service.dart';
import 'package:phase_10_points/services/text_to_speech_service.dart';
import 'package:phase_10_points/views/instructions.dart';
import 'package:phase_10_points/views/view_layout.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';

import '../controllers/last_players_name_controller.dart';
import '../controllers/points_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PointsController _pointsController = Get.find();
  final TextToSpeechService _textToSpeechController = TextToSpeechService();

  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _textToSpeechController.speak("Bienvenidos!");
    if (!kIsWeb) {
      sleep(const Duration(milliseconds: 500));
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => FlutterNativeSplash.remove());
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PointsController>(builder: (_) {
      return Scaffold(
        body: _pointsController.hasSaved == null
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
                          value: _pointsController.players,
                          divisions: 8,
                          onChanged: (value) {
                            changePlayers(value);
                          },
                          onChangeEnd: (value) {
                            double tmpPlayers = value.roundToDouble();
                            _pointsController.setGame(tmpPlayers, 1);
                            setState(() {
                              _visible = true;
                            });
                          },
                        ),
                        Text(
                          'Número de jugadores: ${_pointsController.players.toInt()}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          buildSchemas(_pointsController.schema.assetImages),
                    ),
                    if (_pointsController.hasSaved ?? false)
                      ElevatedButton(
                        onPressed: () {
                          _pointsController.checkSaved();
                          goToLayout();
                        },
                        child: const Center(
                            child: Text("CONTINUA JUEGO GUARDADO")),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        _pointsController.setGameInPrefs();
                        _pointsController.reset();
                        goToLayout();
                      },
                      child:
                          const Center(child: Text("EMPIEZA UN NUEVO JUEGO")),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  void goToLayout() {
    Get.to(
      () => (ViewLayout(
          _pointsController.schema, _pointsController.selectedLayout - 1)),
    )?.then((_) => _pointsController.checkSaved());
  }

  Future<void> changePlayers(double value) async {
    setState(() {
      _visible = false;
    });
    if (value == value.round()) {
      await Future.delayed(const Duration(milliseconds: 300));
      _pointsController.setGame(value, 1);
      setState(() {
        _visible = true;
      });
    }
  }

  buildSchemas(List<String> layouts) {
    List<Widget> result = [];
    for (int i = 0; i < layouts.length; i++) {
      result.add(
        GestureDetector(
          onTap: () => _pointsController.setLayout(i + 1),
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              layouts[i],
              colorFilter: i == _pointsController.selectedLayout - 1
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
