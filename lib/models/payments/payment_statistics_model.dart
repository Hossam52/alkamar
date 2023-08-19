class PaymentStatisticsModel {
  bool status;
  String message;
  int paid;
  int notPaid;
  int latePaid;
  int notAssigned;
  int disabled;
  int totalStudents;
  int totalPaid;
  PaymentStatisticsModel({
    required this.status,
    required this.message,
    required this.paid,
    required this.notPaid,
    required this.latePaid,
    required this.notAssigned,
    required this.disabled,
    required this.totalStudents,
    required this.totalPaid,
  });

  factory PaymentStatisticsModel.fromMap(Map<String, dynamic> map) {
    return PaymentStatisticsModel(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      paid: map['paid']?.toInt() ?? 0,
      notPaid: map['not_paid']?.toInt() ?? 0,
      latePaid: map['late_paid']?.toInt() ?? 0,
      notAssigned: map['not_assigned']?.toInt() ?? 0,
      disabled: map['disabled']?.toInt() ?? 0,
      totalStudents: map['total_students']?.toInt() ?? 0,
      totalPaid: map['total_paid']?.toInt() ?? 0,
    );
  }
}
