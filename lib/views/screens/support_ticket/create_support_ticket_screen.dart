import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/ticket_controller.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class CreateSupportTicketScreen extends StatefulWidget {
  const CreateSupportTicketScreen({super.key});

  @override
  State<CreateSupportTicketScreen> createState() => _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState extends State<CreateSupportTicketScreen> {
  final ticketController = Get.put(TicketController());
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(builder: (ticketController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: languageController.languageData['Create Ticket'] ?? "Create Ticket",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languageController.languageData['Subject'] ?? "Subject", style: context.t.displayMedium),
                VSpace(12.h),
                CustomTextField(
                  bgColor: AppThemes.getFillColor(),
                  controller: ticketController.subjectController,
                  contentPadding: EdgeInsets.only(left: 20.w),
                  hintext: languageController.languageData['Enter Subject'] ?? "Enter Subject",
                  isPrefixIcon: false,
                ),
                VSpace(25.h),
                Text(languageController.languageData['Message'] ?? "Message", style: context.t.displayMedium),
                VSpace(12.h),
                CustomTextField(
                  height: 132.h,
                  contentPadding: EdgeInsets.only(left: 20.w, bottom: 0.h, top: 10.h),
                  alignment: Alignment.topLeft,
                  minLines: 3,
                  maxLines: 5,
                  bgColor: AppThemes.getFillColor(),
                  controller: ticketController.messageController,
                  hintext: languageController.languageData['Enter Message'] ?? "Enter Message",
                  isPrefixIcon: false,
                ),
                VSpace(32.h),
                DottedBorder(
                  dashPattern: const [8, 4],
                  strokeWidth: 1.w,
                  strokeCap: StrokeCap.round,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10.w),
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(color: AppThemes.getFillColor(), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ticketController.selectedFiles.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.all(0.w),
                                shrinkWrap: true,
                                itemCount: ticketController.selectedFiles.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    padding: EdgeInsets.only(left: 15.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.mainColor.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(8.r)),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0.w),
                                      dense: true,
                                      title: Text(
                                        ticketController.selectedFiles[index].path.split('/').last,
                                        style: Theme.of(context).textTheme.bodySmall,
                                        maxLines: 1,
                                      ),
                                      trailing: IconButton(
                                        onPressed: () => ticketController.removeFile(index),
                                        icon: const Icon(
                                          CupertinoIcons.xmark,
                                          color: AppColors.redColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/images/drop.png",
                                color: AppColors.mainColor,
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                            onPressed: ticketController.pickFiles,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150.w, 35.h),
                              backgroundColor: AppColors.mainColor,
                              foregroundColor: Colors.white,
                              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                            ),
                            child: Text(languageController.languageData["Choose files"] ?? "Choose files")),
                      ],
                    ),
                  ),
                ),
                VSpace(40.h),
                AppButton(
                  text: languageController.languageData['Submit'] ?? "Submit",
                  isLoading: false,
                  onTap: () {
                    // if (ticketController.formKey.currentState!.validate()) {
                    ticketController.createTicket();
                    // }
                  },
                ),
                VSpace(40.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
