import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class MenuRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchMenu() async {
    dynamic response = await _apiService.getApi(AppConstants.menuUrl);
    return response;
  }

  Future<dynamic> fetchMenuDetails(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.menuDetailsUrl}$id/1");
    return response;
  }

  Future<dynamic> fetchFilteredProducts(dynamic search, dynamic minPrice, dynamic maxPrice, dynamic id) async {
    dynamic response = await _apiService.getApi(
        "${AppConstants.filterMenuUrl}title=$search&min_price=$minPrice&max_price=$maxPrice&category_id=$id&language_id=1");
    return response;
  }
}
