import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final bool isClearCart;

  const CustomAlertDialog({super.key, required this.title, required this.content, this.isClearCart = false});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (widget.isClearCart) {
          cartController.clearCart();
        }
        Get.offAllNamed(RoutesName.homeScreen);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          leading: IconButton(
              onPressed: () {
                if (widget.isClearCart) {
                  cartController.clearCart();
                }
                Get.offAllNamed(RoutesName.homeScreen);
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(10.5.h),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: Get.isDarkMode ? AppColors.mainColor : Colors.transparent,
                      width: Dimensions.appThinBorder),
                ),
                child: Image.asset(
                  "assets/images/back.png",
                  height: 32.h,
                  width: 32.h,
                  color: AppThemes.getIconBlackColor(),
                  fit: BoxFit.fitHeight,
                ),
              )),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 630.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 150,
                    child:
                        Lottie.asset(widget.title == "success" ? "assets/json/success.json" : "assets/json/fail.json"),
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Utils.capitalizeEachWord(widget.content),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
