import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SinginController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // RxBool isLoding = true.obs;
  RxBool isshowpassword = true.obs;
  RxBool condition = false.obs;
  RxBool onchange = false.obs;
  RxBool isLoading = false.obs;
  void setLoading(bool value) {
    isLoading.value = value;
  }
   RxBool isGoogleLoading = false.obs;
  void setGoogleLoading(bool value) {
    isLoading.value = value;
  }
}
