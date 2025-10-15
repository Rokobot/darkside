import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/controllers/payment_controller.dart';
import 'package:food_app/controllers/sdk_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/app_controller.dart';
import 'controllers/bindings/bindings.dart';
import 'routes/routes_helper.dart';
import 'routes/routes_name.dart';
import 'themes/themes.dart';
import 'utils/app_constants.dart';
import 'utils/services/localstorage/init_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await Future.delayed(const Duration(milliseconds: 400));
  Stripe.publishableKey = "pk_test_AU3G7doZ1sbdpJLj0NaozPBu";
  Get.put(SdkPaymentController()); // make sure this is called before PaymentController
  Get.put(PaymentController());

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          initialBinding: InitBindings(),
          themeMode: Get.put(AppController()).themeManager(),
          initialRoute: RoutesName.initial,
          getPages: RouteHelper.routes(),
        );
      },
    );
  }
}
