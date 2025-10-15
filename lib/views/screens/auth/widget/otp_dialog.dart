import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/password_recovery_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/app_dialog.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/spacing.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

buildOtpDialog(BuildContext context, TextTheme t, PasswordRecoveryController passwordRecoveryController) {
  appDialog(
    context: context,
    title: Align(
      alignment: Alignment.center,
      child: Text(
        "Enter Your OTP Code",
        style: t.titleLarge?.copyWith(color: AppColors.mainColor),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              "Enter the 6 digits code that you\nreceived on your email",
              textAlign: TextAlign.center,
              style: t.displayMedium?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
            )),
        VSpace(32.h),
        Pinput(
          length: 6,
          onCompleted: (pin) {
            passwordRecoveryController.validationCodeController.text = pin;
          },
          focusedPinTheme: PinTheme(
            width: 50.r,
            height: 47.r,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mainColor),
              color: AppThemes.getFillColor(),
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          defaultPinTheme: PinTheme(
            width: 50.r,
            height: 47.r,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
            decoration: BoxDecoration(
              border: Border.all(color: AppThemes.getFillColor()),
              color: AppThemes.getFillColor(),
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
        ),
        VSpace(32.h),
        Obx(
          () => AppButton(
            isLoading: passwordRecoveryController.isLoading.value,
            bgColor: AppColors.mainColor,
            onTap: () {
              passwordRecoveryController.matchCode();
            },
          ),
        ),
      ],
    ),
  );
}
