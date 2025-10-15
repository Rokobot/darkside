import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class Styles {
  static const String appFontFamily = 'PlusJakartaSans';

  static TextStyle baseStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static TextStyle mediumTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 24.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static TextStyle smallTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w700,
  );
  static TextStyle bodyLarge = TextStyle(
    color: AppColors.blackColor,
    fontSize: 20.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyMedium = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodySmall = TextStyle(
    color: AppColors.paragraphColor,
    fontSize: 14.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static TextStyle extraSmall = TextStyle(
    color: AppColors.paragraphColor,
    fontSize: 12.sp,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
}
