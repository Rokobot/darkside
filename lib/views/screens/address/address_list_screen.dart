import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:food_app/views/widgets/shimmer_preloader.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_appbar.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final addressController = Get.put(AddressController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    addressController.fetchAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {
      TextTheme t = Theme.of(context).textTheme;
      return Scaffold(
        appBar: CustomAppBar(title: languageController.languageData['Address'] ?? 'Address'),
        body: RefreshIndicator(
          onRefresh: () async {
            addressController.fetchAddressList();
          },
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                child: addressController.isLoading
                    ? ListView.builder(
                        itemCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return Container(margin: EdgeInsets.only(bottom: 20.h), child: const ShimmerPreloader());
                        }))
                    : addressController.addressList == null || addressController.addressList!.isEmpty
                        ? SizedBox(
                            height: Get.height - 200.h,
                            child: NotFound(
                                message: languageController.languageData["No Address Found!"] ?? "No Address Found!"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addressController.addressList!.length,
                            itemBuilder: (context, i) {
                              var item = addressController.addressList![i];
                              return InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
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
                                          SizedBox(width: 10.w),
                                          InkWell(
                                            onTap: () {
                                              addressController.deleteAddress(item.id);
                                              // .then((value) {
                                              //   addressController.addressList!
                                              //       .removeWhere((item) => item.id == item.id);
                                              // });
                                            },
                                            child: Container(
                                              width: 40.w,
                                              height: 30.h,
                                              padding: EdgeInsets.all(6.h),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.redColor, width: .4),
                                                color: AppColors.redColor,
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                              child: Image.asset(
                                                "$rootImageDir/delete.png",
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
              )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Get.isDarkMode ? AppColors.blackColor : AppColors.mainColor,
          onPressed: () {
            Get.toNamed(RoutesName.createAddressScreen);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
        ),
      );
    });
  }
}
