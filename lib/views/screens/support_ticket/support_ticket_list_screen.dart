import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/ticket_controller.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class SupportTicketListScreen extends StatefulWidget {
  const SupportTicketListScreen({super.key});

  @override
  State<SupportTicketListScreen> createState() => _SupportTicketListScreenState();
}

class _SupportTicketListScreenState extends State<SupportTicketListScreen> {
  final ticketController = Get.put(TicketController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    ticketController.fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<TicketController>(builder: (ticketController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: languageController.languageData['Support Ticket'] ?? "Support Ticket",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            await ticketController.fetchTickets();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(25.h),
                  ticketController.isScreenLoading
                      ? ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
                          }))
                      : ticketController.supportTickets == null || ticketController.supportTickets!.isEmpty
                          ? SizedBox(
                              height: 700.h,
                              child: NotFound(
                                  message: languageController.languageData["No tickets found!"] ?? "No tickets found!"))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ticketController.supportTickets!.length,
                              itemBuilder: (context, i) {
                                var item = ticketController.supportTickets![i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onTap: () =>
                                        Get.toNamed(RoutesName.supportTicketViewScreen, arguments: item.ticket),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Ink(
                                          height: 108.h,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? AppColors.darkCardColor
                                                : AppColors.mainColor.withOpacity(.1),
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: AppColors.mainColor,
                                              width: Dimensions.appThinBorder,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 58.h,
                                                height: 58.h,
                                                margin: EdgeInsets.only(left: 15.w),
                                                padding: EdgeInsets.all(15.h),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  checkStatusIcon(int.tryParse(item.status.toString())),
                                                  width: 28.w,
                                                  height: 26.h,
                                                ),
                                              ),
                                              HSpace(Dimensions.screenWidth * .1),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      item.subject,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.clip,
                                                      style: t.displayMedium,
                                                    ),
                                                    VSpace(16.h),
                                                    RichText(
                                                        text: TextSpan(children: [
                                                      TextSpan(
                                                        text: languageController.languageData['Last reply'] ??
                                                            "Last reply: ",
                                                        style: t.displayMedium?.copyWith(
                                                            color:
                                                                Get.isDarkMode ? AppColors.black30 : AppColors.black50),
                                                      ),
                                                      TextSpan(
                                                          text: Utils.changeDateFormat(item.lastReply),
                                                          style: t.displayMedium),
                                                    ]))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: Dimensions.screenWidth * .17,
                                          top: -13.h,
                                          child: Container(
                                            height: 33.h,
                                            width: 33.h,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.whiteColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            left: Dimensions.screenWidth * .205,
                                            bottom: -13.h,
                                            child: SizedBox(
                                              height: 102.h,
                                              child: const DottedLine(
                                                dashColor: AppColors.black20,
                                                direction: Axis.vertical,
                                              ),
                                            )),
                                        Positioned(
                                          left: Dimensions.screenWidth * .17,
                                          bottom: -13.h,
                                          child: Container(
                                            height: 33.h,
                                            width: 33.h,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.whiteColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Get.isDarkMode ? AppColors.blackColor : AppColors.mainColor,
          onPressed: () {
            Get.toNamed(RoutesName.createSupportTicketScreen);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
        ),
      );
    });
  }

  checkStatusIcon(dynamic status) {
    if (status == 3) {
      return "$rootImageDir/closed.png";
    } else if (status == 1 || status == 2) {
      return "$rootImageDir/replied.png";
    } else if (status == 0) {
      return "$rootImageDir/open.png";
    }
  }
}
