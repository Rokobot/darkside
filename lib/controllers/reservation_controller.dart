import 'package:flutter/foundation.dart';
import 'package:food_app/models/add_reservation_model.dart';
import 'package:food_app/models/reservation_table_model.dart';

import 'package:food_app/utils/utils.dart';
import 'package:get/get.dart';

import '../models/reservation_history_model.dart';
import '../repositories/reservation_repo.dart';

class ReservationController extends GetxController {
  final ReservationRepository _reservationRepository = ReservationRepository();

  bool isLoading = false;
  ReservationTableModel? reservationTablesModel;
  List<TableItem>? tablesList = [];
  ReservationHistoryModel? reservationHistoryModel;
  List<ReservationHistoryItem>? reservationList = [];
  /// Fetch available reservation tables
  Future<void> fetchReservationTables() async {
    isLoading = true;
    update();
    try {
      final response = await _reservationRepository.fetchReservationTable();

      if (response['status'] == 'success') {
        // Parse the JSON response into our model
        reservationTablesModel = ReservationTableModel.fromJson(response);

        // Extract the actual table list
        tablesList = reservationTablesModel?.data?.tables ?? [];

        if (kDebugMode) {
          for (var t in tablesList!) {
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to load reservation tables');
      }
    } catch (error) {
      if (kDebugMode) print('Fetch reservation tables error: $error');
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Add new reservation
  Future<void> addReservation(AddReservationModel addReservationModel) async {
    isLoading = true;
    update();
    try {
      final response =
      await _reservationRepository.addReservation(addReservationModel.toJson());
      print("_reservationRepository: ${response}");
      if (response['status'] == 'success') {
        Utils.handleSuccessResponse(response['status'], 'Successfully booked!');
      } else {
        Get.snackbar('Error', 'Failed to create reservation');
      }
    } catch (error) {
      if (kDebugMode) print('Add reservation error: $error');
    } finally {
      isLoading = false;
      update();
    }
  }



  /// Fetch reservation history/list
  Future<void> fetchReservationList() async {
    isLoading = true;
    update();
    try {
      final response = await _reservationRepository.fetchReservationList();

      if (response['status'] == 'success') {
        reservationHistoryModel = ReservationHistoryModel.fromJson(response);
        reservationList = reservationHistoryModel?.data ?? [];
      } else {
        Get.snackbar('Error', 'Failed to load reservations');
      }
    } catch (error) {
      if (kDebugMode) print('Fetch reservation list error: $error');
    } finally {
      isLoading = false;
      update();
    }
  }
}
