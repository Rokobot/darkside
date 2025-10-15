import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/verification_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatefulWidget {
  static const String routeName = "/verificationScreen";
  const VerificationScreen({super.key, required this.verificationType});

  final String verificationType;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  dynamic validationCode;
  final verificationController = Get.put(VerificationController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      builder: (verificationController) {
        return Scaffold(
          appBar: const CustomAppBar(title: ""),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 200.h),
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verify Your ${Utils.capitalizeEachWord(widget.verificationType)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Please enter the code sent to your ${Utils.capitalizeEachWord(widget.verificationType)}.",
                  ),
                  SizedBox(height: 30.h),
                  Pinput(
                    length: 6,
                    onCompleted: (pin) {
                      validationCode = pin;
                    },
                    focusedPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.w,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor),
                        color: AppThemes.getFillColor(),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.w,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppThemes.borderColor()),
                        color: AppThemes.getFillColor(),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Material(
                    color: Colors.transparent,
                    child: AppButton(
                      isLoading: verificationController.isLoading,
                      onTap: () => verificationController.userVerification(widget.verificationType, validationCode),
                      text: languageController.languageData['Submit Code'] ?? 'Submit Code',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () {
                      verificationController.resendCode(widget.verificationType);
                    },
                    child: Text(
                      languageController.languageData["Resend Code"] ?? "Resend Code",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
