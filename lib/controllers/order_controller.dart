import 'package:flutter/foundation.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/repositories/order_repo.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  bool isLoading = false;
  List<OrderResponse>? orders;
  List<OrderItem>? orderDetails;
  int statusLevel = 1;

  Future<void> fetchOrders() async {
    isLoading = true;
    try {
      final response = await _orderRepository.fetchOrders();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        orders = data.map((item) => OrderResponse.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load orders');
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

  Future<void> fetchOrderDetails(dynamic id) async {
    isLoading = true;
    try {
      final response = await _orderRepository.fetchOrderDetails(id);
      if (response['status'] == 'success') {
        final data = response['data']['orderItems'] as List<dynamic>;
        orderDetails = data.map((item) => OrderItem.fromJson(item)).toList();
        statusLevel = response['data']['order']['status_level'];
      } else {
        Get.snackbar('Error', 'Failed to load order details');
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
}
