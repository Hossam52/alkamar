import 'package:alqamar/models/payments/payment_statistics_model.dart';
import 'package:alqamar/models/payments/payments_model.dart';
import 'package:alqamar/shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './payment_states.dart';

//Bloc builder and bloc consumer methods
typedef PaymentBlocBuilder = BlocBuilder<PaymentCubit, PaymentStates>;
typedef PaymentBlocConsumer = BlocConsumer<PaymentCubit, PaymentStates>;

//
class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit(this.paymentModel) : super(IntitalPaymentState());
  static PaymentCubit instance(BuildContext context) =>
      BlocProvider.of<PaymentCubit>(context);
  final PaymentsModel paymentModel;

  PaymentStatisticsModel? _paymentStats;
  bool get errorLoadingStatistcs => _paymentStats == null;

  int get paid => _paymentStats?.paid ?? 0;
  int get notPaid => _paymentStats?.notPaid ?? 0;
  int get latePaid => _paymentStats?.latePaid ?? 0;
  int get notAssigned => _paymentStats?.notAssigned ?? 0;
  int get disabled => _paymentStats?.disabled ?? 0;
  int get totalStudents => _paymentStats?.totalStudents ?? 0;
  int get totalPaid => _paymentStats?.totalPaid ?? 0;

  Future<void> getPaymentStats() async {
    try {
      emit(GetPaymentStatsLoadingState());
      final res = await AppServices.getPaymentStats(paymentModel.id);
      _paymentStats = PaymentStatisticsModel.fromMap(res);
      emit(GetPaymentStatsSuccessState());
    } catch (e) {
      debugPrint(e.toString());
      emit(GetPaymentStatsErrorState(error: e.toString()));
    }
  }
}
