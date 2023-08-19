import 'package:alqamar/widgets/custom_table_defination_widget.dart';
import 'package:flutter/material.dart';

import 'package:alqamar/widgets/text_widget.dart';

class StudentLectureBase extends StatelessWidget {
  const StudentLectureBase(
      {super.key, this.data = '', required this.tableDefinition});
  final String data;
  final TableDefinition tableDefinition;
  @override
  Widget build(BuildContext context) {
    if (tableDefinition.rows.isEmpty) {
      return Center(
        child: TextWidget(label: 'لا يوجد $data'),
      );
    }
    return CustomTableDefinition(
      tableDefinition: tableDefinition,
    );
  }
}
