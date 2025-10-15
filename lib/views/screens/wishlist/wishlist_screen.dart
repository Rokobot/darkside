import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/wishlist_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:food_app/views/widgets/spacing.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';

class WishlistScreen extends StatefulWidget {
  final bool? isFromBottomNav;
  const WishlistScreen({super.key, this.isFromBottomNav = false});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final wishlistController = Get.put(WishlistController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    wishlistController.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(title: languageController.languageData["Wishlist"] ?? "Wishlist"),
      body: GetBuilder<WishlistController>(builder: (wishlistController) {
        if (wishlistController.isLoading) {
          return ListView.builder(
              itemCount: 7,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
              }));
        }
        if (wishlistController.wishlist == null || wishlistController.wishlist!.isEmpty) {
          return NotFound(
              message: languageController.languageData["No wishlist item found!"] ?? "No wishlist item found!");
        }
        return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: wishlistController.wishlist!.length,
            itemBuilder: (context, index) {
              var item = wishlistController.wishlist![index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () => Get.toNamed(RoutesName.productDetailsScreen, arguments: item.menuId),
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
                          child: Image.network(
                            item.menuImage,
                            height: 70.h,
                            width: 70.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        HSpace(16.w),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  item.showPrice,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                )),
                                InkWell(
                                  onTap: () {
                                    wishlistController.addToWishlist(item.menuId);
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 30.h,
                                    padding: EdgeInsets.all(6.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.mainColor, width: .4),
                                      color: AppThemes.getFillColor(),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Image.asset(
                                      "$rootImageDir/delete.png",
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
                ),
              );
            });
      }),
    );
  }
}
