import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/themes/themes.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class TrackOrderScreen extends StatefulWidget {
  final String? img;
  final String? description;
  final String? price;
  const TrackOrderScreen({super.key, this.img, this.description, this.price});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: "Track Order"),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              SizedBox(
                height: 127.h,
                child: Row(
                  children: [
                    Container(
                      height: 127.h,
                      width: 127.h,
                      padding: EdgeInsets.all(16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppThemes.getFillColor(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: Image.network(
                          "${widget.img}",
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
                        Text("${widget.description}",
                            maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                        Container(
                          height: 38.h,
                          width: 112.w,
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              "Delivered",
                              style: t.bodyMedium?.copyWith(color: AppColors.greenColor),
                            ),
                          ),
                        ),
                        Text(
                          "${widget.price}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              VSpace(40.h),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: EdgeInsets.only(right: 13.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "$rootImageDir/box.png",
                        height: 24.h,
                        width: 24.h,
                        color: Get.isDarkMode ? AppColors.greenColor : AppColors.greenColor,
                      ),
                      Image.asset(
                        "$rootImageDir/dispatched.png",
                        height: 24.h,
                        width: 24.h,
                        color: Get.isDarkMode ? AppColors.black50 : AppColors.black30,
                      ),
                      Image.asset(
                        "$rootImageDir/delivery.png",
                        height: 24.h,
                        width: 24.h,
                        color: Get.isDarkMode ? AppColors.black50 : AppColors.black30,
                      ),
                      Image.asset(
                        "$rootImageDir/delivered.png",
                        height: 24.h,
                        width: 24.h,
                        color: Get.isDarkMode ? AppColors.black50 : AppColors.black30,
                      ),
                    ],
                  ),
                );
              }),
              VSpace(10.h),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: [
                    buildWidget(constraints, Get.isDarkMode ? AppColors.greenColor : AppColors.greenColor),
                    buildWidget(constraints, Get.isDarkMode ? AppColors.black50 : AppColors.black30),
                    buildWidget(constraints, Get.isDarkMode ? AppColors.black50 : AppColors.black30),
                    Container(
                      height: 16.h,
                      width: 16.h,
                      padding: EdgeInsets.all(2.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? AppColors.black50 : AppColors.black30,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Image.asset(
                        "$rootImageDir/tick.png",
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                );
              }),
              VSpace(40.h),
              Text("Track Order", style: t.bodyMedium?.copyWith(fontSize: 18.sp)),
              VSpace(18.h),
              trackOrder(t: t),
              trackOrder(
                t: t,
                title: "Order Confirm - ",
                date: "30 April 2024",
                description: "Order has been confirmed",
                color: AppColors.black50,
              ),
              trackOrder(
                t: t,
                title: "Processing Order - ",
                date: "1 May 2024",
                description: "Your order is being prepared.",
                color: AppColors.black50,
              ),
              trackOrder(
                t: t,
                title: "All Set to Ship - ",
                date: "5 May 2024",
                description: "Your order is prepared for delivery.",
                color: AppColors.black50,
              ),
              trackOrder(
                isDottedBorder: false,
                t: t,
                title: "All Set to Ship - ",
                date: "5 May 2024",
                description: "Your order is prepared for delivery.",
                color: AppColors.black50,
              ),
              VSpace(30.h),
            ],
          ),
        ),
      ),
    );
  }

  Row trackOrder(
      {required TextTheme t,
      String? title,
      String? date,
      String? time,
      String? description,
      bool? isDottedBorder = true,
      Color? color}) {
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
                    title ?? "Order Placed - ",
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(date ?? "29 April 2024",
                      style: t.displayMedium?.copyWith(
                        color: Get.isDarkMode ? AppColors.black20 : AppColors.blackColor,
                      )),
                ],
              ),
              VSpace(6.h),
              Text(
                description ?? "Received your order",
                style: t.displayMedium?.copyWith(
                  color: Get.isDarkMode ? AppColors.black20 : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Text(
            time ?? "9:41 PM",
            style: t.displayMedium?.copyWith(
              color: Get.isDarkMode ? AppColors.black20 : AppColors.blackColor,
            ),
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
              8,
              (index) => Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    height: index == 0 || index == 7 ? 2.h : 5.h,
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
