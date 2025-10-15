import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/themes/themes.dart';
import 'package:get/get.dart';

import '../../../controllers/reservation_controller.dart';
import '../../widgets/custom_appbar.dart';

class ReservationHistoryScreen extends StatelessWidget {
  ReservationHistoryScreen({super.key});

  // Controller instance
  final ReservationController reservationController =
  Get.put(ReservationController());

  @override
  Widget build(BuildContext context) {
    // Fetch data when screen is opened
    reservationController.fetchReservationList();

    return Scaffold(
      appBar: const CustomAppBar(title: "Reservation History"),
      body: GetBuilder<ReservationController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.reservationList!.isEmpty) {
            return const Center(child: Text("No reservations found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.reservationList!.length,
            itemBuilder: (context, index) {
              final item = controller.reservationList![index];
              return GestureDetector(
                onTap: () {
                  _showReservationDialog(context, item);
                },
                child: AnimatedContainer(

                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Text(
                    "Reservation ID: ${item.id}",
                    style:  TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReservationDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) {

        final Map<String, String?> details = {
          "Name": item.name,
          "Email": item.email,
          "Number": item.number,
          "Person": item.person.toString(),
          "Time From": item.timeFrom,
          "Time To": item.timeTo,
          "Date": item.date,
          "Table": "Table#${item.tableId}",
          "Message": item.message ?? "N/A",
        };

        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppBarTheme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: details.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${e.key}:",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: Text(
                            e.value ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
