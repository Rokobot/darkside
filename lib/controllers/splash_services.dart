import 'package:food_app/controllers/user_preference_controller.dart';
import 'package:food_app/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  UserPreference userPreference = UserPreference();

  void isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardingShown = prefs.getBool('onboardingShown');

    if (onboardingShown == true) {
      userPreference.getUser().then((value) {
        if (value.token != null) {
          Get.offAllNamed(RoutesName.homeScreen);
        } else {
          Get.offAllNamed(RoutesName.loginScreen);
        }
      });
    } else {
      Get.toNamed(RoutesName.onbordingScreen);
    }
  }
}
