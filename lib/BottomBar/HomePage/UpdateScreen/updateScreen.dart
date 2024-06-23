import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:charity_admin/BottomBar/SettingPage/settingScreen.dart';
import 'package:charity_admin/CommonScreen/commonListtile.dart';
import 'package:charity_admin/CommonScreen/commontextfild.dart';
import 'package:charity_admin/CommonScreen/savedButton.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/Controller/HomeScreenCollection/AddCollectionController/addCollectionPageController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class updateScreen extends StatefulWidget {
  final String id;
  const updateScreen({super.key, required this.id});

  @override
  State<updateScreen> createState() => _updateScreenState();
}

class _updateScreenState extends State<updateScreen> {
  AddCollectionPageController addCollectionPageController =
      AddCollectionPageController();

  final formkey = GlobalKey<FormState>();

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

  TextEditingController CharityName = TextEditingController();
  TextEditingController OwnerName = TextEditingController();
  TextEditingController TotalAmount = TextEditingController();
  TextEditingController Amount = TextEditingController();
  TextEditingController AboutCharity = TextEditingController();
  String charityname = "";
  String ownername = "";
  String totalamount = "";
  String amount = "";
  String aboutcharity = "";
  String imageURL = "";

  Map<String, dynamic> data = {};
  void getSubcollectionStream() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('admin1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CharityData")
        .doc(widget.id)
        .get();

    data = documentSnapshot.data() as Map<String, dynamic>;
    charityname = data["CharityName"];
    CharityName.text = charityname;
    ownername = data["OwnerName"];
    OwnerName.text = ownername;
    totalamount = data["TotalAmount"];
    TotalAmount.text = totalamount;
    amount = data["Amount"];
    Amount.text = amount;
    aboutcharity = data["AboutCharity"];
    AboutCharity.text = aboutcharity;
    setState(() {
      imageURL = data["ImageURL"];
    });
    print(imageURL);
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
      backgroundColor: AppColor.backgroudColor,
      body: Form(
          key: formkey,
          child:
              // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //   future: FirebaseFirestore.instance
              //       .collection("admin")
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
              //     var data = snapshot.data!.data() as Map<String, dynamic>;
              //     String charityname = data["CharityName"];
              //     CharityName = TextEditingController(text: charityname);
              //     var ownername = data["OwnerName"];
              //     OwnerName = TextEditingController(text: ownername);
              //     var totalamount = data["TotalAmount"];
              //     TotalAmount = TextEditingController(text: totalamount);
              //     var amount = data["Amount"];
              //     Amount = TextEditingController(text: amount);
              //     var aboutCharity = data["AboutCharity"];
              //     AboutCharity = TextEditingController(text: aboutCharity);
              //     var percentage = data["Percentage"];
              //     var imageurl = data["ImageURL"];
              //     print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii$imageurl");
              //     return
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
                      "Update List",
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
                  controller: CharityName,
                  disabledBorderColor: AppColor.appColor,
                  cursorColor: AppColor.appColor,
                  needValidation: true,
                  validationMessage: "please fill Charity Name"),
              textView(
                  labelText: "Owner Name",
                  hintText: "owner name",
                  controller: OwnerName,
                  disabledBorderColor: AppColor.appColor,
                  cursorColor: AppColor.appColor,
                  needValidation: true,
                  validationMessage: "please fill Owner Name"),
              textView(
                  labelText: "How much money do you want?",
                  hintText: "total amount",
                  controller: TotalAmount,
                  textInputType: TextInputType.number,
                  disabledBorderColor: AppColor.appColor,
                  cursorColor: AppColor.appColor,
                  needValidation: true,
                  prefixIcon: const Icon(Icons.currency_rupee),
                  validationMessage:
                      "please fill how much money do you want? "),
              textView(
                  labelText: "How much money right now?",
                  hintText: "amount",
                  controller: Amount,
                  textInputType: TextInputType.number,
                  disabledBorderColor: AppColor.appColor,
                  cursorColor: AppColor.appColor,
                  needValidation: true,
                  prefixIcon: const Icon(Icons.currency_rupee),
                  validationMessage: "please fill how much money right now?"),
              textView(
                  labelText: "About charity",
                  hintText: "about charity",
                  controller: AboutCharity,
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
                              //  Obx(() {
                              //   return
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
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(imageURL),
                                                  fit: BoxFit.cover)),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      selectedIMage!.path)),
                                                  fit: BoxFit.cover)),
                                        ))
                          // })
                          ),
                      Text(
                        "Add Charity Photos",
                        style: AppTextStyle.regularTextStyle
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          // })

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
                      String? url;
                      if (editProfileController.filePath.value.isNotEmpty) {
                        print("if part run");
                        addCollectionPageController.setLoading(true);

                        print("33");
                        // showIndiCator(context);
                        String ext = editProfileController.filePath.value
                            .split(".")
                            .last;
                        String imgpath =
                            // ignore: prefer_interpolation_to_compose_strings
                            DateTime.now().millisecondsSinceEpoch.toString() +
                                "." +
                                ext;
                        if (!Uri.parse(imgpath).isAbsolute) {
                          Reference reference =
                              FirebaseStorage.instance.ref(imgpath);
                          await reference.putFile(
                              File(editProfileController.filePath.value));

                          url = await reference.getDownloadURL();
                          print(url);
                          double convertRupees() {
                            int conertamount = int.parse(Amount.text);
                            int convertotalAmount = int.parse(TotalAmount.text);
                            double totalPercentage =
                                conertamount * 100 / convertotalAmount;
                            print("totalPersentage$totalPercentage");

                            int intTotalPercentage = totalPercentage.toInt();

                            double convertPercentage =
                                intTotalPercentage / 100.0;

                            return convertPercentage;
                          }

                          DateTime now = DateTime.now();
                          String monthName = DateFormat('MMM').format(now);
                          int day = now.day;
                          int year = now.year;
                          int updateamount = int.parse(Amount.text);
                          // addCollectionPageController.Amount;
                          int updatetotalamount = int.parse(TotalAmount.text);

                          if (updateamount <= updatetotalamount) {
                            print("11111");
                            FirebaseFirestore.instance
                                .collection('admin1')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("CharityData")
                                .doc(widget.id)
                                .update({
                              "CharityName": CharityName.text,
                              "OwnerName": OwnerName.text,
                              "TotalAmount": TotalAmount.text,
                              "Amount": Amount.text,
                              "AboutCharity": AboutCharity.text,
                              "Percentage": convertRupees(),
                              "Time": now,
                              "Date": day,
                              "MonthName": monthName,
                              'Year': year,
                              "ImageURL": url
                            });
                            FirebaseFirestore.instance
                                .collection("CharityData")
                                .doc(widget.id)
                                .update({
                              "CharityName": CharityName.text,
                              "OwnerName": OwnerName.text,
                              "TotalAmount": TotalAmount.text,
                              "Amount": Amount.text,
                              "AboutCharity": AboutCharity.text,
                              "Percentage": convertRupees(),
                              "Time": now,
                              "Date": day,
                              "MonthName": monthName,
                              'Year': year,
                              "ImageURL": url
                            });
                            sendNotification(
                                "${CharityName.text}", "${AboutCharity.text}");
                            Navigator.of(context).pop();
                          } else {
                            print("222222");
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
                                    height:
                                        MediaQuery.of(context).size.height / 5,
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
                                                "You can not right Amount='${Amount.text}' more than you want",
                                            trailingIcon: false),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: savedButton(
                                                  height: 40,
                                                  width: 100,
                                                  title: "Ok",
                                                  buttonColor:
                                                      AppColor.blueColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                          addCollectionPageController.setLoading(true);
                          // FirebaseFirestore.instance
                          //     .collection("CharityData")
                          //     .doc(widget.id);

                          // references.update();
                        }
                      } else {
                        print("else part run");
                        addCollectionPageController.setLoading(true);
                        double convertRupees() {
                          int conertamount = int.parse(Amount.text);
                          int convertotalAmount = int.parse(TotalAmount.text);
                          double totalPercentage =
                              conertamount * 100 / convertotalAmount;
                          print("totalPersentage$totalPercentage");

                          int intTotalPercentage = totalPercentage.toInt();

                          double convertPercentage = intTotalPercentage / 100.0;

                          return convertPercentage;
                        }

                        int updateamount = int.parse(Amount.text);
                        // addCollectionPageController.Amount;
                        int updatetotalamount = int.parse(TotalAmount.text);
                        if (updateamount <= updatetotalamount) {
                          print("3333");
                          FirebaseFirestore.instance
                              .collection('admin1')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("CharityData")
                              .doc(widget.id)
                              .update({
                            "CharityName": CharityName.text,
                            "OwnerName": OwnerName.text,
                            "TotalAmount": TotalAmount.text,
                            "Amount": Amount.text,
                            "AboutCharity": AboutCharity.text,
                            "Percentage": convertRupees(),
                            "ImageURL": imageURL
                          });
                          FirebaseFirestore.instance
                              .collection("CharityData")
                              .doc(widget.id)
                              .update({
                            "CharityName": CharityName.text,
                            "OwnerName": OwnerName.text,
                            "TotalAmount": TotalAmount.text,
                            "Amount": Amount.text,
                            "AboutCharity": AboutCharity.text,
                            "Percentage": convertRupees(),
                            "ImageURL": imageURL
                          });
                          Navigator.of(context).pop();

                          addCollectionPageController.setLoading(false);
                        } else {
                          print("4444");
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
                                  height:
                                      MediaQuery.of(context).size.height / 5,
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
                                              "You can not right Amount='${Amount.text}' more than you want",
                                          trailingIcon: false),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: savedButton(
                                                height: 40,
                                                width: 100,
                                                title: "Ok",
                                                buttonColor:
                                                    AppColor.blueColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        }

                        // DocumentReference<Map<String, dynamic>> references =
                        //     FirebaseFirestore.instance
                        //         .collection("CharityData")
                        //         .doc(widget.id);

                        // references.update({
                        //   "CharityName": CharityName.text,
                        //   "OwnerName": OwnerName.text,
                        //   "TotalAmount": TotalAmount.text,
                        //   "Amount": Amount.text,
                        //   "AboutCharity": AboutCharity.text,
                        //   "Percentage": convertRupees(),
                        //   "ImageURL": imageURL
                        // });

                        // if (selectedIMage == null || imageURL.isEmpty) {
                        // showModalBottomSheet(
                        //     // shape: RoundedRectangleBorder(
                        //     //     borderRadius: BorderRadius.vertical(
                        //     //         top: Radius.circular(12))),
                        //     enableDrag: false,
                        //     // constraints: BoxConstraints(maxHeight: 750),
                        //     isScrollControlled: true,
                        //     backgroundColor: AppColor.transparentColor,
                        //     context: context,
                        //     builder: (context) {
                        //       return Container(
                        //         height:
                        //             MediaQuery.of(context).size.height / 5,
                        //         // color: AppColors.whiteColor,
                        //         decoration: const BoxDecoration(
                        //             color: AppColor.whiteColor,
                        //             borderRadius: BorderRadius.only(
                        //                 topLeft: Radius.circular(20),
                        //                 topRight: Radius.circular(20))),
                        //         child: Column(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           children: [
                        //             commonListtile(
                        //                 leadingIcon: Icon(
                        //                   Icons.image,
                        //                   color: AppColor.redColor,
                        //                   size: 30,
                        //                 ),
                        //                 title:
                        //                     "Please Select image on your Gallery",
                        //                 trailingIcon: false),
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.end,
                        //               children: [
                        //                 InkWell(
                        //                   onTap: () {
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                   child: savedButton(
                        //                       height: 40,
                        //                       width: 100,
                        //                       title: "Ok",
                        //                       buttonColor:
                        //                           AppColor.blueColor),
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       );
                        //     });
                      }

                      addCollectionPageController.setLoading(false);
                      // }
                      // addCollectionPageController.setLoading(true);
                      // if (paths != null) {
                      //   String ex = paths!.split(".").last.toString();

                      //   String unicname =
                      //       DateTime.now().millisecondsSinceEpoch.toString() +
                      //           "." +
                      //           ex;
                      //   print("\npathsssssssssssssssssss${unicname}");
                      //   Reference reference =
                      //       FirebaseStorage.instance.ref(unicname);
                      //   await reference.putFile(File(paths!));
                      //   imagesend = await reference.getDownloadURL();
                      //   print("referenceeeeeeeeeeeeeeeeeeeeeeee$reference");

                      //   print("\nuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$imagesend");
                      // }
                      // // rupees convert rupees in to persentage.
                      // double convertRupees() {
                      //   int conertamount = int.parse(Amount.text);
                      //   int convertotalAmount = int.parse(TotalAmount.text);
                      //   double totalPercentage =
                      //       conertamount * 100 / convertotalAmount;
                      //   print("totalPersentage$totalPercentage");

                      //   int intTotalPercentage = totalPercentage.toInt();

                      //   double convertPercentage = intTotalPercentage / 100.0;

                      //   return convertPercentage;
                      // }

                      // TimeOfDay now = const TimeOfDay(hour: 1, minute: 10);
                      // if (imagesend != null) {
                      //   DocumentReference<Map<String, dynamic>> references =
                      //       FirebaseFirestore.instance
                      //           .collection("admin")
                      //           .doc(widget.id);

                      //   references.update({
                      //     "CharityName": CharityName.text,
                      //     "OwnerName": OwnerName.text,
                      //     "TotalAmount": TotalAmount.text,
                      //     "Amount": Amount.text,
                      //     "AboutCharity": AboutCharity.text,
                      //     "Percentage": convertRupees(),
                      //     // "ImageURL": imagesend
                      //   });

                      //   Navigator.of(context).pop();
                      //   addCollectionPageController.setLoading(true);
                      // } else {
                      //   showModalBottomSheet(
                      //       // shape: RoundedRectangleBorder(
                      //       //     borderRadius: BorderRadius.vertical(
                      //       //         top: Radius.circular(12))),
                      //       enableDrag: false,
                      //       // constraints: BoxConstraints(maxHeight: 750),
                      //       isScrollControlled: true,
                      //       backgroundColor: AppColor.transparentColor,
                      //       context: context,
                      //       builder: (BuildContext) {
                      //         return Container(
                      //           height: MediaQuery.of(context).size.height / 5,
                      //           // color: AppColors.whiteColor,
                      //           decoration: const BoxDecoration(
                      //               color: AppColor.whiteColor,
                      //               borderRadius: BorderRadius.only(
                      //                   topLeft: Radius.circular(20),
                      //                   topRight: Radius.circular(20))),
                      //           child: Column(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceAround,
                      //             children: [
                      //               commonListtile(
                      //                   leadingIcon: Icon(
                      //                     Icons.image,
                      //                     color: AppColor.redColor,
                      //                     size: 30,
                      //                   ),
                      //                   title:
                      //                       "Please Select image on your Gallery",
                      //                   trailingIcon: false),
                      //               Row(
                      //                 mainAxisAlignment: MainAxisAlignment.end,
                      //                 children: [
                      //                   InkWell(
                      //                     onTap: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: savedButton(
                      //                         height: 40,
                      //                         width: 100,
                      //                         title: "Ok",
                      //                         buttonColor: AppColor.blueColor),
                      //                   ),
                      //                 ],
                      //               )
                      //             ],
                      //           ),
                      //         );
                      //       });
                      //   addCollectionPageController.setLoading(false);
                      // }
                      // // _updateData();
                      // // Navigator.of(context).pop();
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
                              "Update",
                              style: AppTextStyle.regularTextStyle
                                  .copyWith(color: AppColor.whiteColor),
                            )),
                ),
                InkWell(
                  onTap: () {
                    CharityName.clear();
                    OwnerName.clear();
                    TotalAmount.clear();
                    Amount.clear();
                    AboutCharity.clear();
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
