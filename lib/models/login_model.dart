class LoginResponse {
  final String? token;
  final bool? isLogin;

  LoginResponse({required this.isLogin, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['data']['message'],
      isLogin: json['data']['token'],
    );
  }
}
