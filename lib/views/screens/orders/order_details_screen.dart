import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/order_controller.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final orderController = Get.put(OrderController());
  final languageController = Get.put(LanguageController());
  dynamic orderId = Get.arguments;

  @override
  void initState() {
    super.initState();
    orderController.fetchOrderDetails(orderId);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<OrderController>(builder: (orderController) {
      List<dynamic> orderStatuses = getOrderStatuses(context);
      List<Function> orderStatusImages = getOrderStatusImages();

      return Scaffold(
        appBar: CustomAppBar(title: languageController.languageData["Order Details"] ?? "Order Details"),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: orderController.isLoading
              ? ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
                  }))
              : orderController.orderDetails == null
                  ? NotFound(message: languageController.languageData["No orders found!"] ?? "No orders found!")
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            itemCount: orderController.orderDetails!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              var item = orderController.orderDetails![i];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
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
                                            item.menu.thumbnail,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(item.menu.details.title,
                                              maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                          SizedBox(height: 10.h),
                                          Text("Quantity: ${item.quantity}",
                                              maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                          SizedBox(height: 10.h),
                                          Text("Price: ${item.menu.showPrice}",
                                              maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          VSpace(40.h),
                          Text("Track Order", style: t.bodyMedium?.copyWith(fontSize: 18.sp)),
                          VSpace(24.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                orderStatusImages.length,
                                (i) {
                                  // Hide the specific status when statusLevel > 2 and i == 1
                                  if (orderController.statusLevel > 2 && i == 1) {
                                    return const SizedBox();
                                  }
                                  bool isActive = i <= orderController.statusLevel - 1;
                                  return Row(
                                    children: [
                                      orderStatusImages[i](isActive),
                                      if (i < orderStatusImages.length - 1)
                                        buildHorizontalTimelineWidget(
                                          isActive ? AppColors.greenColor : Colors.grey,
                                          isDottedBorder: i != orderStatusImages.length - 2,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          VSpace(40.h),
                          ListView.builder(
                            // itemCount: orderController.statusLevel,
                            itemCount: orderStatuses.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              if (orderController.statusLevel > 2 && i == 1) {
                                return const SizedBox();
                              }
                              Color statusColor =
                                  (i <= orderController.statusLevel - 1) ? AppColors.greenColor : AppColors.black50;
                              return orderStatuses[i](statusColor);
                            },
                          ),
                          VSpace(30.h),
                        ],
                      ),
                    ),
        ),
      );
    });
  }

  Widget buildHorizontalTimelineWidget(Color color, {bool isDottedBorder = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0), // Adjust margin between timeline and image
      height: 2.0, // Set the height of the timeline line
      width: 40.0, // Set the width (length) of the timeline line
      decoration: BoxDecoration(
        color: isDottedBorder ? Colors.transparent : color, // Solid color or transparent
        border: isDottedBorder
            ? Border(
                bottom: BorderSide(
                  color: color,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
              )
            : null, // Optional dotted effect
      ),
    );
  }

  List<Function> getOrderStatusImages() {
    return [
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/box.png"),
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/dispatched.png"),
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/order-placed.png"),
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/order-processing.png"),
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/delivery.png"),
      (bool isActive) => buildStatusImage(isActive, "$rootImageDir/delivered.png"),
    ];
  }

  Widget buildStatusImage(bool isActive, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Spacing between images
      child: Opacity(
        opacity: isActive ? 1.0 : 0.4, // Full opacity for active, faded for inactive
        child: Image.asset(
          imagePath,
          width: 32, // Set the image width to 32
          height: 32, // You can set a fixed height as well
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  List<dynamic> getOrderStatuses(BuildContext context) {
    return [
      (Color color) => trackOrder(
            t: Theme.of(context).textTheme,
            title: "Pending",
            date: "",
            description: "Your order is pending now.",
            color: color,
          ),
      (Color color) => trackOrder(
            t: Theme.of(context).textTheme,
            title: "Cancelled",
            date: "",
            description: "Your order is cancelled.",
            color: color,
          ),
      (Color color) => trackOrder(
            t: Theme.of(context).textTheme,
            title: "Order Placed",
            date: "",
            description: "We received your order.",
            color: color,
          ),
      (Color color) => trackOrder(
            t: Theme.of(context).textTheme,
            title: "Processing Order",
            date: "",
            description: "Your order is processing now.",
            color: color,
          ),
      (Color color) => trackOrder(
            t: Theme.of(context).textTheme,
            title: "Picked",
            date: "",
            description: "Order picked by delivery man",
            color: color,
          ),
      (Color color) => trackOrder(
            isDottedBorder: false,
            t: Theme.of(context).textTheme,
            title: "Delivered",
            date: "",
            description: "Your order is delivered.",
            color: color,
          ),
    ];
  }

  Widget trackOrder({
    required TextTheme t,
    String? title,
    String? date,
    String? time,
    String? description,
    bool? isDottedBorder = true,
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTimelineWidget(color ?? AppColors.greenColor, isDottedBorder: isDottedBorder),
        HSpace(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title ?? "", // Order Status
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    date ?? "", // date
                    style: t.displayMedium?.copyWith(
                      color: AppColors.mainColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              VSpace(6.h),
              Text(
                description ?? "", // description
                style: t.displayMedium?.copyWith(
                  color: Get.isDarkMode ? AppColors.black20 : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTimelineWidget(Color color, {bool? isDottedBorder = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 32.h,
          width: 32.h,
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "$rootImageDir/tick.png",
            color: AppColors.whiteColor,
          ),
        ),
        if (isDottedBorder == true) VSpace(4.h),
        if (isDottedBorder == true)
          ...List.generate(
              7,
              (index) => Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    height: index == 0 || index == 6 ? 2.h : 5.h,
                    width: 2,
                    color: color,
                  )),
      ],
    );
  }

  Row buildWidget(BoxConstraints constraints, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 16.h,
          width: 16.h,
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Image.asset(
            "$rootImageDir/tick.png",
            color: AppColors.whiteColor,
          ),
        ),
        HSpace(3.w),
        ...List.generate(
            (constraints.maxWidth / 25).floor(),
            (index) => Container(
                  margin: EdgeInsets.only(right: (constraints.maxWidth / 90)),
                  height: 1,
                  width:
                      index == 0 || index == (constraints.maxWidth / 25).floor() - 1 ? 1 : (constraints.maxWidth / 100),
                  color: color,
                )),
      ],
    );
  }
}
