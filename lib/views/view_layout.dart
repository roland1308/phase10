import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/services/speech_service.dart';
import 'package:phase_10_points/utils/constants.dart';

import '../controllers/points_controller.dart';
import '../widgets/leaderboard_widget.dart';

class ViewLayout extends StatefulWidget {
  final SchemasEnum schema;
  final int layout;

  const ViewLayout(this.schema, this.layout, {super.key});

  @override
  State<ViewLayout> createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
  final PointsController _pointsController = Get.find();
  final SpeechController _speechController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          _pointsController.setIsLeaderboardShowed(true);
        } else if (details.delta.dy < 0) {
          _pointsController.setIsLeaderboardShowed(false);
        }
      },
      child: GetX<SpeechController>(
        builder: (_) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: _speechController.speechEnabled
                ? FloatingActionButton(
                    onPressed: ()=>
                        _speechController.isListening()
                            ? _speechController.stopListening
                            : _speechController.startListening(),
                    tooltip: 'Listen',
                    child: Icon(_speechController.isListening()
                        ? Icons.mic
                        : Icons.mic_off),
                  )
                : null,
            body: GetX<PointsController>(
              builder: (_) {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    widget.schema.layoutWidgets[widget.layout],
                    if (_pointsController.showingPartial)
                      Positioned(
                        top: 10,
                        child: CircleAvatar(
                          radius: 50,
                          child: FittedBox(
                            child: Text(
                              _pointsController.partialPoints.toString(),
                              style: const TextStyle(fontSize: 150),
                            ),
                          ),
                        ),
                      ),
                    if (_pointsController.isLeaderBoardShowed)
                      GestureDetector(
                        onTap: () => _pointsController.setIsLeaderboardShowed(false),
                        child: Container(
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                    Leaderboard(isResultVisible: _pointsController.isLeaderBoardShowed),
                  ],
                );
              },
            ),
          );
        }
      ),
    );
  }
}
