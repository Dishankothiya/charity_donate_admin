import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  void setLoading(bool value) {
    isLoading.value = value;
  }

}
