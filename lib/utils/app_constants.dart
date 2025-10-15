class AppConstants {
  static const String appName = 'Darkside';
  static String baseCurrency = '';

  // BASE_URL
  static const String baseUrl = 'https://restoran.darkside.az/api'; // eg: https://youdomanname.com/api

  // END_POINTS_URL
  static const String appConfigUrl = 'app-config';
  static const String languageUrl = '$baseUrl/languages/';
  static const String onboardingUrl = '$baseUrl/welcome';
  static const String registerUrl = '$baseUrl/register';
  static const String loginUrl = '$baseUrl/login';
  static const String forgotPassUrl = '$baseUrl/recovery-pass/get-email';
  static const String forgotPassGetCodeUrl = '$baseUrl/recovery-pass/get-code';
  static const String updatePassUrl = '$baseUrl/update-pass';
  static const String changePassUrl = '$baseUrl/updatePassword';

  static const String menuCategoriesUrl = '$baseUrl/menu/categories';
  static const String menuUrl = '$baseUrl/menus/1';
  static const String menuDetailsUrl = '$baseUrl/menu/';
  static const String filterMenuUrl = '$baseUrl/search/product?';
  static const String addWishlistUrl = '$baseUrl/add-to-wishlist/';
  static const String wishlistUrl = '$baseUrl/wishlist';
  static const String orderUrl = '$baseUrl/orders';
  static const String orderDetailsUrl = '$baseUrl/show-order/';
  static const String addReviewUrl = '$baseUrl/rating';
  static const String orderChatUrl = '$baseUrl/push-chat-show/';
  static const String replyOrderChatUrl = '$baseUrl/push-chat-newMessage';
  static const String reservationUrl = '$baseUrl/reservation';
  static const String reservationListUrl = '$baseUrl/reservation-list';

  static const String dashboardUrl = '$baseUrl/user/dashboard-info';
  static const String profileUrl = '$baseUrl/profile';
  static const String profileUpdateUrl = '$baseUrl/update-profile';

  static const String ticketUrl = '$baseUrl/ticket';
  static const String ticketViewUrl = '$baseUrl/ticket/view/';
  static const String createTicketUrl = '$baseUrl/ticket/create';
  static const String replyTicketUrl = '$baseUrl/ticket/reply/';
  static const String closeTicketUrl = '$baseUrl/ticket/closed/';

  static const String twoFactorUrl = '$baseUrl/two-step-security';
  static const String enableTwoFactorUrl = '$baseUrl/twoStep-enable';
  static const String disableTwoFactorUrl = '$baseUrl/twoStep-disable';

  static const String addressUrl = '$baseUrl/address';
  static const String areasUrl = '$baseUrl/areas';
  static const String addressViewUrl = '$baseUrl/edit-address/';
  static const String editAddressUrl = '$baseUrl/update-address/';
  static const String createAddressUrl = '$baseUrl/create-address';
  static const String deleteAddressUrl = '$baseUrl/delete-address/';

  static const String couponCodeUrl = '$baseUrl/coupon-apply';
  static const String createOrderUrl = '$baseUrl/create-order';
  static const String gatewaysUrl = '$baseUrl/gateways';
  static const String paymentRequestUrl = '$baseUrl/order/make/payment';
  static const String paymentWebViewUrl = '$baseUrl/payment-webview/?trx_id=';
  static const String paymentDoneUrl = '$baseUrl/payment-done';
  static const String manualPaymentUrl = '$baseUrl/manual-payment/';
  static const String cardPaymentUrl = '$baseUrl/card-payment';
  static const String transactionUrl = '$baseUrl/transactions';

  static const String smsVerifyUrl = '$baseUrl/sms-verify';
  static const String emailVerifyUrl = '$baseUrl/mail-verify';
  static const String twoFaVerifyUrl = '$baseUrl/twoFA-Verify';
  static const String resendCodeUrl = '$baseUrl/resend_code?type=';
  static const String deleteAccountUrl = '$baseUrl/delete-account';
}

// ---------- IMAGE DIRECTORY --------- //
String rootImageDir = "assets/images";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";


// language api
// manual payment List
// app config base currency
// onboarding screen data