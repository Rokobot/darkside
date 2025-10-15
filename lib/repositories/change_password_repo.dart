import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class ChangePasswordRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> changePassword(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.changePassUrl);
    return response;
  }
}
