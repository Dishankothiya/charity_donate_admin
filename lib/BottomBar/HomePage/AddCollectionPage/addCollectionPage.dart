import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:charity_admin/BottomBar/SettingPage/settingScreen.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
// import 'package:charity_admin/Config/notificationServices.dart';
import 'package:charity_admin/Controller/HomeScreenCollection/AddCollectionController/addCollectionPageController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../CommonScreen/commonListtile.dart';
import '../../../CommonScreen/commontextfild.dart';
import '../../../CommonScreen/savedButton.dart';

class addCollectionPage extends StatefulWidget {
  const addCollectionPage({super.key});

  @override
  State<addCollectionPage> createState() => _addCollectionPageState();
}

class _addCollectionPageState extends State<addCollectionPage> {
  DateTime now = DateTime.now();

  AddCollectionPageController addCollectionPageController =
      AddCollectionPageController();
  // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final formkey = GlobalKey<FormState>();
  // ImagePicker Picker = ImagePicker();
  // String? paths;
  // String? imagesend;
  // String? imagesend2;
  // void uploadimage() async {
  //   XFile? picture = await Picker.pickImage(source: ImageSource.gallery);

  //   if (picture!.path.isNotEmpty) {
  //     paths = picture.path;
  //   }
  // }
  EditProfileController editProfileController = EditProfileController();
  File? selectedIMage;
  Uint8List? image;

