import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/change_password_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:get/get.dart';
import '../../../config/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePasswordController = Get.put(ChangePasswordController());
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<ChangePasswordController>(builder: (changePasswordController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: languageController.languageData['Change Password'] ?? "Change Password",
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(Dimensions.screenHeight * .05),
              Container(
                height: Dimensions.screenHeight * .85,
                width: double.maxFinite,
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languageController.languageData['Current Password'] ?? "Current Password",
                        style: t.displayMedium),
                    VSpace(10.h),
                    CustomTextField(
                      hintext: languageController.languageData['Current Password'] ?? "Current Password",
                      isPrefixIcon: true,
                      isSuffixIcon: true,
                      obsCureText: changePasswordController.isPassShow ? false : true,
                      prefixIcon: 'lock',
                      suffixIcon: changePasswordController.isPassShow ? 'show' : 'hide',
                      controller: changePasswordController.currentPasswordController,
                      onSuffixPressed: () {
                        changePasswordController.isPassShow = !changePasswordController.isPassShow;
                        changePasswordController.update();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return languageController.languageData['Please enter password'] ?? 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    VSpace(24.h),
                    Text(languageController.languageData['New Password'] ?? "New Password", style: t.displayMedium),
                    VSpace(10.h),
                    CustomTextField(
                      hintext: languageController.languageData['New Password'] ?? "New Password",
                      isPrefixIcon: true,
                      isSuffixIcon: true,
                      obsCureText: changePasswordController.isNewPassShow ? false : true,
                      prefixIcon: 'lock',
                      suffixIcon: changePasswordController.isNewPassShow ? 'show' : 'hide',
                      controller: changePasswordController.passwordController,
                      onSuffixPressed: () {
                        changePasswordController.isNewPassShow = !changePasswordController.isNewPassShow;
                        changePasswordController.update();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return languageController.languageData['Please enter password'] ?? 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    VSpace(24.h),
                    Text(languageController.languageData['Confirm Password'] ?? "Confirm Password",
                        style: t.displayMedium),
                    VSpace(10.h),
                    CustomTextField(
                      hintext: languageController.languageData['Confirm Password'] ?? "Confirm Password",
                      isPrefixIcon: true,
                      isSuffixIcon: true,
                      obsCureText: changePasswordController.isConfirmPassShow ? false : true,
                      prefixIcon: 'lock',
                      suffixIcon: changePasswordController.isConfirmPassShow ? 'show' : 'hide',
                      controller: changePasswordController.confirmPasswordController,
                      onSuffixPressed: () {
                        changePasswordController.isConfirmPassShow = !changePasswordController.isConfirmPassShow;
                        changePasswordController.update();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return languageController.languageData['Please enter password'] ?? 'Please enter password';
                        } else if (value != changePasswordController.passwordController.text) {
                          return 'Password didn\'t matched';
                        }
                        return null;
                      },
                    ),
                    VSpace(24.h),
                    Material(
                      color: Colors.transparent,
                      child: AppButton(
                        isLoading: changePasswordController.isLoading,
                        onTap: changePasswordController.changePassword,
                        text: languageController.languageData['Change Password'] ?? "Change Password",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
