import 'package:flutter/foundation.dart';
import 'package:food_app/models/menu_category_model.dart';
import 'package:food_app/repositories/menu_category_repo.dart';
import 'package:get/get.dart';

class MenuCategoryController extends GetxController {
  final MenuCategoryRepository _menuCategoryRepository = MenuCategoryRepository();
  bool isLoading = false;
  List<MenuCategoryResponse>? menuCategories;

  @override
  void onInit() {
    fetchMenuCategories();
    super.onInit();
  }

  Future<void> fetchMenuCategories() async {
    isLoading = true;
    try {
      final response = await _menuCategoryRepository.fetchMenuCategories();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        menuCategories = data.map((item) => MenuCategoryResponse.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load menu categories');
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
}
