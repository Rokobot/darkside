import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/sdk_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/widgets/custom_alert_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  List<dynamic> gateways = [];
  List<dynamic> filteredGateways = [];
  bool isLoading = false;
  bool isScreenLoading = false;
  dynamic selectedGateway;
  List<dynamic> supportedCurrencyList = [];
  List<dynamic> receivableCurrencyList = [];
  String? selectedCurrency;
  Map<String, dynamic>? receivableCurrency;

  late SdkPaymentController sdkPaymentController;
  late AddressController addressController;
  late CartController cartController;

  Map<String, TextEditingController> textControllers = {};
  Map<String, File?> pickedFiles = {};
  dynamic trxId;

  // card info
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  Future<void> initializeFuntions() async {
    addressController = await Get.put(AddressController());
  }

  @override
  void onInit() {
    super.onInit();
    cartController = Get.put(CartController());
    sdkPaymentController = Get.put(SdkPaymentController());
    initializeFuntions();
  }

  // get gateway params from selectedService
  void storeGatewayParameters() {
    if (selectedGateway != null) {
      for (var fieldName in selectedGateway['parameters'].entries) {
        textControllers[fieldName.key] = TextEditingController();
      }
      update();
    }
  }

  // filter services by country name
  void filterSupportedCurrencies(String gateway) async {
    var currencies = filteredGateways.where((item) => item['code'] == gateway).toList();
    supportedCurrencyList = [];
    supportedCurrencyList = currencies[0]['supported_currency'];

    receivableCurrencyList = [];
    receivableCurrencyList = currencies[0]['receivable_currencies'];

    if (kDebugMode) {
      print("supportedCurrencyList ------> $supportedCurrencyList");
    }
    if (kDebugMode) {
      print("receivableCurrencyList ------> ${currencies[0]['receivable_currencies']}");
    }
    update();
  }

  // calculate payable amount
  double? totalPayableAmount;
  double? totalPayableAmountForDisplay;
  void calculatePayableAmount(double amount, double rate, double fixedCharge, double percentageCharge) {
    final amountAfterConversion = amount * rate;
    final pCharge = (amount / 100) * percentageCharge;
    final total = (amountAfterConversion + pCharge + fixedCharge).ceil().toDouble();
    totalPayableAmountForDisplay = amountAfterConversion + pCharge + fixedCharge;
    totalPayableAmount = total;
  }

  // getting payment options and bill preview data
  Future<void> fetchPaymentMethods() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isScreenLoading = true;
    update();

    try {
      String apiUrl = AppConstants.gatewaysUrl;
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      String status = data['status'];

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          final List<dynamic> gatewayData = data['data'];
          gateways = gatewayData;
          filteredGateways =
              gateways.where((gateway) => gateway['code'] != 'paystack' && gateway['code'] != 'paytm').toList();

          // saving billPayId for sdk payment handle
          sdkPaymentController.billPayId = "-1";

          for (var gateway in gateways) {
            //Stripe
            if (gateway['name'].toLowerCase() == "stripe" || gateway['id'] == 2) {
              sdkPaymentController.stripeSecretKey = gateway['parameters']['secret_key'];
              sdkPaymentController.stripePublisherKey = gateway['parameters']['publishable_key'];
            }

            //RazorPay
            if (gateway['name'].toLowerCase() == "razorpay") {
              sdkPaymentController.keyIdRazorPay = gateway['parameters']['key_id'];
              sdkPaymentController.keySecretRazorPay = gateway['parameters']['key_secret'];
            }

            //Paytm
            if (gateway['name'].toLowerCase() == "paytm") {
              sdkPaymentController.midPaytm = gateway['parameters']['MID'];
              sdkPaymentController.merchantKeyPaytm = gateway['parameters']['merchant_key'];
              sdkPaymentController.websitePaytm = gateway['parameters']['WEBSITE'];
              sdkPaymentController.industryTypePaytm = gateway['parameters']['INDUSTRY_TYPE_ID'];
              sdkPaymentController.channelIdPaytm = gateway['parameters']['CHANNEL_ID'];
              sdkPaymentController.transactionUrlPaytm = gateway['parameters']['transaction_url'];
              sdkPaymentController.transactionStatusUrlPaytm = gateway['parameters']['transaction_status_url'];
            }

            //FlutterWave
            if (gateway['name'].toLowerCase() == "flutterwave") {
              sdkPaymentController.publicKeyFlutterWave = gateway['parameters']['public_key'];
              sdkPaymentController.secretKeyFlutterWave = gateway['parameters']['secret_key'];
              sdkPaymentController.encryptedKeyFlutterWave = gateway['parameters']['encryption_key'];
            }

            //Paypal
            if (gateway['name'].toLowerCase() == "paypal") {
              sdkPaymentController.clientIdPaypal = gateway['parameters']['cleint_id'];
              sdkPaymentController.secretKeyPaypal = gateway['parameters']['secret'];
            }

            //PayStack
            if (gateway['name'].toLowerCase() == "paystack") {
              sdkPaymentController.publicKeyPayStack = gateway['parameters']['public_key'];
              sdkPaymentController.secretKeyPayStack = gateway['parameters']['secret_key'];
            }

            //Monnify
            if (gateway['name'].toLowerCase() == "monnify") {
              sdkPaymentController.apiKeyMonnify = gateway['parameters']['api_key'];
              sdkPaymentController.secretKeyMonnify = gateway['parameters']['secret_key'];
              sdkPaymentController.contactCodeMonnfiy = gateway['parameters']['contract_code'];
            }
          }
        } else {
          if (kDebugMode) {
            print('Failed to load payment gateways ---------->');
          }
        }
      } else {
        throw Exception('Failed to load payment gateways ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load payment gateways ----------> $e');
      }
    } finally {
      isScreenLoading = false;
      update();
    }
  }

  // submit payment request to get trxID
  Future<void> submitPaymentRequest(dynamic orderId, bool isManual) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();

    if (kDebugMode) {
      print("order_id: $orderId");
    }
    if (kDebugMode) {
      print("gateway_id: ${selectedGateway['id']}");
    }
    if (kDebugMode) {
      print("supported_currency: $selectedCurrency");
    }

    try {
      String apiUrl = AppConstants.paymentRequestUrl;
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'order_id': orderId,
          'gateway_id': selectedGateway['id'],
          'supported_currency': selectedCurrency,
        }),
      );

      final data = jsonDecode(response.body);
      String status = data['status'];
      if (kDebugMode) {
        print("payment request response: ---------------------> $data");
      }

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          trxId = await data['data'];
          sdkPaymentController.utr = trxId;
          // if (isManual) {
          //   submitManualPayment();
          // } else {
          //   submitWebview();
          // }
        } else {
          Utils.handleFailureResponse(data);
        }
      } else {
        throw Exception('Failed to submit payment request ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to submit payment request ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // submit cash on delivery
  Future<void> submitCashOnDelivery(dynamic orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();
    try {
      String apiUrl = AppConstants.paymentRequestUrl;
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'order_id': orderId,
          'gateway_id': "1600",
        }),
      );

      final data = jsonDecode(response.body);
      String status = data['status'];
      if (kDebugMode) {
        print("cash on delivery: ---------------------> $data");
      }

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          cartController.clearCart();
          Get.to(CustomAlertDialog(title: data['status'], content: data['data']));
        } else {
          Get.to(CustomAlertDialog(title: data['status'], content: data['message']));
        }
      } else {
        throw Exception('Failed to submit payment request ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to submit payment request ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // getting payment options and bill preview data
  Future<void> submitWebview() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isScreenLoading = true;
    update();

    try {
      String apiUrl = "${AppConstants.paymentWebViewUrl}$trxId";
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      String status = data['status'];

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          cartController.clearCart();
          Get.toNamed(RoutesName.webView, arguments: data['data']['url']);
        } else {
          if (kDebugMode) {
            print('Failed to redirect webview ---------->');
          }
        }
      } else {
        throw Exception('Failed to redirect webview ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to redirect webview ----------> $e');
      }
    } finally {
      isScreenLoading = false;
      update();
    }
  }

  // submit payment info (BANK TRANSFER / ID GREATER THAN 999)
  Future<void> submitManualPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();

    try {
      String apiUrl = "${AppConstants.manualPaymentUrl}$trxId";
      Uri uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Add text field values to formData
      request.fields['trx_id'] = trxId;
      textControllers.forEach((fieldName, controller) {
        request.fields[fieldName] = controller.text;
      });

      // Add image files to formData
      pickedFiles.forEach((fieldName, file) async {
        if (file != null) {
          List<int> fileBytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              fileBytes,
              filename: file.path.split('/').last,
            ),
          );
        }
      });

      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      final data = jsonDecode(await response.stream.bytesToString());
      String status = data['status'];

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          cartController.clearCart();
          for (var controller in textControllers.values) {
            controller.clear();
          }
          pickedFiles.clear();
          Get.to(CustomAlertDialog(title: data['status'], content: data['message']));
        } else {
          Utils.handleFailureResponse(data);
        }
      } else {
        throw Exception('Failed to submit manual payment ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to submit manual payment ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // submit card payment info (AUTHORIZE.NET, SECURIONPAY / HAVE INDIVIDUAL CARD PAYMENT SCREEN)
  Future<void> submitCardPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isLoading = true;
    update();

    List<String> parts = expiryDate.split('/');
    try {
      String apiUrl = AppConstants.cardPaymentUrl;
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'trx_id': trxId,
          'card_number': cardNumber,
          'card_name': cardHolderName,
          'expiry_month': parts[0],
          'expiry_year': parts[1],
          'card_cvc': cvvCode,
        }),
      );
      final data = jsonDecode(response.body);
      String status = data['status'];

      if (kDebugMode) {
        print(data);
      }

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          cartController.clearCart();
          Get.to(CustomAlertDialog(title: data['status'], content: data['data']));
          update();
        } else {
          Get.to(CustomAlertDialog(title: data['status'], content: data['message']));
        }
      } else {
        throw Exception('Failed to do card payment ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to do card payment ----------> $e');
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
