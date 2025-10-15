import 'package:flutter/foundation.dart';
import 'package:food_app/models/wishlist_item_model.dart';
import 'package:food_app/repositories/wishlist_repo.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final WishlistRepository _wishlistRepository = WishlistRepository();
  bool isLoading = false;
  List<WishlistResponse>? wishlist;

  bool isItemInWishlist(int id) {
    return wishlist!.any((item) => item.menuId == id);
  }

  Future<void> fetchWishlist() async {
    isLoading = true;
    try {
      final response = await _wishlistRepository.fetchWishlist();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        wishlist = data.map((item) => WishlistResponse.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load wishlist');
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

  Future<void> addToWishlist(dynamic id) async {
    isLoading = true;
    try {
      final response = await _wishlistRepository.addToWishlist(id);
      if (response['status'] == 'success') {
        Utils.handleSuccessResponse(response["status"], response["data"]);
        fetchWishlist();
      } else {
        Get.snackbar('Error', 'Failed to perform action');
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
