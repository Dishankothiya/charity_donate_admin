import 'package:charity_admin/CommonScreen/commonAppBar.dart';
import 'package:charity_admin/CommonScreen/commonShimmer.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class totalCharity extends StatefulWidget {
  const totalCharity({super.key});

  @override
  State<totalCharity> createState() => _totalCharityState();
}

class _totalCharityState extends State<totalCharity> {
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
      appBar: commonAppbar(context: context, title: "Total Charity"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('CharityData')
            .orderBy("Time", descending: true)
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

          return Column(
            children: [
              Container(
                height: 50,
                color: AppColor.appColor,
                alignment: Alignment.center,
                child: Text(
                  "Total Charity : ${documents.length}",
                  style: AppTextStyle.regularTextStyle
                      .copyWith(color: AppColor.whiteColor),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    // var documentt = int.parse("${documents[index]}");
                    var document = documents[index];
                    // print("iiiiiiiiiiiiiiiiiiiiiiiiii${documentt}");
                    // You can access fields in the document like document['fieldName']

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const aboutDonation(),
                          // ));
                        },
                        child: Container(
                          height: 100,
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
                                              color: AppColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )))
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: AppColor.backgroudColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      height: 80,
                                      // color: AppColor.blueColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          const SizedBox(
                                            height: 10,
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
                                                child: Text(
                                                  "${document['OwnerName']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyle
                                                      .smallTextStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .greyColor,
                                                          fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
