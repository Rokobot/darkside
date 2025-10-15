import 'package:food_app/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  Future<bool> saveUser(LoginResponse response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token.toString());
    await prefs.setBool('isLogin', response.isLogin!);
    return true;
  }

  Future<LoginResponse> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool? isLogin = prefs.getBool('isLogin');
    return LoginResponse(
      token: token,
      isLogin: isLogin,
    );
  }

  Future<bool> markOnboardingAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardingShown', true);
    return true;
  }

  Future<void> saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<Map<String, String?>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return {
      'username': username,
      'password': password,
    };
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  Future<bool> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('isLogin');
    return true;
  }
}
