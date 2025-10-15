import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/menu_controller.dart';
import 'package:food_app/controllers/wishlist_controller.dart';
import 'package:food_app/views/screens/products/product_item.dart';
import 'package:food_app/views/screens/products/product_list.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final menuController = Get.put(MenusController());
  final wishlistController = Get.put(WishlistController());
  final languageController = Get.put(LanguageController());
  List<int> addedWhishlist = [];
  bool isSearching = false;
  List<Map<String, dynamic>> searchedProductList = [];
  TextEditingController searchProductTextEditingCtrl = TextEditingController();

  dynamic categoryId = Get.arguments;

  @override
  void initState() {
    if (categoryId != null) {
      menuController.fetchFilteredProducts("", 0, 200, categoryId);
    } else {
      menuController.fetchMenu();
    }
    wishlistController.fetchWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenusController>(builder: (menuController) {
      return GetBuilder<WishlistController>(builder: (wishlistController) {
        return RefreshIndicator(
          onRefresh: () async {
            menuController.fetchMenu();
          },
          child: Scaffold(
            appBar: CustomAppBar(
              bgColor: Get.isDarkMode ? AppColors.darkBgColor : AppColors.bgColor,
              title: languageController.languageData["Menus"] ?? "Menus",
              actions: [
                InkResponse(
                  onTap: () {
                    Get.toNamed(RoutesName.filterScreen);
                  },
                  child: Container(
                    width: 34.h,
                    height: 34.h,
                    padding: EdgeInsets.all(10.5.h),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Get.isDarkMode ? AppColors.mainColor : Colors.transparent, width: .2),
                    ),
                    child: Image.asset(
                      "$rootImageDir/filter_3.png",
                      height: 32.h,
                      width: 32.h,
                      color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                HSpace(20.w),
              ],
            ),
            body: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          isPrefixIcon: true,
                          prefixIcon: "search_icon",
                          hintext: "Search Product",
                          borderRadius: BorderRadius.circular(8.r),
                          controller: searchProductTextEditingCtrl,
                          onChanged: (v) {
                            menuController.fetchFilteredProducts(v, 0, 200, "");
                            setState(() {});
                          },
                        ),
                      ),
                      HSpace(16.w),
                      InkWell(
                        onTap: menuController.changeLayout,
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.all(15.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppThemes.borderColor(), width: Dimensions.appThinBorder),
                          ),
                          child: Image.asset(
                            menuController.isGridView ? "$rootImageDir/list.png" : "$rootImageDir/grid.png",
                            fit: BoxFit.fill,
                            color: Get.isDarkMode ? AppColors.whiteColor : AppColors.paragraphColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  VSpace(32.h),
                  if (menuController.isGridView == false)
                    menuController.isLoading
                        ? Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 3 / 4.3,
                              ),
                              itemBuilder: (context, index) {
                                return const ShimmerPreloader();
                              },
                            ),
                          )
                        : menuController.menus == null || menuController.menus!.isEmpty
                            ? Expanded(
                                child: NotFound(
                                    message: languageController.languageData["No menu found!"] ?? "No menu found!"))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: menuController.menus!.length,
                                  itemBuilder: (context, index) {
                                    var clampedIndex = index.clamp(0, menuController.menus!.length);
                                    var item = menuController.menus![clampedIndex];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8.r),
                                        onTap: () {},
                                        child: ProductList(
                                          menu: item,
                                          wishlist: wishlistController.wishlist,
                                          addToWishlist: wishlistController.addToWishlist,
                                          isItemInWishlist: wishlistController.isItemInWishlist,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  if (menuController.isGridView == true)
                    menuController.isLoading
                        ? Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 3 / 4.3,
                              ),
                              itemBuilder: (context, index) {
                                return const ShimmerPreloader();
                              },
                            ),
                          )
                        : menuController.menus == null || menuController.menus!.isEmpty
                            ? Expanded(
                                child: NotFound(
                                    message: languageController.languageData["No menu found!"] ?? "No menu found!"))
                            : Expanded(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: menuController.menus!.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20.w,
                                    mainAxisSpacing: 20.h,
                                    childAspectRatio: 3 / 4.3,
                                  ),
                                  itemBuilder: (context, index) {
                                    var clampedIndex = index.clamp(0, menuController.menus!.length);
                                    var item = menuController.menus![clampedIndex];
                                    return ProductItem(
                                      menu: item,
                                      wishlist: wishlistController.wishlist,
                                      addToWishlist: wishlistController.addToWishlist,
                                      isItemInWishlist: wishlistController.isItemInWishlist,
                                    );
                                  },
                                ),
                              ),
                  VSpace(24.h),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
