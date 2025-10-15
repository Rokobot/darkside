import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/config/dimensions.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/transaction_controller.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';

class TransactionScreen extends StatefulWidget {
  final bool? isFromBottomNav;
  const TransactionScreen({super.key, this.isFromBottomNav = false});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final transactionController = Get.put(TransactionController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    transactionController.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: languageController.languageData["Transactions"] ?? "Transactions"),
      body: GetBuilder<TransactionController>(builder: (transactionController) {
        if (transactionController.isLoading) {
          return ListView.builder(
              itemCount: 7,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
              }));
        }
        if (transactionController.transactionList == null || transactionController.transactionList!.isEmpty) {
          return NotFound(
              message: languageController.languageData["No transactions found!"] ?? "No transactions found!");
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: transactionController.transactionList!.length,
          itemBuilder: (context, index) {
            var item = transactionController.transactionList![index];
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mainColor,
                  width: Dimensions.appThinBorder,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                title: Container(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Text(
                    item.trxId,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
                    maxLines: 1,
                  ),
                ),
                subtitle: Text(
                  item.remarks,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.amount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item.createdAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
