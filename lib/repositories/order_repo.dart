import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class OrderRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchOrders() async {
    dynamic response = await _apiService.getApi(AppConstants.orderUrl);
    return response;
  }

  Future<dynamic> fetchOrderDetails(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.orderDetailsUrl}$id");
    return response;
  }
}
