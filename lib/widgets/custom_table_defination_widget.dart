import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableDefinition {
  final List<String> headers;
  final List<RowItem> rows;

  TableDefinition({required this.headers, required this.rows});
}

class RowItem {
  List<String> cells;
  Color? color;
  VoidCallback? onRowPressed;
  RowItem({
    required this.cells,
    this.color,
    this.onRowPressed,
  });
}

class CustomTableDefinition extends StatelessWidget {
  const CustomTableDefinition(
      {super.key, required this.tableDefinition, this.columnSizes});
  final TableDefinition tableDefinition;
  final Map<int, double>? columnSizes;

  @override
  Widget build(BuildContext context) {
    final mapColumnSizes =
        columnSizes?.map<int, TableColumnWidth>((key, value) {
      final MapEntry<int, TableColumnWidth> map =
          MapEntry(key, FixedColumnWidth(value));
      return map;
    });
    final x = tableDefinition.rows.map((row) {
      if (row.cells.length > tableDefinition.headers.length) {
        row.cells = row.cells.take(tableDefinition.headers.length).toList();
      }
      return [
        _spacerTableRow(row),
        TableRow(
            decoration: BoxDecoration(color: row.color),
            children: row.cells
                .map((cell) => _cellItem(cell, onRowPressed: row.onRowPressed))
                .toList()),
      ];
    }).toList();
    if (tableDefinition.rows.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(columnWidths: mapColumnSizes, children: [
          TableRow(
            decoration:
                BoxDecoration(color: ColorManager.accentColor.withOpacity(0.7)),
            children: tableDefinition.headers
                .map((header) => _cellItem(header))
                .toList(),
          ),
        ]),
        ...x.map((e) {
          return Table(
            columnWidths: mapColumnSizes,
            children: e,
          );
        }).toList()
      ],
    );
  }

  TableRow _spacerTableRow(RowItem row) {
    return TableRow(
        children: row.cells.map((e) => SizedBox(height: 3.h)).toList());
  }

  Widget _cellItem(String value, {VoidCallback? onRowPressed}) => InkWell(
      onTap: onRowPressed, child: Center(child: TextWidget(label: value)));
}
