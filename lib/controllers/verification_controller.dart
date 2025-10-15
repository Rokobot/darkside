import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:food_app/controllers/profile_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerificationController extends GetxController {
  bool isLoading = false;
  bool isScreenLoading = false;
  late ProfileController profileController;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.put(ProfileController());
  }

  // email / sms / two-fa verification
  Future<void> userVerification(dynamic type, dynamic code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUrl}$type-verify';
      Uri uri = Uri.parse(apiUrl);

      if (kDebugMode) {
        print(uri);
      }
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'code': code}),
      );

      final data = jsonDecode(response.body);
      String status = data['status'];

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          // Utils.handleSuccessResponse(data);
          profileController.fetchDashboardData();
          Get.offAllNamed(RoutesName.homeScreen);
        } else {
          Utils.handleFailureResponse(data);
        }
      } else {
        throw Exception('Failed to verify ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to verify ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // getting payment options and bill preview data
  Future<void> resendCode(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isScreenLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.resendCodeUrl}$type';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      String status = data['status'];

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
        } else {
          if (kDebugMode) {
            print('Failed to resend code ---------->');
          }
        }
      } else {
        throw Exception('Failed to resend code ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to resend code ----------> $e');
      }
    } finally {
      isScreenLoading = false;
      update();
    }
  }
}
