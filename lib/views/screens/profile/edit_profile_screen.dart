import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/not_found.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final profileController = Get.put(ProfileController());
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    profileController.fetchUserData();
  }

  @override
  void dispose() {
    Get.delete<ProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appController) {
      return GetBuilder<LanguageController>(builder: (languageController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return Scaffold(
            appBar: CustomAppBar(title: languageController.getStoredData()["Edit Profile"] ?? "Edit Profile"),
            body: profileController.isLoading
                ? Center(child: Helpers.appLoader())
                : profileController.userData == null
                    ? NotFound(message: languageController.getStoredData()["Data not found!"] ?? "Data not found!")
                    : RefreshIndicator(
                        color: AppColors.mainColor,
                        onRefresh: profileController.fetchUserData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Dimensions.screenHeight * .1,
                              ),
                              Container(
                                height: Dimensions.screenHeight,
                                width: double.maxFinite,
                                padding: Dimensions.kDefaultPadding,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: -Dimensions.screenHeight * .07,
                                      child: Container(
                                        height: 110.r,
                                        width: 110.r,
                                        alignment: Alignment.bottomRight,
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24.r),
                                                  border: Border.all(
                                                    color:
                                                        Get.isDarkMode ? AppColors.darkCardColor : AppColors.mainColor,
                                                    width: 2.h,
                                                  ),
                                                  color: AppColors.imageBgColor,
                                                  image: DecorationImage(
                                                    image: NetworkImage(profileController.userData!.image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(22.r),
                                                  child: profileController.pickedUserImage == null
                                                      ? Image.network(
                                                          profileController.userData!.image,
                                                          height: 110.r,
                                                          width: 110.r,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          profileController.pickedUserImage!,
                                                          height: 110.r,
                                                          width: 110.r,
                                                          fit: BoxFit.cover,
                                                        ),
                                                )),
                                            Positioned(
                                              bottom: -9.h,
                                              right: -8.w,
                                              child: InkResponse(
                                                onTap: profileController.pickImage,
                                                child: Container(
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: AppColors.whiteColor,
                                                    size: 20.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        VSpace(70.h),
                                        Text(languageController.getStoredData()["First Name"] ?? "First Name",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        CustomTextField(
                                          height: 50.h,
                                          hintext: languageController.getStoredData()["Enter First Name"] ??
                                              "Enter First Name",
                                          controller: profileController.firstnameController,
                                          contentPadding: EdgeInsets.only(left: 20.w),
                                        ),
                                        VSpace(24.h),
                                        Text(languageController.getStoredData()["Last Name"] ?? "Last Name",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        CustomTextField(
                                          height: 50.h,
                                          hintext: languageController.getStoredData()["Enter Last Name"] ??
                                              "Enter Last Name",
                                          controller: profileController.lastnameController,
                                          contentPadding: EdgeInsets.only(left: 20.w),
                                        ),
                                        VSpace(24.h),
                                        Text(languageController.getStoredData()["Username"] ?? "Username",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        CustomTextField(
                                          height: 50.h,
                                          hintext: languageController.getStoredData()["Username"] ?? "Username",
                                          controller: profileController.usernameController,
                                          contentPadding: EdgeInsets.only(left: 20.w),
                                        ),
                                        VSpace(24.h),
                                        Text(languageController.getStoredData()["Email"] ?? "Email",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        CustomTextField(
                                          height: 50.h,
                                          hintext: languageController.getStoredData()["Email"] ?? "Email",
                                          controller: profileController.emailController,
                                          contentPadding: EdgeInsets.only(left: 20.w),
                                        ),
                                        VSpace(24.h),
                                        Text(languageController.getStoredData()["Phone Number"] ?? "Phone Number",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        Row(
                                          children: [
                                            Container(
                                              height: Dimensions.textFieldHeight,
                                              decoration: BoxDecoration(
                                                color: AppThemes.getFillColor(),
                                                borderRadius: Dimensions.kBorderRadius,
                                                border: Border.all(
                                                    color: AppThemes.borderColor(), width: Dimensions.appThinBorder),
                                              ),
                                              child: CountryCodePicker(
                                                padding: EdgeInsets.zero,
                                                dialogBackgroundColor: AppThemes.getDarkCardColor(),
                                                dialogTextStyle: t.bodyMedium?.copyWith(fontSize: 14.sp),
                                                flagWidth: 29.w,
                                                textStyle: t.bodySmall,
                                                onChanged: (CountryCode countryCode) {
                                                  profileController.countryCodeController.text = countryCode.code!;
                                                  profileController.phoneCodeController.text = countryCode.dialCode!;
                                                },
                                                initialSelection: profileController.countryCodeController.text,
                                                showCountryOnly: false,
                                                showOnlyCountryWhenClosed: false,
                                                alignLeft: false,
                                              ),
                                            ),
                                            HSpace(16.w),
                                            Expanded(
                                              child: CustomTextField(
                                                hintext: languageController.getStoredData()["Phone Number"] ??
                                                    "Phone Number",
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                                controller: profileController.phoneNumberController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return languageController
                                                            .getStoredData()['Please enter phone number'] ??
                                                        'Please enter phone number';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        VSpace(24.h),
                                        Text(languageController.getStoredData()["Address"] ?? "Address",
                                            style: t.displayMedium),
                                        VSpace(10.h),
                                        CustomTextField(
                                          height: 50.h,
                                          hintext: languageController.getStoredData()["Address"] ?? "Address",
                                          controller: profileController.addressController,
                                          contentPadding: EdgeInsets.only(left: 20.w),
                                        ),
                                        VSpace(24.h),
                                        Text(
                                            languageController.getStoredData()["Preferred Language"] ??
                                                "Preferred Language",
                                            style: t.displayMedium),
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
                                              return languageController.getStoredData()['Please select language'] ??
                                                  'Please select language';
                                            }
                                            return null;
                                          },
                                          value: profileController.selectedLanguage,
                                          items: profileController.languages!
                                              .asMap()
                                              .map((index, language) => MapEntry(
                                                    index,
                                                    DropdownMenuItem<String>(
                                                      value: language.name,
                                                      child: Text(
                                                        language.name,
                                                        style: t.bodyMedium,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ))
                                              .values
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              profileController.selectedLanguage = value;
                                              profileController.selectedLanguageIndex = profileController.languages!
                                                      .indexWhere((language) => language.name == value) +
                                                  1;
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
                                        Material(
                                          color: Colors.transparent,
                                          child: AppButton(
                                            isLoading: profileController.isLoading,
                                            onTap: () {
                                              profileController.updateProfile();
                                            },
                                            text: languageController.getStoredData()['Update Profile'] ??
                                                'Update Profile',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        });
      });
    });
  }

  // Future<dynamic> showbottomsheet(BuildContext context, storedLanguage) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return GetBuilder<AppController>(builder: (_) {
  //         return GetBuilder<ProfileController>(builder: (profileController) {
  //           return SizedBox(
  //             height: context.mQuery.height * 0.2,
  //             width: double.infinity,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 SizedBox(height: 10.h),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Get.back();
  //                     profileController.pickImage(ImageSource.camera);
  //                   },
  //                   child: Container(
  //                     height: 80.h,
  //                     width: 150.w,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(5),
  //                         color: AppThemes.getDarkBgColor(),
  //                         border: Border.all(color: AppColors.mainColor, width: .2)),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.camera_alt,
  //                           size: 35.h,
  //                           color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
  //                         ),
  //                         Text(
  //                           storedLanguage['Pick from Camera'] ?? 'Pick from Camera',
  //                           style: context.t.bodySmall?.copyWith(color: AppThemes.getIconBlackColor()),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 10.w),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Get.back();
  //                     profileController.pickImage(ImageSource.gallery);
  //                   },
  //                   child: Container(
  //                     height: 80.h,
  //                     width: 150.w,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(5),
  //                         color: AppThemes.getDarkBgColor(),
  //                         border: Border.all(color: AppColors.mainColor, width: .2)),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.camera,
  //                           size: 35.h,
  //                           color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50,
  //                         ),
  //                         Text(
  //                           storedLanguage['Pick from Gallery'] ?? 'Pick from Gallery',
  //                           style: context.t.bodySmall?.copyWith(color: AppThemes.getIconBlackColor()),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  //       });
  //     },
  //   );
  // }
}
