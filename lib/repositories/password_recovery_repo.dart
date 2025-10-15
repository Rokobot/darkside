import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class PasswordRecoveryRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> sendCode(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.forgotPassUrl);
    return response;
  }

  Future<dynamic> matchCode(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.forgotPassGetCodeUrl);
    return response;
  }

  Future<dynamic> resetPassword(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.updatePassUrl);
    return response;
  }
}
