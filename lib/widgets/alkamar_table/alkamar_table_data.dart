import 'package:flutter/material.dart';

import 'package:alqamar/models/student/student_model.dart';

class TableData {
  List<TableRowItem> rows;
  int? totalItems;
  List<HeaderItem> headers;
  bool hasCheckbox;
  double? headerHeightRatio;
  TableData({
    required this.rows,
    this.totalItems,
    required this.headers,
    this.hasCheckbox = false,
    this.headerHeightRatio,
  });
}

class HeaderItem {
  String title;
  Widget? action;
  VoidCallback onPressed;
  HeaderItem({
    required this.title,
    this.action,
    required this.onPressed,
  });
}

class TableRowItem {
  StudentModel student;
  List<CellItem> cells;
  Color? color;
  TableRowItem({
    required this.student,
    required this.cells,
    this.color,
  });
}

class CellItem {
  String content;
  Color? color;
  VoidCallback onPressed;
  CellItem({
    required this.content,
    this.color,
    required this.onPressed,
  });
}
