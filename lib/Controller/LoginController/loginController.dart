import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController loginEmail = TextEditingController();

  TextEditingController loginpassword = TextEditingController();
  RxBool isshowpassword = false.obs;
  RxBool isLoding = false.obs;
  void isSetLoading(Value) {
    isLoding.value = Value;
  }
}
