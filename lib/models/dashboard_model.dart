class DashboardModel {
  final int currentYear;
  final String monthName;
  final String balance;
  final int totalOrder;
  final int cancelOrder;
  final int completeOrder;
  final int thisMonthOrder;
  final int thisYearOrder;
  final String baseCurrency;
  final String baseCurrencySymbol;
  final int emailVerification;
  final int smsVerification;
  final int twoFaVerification;

  DashboardModel({
    required this.currentYear,
    required this.monthName,
    required this.balance,
    required this.totalOrder,
    required this.cancelOrder,
    required this.completeOrder,
    required this.thisMonthOrder,
    required this.thisYearOrder,
    required this.baseCurrency,
    required this.baseCurrencySymbol,
    required this.emailVerification,
    required this.smsVerification,
    required this.twoFaVerification,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      currentYear: json['current_year'],
      monthName: json['month_name'],
      balance: json['balance'],
      totalOrder: json['total_order'],
      cancelOrder: json['cancel_order'],
      completeOrder: json['complete_order'],
      thisMonthOrder: json['this_month_order'],
      thisYearOrder: json['this_year_order'],
      baseCurrency: json['base_currency'],
      baseCurrencySymbol: json['base_currency_symbol'],
      emailVerification: json['email_verification'],
      smsVerification: json['sms_verification'],
      twoFaVerification: json['two_fa_verify'],
    );
  }
}
