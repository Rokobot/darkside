// import 'package:food_app/data/network/network_api_service.dart';
// import 'package:food_app/utils/app_constants.dart';

// class PaymentRepository {
//   final _apiService = NetworkApiService();

//   Future<dynamic> fetchGateways() async {
//     dynamic response = await _apiService.getApi(AppConstants.gatewaysUrl);
//     return response;
//   }

//   Future<dynamic> paymentRequest(var data) async {
//     dynamic response = await _apiService.postApi(data, AppConstants.paymentRequestUrl);
//     return response;
//   }

//   Future<dynamic> paymentWebview(var data) async {
//     dynamic response = await _apiService.postApi(data, AppConstants.paymentWebViewUrl);
//     return response;
//   }

//   Future<dynamic> paymentDone(var data, dynamic id) async {
//     dynamic response = await _apiService.postApi(data, "${AppConstants.paymentDoneUrl}$id");
//     return response;
//   }

//   Future<dynamic> manualPayment(var data, dynamic id) async {
//     dynamic response = await _apiService.postApi(data, "${AppConstants.paymentDoneUrl}$id");
//     return response;
//   }
// }
