import 'dart:convert';
import 'package:food_app/views/widgets/custom_alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/models/address_model.dart';
import 'package:food_app/repositories/address_repo.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/utils.dart';
import 'package:food_app/views/screens/my_cart/payment_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressController extends GetxController {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final AddressRepository _addressRepository = AddressRepository();
  late CartController cartController;

  bool isLoading = false;
  List<AddressResponse>? addressList;
  AddressResponse? addressView;
  List<AreaResponse>? areaList;
  String? selectedAreaName;
  int? selectedAreaIndex;
  AreaResponse? selectedArea;
  AddressResponse? selectedAddress;

  // coupon
  final TextEditingController couponCodeController = TextEditingController();
  double? totalAmount, amountAfterDiscount;
  dynamic vat, shippingCharge, discountAmount = 0.00;
  String discountType = "";
  bool isCouponApplied = false;
  bool isCouponLoading = false;

  @override
  void onInit() {
    super.onInit();
    cartController = Get.put(CartController());
  }

  Future<void> fetchAddressList() async {
    isLoading = true;
    try {
      final response = await _addressRepository.fetchAddressList();
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data']['address'];
        addressList = data.map((json) => AddressResponse.fromJson(json)).toList();
        // areaList = List<AreaResponse>.from(response['data']['areas'].map((i) => AreaResponse.fromJson(i)));
      } else {
        Get.snackbar('Error', 'Failed to load addresses');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchAreaList() async {
    isLoading = true;
    try {
      final response = await _addressRepository.fetchAreaList();
      if (response['status'] == 'success') {
        final data = response['data'];
        areaList = List<AreaResponse>.from(data.map((i) => AreaResponse.fromJson(i)));
        // addressList = data.map((json) => AddressResponse.fromJson(json)).toList();
        // areaList = List<AreaResponse>.from(response['data'].map((i) => AreaResponse.fromJson(i)));
      } else {
        Get.snackbar('Error', 'Failed to load addresses');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchAddressView(dynamic id) async {
    isLoading = true;
    try {
      final response = await _addressRepository.fetchAddressView(id);
      if (response['status'] == 'success') {
        final data = response['data'];
        addressView = AddressResponse.fromJson(data['address']);

        firstnameController.text = addressView!.firstName;
        lastnameController.text = addressView!.lastName;
        addressController.text = addressView!.address;
        addressNameController.text = addressView!.addressName;
        emailController.text = addressView!.email;
        phoneNumberController.text = addressView!.phone;
        countryController.text = addressView!.country;
        cityController.text = addressView!.city;
        zipController.text = addressView!.zip;

        areaList = List<AreaResponse>.from(data['areas'].map((i) => AreaResponse.fromJson(i)));
        selectedAreaIndex = int.tryParse(addressView!.areaId.toString());
        selectedAreaName = areaList!.firstWhere((area) => area.id == selectedAreaIndex).areaName;
        selectedArea = areaList!.firstWhere((area) => area.id == selectedAreaIndex);

        vat = response['data']['vat'];

        for (var charge in selectedArea!.shippingCharge) {
          int orderFrom = int.parse(charge.orderFrom);
          int? orderTo = charge.orderTo.isEmpty ? null : int.parse(charge.orderTo);

          // If the orderTo is empty, it means there's no upper limit
          if (cartController.cartItems.length >= orderFrom &&
              (orderTo == null || cartController.cartItems.length <= orderTo)) {
            // return double.parse(charge.shippingCharge);
            shippingCharge = charge.shippingCharge;
          }
        }

        // shippingCharge = selectedArea!.shippingCharge[0].shippingCharge;
        var vatPercentage =
            (cartController.totalPrice / 100) * int.parse(vat.toString()).toDouble(); // vat!.toDouble();
        totalAmount = (cartController.totalPrice + vatPercentage + double.parse(shippingCharge));

        if (amountAfterDiscount! <= 0) {
          totalAmount = (cartController.totalPrice + vatPercentage + double.parse(shippingCharge));
        } else {
          totalAmount = (amountAfterDiscount! + vatPercentage + double.parse(shippingCharge));
        }
      } else {
        Get.snackbar('Error', 'Failed to load address details');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> createAddress() async {
    isLoading = true;
    try {
      Map data = {
        "address_name": addressNameController.text,
        "address": addressController.text,
        "city": cityController.text,
        "area": selectedAreaIndex.toString(),
        "zip": zipController.text,
        "country": countryController.text,
        "email": emailController.text,
        "phone": phoneNumberController.text,
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
      };

      _addressRepository.createAddress(data).then((value) {
        isLoading = false;

        if (value["status"] == "success") {
          Get.to(CustomAlertDialog(title: value['status'], content: value['data']));
          addressNameController.clear();
          addressController.clear();
          cityController.clear();
          zipController.clear();
          countryController.clear();
          emailController.clear();
          phoneNumberController.clear();
          firstnameController.clear();
          lastnameController.clear();
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

  Future<void> updateAddress(dynamic id) async {
    isLoading = true;
    update();
    try {
      Map data = {
        "address_name": addressNameController.text,
        "address": addressController.text,
        "city": cityController.text,
        "area": selectedAreaIndex.toString(),
        "zip": zipController.text,
        "country": countryController.text,
        "email": emailController.text,
        "phone": phoneNumberController.text,
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
      };

      _addressRepository.updateAddress(data, id).then((value) {
        if (value["status"] == "success") {
          Utils.handleSuccessResponse(value["status"], "Address Updated Successfully");
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

  Future<void> deleteAddress(dynamic id) async {
    isLoading = true;
    try {
      final response = await _addressRepository.deleteAddress(id);
      if (response['status'] == 'success') {
        Utils.handleSuccessResponse(response["status"], response["data"]);
        fetchAddressList();
      } else {
        Get.snackbar('Error', 'Failed to delete address');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> createOrder() async {
    isLoading = true;
    try {
      // Map data = {
      //   "firstname": firstnameController.text,
      //   "lastname": lastnameController.text,
      //   "area_id": selectedAreaIndex,
      //   "address": addressController.text,
      //   "phone": phoneNumberController.text,
      //   "cartItems": cartController.cartItems.map((item) {
      //     if (item.variant != null) {
      //       Map<String, dynamic> itemData = {
      //         "variants": [
      //           {
      //             "id": item.id,
      //             "quantity": item.quantity,
      //             "price": item.price,
      //             "variant_id": item.variant.id,
      //           }
      //         ]
      //       };
      //       if (item.addons.isNotEmpty) {
      //         itemData["addons"] = item.addons;
      //       }
      //       return itemData;
      //     } else {
      //       Map<String, dynamic> itemData = {
      //         "id": item.id,
      //         "quantity": item.quantity,
      //         "price": item.price,
      //       };
      //       if (item.addons.isNotEmpty) {
      //         itemData["addons"] = item.addons;
      //       }
      //       return itemData;
      //     }
      //   }).toList(),
      // };

      Map data = {
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
        "area_id": selectedAreaIndex,
        "address": addressController.text,
        "phone": phoneNumberController.text,
        "cartItems": cartController.cartItems
            .fold<Map<int, Map<String, dynamic>>>({}, (acc, item) {
              if (item.variant != null) {
                // Handle items with variants
                if (!acc.containsKey(item.id)) {
                  acc[item.id] = {
                    "variants": [],
                  };
                }
                (acc[item.id]!["variants"] as List).add({
                  "id": item.id,
                  "quantity": item.quantity,
                  "price": item.price,
                  "variant_id": item.variant.id,
                });
              } else {
                // Handle items without variants
                acc[item.id] = {
                  "id": item.id,
                  "quantity": item.quantity,
                  "price": item.price,
                };
              }
              return acc;
            })
            .values
            .toList(),
      };

      _addressRepository.createOrder(data).then((value) {
        isLoading = false;
        if (value["status"] == "success") {
          Utils.handleSuccessResponse(value["status"], "Order Created Successfully");
          Get.toNamed(PaymentScreen.routeName, arguments: value["data"]["order_id"]);
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

  // check coupon code
  Future<void> applyCouponCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isCouponLoading = true;
    update();

    try {
      String apiUrl = AppConstants.couponCodeUrl;
      Uri uri = Uri.parse(apiUrl);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'coupon': couponCodeController.text,
          'price': cartController.totalPrice,
        }),
      );
      final data = jsonDecode(response.body);
      String status = data['status'];

      if (kDebugMode) {
        print(data);
      }

      if (response.statusCode == 200) {
        if (status.toLowerCase() == "success") {
          discountAmount = data["data"]["amount"];
          discountType = data["data"]["type"];

          if (discountType == '%' && discountType != '') {
            double percentage = cartController.totalPrice / 100;
            double dp = percentage * discountAmount!;
            amountAfterDiscount = cartController.totalPrice - dp;
          } else if (discountType != '') {
            amountAfterDiscount = cartController.totalPrice - discountAmount;
          }

          // shippingCharge = selectedArea!.shippingCharge[0].shippingCharge;
          isCouponApplied = true;
          var vatPercentage = (cartController.totalPrice / 100) * int.parse(vat.toString()).toDouble();
          totalAmount = (amountAfterDiscount! + vatPercentage + double.parse(shippingCharge));
        } else {
          Utils.handleFailureResponse(data);
          discountAmount = 0;
          amountAfterDiscount = 0;
          discountType = "";
          couponCodeController.clear();
          isCouponApplied = false;
        }
      } else {
        throw Exception('Failed to match coupon code ---------->');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to match coupon code ----------> $e');
      }
    } finally {
      isCouponLoading = false;
      update();
    }
  }
}


// {
//   firstname: Godfrey, 
//   lastname: McLaughlin, 
//   area_id: 2, address: 962 Weissnat Lake Apt. 124 South Candidamouth, AZ 38295, 
//   phone: +16205198179, 
//   cartItems: [{
//     variants: [
//       {id: 6, quantity: 1, price: 150.0, variant_id: 154},
//       {id: 6, quantity: 1, price: 100.0, variant_id: 155}
//     ]
//   }]
// }