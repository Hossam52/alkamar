import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String formatDate([bool year = false]) =>
      DateFormat('${!year ? '' : 'yyyy/'}MM/dd').format(this);
}
