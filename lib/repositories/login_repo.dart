import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class LoginRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> login(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.loginUrl);
    return response;
  }

  Future<dynamic> register(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.registerUrl);
    return response;
  }
}
