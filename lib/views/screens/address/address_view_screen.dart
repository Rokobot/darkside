import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class AddressViewScreen extends StatefulWidget {
  const AddressViewScreen({super.key});

  @override
  State<AddressViewScreen> createState() => _AddressViewScreenState();
}

class _AddressViewScreenState extends State<AddressViewScreen> {
  final addressController = Get.put(AddressController());
  final languageController = Get.put(LanguageController());
  dynamic addressId = Get.arguments;

  @override
  void initState() {
    super.initState();
    addressController.fetchAddressView(addressId);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AddressController>(builder: (addressController) {
      return Scaffold(
        appBar: CustomAppBar(title: languageController.languageData["Edit Address"] ?? "Edit Address"),
        body: addressController.isLoading
            ? Center(child: Helpers.appLoader())
            : addressController.addressView == null
                ? NotFound(message: languageController.languageData["Address not found!"] ?? "Address not found!")
                : RefreshIndicator(
                    color: AppColors.mainColor,
                    onRefresh: () async {
                      addressController.fetchAddressView(addressId);
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.w),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(languageController.languageData["Address Name"] ?? "Address Name",
                              style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            height: 50.h,
                            hintext: languageController.languageData["Address Name"] ?? "Address Name",
                            controller: addressController.addressNameController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["First Name"] ?? "First Name", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            height: 50.h,
                            hintext: languageController.languageData["Enter First Name"] ?? "Enter First Name",
                            controller: addressController.firstnameController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Last Name"] ?? "Last Name", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            height: 50.h,
                            hintext: languageController.languageData["Enter Last Name"] ?? "Enter Last Name",
                            controller: addressController.lastnameController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Email"] ?? "Email", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            height: 50.h,
                            hintext: languageController.languageData["Email"] ?? "Email",
                            controller: addressController.emailController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Phone Number"] ?? "Phone Number",
                              style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            hintext: languageController.languageData["Phone Number"] ?? "Phone Number",
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: addressController.phoneNumberController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Country"] ?? "Country", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            hintext: languageController.languageData["Country Name"] ?? "Country Name",
                            controller: addressController.countryController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["City"] ?? "City", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            hintext: languageController.languageData["City Name"] ?? "City Name",
                            controller: addressController.cityController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Area"] ?? "Area", style: t.displayMedium),
                          VSpace(10.h),
                          DropdownButtonFormField2<String>(
                            isExpanded: true,
                            style: t.bodyMedium,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.r),
                                borderSide: BorderSide(
                                  color: AppColors.mainColor,
                                  width: 1.w,
                                ),
                              ),
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.redColor, fontSize: 12.sp),
                              filled: true,
                              fillColor: AppThemes.getFillColor(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return languageController.languageData['Please select area'] ?? 'Please select area';
                              }
                              return null;
                            },
                            value: addressController.selectedAreaName,
                            items: addressController.areaList!
                                .asMap()
                                .map((index, language) => MapEntry(
                                      index,
                                      DropdownMenuItem<String>(
                                        value: language.areaName,
                                        child: Text(
                                          language.areaName,
                                          style: t.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .values
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                addressController.selectedAreaName = value;

                                var selectedArea =
                                    addressController.areaList!.firstWhere((area) => area.areaName == value);
                                addressController.selectedAreaIndex = selectedArea.id;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.all(0.w),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(
                                CupertinoIcons.chevron_down,
                                color: AppThemes.getIconBlackColor(),
                              ),
                              iconSize: 18.sp,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.w),
                                color: AppThemes.getFillColor(),
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all(3),
                                thumbVisibility: WidgetStateProperty.all(true),
                                thumbColor: const WidgetStatePropertyAll(AppColors.borderColor),
                              ),
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              padding: EdgeInsets.only(left: 14.w),
                            ),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Zip Code"] ?? "Zip Code", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            hintext: languageController.languageData["Zip Code"] ?? "Zip Code",
                            controller: addressController.zipController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Text(languageController.languageData["Address"] ?? "Address", style: t.displayMedium),
                          VSpace(10.h),
                          CustomTextField(
                            hintext: languageController.languageData["Address"] ?? "Address",
                            controller: addressController.addressController,
                            contentPadding: EdgeInsets.only(left: 20.w),
                          ),
                          VSpace(24.h),
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading: addressController.isLoading,
                              onTap: () => addressController.updateAddress(addressId),
                              text: languageController.languageData['Update Address'] ?? 'Update Address',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      );
    });
  }
}
