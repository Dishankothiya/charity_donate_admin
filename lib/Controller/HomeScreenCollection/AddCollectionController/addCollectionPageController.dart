import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddCollectionPageController extends GetxController {
  TextEditingController CharityName = TextEditingController();
  TextEditingController OwnerName = TextEditingController();
  TextEditingController TotalAmount = TextEditingController();
  TextEditingController Amount = TextEditingController();
  TextEditingController AboutCharity = TextEditingController();
  RxBool isImageLoading = false.obs;
  void setimageLoading(bool value) {
    isImageLoading.value = value;
  }

  RxBool isLoading = false.obs;
  void setLoading(bool value) {
    isLoading.value = value;
  }
}
