import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/views/home_page.dart';

import 'controllers/last_players_name_controller.dart';
import 'controllers/points_controller.dart';
import 'services/speech_service.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/phase_10.png"), context);
    Get.put(PointsController());
    Get.put(LastPlayersNameController());
    Get.put(SpeechController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phase 10 points system',
      theme: ThemeData(
          fontFamily: "Futura",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black),
      home: const HomePage(),
    );
  }
}
