import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/cubits/student_cubit/student_states.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/screens/students/student_payments/widgets/payments_table.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPaymentsScreen extends StatefulWidget {
  const StudentPaymentsScreen({Key? key, required this.stage})
      : super(key: key);
  final StageModel stage;
  @override
  State<StudentPaymentsScreen> createState() => _StudentPaymentsScreenState();
}

class _StudentPaymentsScreenState extends State<StudentPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit(widget.stage)..getStudentPayments(),
      child: StudentBlocConsumer(
        listener: (context, state) {},
        builder: (context, state) {
          final studentCubit = StudentCubit.instance(context);
          final students = studentCubit.allStudentPayments;
          final payments = studentCubit.allPayments;
          final totalStudents = studentCubit.totalPaymentStudents;
          return Scaffold(
            appBar: AppBar(
              title: const TextWidget(
                label: 'المصروفات',
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Builder(
                  builder: (context) {
                    if (state is GetStudentPaymentsLoadingState) {
                      return const Center(child: DefaultLoader());
                    }
                    if (!studentCubit.hasLoadedPaymentsRes) {
                      return CustomErrorWidget(
                        onPressed: () {
                          studentCubit.getStudentPayments();
                        },
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                            child: PaymentsTable(
                          students: students,
                          payments: payments,
                          stage: widget.stage,
                          totalStudents: totalStudents,
                        )),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
