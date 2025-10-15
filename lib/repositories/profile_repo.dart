import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class ProfileRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchUserData() async {
    dynamic response = await _apiService.getApi(AppConstants.profileUrl);
    return response;
  }

  Future<dynamic> fetchDashboardData() async {
    dynamic response = await _apiService.getApi(AppConstants.dashboardUrl);
    return response;
  }

  Future<dynamic> deleteAccount() async {
    dynamic response = await _apiService.getApi(AppConstants.deleteAccountUrl);
    return response;
  }

  Future<dynamic> updateProfile(var data, var image) async {
    dynamic response = await _apiService.postApiWithImage(data, AppConstants.profileUpdateUrl, image);
    return response;
  }
}
