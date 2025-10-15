import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/controllers/password_recovery_controller.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/services/localstorage/hive.dart';
import 'package:food_app/views/screens/auth/widget/email_dialog.dart';
import 'package:food_app/views/widgets/custom_textfield.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
  final loginController = Get.put(LoginController());
  final passwordRecoveryController = Get.put(PasswordRecoveryController());

  @override
  void initState() {
    super.initState();
    loginController.loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: Dimensions.screenHeight * .33,
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("$rootImageDir/login_bg.png"))),
            ),
          ),
          Positioned(
            top: 200.h,
            left: 0,
            right: 0,
            height: context.mQuery.height * .75,
            child: SingleChildScrollView(
              child: Transform.rotate(
                angle: 180 * (3.1415926535 / 180),
                child: ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppThemes.getDarkBgColor(),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(170.r)),
                    ),
                    child: Transform.rotate(
                      angle: 180 * (3.1415926535 / 180),
                      child: Form(
                        key: loginController.formkey,
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              VSpace(100.h),
                              Text(storedLanguage['Log In'] ?? "Log In", style: t.bodyLarge),
                              VSpace(12.h),
                              Text(
                                  storedLanguage['Hello there, log in to continue!'] ??
                                      "Hello there, log in to continue!",
                                  style: t.displayMedium?.copyWith(
                                    color: AppThemes.getBlack30Color(),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                  )),
                              VSpace(50.h),
                              CustomTextField(
                                hintext: storedLanguage['Username or Email'] ?? "Username or Email",
                                isPrefixIcon: true,
                                prefixIcon: 'person',
                                controller: loginController.emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              VSpace(32.h),
                              Obx(
                                () => CustomTextField(
                                  hintext: storedLanguage['Password'] ?? "Password",
                                  isPrefixIcon: true,
                                  isSuffixIcon: true,
                                  obsCureText: loginController.isPassShow.value ? false : true,
                                  prefixIcon: 'lock',
                                  suffixIcon: loginController.isPassShow.value ? 'show' : 'hide',
                                  controller: loginController.passwordController,
                                  onSuffixPressed: () {
                                    loginController.isPassShow.value = !loginController.isPassShow.value;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              VSpace(24.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Obx(
                                        () => Transform.scale(
                                          scale: 1,
                                          child: Checkbox(
                                            checkColor: AppColors.whiteColor,
                                            activeColor: AppColors.mainColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                                            visualDensity: const VisualDensity(
                                              horizontal: -4.0, // Adjust the horizontal padding
                                              vertical: -4.0, // Adjust the vertical padding
                                            ),
                                            side: BorderSide(
                                              color: AppThemes.getHintColor(),
                                            ),
                                            value: loginController.isRemember.value,
                                            onChanged: (bool? value) {
                                              loginController.isRemember.value = value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      HSpace(5.w),
                                      Text(
                                        storedLanguage['Remember me'] ?? "Remember me",
                                        style: t.bodySmall?.copyWith(
                                          fontSize: 14.sp,
                                          color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black30,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildForgotPassDialog(context, t, passwordRecoveryController);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      child: Text(
                                        storedLanguage['Forgot Your Password?'] ?? "Forgot Your Password?",
                                        style: t.displayMedium?.copyWith(
                                          color: AppColors.mainColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              VSpace(24.h),
                              Material(
                                color: Colors.transparent,
                                child: Obx(
                                  () => AppButton(
                                    text: storedLanguage['Log In'] ?? "Log In",
                                    isLoading: loginController.isLoading.value,
                                    bgColor: AppColors.mainColor,
                                    onTap: () {
                                      // if (loginController.formkey.currentState!.validate()) {
                                      loginController.loginApi();
                                      // }
                                    },
                                  ),
                                ),
                              ),
                              VSpace(50.h),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  storedLanguage['Don\'t have an account?'] ?? "Don't have an account?",
                                  style: t.displayMedium?.copyWith(
                                    color: AppThemes.getHintColor(),
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(RoutesName.signUpScreen);
                                  },
                                  child: Text(
                                    storedLanguage['Create account'] ?? "Create account",
                                    style: t.bodyMedium?.copyWith(
                                      color: AppColors.mainColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom-left
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 70); // Curve to top-right
    path.lineTo(size.width, 0); // Line to top-right
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
