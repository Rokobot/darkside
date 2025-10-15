import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  Map<dynamic, dynamic> languageData = {};
  int? selectedLanguageIndex;

  @override
  void onInit() {
    super.onInit();
    selectedLanguageIndex = GetStorage().read<int>('languageIndex') ?? 1;
    fetchLanguageData(selectedLanguageIndex!);
  }

  Future<void> fetchLanguageData(dynamic languageIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      String apiUrl = '${AppConstants.languageUrl}$languageIndex';
      Uri uri = Uri.parse(apiUrl);
      if (kDebugMode) {
        print(uri);
      }
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> data = jsonDecode(response.body);

        if (kDebugMode) {
          print("==================================================> languageController.languageData $data");
        }
        final box = GetStorage();
        box.write('languageData', data['data']);
        if (kDebugMode) {
          print('language stored successfully');
        }
      } else {
        if (kDebugMode) {
          print("faild to load language");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("faild to load language: $e");
      }
    }
  }

  Map<dynamic, dynamic> getStoredData() {
    final box = GetStorage();
    languageData = box.read('languageData') ?? {};
    return languageData;
  }
}
