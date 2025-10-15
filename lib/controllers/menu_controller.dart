import 'package:flutter/foundation.dart';
import 'package:food_app/models/menu_model.dart';
import 'package:food_app/repositories/menu_repo.dart';
import 'package:get/get.dart';

class MenusController extends GetxController {
  final MenuRepository _menuRepository = MenuRepository();
  List<MenuResponse>? menus;
  MenuResponse? menuDetails;
  bool isLoading = true;
  bool isGridView = true;

  Future<void> fetchMenu() async {
    isLoading = true;
    try {
      final response = await _menuRepository.fetchMenu();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        menus = data.map((item) => MenuResponse.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load menus');
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

  Future<void> fetchMenuDetails(dynamic id) async {
    isLoading = true;
    try {
      final response = await _menuRepository.fetchMenuDetails(id);
      if (response['status'] == 'success') {
        final data = MenuResponse.fromJson(response['data']);
        menuDetails = data;
      } else {
        Get.snackbar('Error', 'Failed to load menu details');
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

  Future<void> fetchFilteredProducts(dynamic search, dynamic minPrice, dynamic maxPrice, dynamic id) async {
    isLoading = true;
    try {
      final response = await _menuRepository.fetchFilteredProducts(search, minPrice, maxPrice, id);
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        menus = data.map((item) => MenuResponse.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load menus');
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

  changeLayout() {
    isGridView = !isGridView;
    update();
  }
}
