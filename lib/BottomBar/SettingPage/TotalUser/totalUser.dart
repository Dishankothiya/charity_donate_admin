import 'package:charity_admin/CommonScreen/commonAppBar.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class userPage extends StatefulWidget {
  const userPage({super.key});

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
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
        appBar: commonAppbar(context: context, title: "Charity Users"),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColor.appColor,
              ));
            }
            var documents = snapshot.data!.docs;
            print("${documents}");
            return Column(
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              children: [
                Container(
                  height: 50,
                  color: AppColor.appColor,
                  alignment: Alignment.center,
                  child: Text(
                    "Total User : ${documents.length}",
                    style: AppTextStyle.regularTextStyle
                        .copyWith(color: AppColor.whiteColor),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: documents.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: isloading == true
                            ? CommonShimmer(
                                context,
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ))
                            : documents[index]["profilePicture"] == ""
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: AppColor.appColor,
                                      size: 40,
                                    ),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${documents[index]["profilePicture"]}"),
                                            fit: BoxFit.cover)),
                                  ),
                        title: Text(
                          "${documents[index]['name']}",
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.regularTextStyle.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        subtitle: Text(
                          "${documents[index]["email"]}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        // trailing: Container(
                        //     height: 50,
                        //     width: 100,
                        //     decoration: BoxDecoration(
                        //         color: AppColor.transparentColor,
                        //         borderRadius: BorderRadius.circular(10)),
                        //     alignment: Alignment.center,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Container(
                        //           height: 30,
                        //           width: 45,
                        //           decoration: BoxDecoration(
                        //               color: AppColor.appColor,
                        //               borderRadius: BorderRadius.circular(5)),
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             "Accept",
                        //             style: AppTextStyle.regularTextStyle.copyWith(
                        //                 color: AppColor.whiteColor, fontSize: 12),
                        //           ),
                        //         ),
                        //         Container(
                        //           height: 30,
                        //           width: 45,
                        //           decoration: BoxDecoration(
                        //               color: AppColor.redColor,
                        //               borderRadius: BorderRadius.circular(5)),
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             "Delete",
                        //             style: AppTextStyle.regularTextStyle.copyWith(
                        //                 color: AppColor.whiteColor, fontSize: 12),
                        //           ),
                        //         )
                        //       ],
                        //     )),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
