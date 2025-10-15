import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:food_app/config/dimensions.dart';
import '../../config/app_colors.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final double? toolberHeight;
  final double? prefferSized;
  final Color? bgColor;
  final bool? isReverseIconBgColor;
  final bool? isTitleMarginTop;
  final double? fontSize;
  final Widget? titleWidget;
  const CustomAppBar(
      {super.key,
      this.leading,
      this.actions,
      this.title,
      this.titleWidget,
      this.toolberHeight,
      this.prefferSized,
      this.isReverseIconBgColor = false,
      this.isTitleMarginTop = false,
      this.bgColor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: toolberHeight ?? 100.h,
      backgroundColor: bgColor,
      centerTitle: true,
      title: titleWidget ??
          Padding(
            padding: isTitleMarginTop == true
                ? EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h)
                : EdgeInsets.zero,
            child: Text(
              title ?? "",
              style: t.titleMedium?.copyWith(
                fontSize: fontSize ?? 24.sp,
              ),
            ),
          ),
      leading: leading ??
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(10.5.h),
                decoration: BoxDecoration(
                  color: isReverseIconBgColor == true
                      ? Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.fillColorColor
                      : Get.isDarkMode
                          ? AppColors.darkCardColor
                          : AppColors.fillColorColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: Get.isDarkMode
                          ? AppColors.mainColor
                          : Colors.transparent,
                      width: Dimensions.appThinBorder),
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 32.h,
                  width: 32.h,
                  color: AppThemes.getIconBlackColor(),
                  fit: BoxFit.fitHeight,
                ),
              )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefferSized ?? 70.h);
}
