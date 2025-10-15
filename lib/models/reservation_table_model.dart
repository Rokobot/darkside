class ReservationTableModel {
  final String? status;
  final ReservationData? data;
  final String? message;

  ReservationTableModel({
    this.status,
    this.data,
    this.message,
  });

  factory ReservationTableModel.fromJson(Map<String, dynamic> json) {
    return ReservationTableModel(
      status: json['status'] as String?,
      data: json['data'] != null
          ? ReservationData.fromJson(json['data'])
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class ReservationData {
  final List<TableItem>? tables;

  ReservationData({this.tables});

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      tables: json['tables'] != null
          ? List<TableItem>.from(
          json['tables'].map((x) => TableItem.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tables': tables?.map((x) => x.toJson()).toList(),
    };
  }
}

class TableItem {
  final int? id;
  final String? tableNo;
  final String? sit;
  final int? status;
  final int? isEmpty;
  final String? createdAt;
  final String? updatedAt;
  final String? ip;

  TableItem({
    this.id,
    this.tableNo,
    this.sit,
    this.status,
    this.isEmpty,
    this.createdAt,
    this.updatedAt,
    this.ip,
  });

  factory TableItem.fromJson(Map<String, dynamic> json) {
    return TableItem(
      id: json['id'],
      tableNo: json['table_no'],
      sit: json['sit'],
      status: json['status'],
      isEmpty: json['is_empty'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ip: json['ip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_no': tableNo,
      'sit': sit,
      'status': status,
      'is_empty': isEmpty,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'ip': ip,
    };
  }
}
