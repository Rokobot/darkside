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

buildNewPassDialog(BuildContext context, TextTheme t, PasswordRecoveryController passwordRecoveryController) {
  appDialog(
    context: context,
    title: Align(
      alignment: Alignment.center,
      child: Text(
        "Create New Password",
        style: t.titleLarge?.copyWith(color: AppColors.mainColor),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              "Set the new password for your account so that you can login and access all the features.",
              textAlign: TextAlign.center,
              style: t.displayMedium?.copyWith(color: AppThemes.getGreyColor(), height: 1.7),
            )),
        VSpace(32.h),
        Obx(
          () => CustomTextField(
            hintext: "Password",
            isPrefixIcon: true,
            isSuffixIcon: true,
            obsCureText: passwordRecoveryController.isPassShow.value ? false : true,
            prefixIcon: 'lock',
            suffixIcon: passwordRecoveryController.isPassShow.value ? 'show' : 'hide',
            controller: passwordRecoveryController.passwordController,
            onSuffixPressed: () {
              passwordRecoveryController.isPassShow.value = !passwordRecoveryController.isPassShow.value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
        ),
        VSpace(32.h),
        Obx(
          () => CustomTextField(
            hintext: "Confirm Password",
            isPrefixIcon: true,
            isSuffixIcon: true,
            obsCureText: passwordRecoveryController.isConfirmPassShow.value ? false : true,
            prefixIcon: 'lock',
            suffixIcon: passwordRecoveryController.isConfirmPassShow.value ? 'show' : 'hide',
            controller: passwordRecoveryController.confirmPasswordController,
            onSuffixPressed: () {
              passwordRecoveryController.isConfirmPassShow.value = !passwordRecoveryController.isConfirmPassShow.value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter password';
              } else if (value != passwordRecoveryController.passwordController.text) {
                return 'Password didn\'t matched';
              }
              return null;
            },
          ),
        ),
        VSpace(32.h),
        Obx(
          () => AppButton(
            isLoading: passwordRecoveryController.isLoading.value,
            bgColor: AppColors.mainColor,
            onTap: () {
              passwordRecoveryController.changePassword();
            },
          ),
        ),
      ],
    ),
  );
}
