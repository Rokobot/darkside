import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:food_app/data/app_exception.dart';
import 'package:food_app/data/network/base_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getApi(String url) async {
    if (kDebugMode) {
      print("---------------------------------------------------> $url");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("token: ${token}");
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NetworkException('No Internet Connection');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future postApi(var data, String url) async {
    if (kDebugMode) {
      print("data: --------------------> $data");
    }
    if (kDebugMode) {
      print("url: --------------------> $url");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();


    String? token = prefs.getString('token');
    dynamic responseJson;

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Authorization': 'Bearer $token'},
            body: data,
          )
          .timeout(const Duration(seconds: 10));

      print("responser custom: ${response.body}");

      responseJson = returnResponse(response);
      print("responser responseJson: ${responseJson}");
    } on SocketException {
      throw NetworkException('No Internet Connection');
    }

    if (kDebugMode) {
      print("post api response: --------------------> $responseJson");
    }
    return responseJson;
  }

  Future postApiWithImage(Map<dynamic, dynamic> data, String url, File? imageFile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add image file if it's not null
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // Name of the field the server expects
          imageFile.path,
        ));
      }

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        return returnResponse(responseData);
      } else {
        throw Exception('Failed to update profile');
      }
    } on SocketException {
      throw NetworkException('No Internet Connection');
    }
  }

  Future postRawApi(var data, String url) async {
    if (kDebugMode) {
      print("data: --------------------> $data");
    }
    if (kDebugMode) {
      print("url: --------------------> $url");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    dynamic responseJson;

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              "Content-Type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NetworkException('No Internet Connection');
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    if (kDebugMode) {
      print("post api response: --------------------> $responseJson");
    }
    return responseJson;
  }

  Future postFileApi(Map<dynamic, dynamic> fields, String url, List<File> files) async {
    if (kDebugMode) {
      print("data: --------------------> $fields");
    }
    if (kDebugMode) {
      print("url: --------------------> $url");
    }
    if (kDebugMode) {
      print("files: --------------------> $files");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    dynamic responseJson;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add files
      for (File file in files) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile('attachments[]', stream, length, filename: basename(file.path));
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = returnResponse(response);
    } on SocketException {
      throw NetworkException('No Internet Connection');
    }

    if (kDebugMode) {
      print("post api response: --------------------> $responseJson");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communication with server with status code : ${response.statusCode}');
    }
  }
}
