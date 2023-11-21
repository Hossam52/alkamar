import 'package:alqamar/models/payments/payment_status_enum.dart';
import 'package:intl/intl.dart';

class PaymentsModel {
  int id;
  int stageId;
  String title;
  bool status;
  int price;
  int month;
  int year;
  DateTime paymentDate;
  int? payment_status;
  int? student_id;
  int? payment_id;
  DateTime? created_at;
  PaymentStatus paymentStatus;

  PaymentsModel({
    required this.id,
    required this.stageId,
    required this.title,
    required this.price,
    required this.status,
    required this.month,
    required this.year,
    required this.payment_status,
    required this.payment_id,
    required this.student_id,
    required this.created_at,
  })  : paymentDate = DateTime(year, month),
        paymentStatus = PaymentStatus.instance(payment_status);

  factory PaymentsModel.fromJson(Map<String, dynamic> json) {
    return PaymentsModel(
      id: json['id'],
      stageId: json['stage_id'],
      title: json['title'],
      status: json['status'],
      price: json['price'],
      month: json['month'],
      year: json['year'],
      payment_status: json['payment_status'],
      payment_id: json['payment_id'],
      student_id: json['student_id'],
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
    );
  }
  String get generateTitle {
    String title = paymentStatus.title;
    if (created_at != null) {
      title += '\n ${DateFormat('MM/dd').format(created_at!)}';
    }
    return title;
  }
}
