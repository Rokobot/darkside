import 'package:flutter/foundation.dart';
import 'package:food_app/models/transaction_model.dart';
import 'package:food_app/repositories/transaction_repo.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  bool isLoading = false;
  List<TransactionModel>? transactionList;

  Future<void> fetchTransactions() async {
    isLoading = true;
    try {
      final response = await _transactionRepository.fetchTransactions();
      if (response['status'] == 'success') {
        final data = response['data'] as List<dynamic>;
        transactionList = data.map((item) => TransactionModel.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load transactions');
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
