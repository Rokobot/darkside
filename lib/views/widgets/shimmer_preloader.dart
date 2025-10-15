import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPreloader extends StatelessWidget {
  const ShimmerPreloader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.mainColor.withOpacity(.1),
      highlightColor: AppColors.mainColor.withOpacity(.02),
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
