import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/models/student/students_paginate_model.dart';

class StudentPaymentsResponse {
  final StudentsPaginateModel studentsPaginateModel;
  List<StudentModel> get students => studentsPaginateModel.students;
  final List<PaymentsModel> payments;

  StudentPaymentsResponse(
      {required this.studentsPaginateModel, required this.payments}) {
    _reAssign();
  }

  factory StudentPaymentsResponse.fromJson(Map<String, dynamic> map) {
    return StudentPaymentsResponse(
      studentsPaginateModel: StudentsPaginateModel.fromMap(map),
      payments: List<PaymentsModel>.from(
          map['payments']?.map((x) => PaymentsModel.fromJson(x))),
    );
  }

  void _reAssign() {
    for (var std in students) {
      List<PaymentsModel> allPayments = [];
      for (var payment in payments) {
        final payments = std.payments;
        if (payments != null) {
          final res =
              payments.where((pay) => pay.payment_id == payment.id).firstOrNull;
          if (res == null) {
            final pay = PaymentsModel(
              id: payment.id,
              month: payment.month,
              payment_id: payment.id,
              price: payment.price,
              stageId: payment.stageId,
              status: payment.status,
              title: payment.title,
              year: payment.year,
              payment_status: null,
              student_id: null,
              created_at: null,
            );

            allPayments.add(pay);
          } else {
            allPayments.add(res);
          }
        }
      }
      std.payments = allPayments;
    }
  }

  void setPayment(PaymentsModel payment) {
    int studentIndex =
        students.indexWhere((element) => element.id == payment.student_id);
    if (studentIndex == -1) return;
    students[studentIndex].setPayment(payment);
  }
}
