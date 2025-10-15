import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class OnboardingRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchOnboardingData() async {
    dynamic response = await _apiService.getApi(AppConstants.onboardingUrl);
    return response;
  }
}
