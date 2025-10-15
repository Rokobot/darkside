import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/models/menu_model.dart';
import 'package:food_app/models/wishlist_item_model.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/views/widgets/spacing.dart';
import 'package:get/get.dart';

class ProductList extends StatelessWidget {
  final MenuResponse menu;
  final List<WishlistResponse>? wishlist;
  final Function(int) addToWishlist;
  final Function(int) isItemInWishlist;
  const ProductList(
      {super.key,
      required this.menu,
      required this.wishlist,
      required this.addToWishlist,
      required this.isItemInWishlist});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => Get.toNamed(RoutesName.productDetailsScreen, arguments: menu.id),
      child: Container(
        height: 120.h,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.mainColor,
            width: Dimensions.appThinBorder,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              height: 100.h,
              width: 100.h,
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.network(
                      menu.images[0].image,
                      height: 70.h,
                      width: 70.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        addToWishlist(menu.id);
                      },
                      child: Container(
                        height: 20.h,
                        width: 20.h,
                        padding: EdgeInsets.all(4.h),
                        decoration: BoxDecoration(
                          color: AppThemes.getDarkBgColor(),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.mainColor, width: .2),
                        ),
                        child: isItemInWishlist(menu.id)
                            ? Image.asset(
                                "$rootImageDir/love1.png",
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "$rootImageDir/love.png",
                                fit: BoxFit.cover,
                                color: AppThemes.getIconBlackColor(),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HSpace(16.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(menu.details.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                Container(
                  height: 24.h,
                  width: 55.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    color: AppThemes.getDarkBgColor(),
                    border: Border.all(color: AppColors.mainColor, width: .5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.mainColor,
                        size: 13.h,
                      ),
                      HSpace(3.w),
                      Text(
                        menu.rating.length.toString(),
                        style: t.labelSmall?.copyWith(color: AppThemes.getIconBlackColor()),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        menu.showPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(4.r),
                      onTap: () => Get.toNamed(RoutesName.productDetailsScreen, arguments: menu.id),
                      child: Ink(
                        width: 40.w,
                        height: 30.h,
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainColor, width: .4),
                          color: AppThemes.getFillColor(),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Image.asset(
                          "$rootImageDir/addCart.png",
                          fit: BoxFit.fitHeight,
                          color: Get.isDarkMode ? AppColors.whiteColor : AppColors.paragraphColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
