import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../config/dimensions.dart';
import '../app_constants.dart';

class Helpers {
  static showToast({Color? bgColor, Color? textColor, String? msg, ToastGravity? gravity = ToastGravity.CENTER}) {
    return Fluttertoast.showToast(
      msg: msg ?? 'Field must not be empty!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? Colors.red,
      textColor: textColor ?? Colors.white,
      fontSize: 16.sp,
    );
  }

  /// hide keyboard automatically when click anywhere in screen
  static hideKeyboard() {
    return FocusManager.instance.primaryFocus?.unfocus();
  }

  static notFound({double? top}) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: top ?? Dimensions.screenHeight * .25),
        height: 240.h,
        width: 240.h,
        child: Image.asset(
          Get.isDarkMode ? "$rootImageDir/not_found_dark.png" : "$rootImageDir/not_found.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// SHOW VALIDATION ERROR DIALOG
  static showSnackBar({
    String msg = "Field must not be empty!",
    String title = "Error!",
    int? durationTime = 3,
    Widget? icon,
    Widget? titleText,
    Widget? messageText,
    Color? textColor,
    Color? bgColor,
    SnackPosition? snackPosition = SnackPosition.TOP,
  }) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        titleText: titleText,
        msg,
        snackPosition: snackPosition,
        messageText: messageText,
        colorText: textColor ?? AppColors.whiteColor,
        backgroundColor: bgColor ??
            (title == 'Failed' || title == 'Error!' || title == 'Error' ? AppColors.redColor : AppColors.greenColor),
        duration: Duration(seconds: durationTime!),
      );
    }
  }

  static appLoader({Color? color}) {
    return Center(
        child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(
              color: color ?? AppColors.mainColor,
              strokeWidth: 2.w,
            )));
  }
}

extension StringExtension on String {
  String toCapital() {
    if (isEmpty) {
      return this; // Return the original string if it's empty
    }

    // Capitalize the first letter and concatenate the rest of the string
    return this[0].toUpperCase() + substring(1);
  }
}
