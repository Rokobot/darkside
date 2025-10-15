class TwoFactorResponse {
  final String secret;
  final String qrCodeUrl;
  final bool twoFactorEnable;
  final String downloadApp;
  final String iosApp;

  TwoFactorResponse({
    required this.secret,
    required this.qrCodeUrl,
    required this.twoFactorEnable,
    required this.downloadApp,
    required this.iosApp,
  });

  factory TwoFactorResponse.fromJson(Map<String, dynamic> json) {
    return TwoFactorResponse(
      secret: json['secret'],
      qrCodeUrl: json['qrCodeUrl'],
      twoFactorEnable: json['towFactorEnable'],
      downloadApp: json['downloadApp'],
      iosApp: json['iosApp'],
    );
  }
}
