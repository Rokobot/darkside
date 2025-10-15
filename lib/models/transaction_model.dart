class TransactionModel {
  final int id;
  final dynamic userId;
  final String amount;
  final String charge;
  final String trxType;
  final String remarks;
  final String trxId;
  final String createdAt;
  final String updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.charge,
    required this.trxType,
    required this.remarks,
    required this.trxId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'].toString(),
      charge: json['charge'].toString(),
      trxType: json['trx_type'],
      remarks: json['remarks'],
      trxId: json['trx_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
