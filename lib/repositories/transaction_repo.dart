import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class TransactionRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchTransactions() async {
    dynamic response = await _apiService.getApi(AppConstants.transactionUrl);
    return response;
  }
}
