import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class ChatRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchChatDetails(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.orderChatUrl}$id");
    return response;
  }

  Future<dynamic> replyChat(var data) async {
    dynamic response = await _apiService.postApi(data, AppConstants.replyOrderChatUrl);
    return response;
  }
}
