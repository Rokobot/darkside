import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/chat_model.dart';
import 'package:food_app/repositories/chat_repo.dart';
import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  bool isScreenLoading = false;
  bool isLoading = false;
  List<ChatModel> chatDetails = [];

  Future<void> fetchChatDetails(dynamic id) async {
    isScreenLoading = true;
    try {
      final response = await _chatRepository.fetchChatDetails(id);
      if (response['status'] == 'success') {
        List<dynamic> dataList = response['data'];
        chatDetails = dataList.map((item) => ChatModel.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load chat details');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isScreenLoading = false;
      update();
    }
  }

  Future<void> replyChat(dynamic orderId) async {
    isLoading = true;
    update();
    try {
      Map data = {
        "order_id": orderId.toString(),
        "message": messageController.text,
      };

      _chatRepository.replyChat(data).then((value) {
        if (value["status"] == "success") {
          messageController.clear();
          fetchChatDetails(orderId);
        } else {
          Utils.handleFailureResponse(value);
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
