import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/views/widgets/mediaquery_extension.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
  final loginController = Get.put(LoginController());

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
                      key: loginController.registerFormkey,
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(100.h),
                            Text(storedLanguage['Create Account'] ?? "Create Account", style: t.bodyLarge),
                            VSpace(12.h),
                            Text(
                                storedLanguage['Hello there, Sign Up to continue!'] ??
                                    "Hello there, Sign Up to continue!",
                                style: t.displayMedium?.copyWith(fontSize: 14.sp, color: AppThemes.getBlack30Color())),
                            VSpace(40.h),
                            CustomTextField(
                              hintext: storedLanguage['First Name'] ?? "First Name",
                              isPrefixIcon: true,
                              prefixIcon: 'edit',
                              controller: loginController.firstnameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            VSpace(36.h),
                            CustomTextField(
                              hintext: storedLanguage['Last Name'] ?? "Last Name",
                              isPrefixIcon: true,
                              prefixIcon: 'person',
                              controller: loginController.lastnameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            VSpace(36.h),
                            CustomTextField(
                              hintext: storedLanguage['Username'] ?? "Username",
                              isPrefixIcon: true,
                              prefixIcon: 'person',
                              controller: loginController.usernameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            VSpace(36.h),
                            CustomTextField(
                              hintext: storedLanguage['Email Address'] ?? "Email Address",
                              isPrefixIcon: true,
                              prefixIcon: 'email',
                              controller: loginController.registerEmailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            VSpace(36.h),
                            Row(
                              children: [
                                Container(
                                  height: Dimensions.textFieldHeight,
                                  decoration: BoxDecoration(
                                    color: AppThemes.getFillColor(),
                                    borderRadius: Dimensions.kBorderRadius,
                                    border: Border.all(color: AppThemes.borderColor(), width: Dimensions.appThinBorder),
                                  ),
                                  child: CountryCodePicker(
                                    padding: EdgeInsets.zero,
                                    dialogBackgroundColor: AppThemes.getDarkCardColor(),
                                    dialogTextStyle: t.bodyMedium?.copyWith(fontSize: 14.sp),
                                    flagWidth: 29.w,
                                    textStyle: t.bodySmall?.copyWith(color: AppColors.mainColor),
                                    onChanged: (CountryCode countryCode) {
                                      loginController.countryCodeController.text = countryCode.code!;
                                      loginController.phoneCodeController.text = countryCode.dialCode!;
                                    },
                                    initialSelection: 'US',
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                  ),
                                ),
                                HSpace(16.w),
                                Expanded(
                                  child: CustomTextField(
                                    hintext: storedLanguage['Phone Number'] ?? "Phone Number",
                                    isPrefixIcon: true,
                                    prefixIcon: 'call',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: loginController.phoneNumberController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            VSpace(36.h),
                            Obx(
                              () => CustomTextField(
                                hintext: storedLanguage['Password'] ?? "Password",
                                isPrefixIcon: true,
                                isSuffixIcon: true,
                                obsCureText: loginController.isPassShow.value ? false : true,
                                prefixIcon: 'lock',
                                suffixIcon: loginController.isPassShow.value ? 'show' : 'hide',
                                controller: loginController.registerpasswordController,
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
                            VSpace(36.h),
                            Obx(
                              () => CustomTextField(
                                hintext: storedLanguage['Confirm Password'] ?? "Confirm Password",
                                isPrefixIcon: true,
                                isSuffixIcon: true,
                                obsCureText: loginController.isConfirmPassShow.value ? false : true,
                                prefixIcon: 'lock',
                                suffixIcon: loginController.isConfirmPassShow.value ? 'show' : 'hide',
                                controller: loginController.confirmPasswordController,
                                onSuffixPressed: () {
                                  loginController.isConfirmPassShow.value = !loginController.isConfirmPassShow.value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter password';
                                  } else if (value != loginController.registerpasswordController.text) {
                                    return 'Password didn\'t matched';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            VSpace(48.h),
                            Material(
                              color: Colors.transparent,
                              child: Obx(
                                () => AppButton(
                                  text: storedLanguage['Sign Up'] ?? "Sign Up",
                                  isLoading: loginController.isLoading.value,
                                  bgColor: AppColors.mainColor,
                                  onTap: () {
                                    // if (loginController.registerFormkey.currentState!.validate()) {
                                    loginController.registerApi();
                                    // }
                                  },
                                ),
                              ),
                            ),
                            VSpace(10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  storedLanguage['Already have an account?'] ?? "Already have an account?",
                                  style: t.displayMedium?.copyWith(fontSize: 14.sp, color: AppThemes.getHintColor()),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(RoutesName.loginScreen);
                                  },
                                  child: Text(
                                    storedLanguage['Login'] ?? "Login",
                                    style: t.displayMedium?.copyWith(fontSize: 14.sp, color: AppColors.mainColor),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(250.h),
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
    ));
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
