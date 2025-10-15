import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class TwoFactorRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchTwoFactor() async {
    dynamic response = await _apiService.getApi(AppConstants.twoFactorUrl);
    return response;
  }

  Future<dynamic> enableTwoFactor(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.enableTwoFactorUrl);
    return response;
  }

  Future<dynamic> disableTwoFactor(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.disableTwoFactorUrl);
    return response;
  }
}
