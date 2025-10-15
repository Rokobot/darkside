import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/password_recovery_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/app_dialog.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_textfield.dart';
import 'package:food_app/views/widgets/spacing.dart';
import 'package:get/get.dart';

buildForgotPassDialog(BuildContext context, TextTheme t, PasswordRecoveryController passwordRecoveryController) {
  appDialog(
    context: context,
    title: Align(
      alignment: Alignment.center,
      child: Text(
        "Forgot Password",
        style: t.titleLarge?.copyWith(color: AppColors.mainColor),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              "Please enter your email address to\nreceive a verification code",
              textAlign: TextAlign.center,
              style: t.displayMedium?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
            )),
        VSpace(32.h),
        CustomTextField(
          hintext: "Enter Email Address",
          isPrefixIcon: true,
          prefixIcon: 'email',
          controller: passwordRecoveryController.emailController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        VSpace(32.h),
        Obx(
          () => AppButton(
            isLoading: passwordRecoveryController.isLoading.value,
            bgColor: AppColors.mainColor,
            onTap: () {
              passwordRecoveryController.sendCodeApi();
            },
          ),
        ),
      ],
    ),
  );
}
