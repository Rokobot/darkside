import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/spacing.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final cartController = Get.put(CartController());
  final addressController = Get.put(AddressController());
  final languageController = Get.put(LanguageController());

  List<int> addedWhishlist = [];
  int count = 12;
  int selectedIndex = 0;

  @override
  void initState() {
    addressController.fetchAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<CartController>(builder: (cartController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: languageController.languageData["My Cart"] ?? "My Cart",
        ),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              cartController.cartItems.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (_, i) {
                            int clampedIndex = i.clamp(0, cartController.cartItems.length);
                            var item = cartController.cartItems[clampedIndex];
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
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
                                              top: 0,
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Image.network(
                                                item.image,
                                                height: 70.h,
                                                width: 70.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                top: 0,
                                                left: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      cartController.removeItem(item.id, item.variant);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30.r,
                                                    width: 30.r,
                                                    padding: EdgeInsets.all(6.r),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.redColor,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: AppColors.mainColor, width: .2),
                                                    ),
                                                    child: Image.asset(
                                                      "$rootImageDir/delete.png",
                                                      fit: BoxFit.cover,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      HSpace(16.w),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item.name,
                                              maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "${AppConstants.baseCurrency}${item.price.toString()}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                              )),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8.r),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.mainColor,
                                                      borderRadius: BorderRadius.circular(50.r),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        cartController.decreaseQuantity(item.id, item.variant);
                                                      },
                                                      child: Icon(
                                                        CupertinoIcons.minus,
                                                        color: AppColors.whiteColor,
                                                        size: 16.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(item.quantity.toString(),
                                                      style: Theme.of(context).textTheme.bodySmall),
                                                  SizedBox(width: 10.w),
                                                  Container(
                                                    padding: EdgeInsets.all(8.r),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.mainColor,
                                                      borderRadius: BorderRadius.circular(50.r),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        cartController.increaseQuantity(item.id, item.variant);
                                                      },
                                                      child: Icon(
                                                        CupertinoIcons.plus,
                                                        color: AppColors.whiteColor,
                                                        size: 16.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                          }))
                  : Expanded(
                      child: NotFound(message: languageController.languageData["Cart is empty!"] ?? "Cart is empty!")),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 190.h,
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(10.h),
                Row(
                  children: [
                    Text(languageController.languageData["Sub Total:"] ?? "Sub Total:",
                        style: t.bodyLarge?.copyWith(
                            fontSize: 18.sp, color: Get.isDarkMode ? AppColors.black30 : AppColors.paragraphColor)),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("${AppConstants.baseCurrency}${cartController.totalPrice.toStringAsFixed(2)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyLarge?.copyWith(
                              fontSize: 18.sp, color: Get.isDarkMode ? AppColors.black30 : AppColors.paragraphColor)),
                    )),
                  ],
                ),
                VSpace(10.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32.r),
                    onTap: () {
                      Get.toNamed(RoutesName.productScreen);
                    },
                    child: Ink(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: AppColors.mainColor,
                          width: .5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "$rootImageDir/plus.png",
                            width: 20.h,
                            height: 20.h,
                            fit: BoxFit.cover,
                            color: Get.isDarkMode ? AppColors.whiteColor : AppColors.paragraphColor,
                          ),
                          HSpace(12.w),
                          Text(
                            languageController.languageData["Add More"] ?? "Add More",
                            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                VSpace(14.h),
                AppButton(
                  onTap: () {
                    if (addressController.addressList == null || addressController.addressList!.isEmpty) {
                      Get.toNamed(RoutesName.createAddressScreen, arguments: true);
                    } else {
                      cartController.cartItems.isNotEmpty ? Get.toNamed(RoutesName.shippingScreen) : () {};
                    }
                  },
                  text: languageController.languageData["Buy Now"] ?? "Buy Now",
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
