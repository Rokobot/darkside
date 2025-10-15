import 'package:flutter/material.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/user_preference_controller.dart';
import 'package:food_app/models/login_model.dart';
import 'package:food_app/repositories/login_repo.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginRepository _loginRepository = LoginRepository();
  UserPreference userPreference = UserPreference();

  final formkey = GlobalKey<FormState>();
  final registerFormkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerpasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneCodeController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController validationCodeController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPassShow = false.obs;
  RxBool isConfirmPassShow = false.obs;
  RxBool isRemember = false.obs;

  void loginApi() {
    isLoading.value = true;
    Map data = {
      "username": emailController.text,
      "password": passwordController.text,
    };
    _loginRepository.login(data).then((value) {
      isLoading.value = false;
      if (value["status"] == "success") {
        Utils.handleSuccessResponse(value["status"], value["data"]["message"]);
        LoginResponse data = LoginResponse(
          token: value["data"]["token"],
          isLogin: true,
        );
        if (isRemember.value) {
          userPreference.saveCredentials(emailController.text, passwordController.text);
        } else {
          userPreference.clearCredentials();
        }
        userPreference.saveUser(data).then((value) {
          Get.delete<LoginController>();
          Get.offAllNamed(RoutesName.homeScreen);
        });
      } else {
        Utils.handleFailureResponse(value);
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      Get.snackbar(
        error.toString(),
        "data['message']",
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
    });
  }

  void registerApi() {
    isLoading.value = true;
    Map data = {
      "firstname": firstnameController.text,
      "lastname": lastnameController.text,
      "email": registerEmailController.text,
      "password": registerpasswordController.text,
      "username": usernameController.text,
      "password_confirmation": confirmPasswordController.text,
      "phone": phoneNumberController.text,
      "phone_code": phoneCodeController.text,
      "country": countryCodeController.text,
      "country_code": countryCodeController.text,
    };
    _loginRepository.register(data).then((value) {
      isLoading.value = false;
      if (value["status"] == "success") {
        Utils.handleSuccessResponse(value["status"], "User created successfully");
        LoginResponse data = LoginResponse(
          token: value["data"],
          isLogin: true,
        );
        userPreference.saveUser(data).then((value) {
          Get.delete<LoginController>();
          Get.offAllNamed(RoutesName.homeScreen);
        });
      } else {
        Utils.handleFailureResponse(value);
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      // Utils.handleFailureResponse("Error", error.toString());
    });
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    return await userPreference.getCredentials();
  }

  Future<void> loadSavedCredentials() async {
    Map<String, String?> credentials = await getSavedCredentials();
    if (credentials['username'] != null && credentials['password'] != null) {
      emailController.text = credentials['username']!;
      passwordController.text = credentials['password']!;
      isRemember.value = true;
    }
  }
}
