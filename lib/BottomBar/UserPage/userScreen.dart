import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../CommonScreen/commonAppBar.dart';

class userScreen extends StatefulWidget {
  const userScreen({super.key});

  @override
  State<userScreen> createState() => _userScreenState();
}

class _userScreenState extends State<userScreen> {
  // int totalSum = 0;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final CollectionReference _parentCollection =
  //     FirebaseFirestore.instance.collection('user');
  // int sum = 0;
  // Future<int> sumAmountValues() async {
  //   int totalAmount = 0;

  //   QuerySnapshot parentCollectionSnapshot = await _parentCollection.get();

  //   for (QueryDocumentSnapshot parentDoc in parentCollectionSnapshot.docs) {
  //     CollectionReference subCollectionRef =
  //         parentDoc.reference.collection('transectionData');
  //     QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

  //     for (QueryDocumentSnapshot subDoc in subCollectionSnapshot.docs) {
  //       int amountValue = int.parse(subDoc['useramount']);
  //       totalAmount += amountValue;
  //       print("ttttttttttttttttttttttttttttt$totalAmount");
  //     }
  //   }
  //   print("ttttttttttttttttttttttttttttt$totalAmount");

  //   return totalAmount;
  // }

  //Shimmer widget
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
    await Future.delayed(Duration(microseconds: 100), () {});
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      // appBar: AppBar(
      //   title: Text('Firestore Example'),
      // ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    // sum = await sumAmountValues();
                    // print('Total Sum of Amounts: $sum');
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColor.greenColor,
                  ),
                ),
                Text(
                  "User Donated",
                  style: AppTextStyle.mediumTextStyle.copyWith(),
                ),
                const SizedBox(
                  height: 40,
                  width: 40,
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .orderBy("time", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot parentDoc) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // color: AppColor.whiteColor,
                      decoration: BoxDecoration(
                          // border: Border.all(color: AppColor.textColor),
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColor.appColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  isloading == true
                                      ? CommonShimmer(
                                          context,
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                AppColor.whiteColor,
                                          ))
                                      : parentDoc["profilePicture"] == ""
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  AppColor.whiteColor,
                                              radius: 20,
                                              child: Icon(
                                                Icons.person,
                                                color: AppColor.appColor,
                                                size: 30,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  AppColor.whiteColor,
                                              backgroundImage: NetworkImage(
                                                  parentDoc["profilePicture"]),
                                            ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${parentDoc["name"]}",
                                    style: AppTextStyle.regularTextStyle
                                        .copyWith(color: AppColor.whiteColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: parentDoc.reference
                                .collection('perticulerUserData')
                                .orderBy("Time", descending: true)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> subSnapshot) {
                              if (subSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: AppColor.appColor,
                                ));
                              }
                              // Calculate total sum of values retrieved from Firestore
                              // totalSum;
                              // for (DocumentSnapshot doc
                              //     in subSnapshot.data!.docs) {
                              //   int amount = int.parse(doc['useramount']);
                              //   totalSum += amount;
                              //   print(totalSum);
                              //   // Assuming 'value' is the field you want to subtract
                              // }
                              // Return a list view of sub-collection documents
                              return ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: subSnapshot.data!.docs.map((subDoc) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: AppColor.backgroudColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${subDoc["Day"]} ${subDoc["Mounth"]} ${subDoc["Year"]}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle.smallTextStyle
                                                  .copyWith(
                                                      color: AppColor.appColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Text(
                                            "${subDoc["Charityname"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        // Text("Amount :"),
                                        Icon(
                                          Icons.currency_rupee_outlined,
                                          color: AppColor.greenColor,
                                        ),
                                        Text(
                                          "${subDoc["Amount"]}/-",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle.mediumTextStyle
                                              .copyWith(
                                                  color: AppColor.greenColor),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          // Divider(), // Separate each parent with a divider
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       Text("Total Amount: "),
                          //       Icon(
                          //         Icons.currency_rupee_outlined,
                          //         color: AppColor.greenColor,
                          //       ),
                          //       Text(
                          //         "${sum}",
                          //         style: AppTextStyle.mediumTextStyle
                          //             .copyWith(color: AppColor.greenColor),
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
    //  Scaffold(
    //   backgroundColor: AppColor.backgroudColor,
    //   appBar: commonAppbar(context: context, title: "Users Donated"),
    //   body: ListView(
    //     physics: const BouncingScrollPhysics(),
    //     shrinkWrap: true,
    //     children: [
    //       // Padding(
    //       //   padding: const EdgeInsets.all(15.0),
    //       //   child: Row(
    //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       //     children: [
    //       //       InkWell(
    //       //         onTap: () {
    //       //           Navigator.of(context).pop();
    //       //         },
    //       //         child: const Icon(
    //       //           Icons.arrow_back_ios_new_outlined,
    //       //           color: AppColor.blackColor,
    //       //         ),
    //       //       ),
    //       //       Text(
    //       //         "User Donated",
    //       //         style: AppTextStyle.mediumTextStyle.copyWith(),
    //       //       ),
    //       //       const SizedBox(
    //       //         height: 40,
    //       //         width: 40,
    //       //       )
    //       //     ],
    //       //   ),
    //       // ),
    //       ListView.builder(
    //         physics: const NeverScrollableScrollPhysics(),
    //         shrinkWrap: true,
    //         scrollDirection: Axis.vertical,
    //         itemCount: 5,
    //         itemBuilder: (context, index) {
    //           return Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    //             child: Container(
    //               height: 100,
    //               decoration: BoxDecoration(
    //                   color: AppColor.whiteColor,
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       height: 80,
    //                       width: 80,
    //                       decoration: BoxDecoration(
    //                         color: AppColor.backgroudColor,
    //                         borderRadius: BorderRadius.circular(10),
    //                         // image: const DecorationImage(
    //                         //     image: AssetImage(ImagePath.kidsImage),
    //                         //     fit: BoxFit.cover)
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       width: 8,
    //                     ),
    //                     Expanded(
    //                         flex: 1,
    //                         child: SizedBox(
    //                           height: 90,
    //                           // color: AppColor.blueColor,
    //                           child: Column(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceAround,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               SizedBox(
    //                                 width:
    //                                     MediaQuery.of(context).size.width / 2.7,
    //                                 // color: AppColor.blueColor,
    //                                 child: Text(
    //                                   "Favour Dumnoi",
    //                                   overflow: TextOverflow.ellipsis,
    //                                   maxLines: 1,
    //                                   style:
    //                                       AppTextStyle.mediumTextStyle.copyWith(
    //                                     fontSize: 18,
    //                                   ),
    //                                 ),
    //                               ),
    //                               Row(
    //                                 children: [
    //                                   const CircleAvatar(
    //                                       radius: 12,
    //                                       backgroundColor:
    //                                           AppColor.backgroudColor
    //                                       // backgroundImage: AssetImage(
    //                                       //     ImagePath.childrenCharityImage),
    //                                       ),
    //                                   const SizedBox(
    //                                     width: 5,
    //                                   ),
    //                                   SizedBox(
    //                                     width:
    //                                         MediaQuery.of(context).size.width /
    //                                             2,
    //                                     // color: AppColor.blueColor,
    //                                     child: Text(
    //                                         "Healthy food for the homeless",
    //                                         overflow: TextOverflow.ellipsis,
    //                                         maxLines: 1,
    //                                         style: AppTextStyle.mediumTextStyle
    //                                             .copyWith(
    //                                                 color: AppColor.blackColor
    //                                                     .withOpacity(0.4),
    //                                                 fontSize: 15,
    //                                                 fontWeight:
    //                                                     FontWeight.w500)),
    //                                   ),
    //                                 ],
    //                               ),
    //                               Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   Text(
    //                                     "+\$2500",
    //                                     style: AppTextStyle.mediumTextStyle
    //                                         .copyWith(
    //                                             color: AppColor.greenColor,
    //                                             fontSize: 18,
    //                                             fontWeight: FontWeight.w500),
    //                                     textAlign: TextAlign.end,
    //                                     maxLines: 1,
    //                                     overflow: TextOverflow.ellipsis,
    //                                   ),
    //                                   Text(
    //                                     "12 Dec 23",
    //                                     textAlign: TextAlign.end,
    //                                     overflow: TextOverflow.ellipsis,
    //                                     maxLines: 1,
    //                                     style: AppTextStyle.mediumTextStyle
    //                                         .copyWith(
    //                                             color: AppColor.greyColor
    //                                                 .withOpacity(0.9),
    //                                             fontWeight: FontWeight.w400,
    //                                             fontSize: 14),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                         ))
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}
