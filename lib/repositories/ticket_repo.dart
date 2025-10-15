import 'dart:io';

import 'package:food_app/data/network/network_api_service.dart';
import 'package:food_app/utils/app_constants.dart';

class TicketRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> fetchTickets() async {
    dynamic response = await _apiService.getApi(AppConstants.ticketUrl);
    return response;
  }

  Future<dynamic> fetchTicketDetails(dynamic id) async {
    dynamic response = await _apiService.getApi("${AppConstants.ticketViewUrl}$id");
    return response;
  }

  Future<dynamic> replyTicket(var data, dynamic id, List<File> files) async {
    dynamic response = await _apiService.postFileApi(data, "${AppConstants.replyTicketUrl}$id", files);
    return response;
  }

  Future<dynamic> closeTicket(var data, dynamic id) async {
    dynamic response = await _apiService.postApi(data, "${AppConstants.closeTicketUrl}$id");
    return response;
  }

  Future<dynamic> createTicket(var data, List<File> files) async {
    dynamic response = await _apiService.postFileApi(data, AppConstants.createTicketUrl, files);
    return response;
  }
}
