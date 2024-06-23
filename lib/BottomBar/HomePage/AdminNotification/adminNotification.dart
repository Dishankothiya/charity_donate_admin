import 'package:charity_admin/BottomBar/HomePage/AdminNotification/AddNotificationData/addNotificationData.dart';
import 'package:charity_admin/BottomBar/HomePage/AdminNotification/UpdateNotificationData/updateNotificationData.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class adminNotificationScreen extends StatefulWidget {
  final String id;
  const adminNotificationScreen({super.key, required this.id});

  @override
  State<adminNotificationScreen> createState() =>
      _adminNotificationScreenState();
}

class _adminNotificationScreenState extends State<adminNotificationScreen> {
  Stream<QuerySnapshot> getSubcollectionStream() {
    // Get a reference to the parent document
    DocumentReference parentDocumentRef = FirebaseFirestore.instance
        .collection('admin1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CharityData")
        .doc(widget.id);

    // Return a stream of the subcollection
    return parentDocumentRef
        .collection('adminNotification')
        .orderBy("NotificationTime", descending: true)
        .snapshots();
  }

  Future<void> editSubcollectionDocument(
      String parentCollectionPath,
      String parentDocumentId,
      String subcollectionPath,
      String documentId,
      Map<String, dynamic> newData) async {
    final firestore = FirebaseFirestore.instance;
    final parentDocRef =
        firestore.collection(parentCollectionPath).doc(parentDocumentId);
    final subcollectionRef = parentDocRef.collection(subcollectionPath);

    final docRef = subcollectionRef.doc(documentId);

    // Update the document with new data
    await docRef.update(newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.appColor,
        child: Icon(
          Icons.add,
          color: AppColor.whiteColor,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => addNotificationData(id: widget.id),
          ));
        },
      ),
      body: StreamBuilder(
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
            var charityname= snapshot.data!["CharityName"];
            return ListView(
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
                        "Notification",
                        style: AppTextStyle.mediumTextStyle.copyWith(),
                      ),
                      const SizedBox(
                        height: 40,
                        width: 40,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  // width: 200,
                  color: AppColor.appColor,
                  child: Image.network(
                    snapshot.data!["ImageURL"],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${snapshot.data!["CharityName"]}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: AppColor.blackColor, fontSize: 20),
                ),
                StreamBuilder(
                    stream: getSubcollectionStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.appColor,
                          ),
                        );
                      }
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: AppColor.appColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                color: AppColor.greyColor
                                                    .withOpacity(0.7))
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "${documents[index]["NotificationDay"]}",
                                            style: AppTextStyle.regularTextStyle
                                                .copyWith(
                                                    color: AppColor.whiteColor,
                                                    fontSize: 16),
                                          ),
                                          Text(
                                            "${documents[index]["NotificationMonth"]}",
                                            style: AppTextStyle.regularTextStyle
                                                .copyWith(
                                                    color: AppColor.whiteColor,
                                                    fontSize: 16),
                                          ),
                                          Text(
                                            "${documents[index]["NotificationYear"]}",
                                            style: AppTextStyle.regularTextStyle
                                                .copyWith(
                                                    color: AppColor.whiteColor,
                                                    fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          child: Text(
                                            "${documents[index]["AdminNotification"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            style: AppTextStyle.mediumTextStyle
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.blackColor
                                                        .withOpacity(0.9)),
                                          ),
                                        )),
                                    PopupMenuButton(
                                      onSelected: (String choice) async {
                                        if (choice == 'edit') {
                                          // await editSubcollectionDocument(
                                          //     'admin',
                                          //     '${widget.id}',
                                          //     'adminNotification',
                                          //     '${documents[index].id}', {
                                          //   'field1': '${documents[index]["AdminNotification"]}',
                                          //   // 'field2': 'updated_value2',
                                          //   // Add other fields as needed
                                          // });
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                updateNotificationData(
                                              sid: documents[index].id,
                                              pid: widget.id,
                                              CharityTitle:charityname
                                            ),
                                          ));
                                          print("${documents[index].id}");
                                        }
                                        if (choice == 'delete') {
                                          DocumentReference parentDocumentRef =
                                              FirebaseFirestore.instance
                                                  .collection("admin1")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection("CharityData")
                                                  .doc(widget.id);
                                          parentDocumentRef
                                              .collection("adminNotification")
                                              .doc(documents[index].id)
                                              .delete();

                                          FirebaseFirestore.instance
                                              .collection(
                                                  "adminNotificationdata")
                                              .doc(documents[index].id)
                                              .delete();
                                        }
                                      },
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Edit"),
                                              ],
                                            ),
                                            value: "edit",
                                            // value: '/hello',
                                          ),
                                          PopupMenuItem(
                                            child: Row(
                                              children: const [
                                                Icon(Icons.delete),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Delete"),
                                              ],
                                            ),
                                            value: 'delete',
                                          ),
                                        ];
                                      },
                                      child: const Icon(
                                        Icons.more_vert_outlined,
                                        color: AppColor.greyColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    })
              ],
            );
          }),
    );
  }
}
