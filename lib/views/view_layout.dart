import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final pointsController = Get.put(PointsController());
  bool _isResultVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          setState(() {
            _isResultVisible = true;
          });
        } else if (details.delta.dy < 0) {
          setState(() {
            _isResultVisible = false;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetX<PointsController>(
          builder: (_) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                widget.schema.layoutWidgets[widget.layout],
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
                if(_isResultVisible) Container(color: Colors.black.withOpacity(.5),),
                Leaderboard(isResultVisible: _isResultVisible),
              ],
            );
          },
        ),
      ),
    );
  }
}
