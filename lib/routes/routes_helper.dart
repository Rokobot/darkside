import 'package:food_app/routes/page_index.dart';
import 'package:food_app/views/screens/my_cart/card_payment_screen.dart';
import 'package:food_app/views/screens/my_cart/manual_payment_screen.dart';
import 'package:food_app/views/screens/my_cart/payment_screen.dart';
import 'package:food_app/views/screens/my_cart/shipping_screen.dart';
import 'package:food_app/views/screens/my_cart/transaction_screen.dart';
import 'package:food_app/views/screens/orders/chat_screen.dart';
import 'package:food_app/views/screens/orders/order_details_screen.dart';
import 'package:food_app/views/screens/address/address_view_screen.dart';
import 'package:food_app/views/screens/address/create_address_screen.dart';
import 'package:food_app/views/screens/orders/track_order_screen.dart';
import 'package:food_app/views/screens/reservation/reservation_history_screen.dart';
import 'package:food_app/views/screens/reservation/reservation_screen.dart';
import 'package:food_app/views/widgets/webview.dart';
import 'routes_name.dart';
import '../views/screens/auth/sign_up_screen.dart';
import '../views/screens/profile/change_password_screen.dart';

class RouteHelper {
  static List<GetPage<dynamic>> routes() => [
        GetPage(name: RoutesName.initial, page: () => const SplashScreen(), transition: Transition.zoom),
        GetPage(name: RoutesName.onbordingScreen, page: () => const OnbordingScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.bottomNavBar, page: () => const BottomNavBar(), transition: Transition.fade),
        GetPage(name: RoutesName.loginScreen, page: () => const LoginScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.signUpScreen, page: () => const SignUpScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.homeScreen, page: () => const HomeScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => const ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(name: RoutesName.editProfileScreen, page: () => const EditProfileScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => const ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => const SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => const SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => const CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => const TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(name: RoutesName.addressListScreen, page: () => const AddressListScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen, page: () => const NotificationScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.productScreen, page: () => const ProductScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.filterScreen, page: () => const FilterScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.productDetailsScreen,
            page: () => const ProductDetailsScreen(),
            transition: Transition.fade),
        GetPage(name: RoutesName.wishlistScreen, page: () => const WishlistScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.myOrdersScreen, page: () => const MyOrdersScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.trackOrderScreen, page: () => const TrackOrderScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.orderDetailsScreen, page: () => const OrderDetailsScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.myCartScreen, page: () => const MyCartScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.addressViewScreen, page: () => const AddressViewScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.createAddressScreen, page: () => const CreateAddressScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.shippingScreen, page: () => const ShippingScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.paymentScreen, page: () => const PaymentScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.webView, page: () => const CustomWebView(), transition: Transition.fade),
        GetPage(name: RoutesName.cardPaymentScreen, page: () => const CardPaymentScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.transactionScreen, page: () => const TransactionScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.orderChatScreen, page: () => const OrderChatScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.reservationScreen, page: () => const ReservationScreen(), transition: Transition.fade),
        GetPage(name: RoutesName.reservationHistoryScreen, page: () =>  ReservationHistoryScreen(), transition: Transition.fade),
        GetPage(
            name: RoutesName.manualPaymentScreen, page: () => const ManualPaymentScreen(), transition: Transition.fade),
      ];
}
