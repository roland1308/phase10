import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';
import 'package:phase_10_points/views/view_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _players = 2;
  int _selectedLayout = 1;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => FlutterNativeSplash.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/phase_10.png",
              height: 200,
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
                  style: const TextStyle(color: kColor1, fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  buildSchemas(kLayouts[_players.toInt() - 2].assetImages),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(ViewLayout(_players.toInt() - 2, _selectedLayout - 1));
                },
                child: const Text("INICIO"))
          ],
        ),
      ),
    );
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
