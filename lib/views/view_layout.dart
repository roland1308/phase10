import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phase_10_points/utils/constants.dart';

import '../controllers/points_controller.dart';

class ViewLayout extends StatelessWidget {
  final SchemasEnum schema;
  final int layout;

  ViewLayout(this.schema, this.layout, {super.key});

  final pointsController = Get.put(PointsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetX<PointsController>(
        builder: (_) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              schema.layoutWidgets[layout],
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
    );
  }
}
