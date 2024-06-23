// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/notificationServices.dart';
import 'package:charity_admin/MyHomePage/myHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:percent_indicator/percent_indicator.dart';

Future multipleragistration() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("all_users");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  multipleragistration();
  // await FirebaseMessaging.instance.getInitialMessage();
  await AwesomeNotifictionServices.initialization();
  // FirebaseMessaging.onBackgroundMessage((message) {
  //   return _firebaseMessagingBackgroundHandler(message);
  // });

  // await NotificationService.initialize();

  // FirebaseMessagingHandler().setupFirebaseMessaging();
  // FirebaseMessaging.onBackgroundMessage((message) {
  //   return _firebaseMessagingBackgroundHandler(message);
  // });
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: AppColor.transparentColor));
  runApp(
    // DevicePreview(
    //   builder: (context) => const MyApp(), // Wrap your app
    // ),
    const MyApp()
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'high_importance_channel',
      title: message.notification?.title ?? 'hello',
      body: message.notification?.body ?? 'how are you',
    ),
  );
}

// Stream<QuerySnapshot> getSubcollectionStream() {
//   // Get a reference to the parent document
//   DocumentReference parentDocumentRef =
//       FirebaseFirestore.instance.collection('admin').doc();

//   // Return a stream of the subcollection
//   return parentDocumentRef
//       .collection('adminNotification')
//       .orderBy("NotificationTime", descending: true)
//       .snapshots();
// }

// StreamBuilder getNotification(String title, String body) {
//   return StreamBuilder(
//     stream: getSubcollectionStream(),
//     builder: (context, snapshot) {
//       return ListView(
//         children: [
//           title = snapshot.data!["CharityName"],
//           body = snapshot.data!["AdminNotification"]
//         ],
//       );
//     },
//   );
// }

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "pppppppppppppppppppppppppppppppppp${message.notification!.title.toString()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      home: myHomePage(),
      // home:NotificationReceiver()
    );
  }
}
