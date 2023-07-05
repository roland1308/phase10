import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';
import 'package:phase_10_points/views/2_up_layouts/two_up_layout_1.dart';

import '2_up_layouts/two_up_layout_2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double players = 2;
  int selectedLayout = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Slider(
                  min: 2.0,
                  max: 6.0,
                  value: players,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() {
                      selectedLayout = 1;
                      players = value;
                    });
                  },
                ),
                Text(
                  'Número de jugadores: $players',
                  style: TextStyle(color: kColor1),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buildSchemas(kLayouts[players.toInt() - 2]),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(TwoUpLayout1());
                },
                child: const Text("INICIO"))
          ],
        ),
      ),
    );
  }

  buildSchemas(List<String> layouts) {
    List<Widget> result = [];
    for (int i = 0; i < layouts.length; i++) {
      result.add(
        GestureDetector(
          onTap: () => setState(() {
            selectedLayout = i + 1;
          }),
          child: SvgPicture.asset(
            layouts[i],
            semanticsLabel: '2 UP Layout 1',
            colorFilter: i == selectedLayout - 1
                ? const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
                : const ColorFilter.mode(Colors.blueGrey, BlendMode.srcIn),
            width: MediaQuery.of(context).size.width / 4,
          ),
        ),
      );
    }
    return result;
  }
}
