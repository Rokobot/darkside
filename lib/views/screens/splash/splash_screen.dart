import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/bindings/controller_index.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/onboarding_controller.dart';
import 'package:food_app/controllers/splash_services.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import 'package:get_storage/get_storage.dart';
import '../../../config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  final onboardingController = Get.put(OnboardingController());
  final languageController = Get.put(LanguageController());
  final profileController = Get.put(ProfileController());
  int? selectedLanguageIndex;

  void _initializeState() async {
    await onboardingController.fetchOnboardingData();
    await profileController.fetchUserData();
    selectedLanguageIndex = GetStorage().read<int>('languageIndex') ?? 1;
    languageController.fetchLanguageData(selectedLanguageIndex!);
    Future.delayed(const Duration(seconds: 3), () {
      splashServices.isLogin();
    });
  }

  @override
  void initState() {
    _initializeState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
        width: context.mQuery.width,
        height: context.mQuery.height,
        padding: EdgeInsets.all(125.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "$rootImageDir/splash_bg.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, left: 15.w),
                child: ClipRRect(
                    borderRadius:BorderRadius.circular(100.r),
                    child: Image.asset("$rootImageDir/splash_logo.png")),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Text(
                    AppConstants.appName,
                    style: context.t.titleMedium?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
