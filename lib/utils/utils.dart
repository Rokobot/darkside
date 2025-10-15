import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/screens/verification/verification_screen.dart';
import 'package:food_app/views/widgets/banned.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Utils {
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // capitalizes the first letter of each word
  static String capitalizeEachWord(String input) {
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }

  static changeDateFormat(dynamic time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.bgColor,
      textColor: AppColors.paragraphColor,
    );
  }

  static void handleSuccessResponse(String title, String message) {
    Get.snackbar(
      capitalizeEachWord(title),
      message,
      duration: const Duration(seconds: 2),
      backgroundColor: AppThemes.getFillColor(),
    );
  }

  static void handleFailureResponse(Map<String, dynamic> data) {
    if (data['message'].runtimeType.toString().toLowerCase() == "string") {
      Get.snackbar(
        capitalizeEachWord(data['status']),
        data['message'],
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
    } else {
      Get.snackbar(
        capitalizeEachWord(data['status']),
        "",
        messageText: SizedBox(
          height: 20.h,
          child: ListView.builder(
            itemCount: data['message'].length,
            itemBuilder: (context, index) {
              return Text(
                data['message'][index],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp, color: AppColors.whiteColor),
              );
            },
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
    }
  }

  static snackBar(String title, String message) {
    Get.snackbar(title, message);
  }
}

final box = GetStorage();

void checkVerificationStatus() {
  if (kDebugMode) {
    print("checking verification status");
  }
  dynamic storedEmail = box.read('isEmailVerified');
  dynamic storedSms = box.read('isSmsVerified');
  dynamic storedTwoFa = box.read('isTwoFaVerified');
  dynamic storedStatus = box.read('isStatusVerified');

  if (storedEmail != 1) {
    Get.offAll(const VerificationScreen(verificationType: "mail"));
  } else if (storedSms != 1) {
    Get.offAll(const VerificationScreen(verificationType: "sms"));
  } else if (storedTwoFa != 1) {
    Get.offAll(const VerificationScreen(verificationType: "twoFA"));
  } else if (storedStatus != 1) {
    Get.offAll(const UserStatus());
  }
}
