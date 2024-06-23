import 'dart:io';

import 'package:charity_admin/BottomBar/SettingPage/SecurityPage/security.dart';
import 'package:charity_admin/BottomBar/SettingPage/TotalCharity/totalCharity.dart';
import 'package:charity_admin/BottomBar/SettingPage/TotalUser/totalUser.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/SingupScreen/signupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../CommonScreen/commonIndicator.dart';
import '../../CommonScreen/commonListtile.dart';
import '../../CommonScreen/savedButton.dart';
import '../../Config/imagePath.dart';
import 'TotalDonation/totalDonation.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  EditProfileController editProfileController = EditProfileController();
// shimmer peakeg
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaded();
  }

  void loaded() async {
    setState(() {
      isloading = true;
    });
    await Future.delayed(Duration(seconds: 3), () {});
    setState(() {
      isloading = false;
    });
  }

//update the url image
  void userData() async {
    showIndiCator(context);
    String? url;
    if (editProfileController.filePath.value.isNotEmpty) {
      String ext = editProfileController.filePath.value.split(".").last;
      String imgpath =
          // ignore: prefer_interpolation_to_compose_strings
          DateTime.now().millisecondsSinceEpoch.toString() + "." + ext;
      if (!Uri.parse(imgpath).isAbsolute) {
        Reference reference = FirebaseStorage.instance.ref(imgpath);
        await reference.putFile(File(editProfileController.filePath.value));

        url = await reference.getDownloadURL();
        print(url);
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"profilePicture": url.toString()});
        print("data set ");
        Navigator.pop(context);
      }
    }
  }

  void imageShowModalSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: AppColor.transparentColor,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 5,
            decoration: const BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Divider(
                //   height: 30,
                //   thickness: 20,
                //   color: AppColor.greyColor,
                // ),
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: AppColor.appColor,
                //   backgroundImage: AssetImage(ImagePath.kidsImage),
                // ),
                SizedBox(
                  height: 10,
                ),

                InkWell(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    editProfileController.xfile.value = await imagePicker
                        .pickImage(source: ImageSource.gallery);
                    if (editProfileController.xfile.value != null) {
                      editProfileController.filePath.value =
                          editProfileController.xfile.value!.path;
                    }
                    Navigator.of(context).pop();
                    userData();
                  },
                  child: commonListtile(
                      leadingIcon: const Icon(
                        Icons.image_outlined,
                        size: 30,
                        color: AppColor.blackColor,
                      ),
                      title: "New profile picture",
                      trailingIcon: false),
                ),
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"profilePicture": ""}).then((value) {
                      Image(image: AssetImage(ImagePath.kidsImage));
                    });

                    Navigator.of(context).pop();
                  },
                  child: commonListtile(
                      leadingIcon: const Icon(
                        Icons.delete_outline_outlined,
                        size: 30,
                        color: AppColor.redColor,
                      ),
                      title: "Remove current picture",
                      trailingIcon: false),
                ),
              ],
            ),
          );
        });
  }

  Stream<DocumentSnapshot> getUserDataStream() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      // appBar: commonAppbar(title: "Settings"),
      body: StreamBuilder(
        stream: getUserDataStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.appColor,
            ));
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 230,
                // color: AppColor.blackColor,
                child: Stack(children: [
                  Positioned(
                      child: ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      height: 200,
                      color: AppColor.appColor,
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          "Profile",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.mediumTextStyle.copyWith(
                              color: AppColor.whiteColor, fontSize: 20),
                        ),
                      ),
                    ),
                  )),
                  Positioned(
                      top: 120,
                      right: 130,
                      left: 130,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("user")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!["profilePicture"] == "") {
                                return Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: AppColor.whiteColor,
                                      // backgroundImage:
                                      //     AssetImage(ImagePath.kidsImage),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColor.appColor,
                                        size: 80,
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            imageShowModalSheet();
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColor.appColor,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: AppColor.whiteColor,
                                              size: 18,
                                            ),
                                          ),
                                        ))
                                  ],
                                );
                              } else {
                                return Stack(
                                  children: [
                                    isloading == true
                                        ? CommonShimmer(
                                            context,
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  AppColor.backgroudColor,
                                            ))
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                AppColor.whiteColor,
                                            // child: Text("${snapshot.data!["name"]}"),
                                            backgroundImage: NetworkImage(
                                                snapshot
                                                    .data!["profilePicture"]),
                                          ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            imageShowModalSheet();
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: AppColor.appColor,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: AppColor.whiteColor,
                                              size: 18,
                                            ),
                                          ),
                                        ))
                                  ],
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.blackColor,
                                ),
                              );
                            }
                          }))
                ]),
              ),
              Text(
                "${snapshot.data!["name"]}",
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(fontSize: 20),
              ),
              Text(
                "${snapshot.data!["email"]}",
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumTextStyle
                    .copyWith(color: AppColor.greyColor, fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const userPage(),
                  ));
                  // fetchdata();
                },
                child: commonListtile(
                  leadingIcon: const Icon(Icons.person_outline_outlined),
                  title: "Total User",
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const totalDoantion(),
                  ));
                },
                child: commonListtile(
                    leadingIcon: const Icon(Icons.local_atm_outlined),
                    title: "Total Donation"),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const totalCharity(),
                  ));
                },
                child: commonListtile(
                    leadingIcon: const Icon(Icons.assignment_ind_rounded),
                    title: "Total Charity"),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => const securityScreen(),
              //     ));
              //   },
              //   child: commonListtile(
              //       leadingIcon: const Icon(Icons.lock_outline),
              //       title: "Security"),
              // ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      enableDrag: false,
                      isScrollControlled: true,
                      backgroundColor: AppColor.transparentColor,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 5,
                          decoration: const BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              commonListtile(
                                  leadingIcon: const Icon(
                                    Icons.logout,
                                    color: AppColor.redColor,
                                  ),
                                  title: "Are you sure for LogOut",
                                  trailingIcon: false),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: savedButton(
                                        height: 40,
                                        width: 100,
                                        title: "No",
                                        buttonColor: AppColor.blueColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  signUpPage()),
                                          (Route<dynamic> route) =>
                                              route is signUpPage);
                                    },
                                    child: savedButton(
                                        height: 40,
                                        width: 100,
                                        title: "Yes",
                                        buttonColor: AppColor.redColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                child: commonListtile(
                    leadingIcon: const Icon(Icons.logout), title: "Logout"),
              )
            ],
          );
        },
      ),
    );
  }
}

class EditProfileController extends GetxController {
  RxString filePath = "".obs;
  final xfile = Rx<XFile?>(null);
}
