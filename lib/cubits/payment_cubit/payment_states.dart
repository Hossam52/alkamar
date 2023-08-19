//
abstract class PaymentStates {}

class IntitalPaymentState extends PaymentStates {}

//
//GetPaymentStats online fetch data
class GetPaymentStatsLoadingState extends PaymentStates {}

class GetPaymentStatsSuccessState extends PaymentStates {}

class GetPaymentStatsErrorState extends PaymentStates {
  final String error;
  GetPaymentStatsErrorState({required this.error});
}
