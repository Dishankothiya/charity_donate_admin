import 'dart:convert';

import 'package:charity_admin/CommonScreen/commontextfild.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/Config/notificationServices.dart';
// import 'package:charity_admin/Config/notificationServices.dart';
import 'package:charity_admin/Controller/HomeScreenCollection/AdminNotificationController/adminNotificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class addNotificationData extends StatefulWidget {
  final String id;
  const addNotificationData({super.key, required this.id});

  @override
  State<addNotificationData> createState() => _addNotificationDataState();
}

class _addNotificationDataState extends State<addNotificationData> {
  DateTime second = DateTime.now();

  // NotificationServices notificationServices = NotificationServices();
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   notificationServices.requestNotificationPermission();
  //   notificationServices.firebaseInit();
  //   notificationServices.isTokenRefresh();
  //   notificationServices.getDeviceToken().then((value) {
  //     print("device token");
  //     print(value);
  //   });
  // }
  Future<void> sendNotification(String title, String body) async {
    // FCM endpoint
    final String serverKey =
        'AAAA666dvBA:APA91bGUzr1ydcYK1avmvqQearGLgO9w4dc24YTQlZrYW5sATcXHrGhSyf7f5fEHAKMTBhbuXbIV8AkdqWCEvJhjH6O9kZQmaHxZUf3wmAlc3PZgCxdCDb8tlIay8cCsJrvHlkP-ukR-';
    final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    // Notification body
    final Map<String, dynamic> notificationData = {
      'notification': {'title': title, 'body': body},
      'priority': 'high',
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
    };

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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  AdminNotificationController adminNotificationController =
      AdminNotificationController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Add Notification",
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
                labelText: "Notification",
                hintText: "Notification",
                controller: adminNotificationController.AdminNotification,
                disabledBorderColor: AppColor.appColor,
                cursorColor: AppColor.appColor,
                needValidation: true,
                // topPadding: 10,
                // maxLine: 7,
                validationMessage: "please fill the Notification filed "),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("admin1")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("CharityData")
                      .doc(widget.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.appColor,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        adminNotificationController.isLoading(false);
                        if (formkey.currentState!.validate()) {
                          adminNotificationController.isLoading(true);

                          DateTime now = DateTime.now();
                          int day = now.day;
                          String monthName = DateFormat('MMM').format(now);
                          int year = now.year;
                          int userid = now.millisecondsSinceEpoch;

                          DocumentReference<Map<String, dynamic>> references =
                              FirebaseFirestore.instance
                                  .collection("admin1")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("CharityData")
                                  .doc(widget.id);

                          references
                              .collection("adminNotification")
                              .doc(userid.toString())
                              .set({
                            "AdminNotification": adminNotificationController
                                .AdminNotification.text,
                            "CharityName": "${snapshot.data!["CharityName"]}",
                            "ImageURL": "${snapshot.data!["ImageURL"]}",
                            "NotificationTime": now,
                            "NotificationDay": day,
                            "NotificationMonth": monthName,
                            "NotificationYear": year
                          });
                          int milisecond = now.microsecondsSinceEpoch;
                          FirebaseFirestore.instance
                              .collection("adminNotificationdata")
                              .doc(userid.toString())
                              .set({
                            "AdminNotification": adminNotificationController
                                .AdminNotification.text,
                            "CharityName": "${snapshot.data!["CharityName"]}",
                            "ImageURL": "${snapshot.data!["ImageURL"]}",
                            "NotificationTime": now,
                            "NotificationDay": day,
                            "NotificationMonth": monthName,
                            "NotificationYear": year,
                            "adminNotificationId": milisecond.toString()
                          });
                          sendNotification("${snapshot.data!["CharityName"]}",
                              "${adminNotificationController.AdminNotification.text}");
                          // NotificationApi.requestNotificationPermission();
                          // NotificationApi.showNotification(
                          //     title: 'hello',
                          //     body: "How are you? i hope you are fine right now",
                          //     payload: 'sarah.abs');

                          // notificationServices.getDeviceToken().then((value) async {
                          //   // print("device token");
                          //   // print(value);
                          //   var data = {
                          //     'to': value.toString(),
                          //     'priority': 'high',
                          //     'notification': {
                          //       'title': "dishan",
                          //       'body': 'Hello dishan, how are you'
                          //     }
                          //   };
                          //   await http.post(
                          //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
                          //       body: jsonEncode(data),
                          //       headers: {
                          //         'Content-Type': 'application/json; charset=UTF-8',
                          //         'Authorization':
                          //             'AAAAG-OeXEk:APA91bG7uTUizpWHA5JJdRs0idZI_F4MiyulzCTPmNkRYla0nFbaWVRPCXvvu-Stjzs91_iMdYD1gDRAt9bfaV4p0daO2x5SoSNFieyggBOG-y-MvybnxvJYgkI3oVuo6jfBEWYYNWvX'
                          //       });
                          // });
                          /////////////////////////////////////////////////////////////////////////////////////////////////
                          // await AwesomeNotifictionServices.showNotification(
                          //     payload: {
                          //       "To":
                          //           "f85h-vcJQ46N5Gw6J3vB_F:APA91bFrKP4P3YNsPHT5USHRznKGHmPkRU8omahDWteX13rtc52AUkPioCSJ4QkW0RVcOrzOfY_3-ZMD35ztWi-B2dwT1-4YSvLq9GdF1XjQZOHj1hAklJol5MFd-rYAKh8VJfAbjtpC",
                          //       'userId':
                          //           "f85h-vcJQ46N5Gw6J3vB_F:APA91bFrKP4P3YNsPHT5USHRznKGHmPkRU8omahDWteX13rtc52AUkPioCSJ4QkW0RVcOrzOfY_3-ZMD35ztWi-B2dwT1-4YSvLq9GdF1XjQZOHj1hAklJol5MFd-rYAKh8VJfAbjtpC"
                          //       // 'f85h-vcJQ46N5Gw6J3vB_F:APA91bFrKP4P3YNsPHT5USHRznKGHmPkRU8omahDWteX13rtc52AUkPioCSJ4QkW0RVcOrzOfY_3-ZMD35ztWi-B2dwT1-4YSvLq9GdF1XjQZOHj1hAklJol5MFd-rYAKh8VJfAbjtpC'
                          //     },
                          //     utoken: "high_importance_channel",
                          //     title: "${snapshot.data!["CharityName"]}",
                          //     body:
                          //         "${adminNotificationController.AdminNotification.text}");

                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          // await NotificationService.sendNotificationToUser(
                          //     "default_channel",
                          //     // " f85h-vcJQ46N5Gw6J3vB_F:APA91bFrKP4P3YNsPHT5USHRznKGHmPkRU8omahDWteX13rtc52AUkPioCSJ4QkW0RVcOrzOfY_3-ZMD35ztWi-B2dwT1-4YSvLq9GdF1XjQZOHj1hAklJol5MFd-rYAKh8VJfAbjtpC",
                          //     "hello",
                          //     "kem cho majama");
                          Navigator.of(context).pop();
                          adminNotificationController.isLoading(false);
                        }
                      },
                      child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColor.appColor,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: adminNotificationController.isLoading.value
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
                    );
                  }),
              InkWell(
                onTap: () {
                  adminNotificationController.AdminNotification.clear();
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
          )),
    );
  }
}
