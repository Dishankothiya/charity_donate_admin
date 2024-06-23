import 'package:get/get.dart';

class MyHomePageController extends GetxController {
  RxBool isLoading = false.obs;
  void setLoading(Value) {
    isLoading.value = Value;
  }
}
