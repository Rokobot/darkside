import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/themes/themes.dart';
import 'package:get/get.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/bottom_nav_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/pop_app.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    _connectivity.onConnectivityChanged.listen(Get.find<AppController>().updateConnectionStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_) {
      return GetBuilder<BottomNavController>(builder: (controller) {
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) async {
              if (didPop) {
                return;
              }
              return await PopApp.onWillPop();
            },
            child: Scaffold(
              body: controller.currentScreen,
              bottomNavigationBar: SafeArea(
                child: Container(
                  height: 84.h,
                  padding: EdgeInsets.only(top: 33.h, left: 15.w, right: 15.w),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Get.isDarkMode ? AppColors.darkBgColor : Colors.grey.shade100,
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            AppThemes.getDarkCardColor(), // Apply a red tint with 50% opacity
                            BlendMode.srcATop, // Use 'srcATop' blend mode
                          ),
                          image: AssetImage("$rootImageDir/bottom_nav.png"),
                          fit: BoxFit.cover)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(0);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              controller.selectedIndex == 0 ? "$rootImageDir/home1.png" : "$rootImageDir/home.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? controller.selectedIndex == 0
                                      ? AppColors.mainColor
                                      : AppColors.whiteColor
                                  : controller.selectedIndex == 0
                                      ? AppColors.mainColor
                                      : AppColors.blackColor,
                              fit: BoxFit.cover,
                            ),
                            Text("Home",
                                style: context.t.bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: _.isDarkMode() == true
                                        ? controller.selectedIndex == 0
                                            ? AppColors.mainColor
                                            : AppColors.whiteColor
                                        : controller.selectedIndex == 0
                                            ? AppColors.mainColor
                                            : AppColors.blackColor)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 70.w),
                        child: InkResponse(
                          onTap: () {
                            controller.changeScreen(1);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "$rootImageDir/cart1.png",
                                height: 24.h,
                                color: _.isDarkMode() == true
                                    ? controller.selectedIndex == 1
                                        ? AppColors.mainColor
                                        : AppColors.whiteColor
                                    : controller.selectedIndex == 1
                                        ? AppColors.mainColor
                                        : AppColors.blackColor,
                                fit: BoxFit.cover,
                              ),
                              Text("Cart",
                                  style: context.t.bodySmall?.copyWith(
                                      fontSize: 14.sp,
                                      color: _.isDarkMode() == true
                                          ? controller.selectedIndex == 1
                                              ? AppColors.mainColor
                                              : AppColors.whiteColor
                                          : controller.selectedIndex == 1
                                              ? AppColors.mainColor
                                              : AppColors.blackColor)),
                            ],
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(2);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "$rootImageDir/love.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? controller.selectedIndex == 2
                                      ? AppColors.mainColor
                                      : AppColors.whiteColor
                                  : controller.selectedIndex == 2
                                      ? AppColors.mainColor
                                      : AppColors.blackColor,
                              fit: BoxFit.cover,
                            ),
                            Text("Wishlist",
                                style: context.t.bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: _.isDarkMode() == true
                                        ? controller.selectedIndex == 2
                                            ? AppColors.mainColor
                                            : AppColors.whiteColor
                                        : controller.selectedIndex == 2
                                            ? AppColors.mainColor
                                            : AppColors.blackColor)),
                          ],
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(3);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "$rootImageDir/person.png",
                              height: 24.h,
                              color: _.isDarkMode() == true
                                  ? controller.selectedIndex == 3
                                      ? AppColors.mainColor
                                      : AppColors.whiteColor
                                  : controller.selectedIndex == 3
                                      ? AppColors.mainColor
                                      : AppColors.blackColor,
                              fit: BoxFit.cover,
                            ),
                            Text("Profile",
                                style: context.t.bodySmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: _.isDarkMode() == true
                                        ? controller.selectedIndex == 3
                                            ? AppColors.mainColor
                                            : AppColors.whiteColor
                                        : controller.selectedIndex == 3
                                            ? AppColors.mainColor
                                            : AppColors.blackColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Get.isDarkMode ? AppColors.darkBgColor : const Color(0xffD6CCF9),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: ClipOval(
                    child: FloatingActionButton(
                      backgroundColor: AppColors.mainColor,
                      child: Image.asset(
                        "$rootImageDir/shop.png",
                        fit: BoxFit.cover,
                        height: 26.h,
                        width: 26.h,
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesName.productScreen);
                      },
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            ));
      });
    });
  }
}
