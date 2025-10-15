import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:get/get.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({super.key});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  var url = Get.arguments as String;
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(RoutesName.homeScreen);
            },
            icon: Container(
              width: 34.h,
              height: 34.h,
              padding: EdgeInsets.all(10.5.h),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: Get.isDarkMode ? AppColors.mainColor : Colors.transparent, width: Dimensions.appThinBorder),
              ),
              child: Image.asset(
                "$rootImageDir/back.png",
                height: 32.h,
                width: 32.h,
                color: AppThemes.getIconBlackColor(),
                fit: BoxFit.fitHeight,
              ),
            )),
        title: "Payment",
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          if (kDebugMode) {
            print("Check>>>${url.toString()}");
          }

          // if (url.toString() == '${AppConstants.baseUri}/success') {
          //   Get.to(CustomAlertDialog(title: "success", content: "Payment Success"));
          // }
          // if (url.toString() == '${AppConstants.baseUri}/failed') {
          //   Get.to(CustomAlertDialog(title: "failed", content: "Payment Failed"));
          // }
        },
        onLoadStop: (controller, url) {
          setState(() {
            isLoading = false;
          });
        },
      ),
    );
  }
}
