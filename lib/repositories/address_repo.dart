import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class AddressRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchAddressList() async {
    dynamic response = await _apiService.getApi(AppConstants.addressUrl);
    return response;
  }

  Future<dynamic> fetchAreaList() async {
    dynamic response = await _apiService.getApi(AppConstants.areasUrl);
    return response;
  }

  Future<dynamic> fetchAddressView(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.addressViewUrl}$id");
    return response;
  }

  Future<dynamic> deleteAddress(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.deleteAddressUrl}$id");
    return response;
  }

  Future<dynamic> createAddress(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.createAddressUrl);
    return response;
  }

  Future<dynamic> createOrder(var data) async {
    dynamic response = await _apiService.postRawApi(data, AppConstants.createOrderUrl);
    return response;
  }

  Future<dynamic> updateAddress(var data, dynamic id) async {
    dynamic response = await _apiService.postApi(data, "${AppConstants.editAddressUrl}$id");
    return response;
  }
}
