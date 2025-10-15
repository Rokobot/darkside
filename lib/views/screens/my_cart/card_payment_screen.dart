import 'package:food_app/config/app_colors.dart';
import 'package:food_app/controllers/language_controller.dart';
import 'package:food_app/controllers/payment_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/themes/themes.dart';
import 'package:food_app/views/widgets/app_button.dart';
import 'package:food_app/views/widgets/custom_appbar.dart';
import 'package:get/get.dart';

class CardPaymentScreen extends StatefulWidget {
  static const String routeName = "/cardPaymentScreen";
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final paymentController = Get.put(PaymentController());
  final languageController = Get.put(LanguageController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCvvFocused = false;

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      paymentController.submitCardPayment();
      if (kDebugMode) {
        print('valid!');
      }
    } else {
      if (kDebugMode) {
        print('invalid!');
      }
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      paymentController.cardNumber = creditCardModel.cardNumber;
      paymentController.expiryDate = creditCardModel.expiryDate;
      paymentController.cardHolderName = creditCardModel.cardHolderName;
      paymentController.cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (paymentController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: languageController.languageData["Card Details"] ?? "Card Details",
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 0.h, left: 4.w, right: 4.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CreditCardWidget(
                  cardNumber: paymentController.cardNumber,
                  expiryDate: paymentController.expiryDate,
                  cardHolderName: paymentController.cardHolderName,
                  cvvCode: paymentController.cvvCode,
                  bankName: 'Bank',
                  frontCardBorder: Border.all(color: AppColors.mainColor),
                  backCardBorder: Border.all(color: AppColors.mainColor),
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: AppColors.mainColor,
                  backgroundImage: 'assets/images/card.png',
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  // margin: EdgeInsets.all(16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: false,
                          obscureNumber: false,
                          cardNumber: paymentController.cardNumber,
                          cvvCode: paymentController.cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: paymentController.cardHolderName,
                          expiryDate: paymentController.expiryDate,
                          inputConfiguration: InputConfiguration(
                            cardNumberDecoration: InputDecoration(
                              labelText: languageController.languageData['Number'] ?? 'Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: EdgeInsets.all(12.w),
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
                            expiryDateDecoration: InputDecoration(
                              labelText: languageController.languageData['Expired Date'] ?? 'Expired Date',
                              hintText: 'XX/XX',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: EdgeInsets.all(12.w),
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
                            cvvCodeDecoration: InputDecoration(
                              labelText: languageController.languageData['CVV'] ?? 'CVV',
                              hintText: 'XXX',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: EdgeInsets.all(12.w),
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
                            cardHolderDecoration: InputDecoration(
                              labelText: languageController.languageData['Card Holder'] ?? 'Card Holder',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: EdgeInsets.all(12.w),
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
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading: paymentController.isLoading,
                              onTap: _onValidate,
                              text: languageController.languageData['Make Payment'] ?? 'Make Payment',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
