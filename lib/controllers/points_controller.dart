
import 'package:get/get.dart';

class PointsController extends GetxController{
  RxInt partialPoints = 0.obs;
  RxBool showingPartial = false.obs;

  updatePartial(int x) {
    partialPoints.value += x;
  }

  resetPartial() {
    partialPoints.value = 0;
  }

  showPartial(bool status) {
    showingPartial.value = status;
  }
}