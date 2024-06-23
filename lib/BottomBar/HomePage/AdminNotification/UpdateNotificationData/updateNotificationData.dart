import 'dart:convert';

import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../CommonScreen/commontextfild.dart';
import 'package:http/http.dart' as http;

class updateNotificationData extends StatefulWidget {
  final String sid;
  final String pid;
  final String CharityTitle;
  const updateNotificationData(
      {super.key,
      required this.sid,
      required this.pid,
      required this.CharityTitle});

  @override
  State<updateNotificationData> createState() => _updateNotificationDataState();
}

class _updateNotificationDataState extends State<updateNotificationData> {
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

  TextEditingController AddNotification = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String name = "";
  Map<String, dynamic> data = {};
  void getSubcollectionStream() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('admin1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CharityData")
        .doc(widget.pid)
        .collection("adminNotification")
        .doc(widget.sid)
        .get();

    data = documentSnapshot.data() as Map<String, dynamic>;
    name = data["AdminNotification"];
    AddNotification.text = name;

    print(name);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubcollectionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formkey,
          child:
              // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //   // future: getSubcollectionStream(),
              //   future: FirebaseFirestore.instance
              //       .collection("adminNotification")
              //       .doc(widget.id)
              //       .get(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Center(
              //         child: CircularProgressIndicator(
              //           color: AppColor.appColor,
              //         ),
              //       );
              //     }
              //     // print(
              //     //     "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${getSubcollectionStream()}");
              //     // print(
              //     // "dddddddddddddddddddddddddddddddddddd${FirebaseFirestore.instance.collection("adminNotification").doc(widget.id).get()}");
              //     var datas = snapshot.data!.data() as Map<String, dynamic>;

              //     print("data $datas");
              //     var addnotification = datas["AdminNotification"];
              //     AddNotification = TextEditingController(text: addnotification);

              ListView(
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
                      "Update Notification",
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
                  controller: AddNotification,
                  disabledBorderColor: AppColor.appColor,
                  cursorColor: AppColor.appColor,
                  needValidation: true,
                  // topPadding: 10,
                  // maxLine: 7,
                  validationMessage: "please fill something about charity"),
            ],
          )),
      bottomNavigationBar: Container(
          height: 70,
          child:
              // Obx(() {
              // return
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    DateTime now = DateTime.now();
                    int day = now.day;
                    String monthName = DateFormat('MMM').format(now);
                    int year = now.year;
                    DocumentReference<Map<String, dynamic>> references =
                        FirebaseFirestore.instance
                            .collection("admin1")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("CharityData")
                            .doc(widget.pid);

                    references
                        .collection("adminNotification")
                        .doc(widget.sid)
                        .update({
                      "AdminNotification": AddNotification.text,
                      "NotificationTime": now,
                      "NotificationDay": day,
                      "NotificationMonth": monthName,
                      "NotificationYear": year
                    });
                    FirebaseFirestore.instance
                        .collection("adminNotificationdata")
                        .doc(widget.sid)
                        .update({
                      "AdminNotification": AddNotification.text,
                      "NotificationTime": now,
                      "NotificationDay": day,
                      "NotificationMonth": monthName,
                      "NotificationYear": year
                    });
                    sendNotification(
                        "${widget.CharityTitle}", "${AddNotification.text}");

                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: AppColor.appColor,
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      "Update",
                      style: AppTextStyle.regularTextStyle
                          .copyWith(color: AppColor.whiteColor),
                    )),
              ),
              InkWell(
                onTap: () {
                  AddNotification.clear();
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
          )
          // })
          ),
    );
  }
}
