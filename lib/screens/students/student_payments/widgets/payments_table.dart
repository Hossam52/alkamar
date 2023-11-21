import 'package:alqamar/models/payments/payment_status_enum.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/screens/statistics/payment_statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/qr/qr_screen.dart';
import 'package:alqamar/screens/qr/widgets/confirm_attend_dialog.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_widget.dart';
import 'package:alqamar/widgets/custom_button.dart';
import 'package:alqamar/widgets/default_loader.dart';

class PaymentsTable extends StatefulWidget {
  final List<StudentModel> students;
  final int? totalStudents;
  final List<PaymentsModel> payments;
  final StageModel stage;

  const PaymentsTable(
      {super.key,
      required this.students,
      required this.payments,
      required this.stage,
      this.totalStudents});

  @override
  State<PaymentsTable> createState() => _PaymentsTableState();
}

class _PaymentsTableState extends State<PaymentsTable> {
  @override
  Widget build(BuildContext context) {
    return AlkamarTable(
      stage: widget.stage,
      tableData: TableData(
        totalItems: widget.totalStudents,
        rows: _studentRows(context),
        headers: _headers(context),
      ),
      loadMore: () {
        StudentCubit.instance(context).getStudentPayments();
      },
    );
  }

  List<HeaderItem> _headers(BuildContext context) {
    return widget.payments
        .map((payment) => HeaderItem(
              title:
                  '${payment.title}\n ${Methods.formatDate(payment.paymentDate)}',
              onPressed: () {
                Methods.navigateTo(
                    context, PaymentStatistcsscreen(payment: payment));
              },
              action: _CustomStorePayment(payment: payment),
            ))
        .toList();
  }

  List<TableRowItem> _studentRows(BuildContext context) {
    return widget.students
        .map(
          (student) => TableRowItem(
              student: student,
              cells: List.generate(
                student.payments?.length ?? 0,
                (index) {
                  final payment = student.payments![index];

                  return CellItem(
                      content: payment.generateTitle,
                      onPressed: () {
                        try {
                          final payment = widget.payments[index];
                          showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                  value: StudentCubit.instance(context),
                                  child: ConfirmAttendDialog(
                                    studentId: student.id.toString(),
                                    actionsWidget: _ConfirmHomeworkActions(
                                        paymentId: payment.id.toString()),
                                  )));
                        } on Exception {
                          //
                        }
                      },
                      color: payment.paymentStatus.color);
                },
              )),
        )
        .toList();
  }
}

class _CustomStorePayment extends StatelessWidget {
  const _CustomStorePayment({required this.payment});
  final PaymentsModel payment;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'تسجيل',
      onPressed: () async {
        await Methods.navigateTo(
            context,
            BlocProvider.value(
                value: StudentCubit.instance(context),
                child: QrScreen(
                  title: payment.title,
                  actionsWidget:
                      _ConfirmHomeworkActions(paymentId: payment.id.toString()),
                  onManual: (studentCode) async {
                    await showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                            value: StudentCubit.instance(context),
                            child: _confirm(studentCode: studentCode)));
                  },
                  onQr: (studentid) async {
                    await showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                            value: StudentCubit.instance(context),
                            child: _confirm(studentId: studentid)));
                  },
                )));
        StudentCubit.instance(context).getStudentPayments();
      },
    );
  }

  ConfirmAttendDialog _confirm({String? studentId, String? studentCode}) {
    return ConfirmAttendDialog(
      studentCode: studentCode,
      studentId: studentId,
      actionsWidget: _ConfirmHomeworkActions(paymentId: payment.id.toString()),
    );
  }
}

class _ConfirmHomeworkActions extends StatelessWidget {
  const _ConfirmHomeworkActions({required this.paymentId});
  final String paymentId;
  @override
  Widget build(BuildContext context) {
    return StudentBlocConsumer(
      listener: (context, state) {
        if (state is AddPaymentErrorState) {
          Methods.showSnackBar(context, state.error);
        }
        if (state is AddPaymentSuccessState) {
          Methods.showSuccessSnackBar(context, 'تم اضافة الدفع للطالب بنجاح');
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = StudentCubit.instance(context);
        if (state is AddPaymentLoadingState) {
          return const DefaultLoader();
        }

        return Column(
          children: [
            _actionButton(cubit,
                paymentStatus: PaidPayment(), icon: Icons.done),
            _sizedBox(),
            Row(
              children: [
                Expanded(
                  child: _actionButton(cubit,
                      paymentStatus: NotPaidPayment(), icon: Icons.close),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _actionButton(cubit,
                      paymentStatus: LatePaidPayment(), icon: Icons.timer),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  CustomButton _actionButton(StudentCubit cubit,
      {required PaymentStatus paymentStatus, required IconData icon}) {
    return CustomButton(
      text: paymentStatus.title,
      backgroundColor: paymentStatus.color,
      leadingIcon: Icon(icon),
      onPressed: () {
        cubit.addPayment(paymentId, paymentStatus);
      },
    );
  }

  Widget _sizedBox() {
    return SizedBox(height: 10.h);
  }
}
