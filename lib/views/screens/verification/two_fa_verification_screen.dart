import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/two_fa_controller.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class TwoFaVerificationScreen extends StatefulWidget {
  const TwoFaVerificationScreen({super.key});

  @override
  State<TwoFaVerificationScreen> createState() => _TwoFaVerificationScreenState();
}

class _TwoFaVerificationScreenState extends State<TwoFaVerificationScreen> {
  final twoFactorController = Get.put(TwoFactorController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    twoFactorController.fetchTwoFactor();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<TwoFactorController>(builder: (twoFactorController) {
      return Scaffold(
        backgroundColor: Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          bgColor: Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor,
          title: languageController.languageData["Two Step Security"] ?? "Two Step Security",
        ),
        body: twoFactorController.isLoading
            ? Center(child: Helpers.appLoader())
            : twoFactorController.twoFactorInfo == null
                ? NotFound(message: languageController.languageData["Data not found!"] ?? "Data not found!")
                : Column(
                    children: [
                      VSpace(20.h),
                      Expanded(
                        child: Container(
                          padding: Dimensions.kDefaultPadding,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppThemes.getDarkCardColor(),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                VSpace(24.h),
                                Container(
                                  height: 184.h,
                                  width: 184.h,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    color: AppThemes.getFillColor(),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "$rootImageDir/two_fa_image.png",
                                  ),
                                ),
                                VSpace(24.h),
                                Text(
                                  languageController.languageData["Two Factor Authenticator"] ??
                                      "Two Factor Authenticator",
                                  style: t.bodyLarge,
                                ),
                                VSpace(16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 43.h,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 16.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32.r),
                                            bottomLeft: Radius.circular(32.r),
                                          ),
                                        ),
                                        child: Text(
                                          twoFactorController.twoFactorInfo!.secret,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodySmall?.copyWith(
                                              color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: twoFactorController.twoFactorInfo!.secret));
                                        Helpers.showToast(
                                            msg: languageController.languageData["Copied Successfully"] ??
                                                "Copied Successfully",
                                            gravity: ToastGravity.CENTER,
                                            bgColor: AppColors.whiteColor,
                                            textColor: AppColors.blackColor);
                                      },
                                      child: Container(
                                        height: 44.h,
                                        width: 41.w,
                                        padding: EdgeInsets.all(12.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(32.r),
                                            bottomRight: Radius.circular(32.r),
                                          ),
                                        ),
                                        child: Image.asset("$rootImageDir/copy.png"),
                                      ),
                                    ),
                                  ],
                                ),
                                VSpace(32.h),
                                Container(
                                  height: 270.h,
                                  width: 220.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.mainColor),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    children: [
                                      VSpace(10.h),
                                      Container(
                                        height: 200.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "$rootImageDir/frame.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // child: QrImageView(
                                        //   foregroundColor: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                        //   data: twoFactorController.twoFactorInfo!.secret,
                                        //   version: QrVersions.auto,
                                        //   size: 200.0,
                                        // ),
                                        child: Image.network(
                                            "https://quickchart.io/chart?cht=qr&chs=250x250&chl={{(${twoFactorController.twoFactorInfo!.secret})}}"),
                                      ),
                                      const Spacer(),
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Transform.rotate(
                                            angle: .85,
                                            child: Container(
                                              height: 20.h,
                                              width: 35.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30.h,
                                            width: 220.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
                                            ),
                                            child: Text(
                                              languageController.languageData["Scan Here"] ?? "Scan Here",
                                              style: t.displayMedium?.copyWith(color: AppColors.whiteColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                VSpace(32.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  height: Dimensions.buttonHeight,
                                  child: MaterialButton(
                                    color: AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.r),
                                    ),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        barrierDismissible: false,
                                        titlePadding: EdgeInsets.only(top: 10.h),
                                        titleStyle: t.bodyLarge,
                                        title: languageController.languageData['2 Step Security'] ?? '2 Step Security',
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 20.h),
                                              twoFactorController.twoFactorInfo!.twoFactorEnable
                                                  ? CustomTextField(
                                                      keyboardType: TextInputType.number,
                                                      contentPadding: EdgeInsets.only(left: 10.w),
                                                      bgColor: AppThemes.getDarkBgColor(),
                                                      hintext: languageController.languageData["Enter Password"] ??
                                                          "Enter Password",
                                                      controller: twoFactorController.passwordController,
                                                    )
                                                  : CustomTextField(
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter.digitsOnly,
                                                      ],
                                                      contentPadding: EdgeInsets.only(left: 10.w),
                                                      bgColor: AppThemes.getDarkBgColor(),
                                                      hintext:
                                                          languageController.languageData["Enter Code"] ?? "Enter Code",
                                                      controller: twoFactorController.codeController,
                                                    ),
                                            ],
                                          ),
                                        ),
                                        cancel: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.redColor, // Customize the button color
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            languageController.languageData['Cancel'] ?? 'Cancel',
                                            style: t.bodySmall?.copyWith(color: AppColors.whiteColor),
                                          ),
                                        ),
                                        confirm: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.mainColor // Customize the button color
                                              ),
                                          onPressed: () {
                                            twoFactorController.twoFactorInfo!.twoFactorEnable
                                                ? twoFactorController.disableTwoFactor()
                                                // .then((value) => twoFactorController.fetchTwoFactor())
                                                : twoFactorController.enableTwoFactor();
                                            // .then((value) => twoFactorController.fetchTwoFactor());
                                            Get.back();
                                          },
                                          child: Text(
                                            languageController.languageData['Verify'] ?? 'Verify',
                                            style: t.bodySmall?.copyWith(color: AppColors.whiteColor),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        twoFactorController.twoFactorInfo!.twoFactorEnable != true
                                            ? languageController.languageData["Enable Two Factor Authentication"] ??
                                                "Enable Two Factor Authentication"
                                            : languageController.languageData["Disable Two Factor Authentication"] ??
                                                "Disable Two Factor Authentication",
                                        style: t.bodyMedium?.copyWith(color: AppColors.whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                VSpace(32.h),
                                Text(languageController.languageData["Google Authenticator"] ?? "Google Authenticator",
                                    style: t.bodyLarge),
                                VSpace(8.h),
                                const Divider(color: AppColors.black10),
                                VSpace(12.h),
                                Text(
                                  languageController.languageData[
                                          "Use Google Authenticator to Scan The QR code or use the code"] ??
                                      "Use Google Authenticator to Scan The QR code or use the code",
                                  style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                                ),
                                VSpace(12.h),
                                Text(
                                  languageController.languageData[
                                          "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the Two-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device."] ??
                                      "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the Two-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.",
                                  style: t.bodyMedium
                                      ?.copyWith(color: Get.isDarkMode ? AppColors.black20 : AppColors.black50),
                                ),
                                VSpace(30.h),
                                Material(
                                  color: Colors.transparent,
                                  child: AppButton(
                                    text: languageController.languageData["Download App"] ?? "Download App",
                                    onTap: twoFactorController.openStore,
                                  ),
                                ),
                                VSpace(50.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      );
    });
  }
}
