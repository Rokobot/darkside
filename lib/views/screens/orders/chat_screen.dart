import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/chat_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/custom_appbar.dart';

class OrderChatScreen extends StatefulWidget {
  const OrderChatScreen({super.key});

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  final chatController = Get.put(ChatController());
  final languageController = Get.put(LanguageController());
  dynamic orderId = Get.arguments;

  @override
  void initState() {
    chatController.fetchChatDetails(orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
      appBar: CustomAppBar(
        bgColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
        title: "Chat #$orderId",
      ),
      body: GetBuilder<ChatController>(builder: (chatController) {
        return Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppThemes.borderColor()))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              chatController.isScreenLoading
                  ? Flexible(child: Center(child: Helpers.appLoader()))
                  : chatController.chatDetails.isEmpty
                      ? Flexible(
                          child: NotFound(
                              message: languageController.languageData["No messages yet!"] ?? "No messages yet!"))
                      : Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            itemCount: chatController.chatDetails.length,
                            itemBuilder: (context, index) {
                              var message = chatController.chatDetails[index];
                              return Column(
                                crossAxisAlignment: message.chatableType == "App\\Models\\User"
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
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
                                        color: message.chatableType == "App\\Models\\User"
                                            ? AppColors.mainColor
                                            : AppColors.mainColor.withOpacity(.2),
                                      ),
                                      child: Text(
                                        message.description,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: message.chatableType == "App\\Models\\User"
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor,
                                            ),
                                        textAlign: message.chatableType == "App\\Models\\User"
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                    ),
                                  ), // Visibility(
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
                                  controller: chatController.messageController,
                                  onSubmitted: (value) async {
                                    if (chatController.messageController.text != '') {
                                      await chatController.replyChat(orderId);
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
                            chatController.isLoading
                                ? Helpers.appLoader()
                                : IconButton(
                                    icon: Icon(Icons.send, color: AppColors.whiteColor, size: 18.sp),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(AppColors.mainColor),
                                      padding: WidgetStatePropertyAll(EdgeInsets.all(12.w)),
                                    ),
                                    onPressed: () async {
                                      if (chatController.messageController.text != '') {
                                        await chatController.replyChat(orderId);
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
}