  Future pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      image = File(returnImage.path).readAsBytesSync();
      editProfileController.xfile.value = returnImage;
      if (editProfileController.xfile.value != null) {
        editProfileController.filePath.value =
            editProfileController.xfile.value!.path;
      }
    });
  }

  Future<void> sendNotification(String title, String body) async {
    // FCM endpoint
    final String serverKey =
        'AAAA666dvBA:APA91bGUzr1ydcYK1avmvqQearGLgO9w4dc24YTQlZrYW5sATcXHrGhSyf7f5fEHAKMTBhbuXbIV8AkdqWCEvJhjH6O9kZQmaHxZUf3wmAlc3PZgCxdCDb8tlIay8cCsJrvHlkP-ukR-';
    final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    // Notification body
    // final Map<String, dynamic> notificationData = {
    //   'notification': {'title': title, 'body': body},
    //   'priority': 'high',
    //   'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
    // };

    // Convert tokens to FCM payload
    final Map<String, dynamic> fcmPayload = {
      'to': '/topics/all_users',
      'notification': {'title': title, 'body': body},
    };

    // Send POST request to FCM endpoint
    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey', // Add your server key here
      },
      body: jsonEncode(fcmPayload),
    );

    // Handle response
    if (response.statusCode == 200) {
      print('Notification sent successfully');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('successfull'),
      //     duration: Duration(
      //         seconds:
      //             3), // Set the duration for how long the SnackBar will be displayed
      //   ),
      // );
    } else {
      print('Failed to send notification. Error: ${response.statusCode}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Faile'),
      //     duration: Duration(
      //         seconds:
      //             3), // Set the duration for how long the SnackBar will be displayed
      //   ),
      // );
    }
  }

  void uploadData() async {
    int userid = now.millisecondsSinceEpoch;
    //  showIndiCator(context);
    String? url;
    if (editProfileController.filePath.value.isNotEmpty) {
      addCollectionPageController.setLoading(true);

      // showIndiCator(context);
      String ext = editProfileController.filePath.value.split(".").last;
      String imgpath =
          // ignore: prefer_interpolation_to_compose_strings
          DateTime.now().millisecondsSinceEpoch.toString() + "." + ext;

      if (!Uri.parse(imgpath).isAbsolute) {
        Reference reference = FirebaseStorage.instance.ref(imgpath);
        await reference.putFile(File(editProfileController.filePath.value));

        url = await reference.getDownloadURL();
        print(url);
        double convertRupees() {
          int conertamount = int.parse(addCollectionPageController.Amount.text);
          int convertotalAmount =
              int.parse(addCollectionPageController.TotalAmount.text);
          double totalPercentage = conertamount * 100 / convertotalAmount;
          print("totalPersentage$totalPercentage");

          int intTotalPercentage = totalPercentage.toInt();

          double convertPercentage = intTotalPercentage / 100.0;

          return convertPercentage;
        }

        DateTime now = DateTime.now();
        String monthName = DateFormat('MMM').format(now);
        int day = now.day;
        int year = now.year;

        // DocumentReference<Map<String, dynamic>> references =
        //     FirebaseFirestore.instance.collection("admin").doc();

        // references.set({
        //   "CharityName": addCollectionPageController.CharityName.text,
        //   "OwnerName": addCollectionPageController.OwnerName.text,
        //   "TotalAmount": addCollectionPageController.TotalAmount.text,
        //   "Amount": addCollectionPageController.Amount.text,
        //   "AboutCharity": addCollectionPageController.AboutCharity.text,
        //   "Percentage": convertRupees(),
        //   "ImageURL": url,
        //   "Time": now,
        //   "Date": day,
        //   "MonthName": monthName,
        //   'Year': year,
        //   "updateTime":""
        // });
        DocumentReference<Map<String, dynamic>> references = FirebaseFirestore
            .instance
            .collection("admin1")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("CharityData")
            .doc(userid.toString());

        references.set({
          "CharityName": addCollectionPageController.CharityName.text,
          "OwnerName": addCollectionPageController.OwnerName.text,
          "TotalAmount": addCollectionPageController.TotalAmount.text,
          "Amount": addCollectionPageController.Amount.text,
          "AboutCharity": addCollectionPageController.AboutCharity.text,
          "Percentage": convertRupees(),
          "ImageURL": url,
          "Time": now,
          "Date": day,
          "MonthName": monthName,
          'Year': year,
          "currentUSerId": "${FirebaseAuth.instance.currentUser!.uid}",
          "charityId": userid.toString()
        });

        FirebaseFirestore.instance
            .collection("CharityData")
            .doc(userid.toString())
            .set({
          "CharityName": addCollectionPageController.CharityName.text,
          "OwnerName": addCollectionPageController.OwnerName.text,
          "TotalAmount": addCollectionPageController.TotalAmount.text,
          "Amount": addCollectionPageController.Amount.text,
          "AboutCharity": addCollectionPageController.AboutCharity.text,
          "Percentage": convertRupees(),
          "ImageURL": url,
          "Time": now,
          "Date": day,
          "MonthName": monthName,
          'Year': year,
          "currentUSerId": "${FirebaseAuth.instance.currentUser!.uid}",
          "charityId": userid.toString()
        });
        sendNotification("${addCollectionPageController.CharityName.text}",
            "${addCollectionPageController.AboutCharity.text}");
        Navigator.of(context).pop();

        addCollectionPageController.setLoading(true);
      }
    } else {
      showModalBottomSheet(
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(
          //         top: Radius.circular(12))),
          enableDrag: false,
          // constraints: BoxConstraints(maxHeight: 750),
          isScrollControlled: true,
          backgroundColor: AppColor.transparentColor,
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 5,
              // color: AppColors.whiteColor,
              decoration: const BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  commonListtile(
                      leadingIcon: Icon(
                        Icons.image,
                        color: AppColor.redColor,
                        size: 30,
                      ),
                      title: "Please Select image on your Gallery",
                      trailingIcon: false),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: savedButton(
                            height: 40,
                            width: 100,
                            title: "Ok",
                            buttonColor: AppColor.blueColor),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
      addCollectionPageController.setLoading(false);
    }
  }

  // Navigator.of(context).pop(); //close the model sheet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      body: Form(
        key: formkey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: AppColor.greenColor,
                      ),
                    ),
                  ),
                  Text(
                    "Add List",
                    style: AppTextStyle.mediumTextStyle.copyWith(),
                  ),
                  const SizedBox(
                    height: 40,
                    width: 40,
                  )
                ],
              ),
            ),
            textView(
                labelText: "Charity Name",
                hintText: "charity name",
                controller: addCollectionPageController.CharityName,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                validationMessage: "please fill Charity Name"),
            textView(
                labelText: "Owner Name",
                hintText: "owner name",
                controller: addCollectionPageController.OwnerName,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                validationMessage: "please fill Owner Name"),
            textView(
                labelText: "How much money do you want?",
                hintText: "total amount",
                controller: addCollectionPageController.TotalAmount,
                textInputType: TextInputType.number,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                prefixIcon: const Icon(Icons.currency_rupee),
                validationMessage: "please fill how much money do you want? "),
            textView(
                labelText: "How much money right now?",
                hintText: "amount",
                controller: addCollectionPageController.Amount,
                textInputType: TextInputType.number,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                prefixIcon: const Icon(Icons.currency_rupee),
                validationMessage: "please fill how much money right now?"),
            textView(
                labelText: "About charity",
                hintText: "about charity",
                controller: addCollectionPageController.AboutCharity,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                // topPadding: 10,

                // maxLine: 7,
                validationMessage: "please fill something about charity"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.greyColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          pickImageFromGallery();
                        },
                        child:
                            // Obx(() {
                            Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.greyColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: selectedIMage == null
                                    ? Icon(
                                        Icons.image,
                                        size: 100,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: FileImage(
                                                    File(selectedIMage!.path)),
                                                fit: BoxFit.cover)),
                                      ))),
                    Text(
                      "Add Charity Photos",
                      style:
                          AppTextStyle.regularTextStyle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 70,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      int amount =
                          int.parse(addCollectionPageController.Amount.text);
                      // addCollectionPageController.Amount;
                      int totalamount = int.parse(
                          addCollectionPageController.TotalAmount.text);

                      if (amount <= totalamount) {
                        uploadData();
                      } else {
                        showModalBottomSheet(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.vertical(
                            //         top: Radius.circular(12))),
                            enableDrag: false,
                            // constraints: BoxConstraints(maxHeight: 750),
                            isScrollControlled: true,
                            backgroundColor: AppColor.transparentColor,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 5,
                                // color: AppColors.whiteColor,
                                decoration: const BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    commonListtile(
                                        leadingIcon: Icon(
                                          Icons.app_blocking,
                                          color: AppColor.redColor,
                                          size: 30,
                                        ),
                                        title:
                                            "You can not right Amount='${addCollectionPageController.Amount.text}' more than you want",
                                        trailingIcon: false),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: savedButton(
                                              height: 40,
                                              width: 100,
                                              title: "Ok",
                                              buttonColor: AppColor.blueColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                        addCollectionPageController.setLoading(false);
                      }
                    }
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColor.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: addCollectionPageController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColor.transparentColor,
                                color: AppColor.whiteColor,
                              ),
                            )
                          : Text(
                              "Save",
                              style: AppTextStyle.regularTextStyle
                                  .copyWith(color: AppColor.whiteColor),
                            )),
                ),
                InkWell(
                  onTap: () {
                    // addCollectionPageController.isLoading(false);
                    addCollectionPageController.CharityName.clear();
                    addCollectionPageController.OwnerName.clear();
                    addCollectionPageController.TotalAmount.clear();
                    addCollectionPageController.Amount.clear();
                    addCollectionPageController.AboutCharity.clear();
                    setState(() {
                      selectedIMage = null;
                    });
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: AppColor.appColor,
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      "Delete",
                      style: AppTextStyle.regularTextStyle
                          .copyWith(color: AppColor.whiteColor),
                    ),
                  ),
                )
              ],
            );
          })),
    );
  }
}
