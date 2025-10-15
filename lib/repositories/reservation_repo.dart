import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class ReservationRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchReservationTable() async {
    dynamic response = await _apiService.getApi(AppConstants.reservationUrl);
    return response;
  }

  Future<dynamic> addReservation(dynamic addReservationModel) async {
    dynamic response = await _apiService.postApi(addReservationModel, AppConstants.reservationUrl);
    return response;
  }

  Future<dynamic> fetchReservationList() async {
    dynamic response = await _apiService.getApi(AppConstants.reservationListUrl);
    return response;
  }



}
