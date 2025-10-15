import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/order_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final orderController = Get.put(OrderController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<OrderController>(builder: (orderController) {
      return Scaffold(
        appBar: CustomAppBar(title: languageController.languageData["My Orders"] ?? "My Orders"),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              orderController.isLoading
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
                          })),
                    )
                  : orderController.orders == null || orderController.orders!.isEmpty
                      ? Expanded(
                          child: NotFound(
                              message: languageController.languageData["No orders found!"] ?? "No orders found!"))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: orderController.orders!.length,
                              itemBuilder: (context, i) {
                                var item = orderController.orders![i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onTap: () {
                                      Get.toNamed(RoutesName.orderDetailsScreen, arguments: item.id);
                                    },
                                    child: SizedBox(
                                      height: 110.h,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 110.h,
                                            width: 110.h,
                                            padding: EdgeInsets.all(12.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r),
                                              color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4.r),
                                              child: Image.network(
                                                item.image,
                                                height: 70.h,
                                                width: 70.h,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          HSpace(16.w),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Order ${item.orderNumber}",
                                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                              Container(
                                                height: 30.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                  color: item.foodStatus.toLowerCase() == "pending"
                                                      ? AppColors.mainColor.withOpacity(.05)
                                                      : AppColors.greenColor.withOpacity(.05),
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.foodStatus,
                                                    style: t.bodyMedium?.copyWith(
                                                        fontSize: 12.sp,
                                                        color: item.foodStatus.toLowerCase() == "pending"
                                                            ? AppColors.mainColor
                                                            : AppColors.greenColor),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.showTotal,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                  item.foodStatus.toLowerCase() == "picked up" ||
                                                          item.foodStatus.toLowerCase() == "delivered" ||
                                                          item.foodStatus.toLowerCase() == "arrive" ||
                                                          item.foodStatus.toLowerCase() == "peek up"
                                                      ? InkWell(
                                                          borderRadius: BorderRadius.circular(8.r),
                                                          onTap: () {
                                                            Get.toNamed(RoutesName.orderChatScreen, arguments: item.id);
                                                          },
                                                          child: Container(
                                                            height: 36.h,
                                                            width: 36.w,
                                                            padding: EdgeInsets.all(8.r),
                                                            decoration: BoxDecoration(
                                                              color: AppColors.mainColor.withOpacity(.2),
                                                              borderRadius: BorderRadius.circular(8.r),
                                                            ),
                                                            child: Image.asset(
                                                              "$rootImageDir/chat.png",
                                                              height: 15.h,
                                                              width: 15.h,
                                                              fit: BoxFit.fitWidth,
                                                              color: AppThemes.getIconBlackColor(),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  SizedBox(width: 10.w),
                                                  InkWell(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    onTap: () {
                                                      Get.toNamed(RoutesName.orderDetailsScreen, arguments: item.id);
                                                    },
                                                    child: Container(
                                                      height: 36.h,
                                                      width: 36.w,
                                                      padding: EdgeInsets.all(8.r),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.mainColor.withOpacity(.2),
                                                        borderRadius: BorderRadius.circular(8.r),
                                                      ),
                                                      child: Image.asset(
                                                        "$rootImageDir/eye.png",
                                                        height: 15.h,
                                                        width: 15.h,
                                                        fit: BoxFit.fitWidth,
                                                        color: AppThemes.getIconBlackColor(),
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
                              }))
            ],
          ),
        ),
      );
    });
  }
}
