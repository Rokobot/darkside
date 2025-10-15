import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/controllers/reservation_controller.dart';
import 'package:food_app/models/add_reservation_model.dart';
import 'package:food_app/models/reservation_table_model.dart';
import 'package:food_app/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {


  /// Time picker builder
  Widget _buildTimePickerField(
      BuildContext context,
      TextEditingController controller,
      String hint,
      ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final now = DateTime.now();
          final selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final formattedTime = DateFormat('HH:mm').format(selectedDateTime);
          setState(() {
            controller.text = formattedTime; // seçilmiş saat controller-a yazılır
          });
        }
      },
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(14.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: AppColors.mainColor,
            width: 1.w,
          ),
        ),
        filled: true,
        fillColor: AppThemes.getFillColor(),
      ),
    );
  }



  final ReservationController reservationController =
  Get.put(ReservationController());

  /// Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController tablesController = TextEditingController();
  final TextEditingController reservationDateController = TextEditingController();
  final TextEditingController toReservationDateController = TextEditingController();
  final TextEditingController fromReservationDateController = TextEditingController();

  String? selectedTable; // for dropdown

  @override
  void initState() {
    super.initState();
    reservationController.fetchReservationTables();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Reservation"),
        body: GetBuilder<ReservationController>(
          builder: (controller) {
            return Container(
              margin: EdgeInsets.all(8.dm),
              width: double.infinity,
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Name
                    CustomTextField(
                      isPrefixIcon: false,
                      hintext: "Your Name",
                      controller: userNameController,
                    ),
                    20.verticalSpace,

                    /// Email
                    CustomTextField(
                      isPrefixIcon: false,
                      hintext: "Your Email",
                      controller: emailController,
                    ),
                    20.verticalSpace,

                    /// Phone
                    CustomTextField(
                      isPrefixIcon: false,
                      hintext: "Phone Number",
                      controller: phoneNumberController,
                    ),
                    20.verticalSpace,

                    /// Person
                   /* CustomTextField(

                      isPrefixIcon: false,
                      hintext: "Person",
                      controller: personController,
                    ),*/

                    PersonTextField(controller: personController),
                    20.verticalSpace,

                    /// Reservation Date
                    _buildDatePickerField(
                       context, reservationDateController, "Reservation Date"),
                    20.verticalSpace,
                    _buildTimePickerField(context, fromReservationDateController, "From"),
                    20.verticalSpace,
                    _buildTimePickerField(context, toReservationDateController, "To"),
                    20.verticalSpace,
                    /// Dropdown for tables

                    TableSelectorField(
                      controller: tablesController,
                      tablesList: controller.tablesList!,
                      onTableSelected: (table) {
                        selectedTable = table.id.toString();
                        print("selectedTable: ${selectedTable}");
                      },
                    ),

                    30.verticalSpace,

                    /// Message
                    SizedBox(
                      height: 150,
                      child: CustomTextField(
                        isPrefixIcon: false,
                        hintext: "Write Message...",
                        controller: messageController,
                      ),
                    ),



                    70.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: /// ✅ Submit Button
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            onPressed: () async {
              if (selectedTable == null ||
                  userNameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  phoneNumberController.text.isEmpty ||
                  reservationDateController.text.isEmpty ||
                  fromReservationDateController.text.isEmpty ||
                  toReservationDateController.text.isEmpty ||
                  personController.text.isEmpty) {
                Get.snackbar('Error', 'Please fill all required fields');
                Get.snackbar('Error', 'Please fill all required fields${selectedTable}');
                Get.snackbar('Error', 'Please fill all required fields${userNameController.text}');
                Get.snackbar('Error', 'Please fill all required fields${emailController.text}');
                Get.snackbar('Error', 'Please fill all required fields${phoneNumberController.text}');
                Get.snackbar('Error', 'Please fill all required fields${reservationDateController.text}');
                Get.snackbar('Error', 'Please fill all required fields${fromReservationDateController.text}');
                Get.snackbar('Error', 'Please fill all required fields${toReservationDateController.text}');
                Get.snackbar('Error', 'Please fill all required fields${personController.text}');
                return;
              }

              /// Create the reservation model
              final addReservation = AddReservationModel(
                table: selectedTable!,
                name: userNameController.text.trim(),
                email: emailController.text.trim(),
                number: phoneNumberController.text.trim(),
                date: reservationDateController.text.trim(),
                timeFrom: fromReservationDateController.text.trim(),
                timeTo: toReservationDateController.text.trim(),
                person: personController.text.trim(),
                message: messageController.text.trim().isNotEmpty
                    ? messageController.text.trim()
                    : null,
              );

              /// Call the controller method
              reservationController.addReservation(addReservation);
            },
            child: Text(
              "Reserve Table",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  /// Date picker builder method
  Widget _buildDatePickerField(
      BuildContext context, TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
      readOnly: true,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(14.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: AppColors.mainColor,
            width: 1.w,
          ),
        ),
        filled: true,
        fillColor: AppThemes.getFillColor(),
      ),
    );
  }
}


class PersonTextField extends StatefulWidget {
  final TextEditingController controller;
  const PersonTextField({super.key, required this.controller});

  @override
  State<PersonTextField> createState() => _PersonTextFieldState();
}

class _PersonTextFieldState extends State<PersonTextField> {
  int person = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.text = person.toString();
  }

  void _increment() {
    setState(() {
      person += 1;
      widget.controller.text = person.toString();
    });
  }

  void _decrement() {
    if (person > 1) {
      setState(() {
        person -= 1;
        widget.controller.text = person.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: 'Person',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // underline-lu border yox
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class TableSelectorField extends StatefulWidget {
  final TextEditingController controller;
  final List<TableItem> tablesList;
  final ValueChanged<TableItem> onTableSelected; // seçilmiş table-i geri qaytarmaq

  const TableSelectorField({
    super.key,
    required this.controller,
    required this.tablesList,
    required this.onTableSelected,
  });

  @override
  State<TableSelectorField> createState() => _TableSelectorFieldState();
}

class _TableSelectorFieldState extends State<TableSelectorField> {
  TableItem? selectedTableInDialog;

  void _openTableDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TableItem? tempSelected = selectedTableInDialog;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            height: 450,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Select a Table',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: widget.tablesList.length,
                              itemBuilder: (context, index) {
                                final table = widget.tablesList[index];
                                final isSelected = tempSelected?.id == table.id;

                                return GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      tempSelected = table;
                                    });
                                  },
                                  child: AnimatedScale(
                                    scale: isSelected ? 1.05 : 1.0,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected ? Colors.blueAccent : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 6,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/tables_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                  if (!isSelected)
                                                    BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        color: Colors.black.withOpacity(0.3),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 6),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                                            ),
                                            child: Text(
                                              table.tableNo ?? 'Table ${table.id}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                shadows: [
                                                  Shadow(
                                                    offset: Offset(0, 1),
                                                    blurRadius: 2,
                                                    color: Colors.black54,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tempSelected != null ? Colors.blue : Colors.grey,
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: tempSelected == null
                                ? null
                                : () {
                              setState(() {
                                selectedTableInDialog = tempSelected;
                                widget.controller.text = selectedTableInDialog!.tableNo ??
                                    'Table ${selectedTableInDialog!.id}';
                              });
                              widget.onTableSelected(selectedTableInDialog!); // ✅ seçilmiş table geri ver
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Select',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      onTap: _openTableDialog,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textFieldHintColor),
      decoration: InputDecoration(
        hintText: 'Select Table',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}



