import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

Color? _getColor(StudentModel student, int index) {
  if (!student.student_status) return student.getStudentStatusColor;
  if (index % 2 == 0) {
    return ColorManager.accentColor.withOpacity(0.4);
  } else {
    return ColorManager.primary.withOpacity(0.4);
  }
}

class AlkamarTable extends StatefulWidget {
  final TableData tableData;
  final StageModel stage;

  const AlkamarTable({super.key, required this.tableData, required this.stage});

  @override
  State<AlkamarTable> createState() => _AlkamarTableState();
}

class _AlkamarTableState extends State<AlkamarTable> {
  @override
  Widget build(BuildContext context) {
    final headers = widget.tableData.headers;
    final rows = widget.tableData.rows;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StickyHeadersTable(
      tableDirection: TextDirection.rtl,
      columnsLength: headers.length,
      rowsLength: rows.length,
      onContentCellPressed: (columnIndex, rowIndex) {},
      cellAlignments: const CellAlignments.uniform(Alignment.centerRight),
      showVerticalScrollbar: false,
      showHorizontalScrollbar: false,
      cellDimensions: CellDimensions.fixed(
        contentCellHeight: height / 15,
        stickyLegendWidth: width * 0.68,
        stickyLegendHeight:
            height * (widget.tableData.headerHeightRatio ?? 0.11),
        contentCellWidth: width / 4.5,
      ),
      columnsTitleBuilder: (i) => _Header(header: headers[i]),
      rowsTitleBuilder: (i) {
        final row = rows[i];
        final student = row.student;
        return Container(
          decoration: BoxDecoration(
              color: _getColor(student, i),
              border: Border.symmetric(
                  horizontal: BorderSide(
                      color: Colors.white.withOpacity(0.6), width: 0.9))),
          child: InkWell(
            onTap: () {
              Methods.navigateTo(
                  context,
                  StudentProfileScreen(
                      studentId: student.id, stageModel: widget.stage));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.tableData.hasCheckbox)
                  Checkbox(
                      value: StudentCubit.instance(context)
                          .selectedIds
                          .contains(student.id),
                      onChanged: (val) {
                        StudentCubit.instance(context)
                            .toggleSelectedId(student.id);
                      }),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextWidget(
                        fontSize: FontSize.s12,
                        label: student.generateCodeWithName),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      contentCellBuilder: (i, j) {
        final student = rows[j].student;
        final cell = rows[j].cells[i];
        return Container(
          decoration: BoxDecoration(
              color: _getColor(student, j),
              border:
                  Border.all(color: Colors.white.withOpacity(0.6), width: 0.9)),
          child: _ContentCell(
            cell: cell,
          ),
        );
      },
      legendCell: Row(
        children: [
          if (widget.tableData.hasCheckbox)
            Checkbox(
                value: StudentCubit.instance(context).selectAllStudents,
                onChanged: (val) {
                  StudentCubit.instance(context).toggleSelectAllIds();
                }),
          TextWidget(label: 'الطلاب (${rows.length})'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.header});
  final HeaderItem header;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: header.onPressed,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
                textAlign: TextAlign.center,
                fontSize: FontSize.s12,
                label: header.title),
            const SizedBox(
              height: 10,
            ),
            if (header.action != null)
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: header.action ?? const SizedBox.shrink()),
              )
          ],
        ),
      ),
    );
  }
}

class _ContentCell extends StatelessWidget {
  const _ContentCell({required this.cell});
  final CellItem cell;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cell.onPressed,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: cell.color,
        margin: EdgeInsets.all(4.w),
        child: Center(
            child: TextWidget(fontSize: FontSize.s12, label: cell.content)),
      ),
    );
  }
}
