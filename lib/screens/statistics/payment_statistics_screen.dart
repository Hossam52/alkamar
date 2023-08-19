import 'package:alqamar/cubits/payment_cubit/payment_cubit.dart';
import 'package:alqamar/cubits/payment_cubit/payment_states.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/default_loader.dart';
import 'package:alqamar/widgets/error_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentStatistcsscreen extends StatelessWidget {
  const PaymentStatistcsscreen({Key? key, required this.payment})
      : super(key: key);
  final PaymentsModel payment;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PaymentCubit(payment)..getPaymentStats(),
        child: PaymentBlocBuilder(builder: (context, state) {
          final payment = PaymentCubit.instance(context).paymentModel;
          return Scaffold(
            appBar: AppBar(
              title: TextWidget(label: 'بيانات المصروفات ${payment.title}'),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: ListView(
                  children: [
                    PaymentDetails(payment: payment),
                    Builder(
                      builder: (context) {
                        final cubit = PaymentCubit.instance(context);
                        if (state is GetPaymentStatsLoadingState) {
                          return const DefaultLoader();
                        }
                        if (cubit.errorLoadingStatistcs) {
                          return CustomErrorWidget(onPressed: () {
                            cubit.getPaymentStats();
                          });
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Center(
                                child: TextWidget(
                                    label: 'احصائيات الشهر',
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize.s18),
                              ),
                              _field('دفع', '${cubit.paid} طالب'),
                              _field('لم يدفع', '${cubit.notPaid} طالب'),
                              _field('لم يتم التحصيل',
                                  '${cubit.notAssigned} طالب'),
                              _field('دفع مؤخر', '${cubit.latePaid} طالب'),
                              _field('المتوقفين', '${cubit.disabled} طالب'),
                              _field('اجمالي الدفع',
                                  '${cubit.totalPaid} من ${cubit.totalStudents} طالب'),
                              _field('اجمالي عدد الطلاب',
                                  '${cubit.totalStudents} طالب منتظم من ${cubit.totalStudents + cubit.disabled} طالب'),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  AuthTextField _field(String key, String value, {int? flex}) {
    return AuthTextField(
      controller: TextEditingController(text: value),
      label: key,
      hint: '',
      flex: 3,
      validationRules: [],
      enabled: false,
    );
  }
}

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({required this.payment});
  final PaymentsModel payment;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rowItem('مصروفات', payment.title),
        _rowItem('تاريخ المصروفات',
            Methods.formatDate(payment.paymentDate, appendYear: true)),
      ],
    );
  }

  Widget _rowItem(String key, String value) {
    return Row(
      children: [
        Expanded(flex: 2, child: TextWidget(label: key)),
        Expanded(flex: 3, child: TextWidget(label: value)),
      ],
    );
  }
}
