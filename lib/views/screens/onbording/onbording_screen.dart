import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/onboarding_controller.dart';
import 'package:food_app/controllers/user_preference_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:food_app/utils/services/localstorage/hive.dart';
import 'package:food_app/utils/services/localstorage/keys.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';
import '../auth/sign_up_screen.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  UserPreference userPreference = UserPreference();
  final PageController controller = PageController();
  int currentIndex = 0;

  final onboardingController = Get.put(OnboardingController());

  @override
  void initState() {
    // onboardingController.fetchOnboardingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<OnboardingController>(builder: (onboardingController) {
      return Scaffold(
        body: onboardingController.isLoading
            ? Center(child: Helpers.appLoader())
            : onboardingController.onboardingList == null && onboardingController.onboardingList!.isEmpty
                ? const NotFound(message: "Data not found!")
                : Stack(
                    children: [
                      Positioned(
                        top: 290.h,
                        bottom: 0,
                        left: -25.w,
                        child: Container(
                          height: 70.h,
                          width: 70.h,
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(.35),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 70.h,
                            width: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondaryColor, width: 1.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150.h,
                        right: -25.w,
                        child: Container(
                          height: 70.h,
                          width: 70.h,
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(.35),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 70.h,
                            width: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondaryColor, width: 1.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: onboardingController.onboardingList!.length,
                              onPageChanged: (i) {
                                setState(() {
                                  currentIndex = i;
                                  userPreference.markOnboardingAsShown();
                                });
                              },
                              itemBuilder: (context, i) {
                                if (currentIndex != 0) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: context.mQuery.height,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Image.network(
                                              onboardingController.onboardingList![i].image,
                                              height: (currentIndex == onboardingController.onboardingList!.length - 1)
                                                  ? context.mQuery.height * .72
                                                  : context.mQuery.height,
                                              width: double.maxFinite,
                                              fit: BoxFit.fill,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Transform.rotate(
                                                angle: 180 * (3.1415926535 / 180),
                                                child: ClipPath(
                                                  clipper: TopCurveClipper(),
                                                  child: Container(
                                                    height: (currentIndex ==
                                                            onboardingController.onboardingList!.length - 1)
                                                        ? 380.h
                                                        : 390.h,
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                      color: AppThemes.getDarkCardColor(),
                                                    ),
                                                    child: Transform.rotate(
                                                      angle: 180 * (3.1415926535 / 180),
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Positioned(
                                                            top: 90.h,
                                                            bottom: 0,
                                                            left: -25.w,
                                                            child: Container(
                                                              height: 60.h,
                                                              width: 60.h,
                                                              padding: EdgeInsets.all(8.h),
                                                              decoration: BoxDecoration(
                                                                color: AppColors.mainColor.withOpacity(.35),
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: Container(
                                                                height: 70.h,
                                                                width: 70.h,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: AppColors.secondaryColor, width: 1.5),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              VSpace(80.h),
                                                              Center(
                                                                child: Padding(
                                                                  padding: Dimensions.kDefaultPadding,
                                                                  child: Text(
                                                                      onboardingController.onboardingList![i].heading,
                                                                      textAlign: TextAlign.center,
                                                                      style: t.titleSmall?.copyWith(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontSize: 22.sp)),
                                                                ),
                                                              ),
                                                              VSpace(12.h),
                                                              Padding(
                                                                padding: Dimensions.kDefaultPadding,
                                                                child: Text(
                                                                  onboardingController.onboardingList![i].subHeading,
                                                                  textAlign: TextAlign.center,
                                                                  style: t.displayMedium?.copyWith(
                                                                    height: 1.5,
                                                                    fontSize: 16.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                              VSpace(44.h),
                                                              VSpace(20.h),
                                                              Container(
                                                                  padding: Dimensions.kDefaultPadding,
                                                                  child: Row(
                                                                    mainAxisAlignment: (currentIndex ==
                                                                            onboardingController
                                                                                    .onboardingList!.length -
                                                                                1)
                                                                        ? MainAxisAlignment.center
                                                                        : MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      currentIndex ==
                                                                              onboardingController
                                                                                      .onboardingList!.length -
                                                                                  1
                                                                          ? const SizedBox(
                                                                              height: 1,
                                                                              width: 1,
                                                                            )
                                                                          : InkWell(
                                                                              onTap: () {
                                                                                controller.animateToPage(
                                                                                    onboardingController
                                                                                        .onboardingList!.length,
                                                                                    duration: const Duration(
                                                                                        milliseconds: 800),
                                                                                    curve: Curves.easeInOutQuint);
                                                                                userPreference.markOnboardingAsShown();
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(
                                                                                    vertical: 10.h),
                                                                                child: Text(
                                                                                  storedLanguage['Skip'] ?? "Skip",
                                                                                  style: t.displayMedium?.copyWith(
                                                                                    color: Get.isDarkMode
                                                                                        ? AppColors.whiteColor
                                                                                        : AppColors.greyColor,
                                                                                    fontSize: 16.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                      if (currentIndex !=
                                                                          onboardingController.onboardingList!.length -
                                                                              1)
                                                                        InkWell(
                                                                          borderRadius: BorderRadius.circular(10.r),
                                                                          onTap: () {
                                                                            (currentIndex ==
                                                                                    (onboardingController
                                                                                            .onboardingList!.length -
                                                                                        1))
                                                                                ? Get.offAllNamed(
                                                                                    RoutesName.loginScreen)
                                                                                : controller.nextPage(
                                                                                    duration: const Duration(
                                                                                        milliseconds: 800),
                                                                                    curve: Curves.easeInOutQuint);
                                                                            if ((currentIndex ==
                                                                                (onboardingController
                                                                                        .onboardingList!.length -
                                                                                    1))) {
                                                                              HiveHelp.write(Keys.isNewUser, false);
                                                                            }
                                                                          },
                                                                          child: Material(
                                                                            color: Colors.transparent,
                                                                            child: Ink(
                                                                              height: 50.h,
                                                                              width: 55.h,
                                                                              padding: EdgeInsets.all(13.h),
                                                                              decoration: BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                image: AssetImage(
                                                                                  "$rootImageDir/shape.png",
                                                                                ),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                              child: Image.asset(
                                                                                  "$rootImageDir/double_arrow.png"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (currentIndex ==
                                                                          onboardingController.onboardingList!.length -
                                                                              1)
                                                                        Material(
                                                                          color: Colors.transparent,
                                                                          child: AppButton(
                                                                            text: (currentIndex ==
                                                                                    onboardingController
                                                                                            .onboardingList!.length -
                                                                                        1)
                                                                                ? storedLanguage['Get Started'] ??
                                                                                    "Get Started"
                                                                                : storedLanguage['Next'] ?? "Next",
                                                                            onTap: () {
                                                                              (currentIndex ==
                                                                                      (onboardingController
                                                                                              .onboardingList!.length -
                                                                                          1))
                                                                                  ? Get.offAllNamed(
                                                                                      RoutesName.loginScreen)
                                                                                  : controller.nextPage(
                                                                                      duration: const Duration(
                                                                                          milliseconds: 800),
                                                                                      curve: Curves.easeInOutQuint);
                                                                              if ((currentIndex ==
                                                                                  (onboardingController
                                                                                          .onboardingList!.length -
                                                                                      1))) {
                                                                                HiveHelp.write(Keys.isNewUser, false);
                                                                              }
                                                                            },
                                                                            buttonWidth: (currentIndex ==
                                                                                    onboardingController
                                                                                            .onboardingList!.length -
                                                                                        1)
                                                                                ? 142.h
                                                                                : 100.h,
                                                                            buttonHeight: (currentIndex ==
                                                                                    onboardingController
                                                                                            .onboardingList!.length -
                                                                                        1)
                                                                                ? 42.h
                                                                                : 36.h,
                                                                            style: t.displayMedium?.copyWith(
                                                                              color: AppColors.whiteColor,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: currentIndex == 2
                                                  ? context.mQuery.height * .62 + 5
                                                  : context.mQuery.height * .62,
                                              right: -25.w,
                                              child: Container(
                                                height: 60.h,
                                                width: 60.h,
                                                padding: EdgeInsets.all(8.h),
                                                decoration: BoxDecoration(
                                                  color: Get.isDarkMode
                                                      ? AppColors.mainColor.withOpacity(.35)
                                                      : const Color(0xffFFE7B0),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Container(
                                                  height: 70.h,
                                                  width: 70.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: AppColors.mainColor, width: 2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.network(
                                        onboardingController.onboardingList![i].image,
                                        height: 316.h,
                                        width: context.mQuery.width - 30,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    VSpace(59.h),
                                    Center(
                                      child: Padding(
                                        padding: Dimensions.kDefaultPadding,
                                        child: Text(onboardingController.onboardingList![i].heading,
                                            textAlign: TextAlign.center,
                                            style:
                                                t.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 22.sp)),
                                      ),
                                    ),
                                    VSpace(12.h),
                                    Padding(
                                      padding: Dimensions.kDefaultPadding,
                                      child: Text(
                                        onboardingController.onboardingList![i].subHeading,
                                        textAlign: TextAlign.center,
                                        style: t.displayMedium?.copyWith(
                                          height: 1.5,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    VSpace(30.h),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        bottomNavigationBar: currentIndex != 0
            ? const SizedBox(height: 0)
            : SafeArea(
                child: Container(
                    margin: EdgeInsets.only(bottom: 50.h),
                    padding: Dimensions.kDefaultPadding,
                    child: Row(
                      mainAxisAlignment: (currentIndex == onboardingController.onboardingList!.length - 1)
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        currentIndex == onboardingController.onboardingList!.length - 1
                            ? const SizedBox(
                                height: 1,
                                width: 1,
                              )
                            : InkWell(
                                onTap: () {
                                  controller.animateToPage(onboardingController.onboardingList!.length,
                                      duration: const Duration(milliseconds: 800), curve: Curves.easeInOutQuint);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    storedLanguage['Skip'] ?? "Skip",
                                    style: t.displayMedium?.copyWith(
                                      color: Get.isDarkMode ? AppColors.whiteColor : AppColors.greyColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                        if (currentIndex != onboardingController.onboardingList!.length - 1)
                          InkWell(
                            borderRadius: BorderRadius.circular(10.r),
                            onTap: () {
                              (currentIndex == (onboardingController.onboardingList!.length - 1))
                                  ? Get.offAllNamed(RoutesName.loginScreen)
                                  : controller.nextPage(
                                      duration: const Duration(milliseconds: 800), curve: Curves.easeInOutQuint);
                              if ((currentIndex == (onboardingController.onboardingList!.length - 1))) {
                                HiveHelp.write(Keys.isNewUser, false);
                              }
                            },
                            child: Ink(
                              height: 50.h,
                              width: 55.h,
                              padding: EdgeInsets.all(13.h),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                  "$rootImageDir/shape.png",
                                ),
                                fit: BoxFit.fill,
                              )),
                              child: Image.asset("$rootImageDir/double_arrow.png"),
                            ),
                          ),
                        if (currentIndex == onboardingController.onboardingList!.length - 1)
                          AppButton(
                            text: (currentIndex == onboardingController.onboardingList!.length - 1)
                                ? storedLanguage['Get Started'] ?? "Get Started"
                                : storedLanguage['Next'] ?? "Next",
                            onTap: () {
                              (currentIndex == (onboardingController.onboardingList!.length - 1))
                                  ? Get.offAllNamed(RoutesName.loginScreen)
                                  : controller.nextPage(
                                      duration: const Duration(milliseconds: 800), curve: Curves.easeInOutQuint);
                              if ((currentIndex == (onboardingController.onboardingList!.length - 1))) {
                                HiveHelp.write(Keys.isNewUser, false);
                              }
                            },
                            buttonWidth:
                                (currentIndex == onboardingController.onboardingList!.length - 1) ? 142.h : 100.h,
                            buttonHeight:
                                (currentIndex == onboardingController.onboardingList!.length - 1) ? 42.h : 36.h,
                            style: t.displayMedium?.copyWith(
                              color: AppColors.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                      ],
                    )),
              ),
      );
    });
  }
}
