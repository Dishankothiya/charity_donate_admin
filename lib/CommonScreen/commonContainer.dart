import 'package:charity_admin/Config/appColor.dart';
import 'package:charity_admin/Config/appStyle.dart';
import 'package:flutter/material.dart';

Widget CommonContainer({
  BuildContext? buildContext,
  double? height,
  double? width,
  Color? color,
  double? topPadding,
  double? bottamPadding,
  double? leftPadding,
  double? rightPadding,
}) {
  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding ?? 16,
        right: rightPadding ?? 16,
        top: topPadding ?? 16,
        bottom: bottamPadding ?? 16),
    child: Container(
      height: height ?? 100,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          color: color ?? AppColor.redColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColor.greyColor.withOpacity(0.4), blurRadius: 3)
          ]),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Hello",
          style: AppTextStyle.regularTextStyle.copyWith(
              color: AppColor.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
      ),
    ),
  );
}
