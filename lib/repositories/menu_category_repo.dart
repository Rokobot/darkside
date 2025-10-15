import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class MenuCategoryRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchMenuCategories() async {
    dynamic response = await _apiService.getApi(AppConstants.menuCategoriesUrl);
    return response;
  }
}
