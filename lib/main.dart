import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/views/5_up_layouts/five_up_layout_2.dart';
import 'package:phase_10_points/views/6_up_layouts/six_up_layout_1.dart';
import 'package:phase_10_points/views/6_up_layouts/six_up_layout_2.dart';
import 'package:phase_10_points/views/home_page.dart';

import 'controllers/points_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final pointsController = Get.put(PointsController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phase 10 points system',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black),
      home: const HomePage(),
        /*
        body: GetX<PointsController>(
          builder: (_) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const SixUpLayout1(),
                //const SixUpLayout2(),
                //const FiveUpLayout1(),
                //const FiveUpLayout2(),
                //const FourUpLayout1(),
                //const FourUpLayout2(),
                //const ThreeUpLayout1(),
                //const ThreeUpLayout2(),
                //const TwoUpLayout1()),
                //const TwoUpLayout2()),
                //const TwoUpLayout3()),
                if (pointsController.showingPartial.value)
                  Positioned(
                    top: 10,
                    child: CircleAvatar(
                      radius: 50,
                      child: FittedBox(
                        child: Text(
                          pointsController.partialPoints.toString(),
                          style: const TextStyle(fontSize: 150),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
*/
    );
  }
}
