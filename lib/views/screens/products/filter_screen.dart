import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/menu_category_controller.dart';
import 'package:food_app/controllers/menu_controller.dart';
import 'package:food_app/models/menu_category_model.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final menuController = Get.put(MenusController());
  final menuCategoryController = Get.put(MenuCategoryController());
  final languageController = Get.put(LanguageController());

  double low = 20.0;
  double high = 500.0;
  MenuCategoryResponse? selectedCategory;

  @override
  void initState() {
    menuCategoryController.fetchMenuCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<MenuCategoryController>(builder: (menuCategoryController) {
      return GetBuilder<MenusController>(builder: (menuController) {
        return Scaffold(
          appBar: CustomAppBar(
            bgColor: Get.isDarkMode ? AppColors.darkBgColor : AppColors.bgColor,
            title: languageController.languageData["Filter"] ?? "Filter",
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Text(
                    languageController.languageData["Category"] ?? "Category",
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: SizedBox(
                    height: 42.h,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: menuCategoryController.menuCategories!.length,
                        itemBuilder: ((context, index) {
                          var item = menuCategoryController.menuCategories![index];
                          return InkWell(
                            onTap: () {
                              selectedCategory = item;
                              setState(() {});
                            },
                            child: Container(
                              height: 42.h,
                              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 16.w),
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: selectedCategory == item ? AppColors.mainColor : Colors.transparent,
                                border: Border.all(width: Dimensions.appThinBorder, color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.r),
                                    child: Image.network(
                                      height: 23.h,
                                      width: 23.h,
                                      menuCategoryController.menuCategories![index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  HSpace(8.w),
                                  Text(
                                    menuCategoryController.menuCategories![index].name,
                                    style: t.bodyMedium!.copyWith(
                                        color: selectedCategory == item ? AppColors.whiteColor : AppColors.blackColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Text(
                    languageController.languageData["Price"] ?? "Price",
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.all(23.r),
                  child: FlutterSlider(
                    values: [low, high],
                    rangeSlider: true,
                    max: 1000,
                    min: 0,
                    handlerWidth: 20.r,
                    handlerHeight: 20.r,
                    tooltip: FlutterSliderTooltip(
                      positionOffset: FlutterSliderTooltipPositionOffset(top: -25),
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      boxStyle: FlutterSliderTooltipBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      alwaysShowTooltip: true,
                    ),
                    handler: FlutterSliderHandler(
                      child: const Text(""),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    rightHandler: FlutterSliderHandler(
                      child: const Text(""),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    trackBar: FlutterSliderTrackBar(
                        activeTrackBar: BoxDecoration(
                      color: AppThemes.borderColor(),
                    )),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      low = lowerValue;
                      high = upperValue;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: AppButton(
                    text: languageController.languageData["Filter Now"] ?? "Filter Now",
                    onTap: () {
                      Get.back();
                      if (selectedCategory != null) {
                        menuController.fetchFilteredProducts("", low, high, selectedCategory!.id);
                      } else {
                        menuController.fetchFilteredProducts("", low, high, "");
                      }
                    },
                  ),
                ),
                VSpace(36.h),
              ],
            ),
          ),
        );
      });
    });
  }
}
