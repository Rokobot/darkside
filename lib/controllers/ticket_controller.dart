import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/ticket_model.dart';
import 'package:food_app/repositories/ticket_repo.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/custom_alert_dialog.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TicketController extends GetxController {
  final TicketRepository _ticketRepository = TicketRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  List<File> selectedFiles = [];

  bool isScreenLoading = false;
  bool isLoading = false;
  List<TicketModel>? supportTickets;
  TicketModel? ticketDetails;
  File? pickedUserImage;

  Future<void> fetchTickets() async {
    isScreenLoading = true;
    try {
      final response = await _ticketRepository.fetchTickets();
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        supportTickets = data.map((item) => TicketModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load support tickets');
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

  Future<void> fetchTicketDetails(dynamic id) async {
    isScreenLoading = true;
    try {
      final response = await _ticketRepository.fetchTicketDetails(id);
      if (response['status'] == 'success') {
        final data = TicketModel.fromJson(response['data']);
        ticketDetails = data;
      } else {
        Get.snackbar('Error', 'Failed to load ticket details');
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

  Future<void> replyTicket(dynamic id, dynamic ticketId) async {
    isLoading = true;
    update();
    try {
      Map data = {
        "message": messageController.text,
      };

      _ticketRepository.replyTicket(data, id, selectedFiles).then((value) {
        if (value["status"] == "success") {
          selectedFiles.clear();
          messageController.clear();
          fetchTicketDetails(ticketId);
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

  Future<void> closeTicket(dynamic id) async {
    isLoading = true;
    update();
    try {
      Map data = {};

      _ticketRepository.closeTicket(data, id).then((value) {
        if (value["status"] == "success") {
          Get.to(CustomAlertDialog(title: value["status"], content: value["message"]));
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

  Future<void> createTicket() async {
    isLoading = true;
    update();
    try {
      Map data = {
        "subject": subjectController.text,
        "message": messageController.text,
      };

      _ticketRepository.createTicket(data, selectedFiles).then((value) {
        if (value["status"] == "success") {
          selectedFiles.clear();
          subjectController.clear();
          messageController.clear();
          Get.to(CustomAlertDialog(title: value["status"], content: value["data"]));
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

  void downloadFile(String fileUrl, String fileName) async {
    try {
      var response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        var tempDir = await getTemporaryDirectory();
        String savePath = '${tempDir.path}/$fileName';
        await File(savePath).writeAsBytes(response.bodyBytes);
        if (kDebugMode) {
          print('File downloaded to: $savePath');
        }
        OpenFile.open(savePath);
      } else {
        if (kDebugMode) {
          print('Error downloading file. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        selectedFiles = result.files.map((file) => File(file.path!)).toList();
        update();
      } else {
        // User canceled the picker
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking files: $e');
      }
    }
  }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
    update();
  }
}
