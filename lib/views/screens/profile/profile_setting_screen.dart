import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/user_preference_controller.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/spacing.dart';

class ProfileSettingScreen extends StatefulWidget {
  final bool? isFromHomePage;
  final bool? isIdentityVerification;
  final bool? isAddressVerification;
  const ProfileSettingScreen(
      {super.key,
      this.isFromHomePage = false,
      this.isIdentityVerification = false,
      this.isAddressVerification = false});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final profileController = Get.put(ProfileController());
  UserPreference userPreference = UserPreference();
  final languageController = Get.put(LanguageController());
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    profileController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (_) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        return PopScope(
          canPop: false, // Allow pop by default
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (widget.isIdentityVerification == true || widget.isAddressVerification == true) {
              Get.offAllNamed(RoutesName.bottomNavBar); // Navigate to bottomNavBar
            } else {
              Get.back(); // Navigate back
            }
          },
          child: Scaffold(
            body: profileController.isLoading
                ? Center(child: Helpers.appLoader())
                : profileController.userData == null
                    ? NotFound(message: languageController.languageData["Data not found!"] ?? "Data not found!")
                    : SingleChildScrollView(
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),
                              Container(
                                width: double.infinity,
                                height: 141.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppThemes.getFillColor(),
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 18.h),
                                          child: Text(
                                            languageController.languageData["My Profile"] ?? "My Profile",
                                            style: t.titleMedium?.copyWith(
                                              fontSize: 24.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    widget.isFromHomePage == false
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(top: 10.h, left: 8.w),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (widget.isIdentityVerification == true ||
                                                      widget.isAddressVerification == true) {
                                                    Get.offAllNamed(RoutesName.bottomNavBar);
                                                  } else {
                                                    Get.back();
                                                  }
                                                },
                                                icon: Container(
                                                  width: 34.h,
                                                  height: 34.h,
                                                  padding: EdgeInsets.all(10.5.h),
                                                  decoration: BoxDecoration(
                                                    color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5,
                                                    borderRadius: BorderRadius.circular(12.r),
                                                    border: Border.all(
                                                      color: AppColors.mainColor,
                                                      width: Dimensions.appThinBorder,
                                                    ),
                                                  ),
                                                  child: Image.asset(
                                                    "$rootImageDir/back.png",
                                                    height: 32.h,
                                                    width: 32.h,
                                                    color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                )),
                                          ),
                                    Positioned(
                                        top: -30.h,
                                        right: context.mQuery.width * .15,
                                        child: Container(
                                          height: 70.h,
                                          width: 70.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Get.isDarkMode
                                                ? AppColors.mainColor.withOpacity(.2)
                                                : AppColors.mainColor.withOpacity(.5),
                                          ),
                                        )),
                                    Positioned(
                                        bottom: -20.h,
                                        left: -20.w,
                                        child: Container(
                                          height: 90.h,
                                          width: 90.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Get.isDarkMode
                                                ? AppColors.mainColor.withOpacity(.2)
                                                : AppColors.mainColor.withOpacity(.5),
                                          ),
                                        )),
                                    Positioned(
                                        bottom: -50.h,
                                        right: 20.w,
                                        child: Container(
                                          height: 80.h,
                                          width: 80.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Get.isDarkMode
                                                ? AppColors.mainColor.withOpacity(.2)
                                                : AppColors.mainColor.withOpacity(.5),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 100.h,
                                width: 300.h,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -50.h,
                                      left: 0,
                                      right: 0,
                                      child: SizedBox(
                                        width: 92.h,
                                        height: 92.h,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.r),
                                            child: Image.network(
                                              profileController.userData!.image,
                                              fit: BoxFit.fitHeight,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                      top: 50.h,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(profileController.userData!.firstname,
                                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyLarge),
                                              const SizedBox(width: 5),
                                              Text(profileController.userData!.lastname,
                                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyLarge),
                                            ],
                                          ),
                                          VSpace(5.h),
                                          Text(profileController.userData!.email,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.bodySmall?.copyWith(color: AppThemes.getBlack50Color())),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              VSpace(35.h),

                              // FOOTER PORTION
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: Get.isDarkMode ? AppColors.mainColor : Colors.transparent,
                                    width: Dimensions.appThinBorder,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(languageController.languageData['Theme'] ?? "Theme", style: t.bodyMedium),
                                    VSpace(10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 38.h,
                                              width: 38.h,
                                              padding: EdgeInsets.all(7.h),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18.r),
                                                color: AppColors.mainColor.withOpacity(.1),
                                              ),
                                              child: Image.asset(
                                                Get.isDarkMode ? "$rootImageDir/light.png" : "$rootImageDir/moon.png",
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                            HSpace(10.w),
                                            Text(
                                              languageController.languageData['Dark Mode'] ?? "Dark Mode",
                                              style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Transform.scale(
                                          scale: .8,
                                          child: CupertinoSwitch(
                                            value: HiveHelp.read(Keys.isDark) ?? false,
                                            activeColor: AppColors.mainColor,
                                            onChanged: _.onChanged,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VSpace(24.h),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: AppThemes.getFillColor(),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(languageController.languageData['Profile Settings'] ?? "Profile Settings",
                                        style: t.bodyMedium),

                                  ],
                                ),
                              ),
                              VSpace(24.h)
                            ],
                          ),
                        ),
                      ),
          ),
        );
      });
    });
  }


}
