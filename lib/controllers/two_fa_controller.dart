import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/models/two_fa_model.dart';
import 'package:food_app/repositories/two_fa_repo.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/custom_alert_dialog.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFactorController extends GetxController {
  final TwoFactorRepository _twoFactorRepository = TwoFactorRepository();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  TwoFactorResponse? twoFactorInfo;

  Future<void> fetchTwoFactor() async {
    isLoading = true;
    try {
      final response = await _twoFactorRepository.fetchTwoFactor();
      if (response['status'] == 'success') {
        final data = response['data'];
        twoFactorInfo = TwoFactorResponse.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load two factor info');
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

  Future<void> enableTwoFactor() async {
    isLoading = true;
    update();
    try {
      Map data = {
        "code": codeController.text,
      };

      _twoFactorRepository.enableTwoFactor(data).then((value) {
        isLoading = false;
        if (value["status"] == "success") {
          // Utils.handleSuccessResponse(value["status"], value["data"]);
          Get.to(CustomAlertDialog(title: value['status'], content: value['data']));
          codeController.clear();
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

  Future<void> disableTwoFactor() async {
    isLoading = true;
    update();
    try {
      Map data = {
        "password": passwordController.text,
      };

      _twoFactorRepository.disableTwoFactor(data).then((value) {
        isLoading = false;
        if (value["status"] == "success") {
          // Utils.handleSuccessResponse(value["status"], value["data"]);
          Get.to(CustomAlertDialog(title: value['status'], content: value['data']));
          passwordController.clear();
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

  void openStore() async {
    final Uri appStoreUrl = Uri.parse(twoFactorInfo!.iosApp);
    final Uri playStoreUrl = Uri.parse(twoFactorInfo!.downloadApp);

    if (await canLaunchUrl(appStoreUrl)) {
      await launchUrl(appStoreUrl);
    } else if (await canLaunchUrl(playStoreUrl)) {
      await launchUrl(playStoreUrl);
    } else {
      Get.snackbar(
        "Failed",
        "Couldn't launch to the store.",
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
      throw "Couldn't launch to the store.";
    }
  }
}
