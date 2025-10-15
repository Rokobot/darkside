import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/ticket_controller.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/custom_appbar.dart';

class SupportTicketViewScreen extends StatefulWidget {
  const SupportTicketViewScreen({super.key});

  @override
  State<SupportTicketViewScreen> createState() => _SupportTicketViewScreenState();
}

class _SupportTicketViewScreenState extends State<SupportTicketViewScreen> {
  final ticketController = Get.put(TicketController());
  dynamic ticketId = Get.arguments;

  @override
  void initState() {
    ticketController.fetchTicketDetails(ticketId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
      appBar: CustomAppBar(
        bgColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
        title: "Ticket #$ticketId",
        actions: [
          InkWell(
            onTap: () {
              buildLogoutDialog(context, t);
            },
            child: Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Icon(
                  CupertinoIcons.clear_thick_circled,
                  color: AppColors.mainColor,
                  size: 30.sp,
                )),
          )
        ],
      ),
      body: GetBuilder<TicketController>(builder: (ticketController) {
        if (ticketController.isScreenLoading) {
          return Center(child: Helpers.appLoader());
        }
        if (ticketController.ticketDetails == null) {
          return const NotFound(message: "No data found!");
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppThemes.borderColor()))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  reverse: true,
                  itemCount: ticketController.ticketDetails!.messages.length,
                  itemBuilder: (context, index) {
                    var message = ticketController.ticketDetails!.messages[index];
                    return Column(
                      crossAxisAlignment: message.adminId == null ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              // isVisible = !isVisible;
                              // selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(110.w),
                              color:
                                  message.adminId == null ? AppColors.mainColor : AppColors.mainColor.withOpacity(.2),
                            ),
                            child: Text(
                              message.message,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: message.adminId == null ? AppColors.whiteColor : AppColors.blackColor,
                                  ),
                              textAlign: message.adminId == null ? TextAlign.left : TextAlign.right,
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            message.attachments.length,
                            (index) {
                              var attachment = message.attachments[index];
                              return InkWell(
                                onTap: () {
                                  ticketController.downloadFile(
                                    attachment,
                                    "File ${index + 1}",
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenColor,
                                    borderRadius: BorderRadius.circular(110.w),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cloud_download,
                                        color: AppColors.whiteColor,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text("File ${index + 1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.whiteColor)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Visibility(
                        //   visible: selectedIndex == index,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 6.h),
                        //     child: Text(
                        //       selectedIndex == index
                        //           ? changeDateFormat(message.createdAt.substring(0, 10))
                        //           : "",
                        //       style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12.sp),
                        //     ),
                        //   ),
                        // )
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(24.w),
                          ),
                          child: InkWell(
                            onTap: ticketController.pickFiles,
                            child: Icon(
                              CupertinoIcons.link,
                              color: AppColors.mainColor,
                              size: 22,
                            ),
                          ),
                        ),
                        ticketController.selectedFiles.isNotEmpty
                            ? Positioned(
                                child: Container(
                                  width: 15.r,
                                  height: 15.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    ticketController.selectedFiles.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.whiteColor, fontSize: 10.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const Text(""),
                      ],
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppThemes.getFillColor(),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                    color: AppThemes.getFillColor(), borderRadius: BorderRadius.circular(50)),
                                child: TextField(
                                  controller: ticketController.messageController,
                                  onSubmitted: (value) async {
                                    if (ticketController.messageController.text != '') {
                                      await ticketController.replyTicket(ticketController.ticketDetails!.id, ticketId);
                                    }
                                  },
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration.collapsed(
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    hintText: 'Message...',
                                  ),
                                ),
                              ),
                            ),
                            ticketController.isLoading
                                ? Helpers.appLoader()
                                : IconButton(
                                    icon: Icon(Icons.send, color: AppColors.whiteColor, size: 18.sp),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(AppColors.mainColor),
                                      padding: WidgetStatePropertyAll(EdgeInsets.all(12.w)),
                                    ),
                                    onPressed: () async {
                                      if (ticketController.messageController.text != '') {
                                        await ticketController.replyTicket(
                                            ticketController.ticketDetails!.id, ticketId);
                                      }
                                    },
                                  ),
                            SizedBox(width: 4.w),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<dynamic> buildLogoutDialog(BuildContext context, TextTheme t) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Close Ticket",
            style: t.bodyLarge?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            "Do you want to close the ticket?",
            style: t.bodyMedium,
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "No",
                  style: t.bodyLarge,
                )),
            MaterialButton(
                onPressed: () async {
                  await ticketController.closeTicket(ticketController.ticketDetails!.id);
                  Get.back();
                },
                child: Text(
                  "Yes",
                  style: t.bodyLarge,
                )),
          ],
        );
      },
    );
  }
}
