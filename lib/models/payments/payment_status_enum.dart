import 'package:flutter/material.dart';

import 'package:alqamar/shared/presentation/resourses/color_manager.dart';

abstract class PaymentStatus {
  Color get getColor => color ?? Colors.transparent;
  Color? color;
  String title;
  int index;
  int get getIndex;
  static PaymentStatus instance(int? index) {
    final x = [PaidPayment(), LatePaidPayment(), NotPaidPayment()];
    for (var element in x) {
      if (element.index == index) return element;
    }
    return UndifinedPayment();
  }

  PaymentStatus(this.index, this.title, {this.color});
}

class PaidPayment extends PaymentStatus {
  static int x = 1;
  PaidPayment() : super(x, 'دفع', color: ColorManager.paidColor);

  @override
  int get getIndex => x;
}

class LatePaidPayment extends PaymentStatus {
  static int x = 2;

  LatePaidPayment() : super(x, 'دفع متأخر', color: ColorManager.latePaidColor);

  @override
  int get getIndex => x;
}

class NotPaidPayment extends PaymentStatus {
  static int x = 3;

  NotPaidPayment() : super(x, 'لم يدفع', color: ColorManager.notPaidColor);

  @override
  int get getIndex => x;
}

class UndifinedPayment extends PaymentStatus {
  static int x = 4;

  UndifinedPayment() : super(x, ' - ');

  @override
  int get getIndex => x;
}
