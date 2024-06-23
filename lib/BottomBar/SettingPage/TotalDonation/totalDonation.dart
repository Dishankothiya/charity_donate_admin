import 'package:charity_admin/CommonScreen/commonAppBar.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class totalDoantion extends StatefulWidget {
  const totalDoantion({super.key});

  @override
  State<totalDoantion> createState() => _totalDoantionState();
}

class _totalDoantionState extends State<totalDoantion> {
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
    await Future.delayed(Duration(seconds: 3), () {});
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      appBar: commonAppbar(context: context, title: "Total Doantion"),
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
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
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
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroudColor,
                                        borderRadius: BorderRadius.circular(10),
                                      )))
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: AppColor.backgroudColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${document['ImageURL']}"),
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
                                      children: [
                                        const Icon(
                                          Icons.gpp_good,
                                          color: AppColor.greenColor,
                                          size: 14,
                                        ),
                                        Container(
                                          width: 150,
                                          // color: AppColor.appColor,
                                          child: Text(
                                            "${document['OwnerName']}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.greyColor,
                                                    fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Text(
                                        "Raised",
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                color: AppColor.blackColor,
                                                fontWeight: FontWeight.w500),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "Target",
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                                color: AppColor.blackColor,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ]),
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
                                        Container(
                                          width: 100,
                                          child: Text(
                                            "${document['TotalAmount']}",
                                            textAlign: TextAlign.end,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.smallTextStyle
                                                .copyWith(
                                                    color: AppColor.greyColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        // const Icon(
                                        //   Icons.watch_later_outlined,
                                        //   color: AppColor.greyColor,
                                        //   size: 16,
                                        // ),
                                        // const SizedBox(
                                        //   width: 5,
                                        // ),
                                        // Text(
                                        //   "23 day left",
                                        //   style: AppTextStyle.smallTextStyle
                                        //       .copyWith(
                                        //           color: AppColor.greyColor,
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: 14),
                                        // )
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     InkWell(
                                    //       onTap: () async {
                                    //         final documentId =
                                    //             '${documents[index].id}';
                                    //         final newData = {
                                    //           "CharityName":
                                    //               "${documents[index]['CharityName']}",
                                    //           "OwnerName":
                                    //               "${documents[index]['CharityName']}",
                                    //           "TotalAmount":
                                    //               "${documents[index]['TotalAmount']}",
                                    //           "Amount":
                                    //               "${documents[index]['Amount']}",
                                    //           "AboutCharity":
                                    //               "${documents[index]['AboutCharity']}",
                                    //           "Percentage":
                                    //               "${documents[index]['Percentage']}",
                                    //           "ImageURL":
                                    //               "${documents[index]['ImageURL']}"
                                    //         };
                                    //         await FirebaseFirestore.instance
                                    //             .collection('admin')
                                    //             .doc(documentId)
                                    //             .update(newData);
                                    //         // Navigator.of(context)
                                    //         //     .push(MaterialPageRoute(
                                    //         //   // builder: (context) {},
                                    //         // ));
                                    //       },
                                    //       child: Container(
                                    //         height: 25,
                                    //         width: 50,
                                    //         decoration: BoxDecoration(
                                    //             color: AppColor.appColor,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5)),
                                    //         alignment: Alignment.center,
                                    //         child: Text(
                                    //           "Edit",
                                    //           style: AppTextStyle
                                    //               .regularTextStyle
                                    //               .copyWith(
                                    //                   color:
                                    //                       AppColor.whiteColor,
                                    //                   fontSize: 12),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     InkWell(
                                    //       onTap: () {
                                    //         FirebaseFirestore.instance
                                    //             .collection('admin')
                                    //             .doc(documents[index].id)
                                    //             .delete();
                                    //       },
                                    //       child: Container(
                                    //         height: 25,
                                    //         width: 50,
                                    //         decoration: BoxDecoration(
                                    //             color: AppColor.redColor,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5)),
                                    //         alignment: Alignment.center,
                                    //         child: Text(
                                    //           "Delete",
                                    //           style: AppTextStyle
                                    //               .regularTextStyle
                                    //               .copyWith(
                                    //                   color:
                                    //                       AppColor.whiteColor,
                                    //                   fontSize: 12),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     InkWell(
                                    //       onTap: () {
                                    //         Navigator.of(context)
                                    //             .push(MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const notificationScreen(),
                                    //         ));
                                    //       },
                                    //       child: Container(
                                    //         height: 25,
                                    //         width: 50,
                                    //         decoration: BoxDecoration(
                                    //             color: AppColor.greenColor,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5)),
                                    //         alignment: Alignment.center,
                                    //         child: Text(
                                    //           "Notify",
                                    //           style: AppTextStyle
                                    //               .regularTextStyle
                                    //               .copyWith(
                                    //                   color:
                                    //                       AppColor.whiteColor,
                                    //                   fontSize: 12),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // )
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
    );
  }
}
