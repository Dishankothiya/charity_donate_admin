import 'package:charity_admin/BottomBar/HomePage/UpdateScreen/updateScreen.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/Controller/HomeScreenCollection/homeScreenController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../CommonScreen/commonAppBar.dart';
import '../../CommonScreen/commonListtile.dart';
import '../../CommonScreen/savedButton.dart';
import 'AddCollectionPage/addCollectionPage.dart';
import 'AdminNotification/adminNotification.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  HomeScreenController homeScreenController = HomeScreenController();

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

  // delete the card function
  Future<void> deleteSubcollection(String parentCollectionPath,
      String parentDocumentId, String subcollectionPath) async {
    final firestore = FirebaseFirestore.instance;
    final parentDocRef =
        firestore.collection(parentCollectionPath).doc(parentDocumentId);
    final subcollectionRef = parentDocRef.collection(subcollectionPath);

    final QuerySnapshot snapshot = await subcollectionRef.get();

    // Iterate through each document in the subcollection and delete it
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      appBar: commonAppbar(title: "Charity Card"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admin1')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("CharityData")
            .orderBy('Time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.appColor,
            ));
          }

          var documents = snapshot.data!.docs;
          print("aaaaaaaaaaaa$documents");

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // var documentt = int.parse("${documents[index]}");
              var document = documents[index];
              // print("iiiiiiiiiiiiiiiiiiiiiiiiii${documentt}");
              // You can access fields in the document like document['fieldName']

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const aboutDonation(),
                    // ));
                  },
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          // homeScreenController.setLoading(true);
                          isloading == true
                              ? CommonShimmer(
                                  context,
                                  Container(
                                    height: 100,
                                    width: 100,
                                    color: AppColor.backgroudColor,
                                  ))
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: AppColor.backgroudColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              document['ImageURL']),
                                          fit: BoxFit.cover)),
                                ),

                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 110,
                                // color: AppColor.blueColor,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${document['CharityName']}",
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.regularTextStyle
                                          .copyWith(
                                              color: AppColor.blackColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.gpp_good,
                                          color: AppColor.greenColor,
                                          size: 14,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Text(
                                            "${document['OwnerName']}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.greyColor,
                                                    fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        animationDuration: 1000,
                                        lineHeight: 5.0,
                                        percent: document['Percentage'],
                                        // percent: document['Percentage'],
                                        barRadius: const Radius.circular(10),
                                        progressColor: AppColor.greenColor,
                                        backgroundColor:
                                            AppColor.greyColor.withOpacity(0.4),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          // color: AppColor.appColor,
                                          child: Text(
                                            "${document['Amount']} (${document['Percentage']}%)",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    color: AppColor.greenColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.watch_later_outlined,
                                          color: AppColor.greyColor,
                                          size: 14,
                                        ),
                                        Container(
                                          width: 75,
                                          // color: AppColor.backgroudColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "${documents[index]['Date']} ${documents[index]['MonthName']} ${documents[index]['Year']}",
                                                style: AppTextStyle
                                                    .smallTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greyColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  updateScreen(
                                                      id: documents[index].id),
                                            ));
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: AppColor.appColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Edit",
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                enableDrag: false,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    AppColor.transparentColor,
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    // color: AppColors.whiteColor,
                                                    decoration: const BoxDecoration(
                                                        color: AppColor
                                                            .whiteColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        commonListtile(
                                                            leadingIcon:
                                                                const Icon(
                                                              Icons.delete,
                                                              size: 30,
                                                              color: AppColor
                                                                  .redColor,
                                                            ),
                                                            title:
                                                                "Do You Want to Delete a '${documents[index]["CharityName"]}'  Card ?",
                                                            trailingIcon:
                                                                false),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'admin1')
                                                                    .doc(FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                                    .collection(
                                                                        "CharityData")
                                                                    .doc(documents[
                                                                            index]
                                                                        .id)
                                                                    .delete();

//notifivation delete karva mate
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "CharityData")
                                                                    .doc(documents[
                                                                            index]
                                                                        .id)
                                                                    .delete();
//notifivation delete karva mate

                                                                // DocumentReference parentDocumentRef = FirebaseFirestore
                                                                //     .instance
                                                                //     .collection(
                                                                //         "admin1")
                                                                //     .doc(FirebaseAuth
                                                                //         .instance
                                                                //         .currentUser!
                                                                //         .uid)
                                                                //     .collection(
                                                                //         "CharityData")
                                                                //     .doc(documents[
                                                                //             index]
                                                                //         .id);
                                                                // parentDocumentRef
                                                                //     .collection(
                                                                //         "adminNotification")
                                                                //     .doc(documents[
                                                                //             index]
                                                                //         .id)
                                                                //     .delete();
                                                                // await deleteSubcollection(
                                                                //     'CharityData',
                                                                //     '${documents[index].id}',
                                                                //     'adminNotification');
                                                                // FirebaseFirestore
                                                                //     .instance
                                                                //     .collection(
                                                                //         "adminNotificationdata")
                                                                //     .doc(documents[
                                                                //             index]
                                                                //         .id)
                                                                //     .delete();
                                                                // FirebaseFirestore
                                                                //     .instance
                                                                //     .collection(
                                                                //         'CharityData')
                                                                //     .doc(documents[
                                                                //             index]
                                                                //         .id)
                                                                //     .delete();
                                                                // await deleteSubcollection(
                                                                //     'CharityData',
                                                                //     '${documents[index].id}',
                                                                //     'adminNotification');

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: savedButton(
                                                                  height: 40,
                                                                  width: 100,
                                                                  title: "YES",
                                                                  buttonColor:
                                                                      AppColor
                                                                          .redColor),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: savedButton(
                                                                  height: 40,
                                                                  width: 100,
                                                                  title: "NO",
                                                                  buttonColor:
                                                                      AppColor
                                                                          .blueColor),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: AppColor.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Delete",
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  adminNotificationScreen(
                                                      id: documents[index].id),
                                            ));
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: AppColor.greenColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Notify",
                                              style: AppTextStyle
                                                  .regularTextStyle
                                                  .copyWith(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      // ListView.builder(
      //   physics: const BouncingScrollPhysics(),
      //   shrinkWrap: true,
      //   itemCount: data.length,
      //   scrollDirection: Axis.vertical,
      //   itemBuilder: (context, index) {
      //     final user = data[index];
      //     // print(user.id);
      //     // return Padding(
      //     //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      //     //   child: InkWell(
      //     //     onTap: () {
      //     //       // Navigator.of(context).push(MaterialPageRoute(
      //     //       //   builder: (context) => const aboutDonation(),
      //     //       // ));
      //     //     },
      //     //     child: Container(
      //     //       height: 130,
      //     //       decoration: BoxDecoration(
      //     //           color: AppColor.whiteColor,
      //     //           borderRadius: BorderRadius.circular(10)),
      //     //       child: Padding(
      //     //         padding: const EdgeInsets.all(10.0),
      //     //         child: Row(
      //     //           children: [
      //     //             Container(
      //     //               height: 100,
      //     //               width: 100,
      //     //               decoration: BoxDecoration(
      //     //                 color: AppColor.appColor,
      //     //                 borderRadius: BorderRadius.circular(10),
      //     //                 // image: const DecorationImage(
      //     //                 //     image: AssetImage(
      //     //                 //         ImagePath.childrenCharityImage),
      //     //                 //     fit: BoxFit.cover)
      //     //               ),
      //     //             ),
      //     //             const SizedBox(
      //     //               width: 8,
      //     //             ),
      //     //             Expanded(
      //     //                 flex: 1,
      //     //                 child: SizedBox(
      //     //                   height: 110,
      //     //                   // color: AppColor.blueColor,
      //     //                   child: Column(
      //     //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //                     crossAxisAlignment: CrossAxisAlignment.start,
      //     //                     children: [
      //     //                       Text(
      //     //                         "${user[index]['CharityName']}",
      //     //                         overflow: TextOverflow.ellipsis,
      //     //                         style: AppTextStyle.regularTextStyle.copyWith(
      //     //                             color: AppColor.blackColor,
      //     //                             fontWeight: FontWeight.w700,
      //     //                             fontSize: 16),
      //     //                       ),
      //     //                       Row(
      //     //                         children: [
      //     //                           Text(
      //     //                             "Jude Justin",
      //     //                             style: AppTextStyle.smallTextStyle
      //     //                                 .copyWith(
      //     //                                     fontWeight: FontWeight.w400,
      //     //                                     color: AppColor.greyColor,
      //     //                                     fontSize: 14),
      //     //                           ),
      //     //                           const Icon(
      //     //                             Icons.gpp_good,
      //     //                             color: AppColor.greenColor,
      //     //                             size: 14,
      //     //                           ),
      //     //                         ],
      //     //                       ),
      //     //                       Padding(
      //     //                         padding:
      //     //                             const EdgeInsets.symmetric(vertical: 8),
      //     //                         child: LinearPercentIndicator(
      //     //                           animation: true,
      //     //                           animationDuration: 1000,
      //     //                           lineHeight: 5.0,
      //     //                           percent: 0.2500,
      //     //                           barRadius: const Radius.circular(10),
      //     //                           progressColor: AppColor.greenColor,
      //     //                           backgroundColor:
      //     //                               AppColor.greyColor.withOpacity(0.4),
      //     //                         ),
      //     //                       ),
      //     //                       Row(
      //     //                         children: [
      //     //                           Text(
      //     //                             "\$2500 (15%)",
      //     //                             style: AppTextStyle.smallTextStyle
      //     //                                 .copyWith(
      //     //                                     color: AppColor.greenColor,
      //     //                                     fontWeight: FontWeight.w500),
      //     //                           ),
      //     //                           const Spacer(),
      //     //                           const Icon(
      //     //                             Icons.watch_later_outlined,
      //     //                             color: AppColor.greyColor,
      //     //                             size: 16,
      //     //                           ),
      //     //                           const SizedBox(
      //     //                             width: 5,
      //     //                           ),
      //     //                           Text(
      //     //                             "23 day left",
      //     //                             style: AppTextStyle.smallTextStyle
      //     //                                 .copyWith(
      //     //                                     color: AppColor.greyColor,
      //     //                                     fontWeight: FontWeight.w400,
      //     //                                     fontSize: 14),
      //     //                           )
      //     //                         ],
      //     //                       ),
      //     //                       Row(
      //     //                         mainAxisAlignment:
      //     //                             MainAxisAlignment.spaceAround,
      //     //                         children: [
      //     //                           Container(
      //     //                             height: 25,
      //     //                             width: 50,
      //     //                             decoration: BoxDecoration(
      //     //                                 color: AppColor.appColor,
      //     //                                 borderRadius:
      //     //                                     BorderRadius.circular(5)),
      //     //                             alignment: Alignment.center,
      //     //                             child: Text(
      //     //                               "Edit",
      //     //                               style: AppTextStyle.regularTextStyle
      //     //                                   .copyWith(
      //     //                                       color: AppColor.whiteColor,
      //     //                                       fontSize: 12),
      //     //                             ),
      //     //                           ),
      //     //                           Container(
      //     //                             height: 25,
      //     //                             width: 50,
      //     //                             decoration: BoxDecoration(
      //     //                                 color: AppColor.redColor,
      //     //                                 borderRadius:
      //     //                                     BorderRadius.circular(5)),
      //     //                             alignment: Alignment.center,
      //     //                             child: Text(
      //     //                               "Delete",
      //     //                               style: AppTextStyle.regularTextStyle
      //     //                                   .copyWith(
      //     //                                       color: AppColor.whiteColor,
      //     //                                       fontSize: 12),
      //     //                             ),
      //     //                           ),
      //     //                           Container(
      //     //                             height: 25,
      //     //                             width: 50,
      //     //                             decoration: BoxDecoration(
      //     //                                 color: AppColor.greenColor,
      //     //                                 borderRadius:
      //     //                                     BorderRadius.circular(5)),
      //     //                             alignment: Alignment.center,
      //     //                             child: Text(
      //     //                               "Notify",
      //     //                               style: AppTextStyle.regularTextStyle
      //     //                                   .copyWith(
      //     //                                       color: AppColor.whiteColor,
      //     //                                       fontSize: 12),
      //     //                             ),
      //     //                           ),
      //     //                         ],
      //     //                       )
      //     //                     ],
      //     //                   ),
      //     //                 ))
      //     //           ],
      //     //         ),
      //     //       ),
      //     //     ),
      //     //   ),
      //     // );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: AppColor.whiteColor,
        ),
        backgroundColor: AppColor.appColor,
        onPressed: () {
          // convertRupees();
          // fetchdata();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const addCollectionPage(),
          ));
        },
      ),
    );
  }
}
