import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/menu_controller.dart';
import 'package:food_app/controllers/profile_controller.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  dynamic ratingCount = 5;
  List<dynamic> reviewList = [];
  bool isLoading = false;
  bool isScreenLoading = false;

  late ProfileController profileController;
  late MenusController menuController;

  @override
  void onInit() {
    profileController = Get.put(ProfileController());
    menuController = Get.put(MenusController());
    super.onInit();
  }

  Future<void> makeReview(dynamic productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();

    try {
      String apiUrl = AppConstants.addReviewUrl;
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'menu_id': productId,
          'rating': ratingCount,
          'review': commentController.text,
          'email': profileController.userData!.email ?? "",
          'name': "${profileController.userData!.firstname} ${profileController.userData!.lastname}",
        }),
      );
      final data = jsonDecode(response.body);
      String status = data['status'];

      if (kDebugMode) {
        print(data);
      }

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          Utils.handleSuccessResponse(data["status"], data['data']);
          commentController.text = "";
          menuController.fetchMenuDetails(productId);
          update();
        } else {
          Utils.handleFailureResponse(data);
        }
      } else {
        throw Exception('Failed to make review ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to make review ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
