import 'dart:io';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/payment_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ManualPaymentScreen extends StatefulWidget {
  const ManualPaymentScreen({super.key});

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  // final sdkPaymentController = Get.put(SdkPaymentController());
  final paymentController = Get.put(PaymentController());
  // final cartController = Get.put(CartController());
  // final addressController = Get.put(AddressController());
  final languageController = Get.put(LanguageController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController searchCurrencyController = TextEditingController();

  // Filter the gateways based on the search text
  // TextEditingController searchController = TextEditingController();
  // void onSearchTextChanged(String text) {
  //   setState(() {
  //     if (paymentController.gateways.isNotEmpty) {
  //       paymentController.filteredGateways = paymentController.gateways.where((gateway) {
  //         return gateway['code'].toLowerCase().contains(text.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

  // dynamic orderId = Get.arguments;

  // @override
  // void initState() {
  //   super.initState();
  //   paymentController.fetchPaymentMethods();
  // }

  // @override
  // void dispose() {
  //   Get.delete<PaymentController>();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (paymentController) {
      return GetBuilder<CartController>(builder: (cartController) {
        return GetBuilder<AddressController>(builder: (addressController) {
          return Scaffold(
            appBar: CustomAppBar(title: languageController.languageData["Account Details"] ?? "Account Details"),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(20.w),
                      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppThemes.borderColor(),
                          width: 1.w,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var fieldName in paymentController.selectedGateway['parameters'].entries)
                              buildFormField(fieldName.key),
                            SizedBox(height: 10.h),
                            Material(
                              color: Colors.transparent,
                              child: AppButton(
                                isLoading: paymentController.isLoading,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // await paymentController.submitPaymentRequest(orderId, true);
                                    paymentController.submitManualPayment();
                                  }
                                },
                                text: languageController.languageData['Make Payment'] ?? 'Make Payment',
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
      });
    });
  }

  Widget buildFormField(dynamic fieldName) {
    var field = paymentController.selectedGateway['parameters'][fieldName] as Map<String, dynamic>;
    TextEditingController controller = paymentController.textControllers[fieldName]!;

    if (field['type'] == 'file') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(color: AppThemes.getFillColor(), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.r),
                  child: paymentController.pickedFiles[fieldName] == null
                      ? Image.asset(
                          "assets/images/drop.png",
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          color: AppColors.mainColor,
                        )
                      : Image.file(
                          paymentController.pickedFiles[fieldName]!,
                          width: 120.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          paymentController.pickedFiles[fieldName] = File(pickedFile.path);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(135.w, 35.h),
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    child: const Text("Choose file")),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    } else if (field['type'] == 'date') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                final formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
            readOnly: true,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(14.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide(
                  color: AppColors.mainColor,
                  width: 1.w,
                ),
              ),
              errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.redColor, fontSize: 12.sp),
              filled: true,
              fillColor: AppThemes.getFillColor(),
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 5.h),
          TextFormField(
            controller: controller,
            maxLines: field['type'] == 'textarea' ? 3 : 1,
            keyboardType: _getKeyboardType(field['type']),
            validator: (value) {
              if (field['validation'] == 'required' && value!.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(14.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: BorderSide(
                  color: AppColors.mainColor,
                  width: 1.w,
                ),
              ),
              errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.redColor, fontSize: 12.sp),
              filled: true,
              fillColor: AppThemes.getFillColor(),
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    }
  }

  TextInputType _getKeyboardType(String fieldType) {
    switch (fieldType) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}

enum PaymentMethod { cashOnDelivery, onlinePayment }
