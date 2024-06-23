import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNotificationController extends GetxController {
  TextEditingController AdminNotification = TextEditingController();
  RxBool isLoading = false.obs;
  void setLoading(bool value) {
    isLoading.value = value;
  }
}
