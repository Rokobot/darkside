import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/address_controller.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/payment_controller.dart';
import 'package:food_app/controllers/sdk_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:super_tooltip/super_tooltip.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = "/paymentScreen";
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final sdkPaymentController = Get.put(SdkPaymentController());
  final paymentController = Get.put(PaymentController());
  final cartController = Get.put(CartController());
  final addressController = Get.put(AddressController());
  final languageController = Get.put(LanguageController());

  final TextEditingController searchCurrencyController = TextEditingController();

  // Filter the gateways based on the search text
  TextEditingController searchController = TextEditingController();
  void onSearchTextChanged(String text) {
    setState(() {
      if (paymentController.gateways.isNotEmpty) {
        // paymentController.filteredGateways = paymentController.gateways.where((gateway) {
        //   return gateway['code'].toLowerCase().contains(text.toLowerCase());
        // }).toList();
        paymentController.filteredGateways = paymentController.gateways.where((gateway) {
          return gateway['code'] != 'paystack' &&
              gateway['code'] != 'paytm' &&
              gateway['code'].toLowerCase().contains(text.toLowerCase());
        }).toList();
      }
    });
  }

  bool _isClicked = false;
  void startLoading() {
    setState(() {
      _isClicked = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isClicked = false;
      });
    });
  }

  PaymentMethod _selectedMethod = PaymentMethod.onlinePayment;
  dynamic orderId = Get.arguments;

  @override
  void initState() {
    super.initState();
    paymentController.fetchPaymentMethods();
  }

  @override
  void dispose() {
    Get.delete<PaymentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<PaymentController>(builder: (paymentController) {
      return GetBuilder<CartController>(builder: (cartController) {
        return GetBuilder<AddressController>(builder: (addressController) {
          return Scaffold(
            appBar: CustomAppBar(title: languageController.languageData["Payment Method"] ?? "Payment Method"),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        RadioListTile<PaymentMethod>(
                          title: Text(
                            languageController.languageData['Cash on Delivery'] ?? 'Cash on Delivery',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          activeColor: AppColors.mainColor,
                          value: PaymentMethod.cashOnDelivery,
                          groupValue: _selectedMethod,
                          onChanged: (PaymentMethod? value) {
                            setState(() {
                              _selectedMethod = value!;
                            });
                          },
                        ),
                        RadioListTile<PaymentMethod>(
                          title: Text(
                            languageController.languageData['Online Payment'] ?? 'Online Payment',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          activeColor: AppColors.mainColor,
                          value: PaymentMethod.onlinePayment,
                          groupValue: _selectedMethod,
                          onChanged: (PaymentMethod? value) {
                            setState(() {
                              _selectedMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gateways
                      _selectedMethod == PaymentMethod.onlinePayment
                          ? Container(
                              padding: EdgeInsets.all(20.w),
                              margin: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: Text(
                                          languageController.languageData["Select Payment Method"] ??
                                              "Select Payment Method",
                                          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 16.sp),
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: TextFormField(
                                          controller: searchController,
                                          onChanged: onSearchTextChanged,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          decoration: InputDecoration(
                                            hintText: languageController.languageData["Search"] ?? "Search",
                                            prefixIconConstraints: BoxConstraints(maxWidth: 40.w, minWidth: 40.w),
                                            prefixIcon: Icon(CupertinoIcons.search, size: 18.sp),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15.r),
                                              borderSide: const BorderSide(color: AppColors.borderColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15.r),
                                              borderSide: BorderSide(
                                                color: AppColors.mainColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: AppThemes.getFillColor(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    height: 60.h,
                                    width: double.infinity,
                                    child: !paymentController.isScreenLoading
                                        ? paymentController.filteredGateways.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: paymentController.filteredGateways.length,
                                                itemBuilder: (context, index) {
                                                  var gateway = paymentController.filteredGateways[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        paymentController.selectedGateway = gateway;
                                                        paymentController.storeGatewayParameters();
                                                        paymentController.filterSupportedCurrencies(gateway["code"]);
                                                        paymentController.selectedCurrency = null;
                                                        if (paymentController.selectedCurrency != null) {
                                                          paymentController.supportedCurrencyList
                                                              .add(paymentController.selectedCurrency);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 100.w,
                                                      height: 60.h,
                                                      margin: EdgeInsets.only(right: 5.w),
                                                      padding: EdgeInsets.all(3.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.r),
                                                        border: Border.all(
                                                          color: paymentController.selectedGateway == gateway
                                                              ? AppColors.mainColor
                                                              : AppThemes.borderColor(),
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12.r),
                                                        child: Image.network(
                                                          gateway["image"],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/images/not_found.png", width: 40.w),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                        languageController.languageData["No Gateways Found!"] ??
                                                            "No Gateways Found!",
                                                        style: Theme.of(context).textTheme.bodySmall),
                                                  ],
                                                ),
                                              )
                                        : Center(
                                            child: SizedBox(
                                              width: 24.r,
                                              height: 24.r,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                                                strokeWidth: 2.0,
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(height: 20.h),
                      // currency & calculation
                      Container(
                        padding: EdgeInsets.all(20.w),
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Get.isDarkMode ? AppColors.darkCardColor : AppColors.filledColor,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _selectedMethod == PaymentMethod.onlinePayment && paymentController.selectedGateway != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            languageController.languageData["Select Payable Currency"] ??
                                                "Select Payable Currency",
                                            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 16.sp),
                                          ),
                                          SizedBox(width: 5.w),
                                          SuperTooltip(
                                            showDropBoxFilter: false,
                                            popupDirection: TooltipDirection.up,
                                            minimumOutsideMargin: 20,
                                            content: Text(
                                              languageController
                                                      .languageData["The currency you want to make payment."] ??
                                                  "The currency you want to make payment.",
                                              style: Theme.of(context).textTheme.bodySmall,
                                              softWrap: true,
                                            ),
                                            child: const Icon(CupertinoIcons.info, size: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      DropdownButtonFormField2<String>(
                                        isExpanded: true,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(14.w),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.r),
                                            borderSide: const BorderSide(color: AppColors.borderColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.r),
                                            borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 1.w,
                                            ),
                                          ),
                                          errorStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: AppColors.redColor, fontSize: 12.sp),
                                          filled: true,
                                          fillColor: AppThemes.getFillColor(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return languageController.languageData['Please select currency.'] ??
                                                'Please select currency.';
                                          }
                                          return null;
                                        },
                                        items: paymentController.supportedCurrencyList
                                            .toSet()
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        value: paymentController.selectedCurrency,
                                        onChanged: (value) {
                                          paymentController.selectedCurrency = value;
                                          if (paymentController.selectedGateway != null &&
                                              paymentController.selectedGateway['id'] > 999) {
                                            paymentController.receivableCurrency =
                                                paymentController.receivableCurrencyList.firstWhere(
                                              (currencyInfo) => currencyInfo['currency'] == value,
                                              orElse: () => <String, dynamic>{},
                                            );
                                          } else {
                                            paymentController.receivableCurrency =
                                                paymentController.receivableCurrencyList.firstWhere(
                                              (currencyInfo) => currencyInfo['name'] == value,
                                              orElse: () => <String, dynamic>{},
                                            );
                                          }
                                          if (paymentController.receivableCurrency != null) {
                                            paymentController.calculatePayableAmount(
                                              double.parse(addressController.totalAmount.toString()),
                                              double.parse(
                                                  paymentController.receivableCurrency!['conversion_rate'].toString()),
                                              double.parse(
                                                  paymentController.receivableCurrency!['fixed_charge'].toString()),
                                              double.parse(paymentController.receivableCurrency!['percentage_charge']
                                                  .toString()),
                                            );
                                          }
                                          setState(() {});
                                          if (kDebugMode) {
                                            print(
                                                "paymentController.selectedCurrency: ${paymentController.selectedCurrency}");
                                          }
                                          if (kDebugMode) {
                                            print(
                                                "paymentController.receivableCurrency: ${paymentController.receivableCurrency!['name']}");
                                          }
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          padding: EdgeInsets.all(0.w),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                          ),
                                          iconSize: 18.sp,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14.w),
                                            // color: AppColors.getContainerColor(),
                                          ),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness: WidgetStateProperty.all(3),
                                            thumbVisibility: WidgetStateProperty.all(true),
                                            thumbColor: const WidgetStatePropertyAll(AppColors.borderColor),
                                          ),
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          padding: EdgeInsets.only(left: 14.w),
                                        ),
                                        dropdownSearchData: DropdownSearchData(
                                          searchController: searchCurrencyController,
                                          searchInnerWidgetHeight: 50,
                                          searchInnerWidget: Container(
                                            margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
                                            child: TextFormField(
                                              controller: searchCurrencyController,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              decoration: InputDecoration(
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
                                                errorStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(color: AppColors.redColor, fontSize: 12.sp),
                                                filled: true,
                                                fillColor: AppThemes.getFillColor(),
                                              ),
                                            ),
                                          ),
                                          searchMatchFn: (item, searchValue) {
                                            return item.value.toString().toLowerCase().contains(searchValue);
                                          },
                                        ),
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCurrencyController.clear();
                                          }
                                        },
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  )
                                : const SizedBox(),
                            Text(
                              languageController.languageData["Payment Preview"] ?? "Payment Preview",
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20.sp),
                            ),
                            SizedBox(height: 15.h),
                            SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageController.languageData["Subtotal:"] ?? "Subtotal:"),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: addressController.discountAmount! > 0
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${AppConstants.baseCurrency}${cartController.totalPrice.toStringAsFixed(2)}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(decoration: TextDecoration.lineThrough),
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                        "${AppConstants.baseCurrency}${addressController.amountAfterDiscount!.toStringAsFixed(2)}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis)
                                                  ],
                                                )
                                              : Text(
                                                  "${AppConstants.baseCurrency}${cartController.totalPrice.toStringAsFixed(2)}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageController.languageData["Discount: "] ?? "Discount: "),
                                      addressController.discountType != '%'
                                          ? Text(
                                              "${addressController.discountType}${addressController.discountAmount.toString()} ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: AppColors.redColor),
                                            )
                                          : Text(
                                              "${addressController.discountAmount.toString()}${addressController.discountType}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: AppColors.redColor),
                                            )
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageController.languageData["Shipping Charge:"] ?? "Shipping Charge:"),
                                      Text(
                                        "${AppConstants.baseCurrency}${addressController.shippingCharge.toString()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.greenColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageController.languageData["Vat:"] ?? "Vat:"),
                                      Text(
                                        "${addressController.vat.toString()}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.greenColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Text(languageController.languageData["Total:"] ?? "Total:"),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              "${AppConstants.baseCurrency}${addressController.totalAmount!.toStringAsFixed(2)}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _selectedMethod == PaymentMethod.cashOnDelivery
                                ? Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: AppButton(
                                        isLoading: paymentController.isLoading,
                                        onTap: () {
                                          paymentController.submitCashOnDelivery(orderId);
                                        },
                                        text: languageController.languageData['Confirm Order'] ?? 'Confirm Order',
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            if (_selectedMethod == PaymentMethod.onlinePayment &&
                                paymentController.selectedCurrency != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageController.languageData["Payable:"] ?? "Payable:",
                                          style: t.bodyLarge?.copyWith(fontSize: 18.sp)),
                                      Expanded(
                                        child: Text(
                                          "${double.parse(paymentController.totalPayableAmountForDisplay.toString()).toStringAsFixed(2)}${paymentController.selectedCurrency}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          style: t.bodyLarge?.copyWith(fontSize: 18.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  paymentController.selectedGateway != null &&
                                          paymentController.selectedGateway['id'] < 1000
                                      ? Container(
                                          margin: EdgeInsets.only(top: 16.h),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: AppButton(
                                              isLoading: _isClicked,
                                              onTap: _isClicked == true
                                                  ? null
                                                  : () async {
                                                      startLoading();

                                                      paymentController.trxId == null
                                                          ? await paymentController.submitPaymentRequest(orderId, false)
                                                          : () {};

                                                      // stripe
                                                      if (paymentController.selectedGateway['code'] == "stripe") {
                                                        sdkPaymentController.stripeMakePayment(
                                                            amount: paymentController.totalPayableAmount.toString());
                                                      }
                                                      // razorpay
                                                      else if (paymentController.selectedGateway['code'] ==
                                                          "razorpay") {
                                                        sdkPaymentController.razorpayMakePayment(
                                                            amount: paymentController.totalPayableAmount.toString());
                                                      }
                                                      // flutterwave
                                                      else if (paymentController.selectedGateway['code'] ==
                                                          "flutterwave") {
                                                        sdkPaymentController.flutterwaveMakePayment(
                                                            amount: paymentController.totalPayableAmount.toString());
                                                      }
                                                      // monnify
                                                      else if (paymentController.selectedGateway['code'] == "monnify") {
                                                        sdkPaymentController.monnifyMakePayment(
                                                            amount: paymentController.totalPayableAmount!.toDouble());
                                                      }
                                                      // paytm
                                                      // else if (paymentController.selectedGateway['code'] == "paytm") {
                                                      //   sdkPaymentController.paytmMakePayment(
                                                      //       amount: paymentController.totalPayableAmount!.toString());
                                                      // }
                                                      // paypal
                                                      else if (paymentController.selectedGateway['code'] == "paypal") {
                                                        sdkPaymentController.paypalMakePayment(
                                                            amount: paymentController.totalPayableAmount!.toString());
                                                      }
                                                      // paystack
                                                      // else if (paymentController.selectedGateway['code'] ==
                                                      //     'paystack') {
                                                      //   sdkPaymentController.paystackMakePayment(context,
                                                      //       amount: paymentController.totalPayableAmount!.toDouble());
                                                      // }
                                                      // authorizenet, securionpay (card payment)
                                                      else if (paymentController.selectedGateway['code'] ==
                                                              "authorizenet" ||
                                                          paymentController.selectedGateway['code'] == "securionpay") {
                                                        Get.toNamed(RoutesName.cardPaymentScreen);
                                                      }
                                                      // automatic payment
                                                      else {
                                                        paymentController.submitWebview();
                                                      }
                                                    },
                                              text: languageController.languageData['Make Payment'] ?? 'Make Payment',
                                            ),
                                          ),
                                        )
                                      : SizedBox(height: 0.h),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _selectedMethod == PaymentMethod.onlinePayment &&
                              paymentController.selectedCurrency != null &&
                              paymentController.selectedGateway != null &&
                              paymentController.selectedGateway['id'] > 999
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Material(
                                color: Colors.transparent,
                                child: AppButton(
                                  isLoading: paymentController.isLoading,
                                  onTap: () async {
                                    paymentController.trxId == null
                                        ? await paymentController.submitPaymentRequest(orderId, true)
                                        : () {};
                                    // paymentController.submitManualPayment();
                                    Get.toNamed(RoutesName.manualPaymentScreen);
                                  },
                                  text: languageController.languageData['Make Payment'] ?? 'Make Payment',
                                ),
                              ),
                            )

                          // Container(
                          //     padding: EdgeInsets.all(20.w),
                          //     margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(16.r),
                          //       border: Border.all(
                          //         color: AppThemes.borderColor(),
                          //         width: 1.w,
                          //       ),
                          //     ),
                          //     child: Form(
                          //       key: _formKey,
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             languageController.languageData["Account Details"] ?? "Account Details",
                          //             style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20.sp),
                          //           ),
                          //           SizedBox(height: 20.h),
                          //           for (var fieldName in paymentController.selectedGateway['parameters'].entries)
                          //             buildFormField(fieldName.key),
                          //           SizedBox(height: 10.h),
                          //           Material(
                          //             color: Colors.transparent,
                          //             child: AppButton(
                          //               isLoading: paymentController.isLoading,
                          //               onTap: () async {
                          //                 if (_formKey.currentState!.validate()) {
                          //                   await paymentController.submitPaymentRequest(orderId, true);
                          //                   paymentController.submitManualPayment();
                          //                 }
                          //               },
                          //               text: languageController.languageData['Make Payment'] ?? 'Make Payment',
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ))
                          : const SizedBox(height: 0),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      });
    });
  }

  Widget buildFormField(dynamic fieldName) {
    var field = paymentController.selectedGateway['parameters'][fieldName] as Map<String, dynamic>;
    TextEditingController controller = paymentController.textControllers[fieldName]!;

    if (field['type'] == 'file') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(color: AppThemes.getFillColor(), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.r),
                  child: paymentController.pickedFiles[fieldName] == null
                      ? Image.asset(
                          "assets/images/drop.png",
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          color: AppColors.mainColor,
                        )
                      : Image.file(
                          paymentController.pickedFiles[fieldName]!,
                          width: 120.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          paymentController.pickedFiles[fieldName] = File(pickedFile.path);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(135.w, 35.h),
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    child: const Text("Choose file")),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    } else if (field['type'] == 'date') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                final formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
            readOnly: true,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
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
              errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.redColor, fontSize: 12.sp),
              filled: true,
              fillColor: AppThemes.getFillColor(),
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field['field_label']),
          SizedBox(height: 5.h),
          TextFormField(
            controller: controller,
            maxLines: field['type'] == 'textarea' ? 3 : 1,
            keyboardType: _getKeyboardType(field['type']),
            validator: (value) {
              if (field['validation'] == 'required' && value!.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
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
              errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.redColor, fontSize: 12.sp),
              filled: true,
              fillColor: AppThemes.getFillColor(),
            ),
          ),
          SizedBox(height: 15.h),
        ],
      );
    }
  }

  TextInputType _getKeyboardType(String fieldType) {
    switch (fieldType) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}

enum PaymentMethod { cashOnDelivery, onlinePayment }
