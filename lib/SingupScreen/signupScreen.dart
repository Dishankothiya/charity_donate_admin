import 'package:charity_admin/BottomBar/bottombar.dart';
import 'package:charity_admin/CommonScreen/commonListtile.dart';
import 'package:charity_admin/CommonScreen/commontextfild.dart';
import 'package:charity_admin/CommonScreen/savedButton.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/Config/imagePath.dart';
import 'package:charity_admin/Config/notificationServices.dart';
import 'package:charity_admin/Controller/SingupController/singupController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../loginScreen/loginScreen.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final formKey = GlobalKey<FormState>();
  SinginController signinController = SinginController();
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  Future<void> signIn() async {
    signinController.setLoading(true);
    DateTime now = DateTime.now();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signinController.email.text,
        password: signinController.password.text,
      );
      String? deviceToken = await _pushNotificationService.getDeviceToken();

      if (userCredential.user != null) {
        print('User signed in: ${userCredential.user?.email}');
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "name": signinController.name.text,
          "email": signinController.email.text,
          "profilePicture": "",
          "time": now,
          "userToken": deviceToken,
          "password": signinController.password.text,
        }).then((value) => Navigator.of(context).pushAndRemoveUntil(
                CupertinoModalPopupRoute(
                    builder: (context) => const bottomBar()),
                (Route<dynamic> route) => false));
        signinController.setLoading(true);
      }
    } catch (e) {
      print('Error during sign-in: $e');
      signinController.setLoading(false);
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
                      leadingIcon: const Icon(
                        Icons.close,
                        color: AppColor.redColor,
                      ),
                      title:
                          "The email address is already in use by another account.",
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
                            title: "OK",
                            buttonColor: AppColor.blueColor),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
      signinController.setLoading(false);
      // SnackBar(content: Text('$e'));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     // backgroundColor: AppColor.whiteColor,
      //     content: Text(
      //       'The email address is already in use by another account.',
      //       style:
      //           AppTextStyle.mediumTextStyle.copyWith(color: AppColor.redColor),
      //     ),
      //     action: SnackBarAction(
      //       label: 'Undo',
      //       onPressed: () {
      //         // Perform some action when the "Undo" button is pressed
      //         // (You can customize this according to your needs)
      //         print('Undo action!');
      //       },
      //     ),
      //   ),
      // );
    }
  }

  void signInWithGoogle() async {
    signinController.setGoogleLoading(true);
    final GoogleSignIn googleSignIn = GoogleSignIn();
    DateTime now = DateTime.now();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential authcredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(authcredential);

      if (credential.user != null) {
        String? deviceToken = await _pushNotificationService.getDeviceToken();
        print("Sucseess ${credential.user}");
        FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "name": FirebaseAuth.instance.currentUser!.displayName.toString(),
          "email": FirebaseAuth.instance.currentUser!.email.toString(),
          "profilePicture": "",
          "userToken": deviceToken,
          "time": now,
          "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
        }).then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoModalPopupRoute(
                builder: (context) => const bottomBar(),
              ),
              (route) => false);
        });
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoModalPopupRoute(
              builder: (context) => const bottomBar(),
            ),
            (route) => false);
      }
      signinController.setGoogleLoading(false);
    } catch (error) {
      signinController.setGoogleLoading(false);
      print("Error during Google sign-in: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: AppColor.blackColor),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Lottie.asset(
              ImagePath.signupAnimation,
              height: 200,
            ),
            textView(
              labelText: "Name",
              hintText: "name",
              controller: signinController.name,
              needValidation: true,
            ),
            textView(
                labelText: "Email",
                hintText: "email",
                controller: signinController.email,
                needValidation: true,
                isEmailValidator: true),
            Obx(() {
              return textView(
                labelText: "Password",
                hintText: "password",
                obscureText:
                    signinController.isshowpassword.value ? false : true,
                controller: signinController.password,
                needValidation: true,
                isPasswordValidator: true,
                suffix: InkWell(
                  onTap: () {
                    signinController.isshowpassword.value =
                        !signinController.isshowpassword.value;
                  },
                  child: signinController.isshowpassword.value
                      ? const Icon(Icons.no_encryption_gmailerrorred_sharp)
                      : const Icon(Icons.remove_red_eye),
                ),
              );
            }),
            const SizedBox(
              height: 8,
            ),
            ListTile(
              leading: Obx(() {
                return Checkbox(
                  activeColor: AppColor.blueColor,
                  side: const BorderSide(
                    color: AppColor.blueColor,
                  ),
                  value: signinController.onchange.value,
                  onChanged: (value) {
                    signinController.onchange.value =
                        !signinController.onchange.value;
                  },
                );
              }),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "By signing up, you agree to the",
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: AppColor.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of Service and Privacy Policy",
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: AppColor.blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            InkWell(onTap: () {
              if (formKey.currentState!.validate()) {
                if (signinController.onchange.value == true) {
                  signIn();
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
                                  leadingIcon: const Icon(
                                    Icons.check_box,
                                    size: 30,
                                    color: AppColor.blueColor,
                                  ),
                                  title:
                                      "Please fill the Terms of Service and Privacy Policy",
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
                                        title: "OK",
                                        buttonColor: AppColor.blueColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
              }
            }, child: Obx(
              () {
                return Center(
                    child: signinController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.appColor,
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        : savedButton(
                            title: "Sign Up",
                            buttonColor: AppColor.appColor,
                          ));
              },
            )),

            const SizedBox(height: 10),
            Text(
              "Or With",
              style: AppTextStyle.smallTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            // this row will be google auth
            InkWell(
              onTap: () {
                signInWithGoogle();
                print(
                    "pppppppppppppppppppp${FirebaseAuth.instance.currentUser}");
              },
              child: Obx(
                () {
                  return Center(
                      child: signinController.isGoogleLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.appColor,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImagePath.searchIcon,
                                  scale: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Sign Up with Google",
                                  style: AppTextStyle.regularTextStyle,
                                )
                              ],
                            ));
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoModalPopupRoute(
                    builder: (context) => const loginPage(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: AppTextStyle.smallTextStyle.copyWith(
                              color: AppColor.blackColor,
                              fontSize: 15,
                            )),
                        TextSpan(
                            text: "Login",
                            style: AppTextStyle.smallTextStyle.copyWith(
                                color: AppColor.blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}











// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:montra/auth/Login/login.dart';
// import 'package:montra/auth/Login/login_controller.dart';
// import 'package:montra/auth/SignUp/signup_controller.dart';
// import 'package:montra/common/commonButton.dart';
// import 'package:montra/common/commonDivider.dart';
// import 'package:montra/config/app_color.dart';
// import 'package:montra/config/app_style.dart';
// import 'package:montra/config/image_path.dart';
// import 'package:montra/screen/bottomBar/bottomBar.dart';
// import 'package:montra/screen/splash_screen.dart';
// import 'package:montra/widget/commonWidget/textfield_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   SignUpController signUpController = SignUpController();
//   LoginController loginController = LoginController();

//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void signInWithGoogle() async {
//     loginController.onChangeLoding(true);
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount!.authentication;

//       final AuthCredential authcredential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       UserCredential credential =
//           await _auth.signInWithCredential(authcredential);

//       if (credential.user != null) {
//         print("Sucseess");

//         var sharePref = await SharedPreferences.getInstance();

//         sharePref.setBool(SplashScreenState.KEYLOGIN, true);
//         FirebaseFirestore.instance
//             .collection("user")
//             .doc(_auth.currentUser!.uid)
//             .set({
//           "name": _auth.currentUser!.displayName.toString(),
//           "email": _auth.currentUser!.email.toString(),
//           "profilePicture": "",
//           "userId": _auth.currentUser!.uid.toString(),
//         }).then((value) {
//           Navigator.of(context).pushAndRemoveUntil(
//               CupertinoPageRoute(
//                 builder: (context) => const BottomBar(),
//               ),
//               (route) => false);
//         });

//         loginController.onChangeLoding(false);
//       }
//     } catch (error) {
//       loginController.onChangeLoding(false);

//       print("Error during Google sign-in: $error");
//     }
//   }

//   void signUpWithEmail() async {
//     loginController.onChangeLoding(true);
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: signUpController.email.text,
//           password: signUpController.password.text);
//       if (credential.user != null) {
//         print("sucsess with email ad set data");

//         var sharePref = await SharedPreferences.getInstance();

//         sharePref.setBool(SplashScreenState.KEYLOGIN, true);
//         FirebaseFirestore.instance
//             .collection("user")
//             .doc(_auth.currentUser!.uid)
//             .set({
//           "name": signUpController.name.text,
//           "email": signUpController.email.text,
//           "password": signUpController.password.text,
//           "profilePicture": "",
//           "userId": _auth.currentUser!.uid.toString(),
//         }).then((value) {
//           Navigator.of(context).pushAndRemoveUntil(
//               CupertinoPageRoute(
//                 builder: (context) => const BottomBar(),
//               ),
//               (route) => false);
//         });

//         loginController.onChangeLoding(false);
//       }
//     } catch (e) {
//       loginController.onChangeLoding(false);
//       if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
//         // Display a message instructing the user to log in
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Center(
//               child: Text(
//                   "The email address is already in use. Please log in instead.")),
//         ));
//         print("The email address is already in use. Please log in instead.");

//         // You can also navigate to a login screen or provide UI for the user to log in.
//       } else {
//         // Handle other errors or display a generic error message
//         print("An error occurred during sign-up: $e");
//       }
//       print("Eroror$e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: globalKey,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             centerTitle: true,
//             elevation: 0,
//             title: const Text(
//               "Sign Up",
//               style: TextStyle(color: Appcolor.black),
//             ),
//             leading: InkWell(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Icon(
//                 Icons.arrow_back_outlined,
//                 color: Appcolor.black,
//               ),
//             )),
//         body: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 20,
//             ),
//             textView(
//               labelText: "Name",
//               hintText: "",
//               controller: signUpController.name,
//               needValidation: true,
//             ),
//             textView(
//                 labelText: "Email",
//                 hintText: "",
//                 controller: signUpController.email,
//                 needValidation: true,
//                 isEmailValidator: true),
//             Obx(() {
//               return textView(
//                 labelText: "Password",
//                 hintText: "",
//                 obscureText: signUpController.isshowpassword.value,
//                 controller: signUpController.password,
//                 needValidation: true,
//                 isPasswordValidator: true,
//                 suffix: InkWell(
//                   onTap: () {
//                     signUpController.isshowpassword.value =
//                         !signUpController.isshowpassword.value;
//                   },
//                   child: signUpController.isshowpassword.value
//                       ? const Icon(Icons.no_encryption_gmailerrorred_sharp)
//                       : const Icon(Icons.remove_red_eye),
//                 ),
//               );
//             }),
//             const SizedBox(
//               height: 8,
//             ),
//             ListTile(
//               leading: Obx(() {
//                 return Checkbox(
//                   activeColor: Appcolor.blue,
//                   side: const BorderSide(
//                     color: Appcolor.blue,
//                   ),
//                   value: signUpController.condition.value,
//                   onChanged: (value) {
//                     signUpController.onchange(value!);
//                   },
//                 );
//               }),
//               title: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "By signing up, you agree to the",
//                       style: AppTextStyle.regularTextStyle.copyWith(
//                         color: Appcolor.black,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Terms of Service and Privacy Policy",
//                       style: AppTextStyle.regularTextStyle.copyWith(
//                         color: Appcolor.blue,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 30,
//             ),
//             InkWell(onTap: () {
//               if (globalKey.currentState!.validate()) {
//                 if (signUpController.condition.value == true) {
//                   signUpWithEmail();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Center(child: Text("FillUp Your Condition")),
//                   ));
//                 }
//               }
//             }, child: Obx(() {
//               return Center(
//                 child: loginController.isLoding.value == false
//                     ? commonButton(
//                         context, "Sign Up", Appcolor.blue, Appcolor.whiteColor)
//                     : const CircularProgressIndicator(
//                         color: Appcolor.blue,
//                         backgroundColor: Colors.transparent,
//                       ),
//               );
//             })),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 50,
//             ),
//             Text(
//               "Or With",
//               style: AppTextStyle.smallTextStyle,
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             // this row will be google auth
//             InkWell(
//               onTap: () {
//                 signInWithGoogle();
//                 //  print("1");
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Image(
//                     image: AssetImage(
//                       ImagePath.logo,
//                     ),
//                     height: 40,
//                   ),
//                   const SizedBox(
//                     width: 3,
//                   ),
//                   Text(
//                     "Sign Up with Google",
//                     style: AppTextStyle.regularTextStyle,
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.of(context).push(
//                   CupertinoModalPopupRoute(
//                     builder: (context) => const Login(),
//                   ),
//                 );
//               },
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                         text: "Already have an account? ",
//                         style: AppTextStyle.smallTextStyle
//                             .copyWith(color: Appcolor.black45, fontSize: 15)),
//                     TextSpan(
//                         text: "Login",
//                         style: AppTextStyle.smallTextStyle
//                             .copyWith(color: Appcolor.blue, fontSize: 15))
//                   ],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             commonDivider(context),
//             const SizedBox(
//               height: 5,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }