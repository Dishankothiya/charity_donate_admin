import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:charity_admin/Config/imagePath.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../CommonScreen/commonAppBar.dart';

class notificationScreen extends StatefulWidget {
  const notificationScreen({super.key});

  @override
  State<notificationScreen> createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {
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

//sub data fetch on admin collection
  Stream<QuerySnapshot> getSubcollectionStream() {
    // Get a reference to the parent document
    DocumentReference parentDocumentRef = FirebaseFirestore.instance
        .collection('admin')
        .doc("4cJ7H32TdP3XvG27kCe3");

    // Return a stream of the subcollection
    return parentDocumentRef
        .collection('userTransectionData')
        .orderBy("time", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroudColor,
      appBar: commonAppbar(context: context, title: "Notification"),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("allUserTransection")
                .orderBy("amountTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.appColor,
                  ),
                );
              }
              var documents = snapshot.data!.docs;
              return ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                isloading == true
                                    ? CommonShimmer(
                                        context,
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColor.backgroudColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ))
                                    : Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroudColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: documents[index]
                                                        ["userImage"] ==
                                                    ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                        ImagePath.kidsImage),
                                                    fit: BoxFit.cover)
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        documents[index]
                                                            ["userImage"]),
                                                    fit: BoxFit.cover)),
                                      ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 90,
                                      // color: AppColor.blueColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            // color: AppColor.blueColor,
                                            child: Text(
                                              "${documents[index]["userName"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: AppTextStyle
                                                  .mediumTextStyle
                                                  .copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              isloading == true
                                                  ? CommonShimmer(
                                                      context,
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            AppColor
                                                                .backgroudColor,
                                                      ))
                                                  : CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          AppColor.whiteColor,
                                                      backgroundImage:
                                                          NetworkImage(documents[
                                                                  index]
                                                              ["CharityImage"]),
                                                    ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                width: 180,
                                                // color: AppColor.blueColor,
                                                child: Text(
                                                    "${documents[index]["CharityName"]}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: AppTextStyle
                                                        .mediumTextStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .blackColor
                                                                .withOpacity(
                                                                    0.4),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "+${documents[index]["Amount"]}",
                                                style: AppTextStyle
                                                    .mediumTextStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.greenColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                // color: AppColor.appColor,
                                                child: Text(
                                                  "${documents[index]["amountDay"]} ${documents[index]["amountMounth"]} ${documents[index]["amountYear"]}",
                                                  style: AppTextStyle
                                                      .mediumTextStyle
                                                      .copyWith(
                                                          color: AppColor
                                                              .greyColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12),
                                                  textAlign: TextAlign.end,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            }),
      ),
    );
  }
}
