import 'package:flutter/material.dart';
import 'package:food_app/controllers/user_preference_controller.dart';
import 'package:food_app/repositories/password_recovery_repo.dart';
import 'package:food_app/routes/page_index.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/screens/auth/widget/new_password_dialog.dart';
import 'package:food_app/views/screens/auth/widget/otp_dialog.dart';
import 'package:get/get.dart';

class PasswordRecoveryController extends GetxController {
  final PasswordRecoveryRepository _passwordRecoveryRepository = PasswordRecoveryRepository();
  UserPreference userPreference = UserPreference();

  final formkey = GlobalKey<FormState>();
  final registerFormkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController validationCodeController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPassShow = false.obs;
  RxBool isConfirmPassShow = false.obs;

  void sendCodeApi() {
    isLoading.value = true;
    Map data = {
      "email": emailController.text,
    };
    _passwordRecoveryRepository.sendCode(data).then((value) {
      isLoading.value = false;
      if (value["status"] == "success") {
        Utils.handleSuccessResponse(value["status"], value["data"]["message"]);
        Get.back();
        Get.dialog(buildOtpDialog(Get.context!, Get.textTheme, this));
      } else {
        Utils.handleFailureResponse(value);
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
    });
  }

  void matchCode() {
    isLoading.value = true;
    Map data = {
      "email": emailController.text,
      "code": validationCodeController.text,
    };
    _passwordRecoveryRepository.matchCode(data).then((value) {
      isLoading.value = false;
      if (value["status"] == "success") {
        Utils.handleSuccessResponse(value["status"], value["data"]["message"]);
        Get.back();
        Get.dialog(buildNewPassDialog(Get.context!, Get.textTheme, this));
      } else {
        Utils.handleFailureResponse(value);
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
    });
  }

  void changePassword() {
    isLoading.value = true;
    Map data = {
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
    };
    _passwordRecoveryRepository.resetPassword(data).then((value) {
      isLoading.value = false;
      if (value["status"] == "success") {
        Utils.handleSuccessResponse(value["status"], value["data"]["message"]);
        Get.back();
      } else {
        Utils.handleFailureResponse(value);
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
    });
  }
}
