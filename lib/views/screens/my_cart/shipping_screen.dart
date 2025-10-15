import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/services/helpers.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final addressController = Get.put(AddressController());
  final cartController = Get.put(CartController());
  final languageController = Get.put(LanguageController());
  // dynamic addressId = Get.arguments;

  void fetchData() async {
    await addressController.fetchAddressList();
    await addressController.fetchAddressView(addressController.addressList![0].id);
    addressController.selectedAddress = addressController.addressList![0];
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    addressController.isCouponApplied = false;
    addressController.discountAmount = 0.00;
    addressController.couponCodeController.clear();
  }

  @override
  void dispose() {
    Get.delete<AddressController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AddressController>(builder: (addressController) {
      return GetBuilder<CartController>(builder: (cartController) {
        return Scaffold(
          appBar: CustomAppBar(title: languageController.languageData["Shipping Address"] ?? "Shipping Address"),
          body: RefreshIndicator(
            onRefresh: () async {
              // addressController.fetchAddressList();
              fetchData();
            },
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(
                  child: addressController.isLoading
                      ? ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
                          }))
                      : addressController.addressList == null
                          ? SizedBox(
                              height: Get.height - 200.h,
                              child: NotFound(
                                  message: languageController.languageData["No Address Found!"] ?? "No Address Found!"))
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: addressController.addressList!.length,
                              itemBuilder: (context, i) {
                                var item = addressController.addressList![i];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onTap: () {
                                    addressController.selectedAddress = item;
                                    addressController.fetchAddressView(item.id);
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    padding: EdgeInsets.all(16.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                                      border: Border.all(
                                        color: addressController.selectedAddress == item
                                            ? AppColors.mainColor
                                            : AppThemes.borderColor(),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(Utils.capitalizeEachWord(item.addressName),
                                            maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyLarge),
                                        SizedBox(height: 10.h),
                                        Text(item.address,
                                            maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(RoutesName.addressViewScreen, arguments: item.id);
                                              },
                                              child: Container(
                                                width: 40.w,
                                                height: 30.h,
                                                padding: EdgeInsets.all(6.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppColors.mainColor, width: .4),
                                                  color: AppColors.mainColor,
                                                  borderRadius: BorderRadius.circular(4.r),
                                                ),
                                                child: Image.asset(
                                                  "$rootImageDir/edit.png",
                                                  fit: BoxFit.fitHeight,
                                                  color: AppColors.whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                Container(
                    height: 320.h,
                    padding: Dimensions.kDefaultPadding,
                    child: !addressController.isLoading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VSpace(10.h),
                              TextFormField(
                                enabled: !addressController.isCouponApplied,
                                controller: addressController.couponCodeController,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  hintText: languageController.languageData['Coupon'] ?? 'Coupon',
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      addressController.applyCouponCode();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5.r),
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                          color: !addressController.isCouponApplied
                                              ? AppColors.mainColor
                                              : AppColors.mainColor.withOpacity(.6),
                                          borderRadius: BorderRadius.circular(20.r)),
                                      child: !addressController.isCouponLoading
                                          ? !addressController.isCouponApplied
                                              ? Text(
                                                  languageController.languageData["Apply"] ?? "Apply",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(color: AppColors.whiteColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  languageController.languageData["Applied"] ?? "Applied",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(color: AppColors.whiteColor),
                                                  textAlign: TextAlign.center,
                                                )
                                          : Center(
                                              child: SizedBox(
                                                width: 21.w,
                                                height: 21.h,
                                                child: const CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0)),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 1.w,
                                    ),
                                  ),
                                  errorStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.redColor, fontSize: 12.sp),
                                  filled: true,
                                  fillColor: AppThemes.getFillColor(),
                                ),
                              ),
                              VSpace(10.h),
                              SizedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(languageController.languageData["Subtotal:"] ?? "Subtotal:"),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: addressController.discountAmount! > 0 &&
                                                    addressController.isCouponApplied
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${AppConstants.baseCurrency}${cartController.totalPrice.toStringAsFixed(2)}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(decoration: TextDecoration.lineThrough),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                          "${AppConstants.baseCurrency}${addressController.amountAfterDiscount!.toStringAsFixed(2)}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis)
                                                    ],
                                                  )
                                                : Text(
                                                    "${AppConstants.baseCurrency}${cartController.totalPrice.toStringAsFixed(2)}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(languageController.languageData["Discount:"] ?? "Discount:"),
                                        addressController.discountType != '%'
                                            ? Text(
                                                "${addressController.discountType}${addressController.discountAmount.toString()} ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(color: AppColors.redColor),
                                              )
                                            : Text(
                                                "${addressController.discountAmount.toString()}${addressController.discountType}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(color: AppColors.redColor),
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(languageController.languageData["Shipping Charge:"] ?? "Shipping Charge:"),
                                        Text(
                                          "${AppConstants.baseCurrency}${addressController.shippingCharge.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.greenColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(languageController.languageData["Vat:"] ?? "Vat:"),
                                        Text(
                                          "${addressController.vat.toString()}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.greenColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Text(languageController.languageData["Total:"] ?? "Total:",
                                            style: t.bodyLarge?.copyWith(fontSize: 18.sp)),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${AppConstants.baseCurrency}${addressController.totalAmount!.toStringAsFixed(2)}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodyLarge?.copyWith(fontSize: 18.sp),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              VSpace(10.h),
                              Material(
                                color: Colors.transparent,
                                child: AppButton(
                                  isLoading: addressController.isLoading,
                                  onTap: () {
                                    addressController.createOrder();
                                  },
                                  text: languageController.languageData['Continue'] ?? 'Continue',
                                ),
                              ),
                            ],
                          )
                        : Helpers.appLoader(color: AppColors.mainColor)),
              ],
            ),
          ),
        );
      });
    });
  }
}
