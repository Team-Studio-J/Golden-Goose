import 'package:get/get.dart';

class SizeController extends GetxController {

  RxDouble _size = 700.0.obs;
  RxDouble get size => _size;

  @override
  void onInit() {
    super.onInit();
  }


  void changeSize(double size) {
    _size(size);
  }


}
