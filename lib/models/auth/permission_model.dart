// ignore_for_file: non_constant_identifier_names

import 'package:alqamar/models/permissions/available_permissions_model.dart';

class AllPermissionsModel {
  PermissionModel? assistants;
  PermissionModel? attendances;
  PermissionModel? exams;
  PermissionModel? grades;
  PermissionModel? homeworks;
  PermissionModel? lectures;
  PermissionModel? students;
  PermissionModel? student_payments;
  PermissionModel? payments;

  AllPermissionsModel(
      {this.assistants,
      this.attendances,
      this.exams,
      this.grades,
      this.homeworks,
      this.lectures,
      this.students,
      this.student_payments,
      this.payments});

  factory AllPermissionsModel.fromMap(Map<String, dynamic> map) {
    return AllPermissionsModel(
      assistants: map['assistants'] != null
          ? PermissionModel.fromMap(map['assistants'])
          : null,
      attendances: map['attendances'] != null
          ? PermissionModel.fromMap(map['attendances'])
          : null,
      exams:
          map['exams'] != null ? PermissionModel.fromMap(map['exams']) : null,
      grades:
          map['grades'] != null ? PermissionModel.fromMap(map['grades']) : null,
      homeworks: map['homeworks'] != null
          ? PermissionModel.fromMap(map['homeworks'])
          : null,
      lectures: map['lectures'] != null
          ? PermissionModel.fromMap(map['lectures'])
          : null,
      students: map['students'] != null
          ? PermissionModel.fromMap(map['students'])
          : null,
      student_payments: map['student_payments'] != null
          ? PermissionModel.fromMap(map['student_payments'])
          : null,
      payments: map['payments'] != null
          ? PermissionModel.fromMap(map['payments'])
          : null,
    );
  }
  @override
  String toString() {
    return 'Assitants $assistants \n Attendances $attendances \n Exams $exams \n Grades $grades \n Lectures $lectures \n StudentPayments $student_payments Payments $payments';
  }
}
