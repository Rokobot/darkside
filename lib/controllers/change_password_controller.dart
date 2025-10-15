import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/repositories/change_password_repo.dart';
import 'package:food_app/routes/page_index.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordRepository _changePasswordRepository = ChangePasswordRepository();
  final formkey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isPassShow = false;
  bool isNewPassShow = false;
  bool isConfirmPassShow = false;

  Future<void> changePassword() async {
    isLoading = true;
    try {
      Map data = {
        "current_password": currentPasswordController.text,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
      };

      _changePasswordRepository.changePassword(data).then((value) {
        isLoading = false;
        if (value["status"] == "success") {
          Utils.handleSuccessResponse(value["status"], value["data"]);
          currentPasswordController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
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
}
