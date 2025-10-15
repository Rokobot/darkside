import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/bindings/controller_index.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../widgets/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isClearAll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        actions: [
          GestureDetector(
            onTap: () {
              isClearAll = true;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: 20.w,
              ),
              child: Container(
                height: 25.h,
                width: 80.w,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text("Clear All", style: context.t.displayMedium?.copyWith(fontSize: 13.sp)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            isClearAll
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Get.isDarkMode
                              ? "assets/images/no_notification_dark.png"
                              : "assets/images/no_notification.png",
                          height: 258,
                          width: 226.w,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text("No Notifications Yet", style: context.t.bodyLarge),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Text("You have no notification right now. Come back later",
                              textAlign: TextAlign.center, style: context.t.displayMedium),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {},
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: AppColors.redColor,
                              padding: EdgeInsets.only(right: 20.w),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: AppColors.mainColor,
                                  width: Dimensions.appThinBorder,
                                ),
                              ),
                              child: ListTile(
                                onTap: () {},
                                leading: Container(
                                  padding: EdgeInsets.all(6.h),
                                  height: 35.h,
                                  width: 35.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.mainColor,
                                  ),
                                  child: Image.asset(
                                    "assets/images/notification_icon_new.png",
                                  ),
                                ),
                                title: Text(
                                  "Message",
                                  style: context.t.bodySmall,
                                ),
                                subtitle: Text(
                                  "Admin Replied: Ticket(#98394839434)",
                                  style: context.t.bodySmall?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppThemes.getGreyColor(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
