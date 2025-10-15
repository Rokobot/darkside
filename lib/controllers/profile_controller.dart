import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/models/dashboard_model.dart';
import 'package:food_app/models/profile_model.dart';
import 'package:food_app/repositories/profile_repo.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final formkey = GlobalKey<FormState>();
  final registerFormkey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneCodeController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ProfileRepository _profileRepository = ProfileRepository();
  bool isLoading = false;
  ProfileModel? userData;
  DashboardModel? dashboardData;
  List<LanguageModel>? languages;
  String? selectedLanguage;
  int? selectedLanguageIndex;
  File? pickedUserImage;

  late LanguageController languageController;
  @override
  void onInit() {
    super.onInit();
    languageController = Get.put(LanguageController());
  }

  Future<void> fetchUserData() async {
    isLoading = true;
    try {
      final response = await _profileRepository.fetchUserData();
      if (response['status'] == 'success') {
        final data = response['data'];
        userData = ProfileModel.fromJson(data['profile']);

        firstnameController.text = userData!.firstname ?? "";
        lastnameController.text = userData!.lastname ?? "";
        usernameController.text = userData!.username ?? "";
        emailController.text = userData!.email ?? "";
        phoneNumberController.text = userData!.phone ?? "";
        phoneCodeController.text = userData!.phoneCode ?? "";
        countryCodeController.text = userData!.countryCode ?? "";
        countryController.text = userData!.country ?? "";
        addressController.text = userData!.address ?? "";

        languages = List<LanguageModel>.from(data['languages'].map((i) => LanguageModel.fromJson(i)));
        selectedLanguageIndex = int.tryParse(userData!.languageId);
        selectedLanguage = languages!.firstWhere((language) => language.id == selectedLanguageIndex).name;
      } else {
        Get.snackbar('Error', 'Failed to load user data');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchDashboardData() async {
    isLoading = true;
    try {
      final response = await _profileRepository.fetchDashboardData();
      if (response['status'] == 'success') {
        final data = response['data'];
        dashboardData = DashboardModel.fromJson(data);
        AppConstants.baseCurrency = data['base_currency_symbol'];
        box.write('isEmailVerified', dashboardData!.emailVerification);
        box.write('isSmsVerified', dashboardData!.smsVerification);
        box.write('isTwoFaVerified', dashboardData!.twoFaVerification);
        box.write('isStatusVerified', 1);
      } else {
        Get.snackbar('Error', 'Failed to load dashboard data');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteAccount() async {
    isLoading = true;
    try {
      final response = await _profileRepository.fetchDashboardData();
      if (response['status'] == 'success') {
        Get.offAllNamed(RoutesName.loginScreen);
      } else {
        Get.snackbar('Error', 'Failed to delete account');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateProfile() async {
    isLoading = true;
    update();
    try {
      Map data = {
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
        "username": usernameController.text,
        "email": emailController.text,
        "phone_code": phoneCodeController.text,
        "phone": phoneNumberController.text,
        "country": countryController.text != "" ? countryController.text : countryCodeController.text,
        "country_code": countryCodeController.text,
        "address": addressController.text,
        "language": selectedLanguageIndex.toString(),
        // "image": pickedUserImage,
      };

      _profileRepository.updateProfile(data, pickedUserImage).then((value) {
        isLoading = false;
        if (value["status"] == "success") {
          Utils.handleSuccessResponse(value["status"], "Profile updated successfully");
          final box = GetStorage();
          box.write('languageIndex', selectedLanguageIndex);
          languageController.fetchLanguageData(selectedLanguageIndex!);
          fetchUserData();
        } else {
          Utils.handleFailureResponse(value);
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedUserImage = File(pickedFile.path);
      update();
    }
  }
}
