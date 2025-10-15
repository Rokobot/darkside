import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class WishlistRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchWishlist() async {
    dynamic response = await _apiService.getApi(AppConstants.wishlistUrl);
    return response;
  }

  Future<dynamic> addToWishlist(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.addWishlistUrl}$id");
    return response;
  }
}
