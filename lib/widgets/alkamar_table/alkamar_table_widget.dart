import 'dart:math';

import 'package:alqamar/widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alqamar/cubits/student_cubit/student_cubit.dart';
import 'package:alqamar/models/stage/stage_model.dart';
import 'package:alqamar/models/student/student_model.dart';
import 'package:alqamar/screens/students/student_profile/student_profile_screen.dart';
import 'package:alqamar/shared/methods.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/shared/presentation/resourses/font_manager.dart';
import 'package:alqamar/widgets/alkamar_table/alkamar_table_data.dart';
import 'package:alqamar/widgets/text_widget.dart';

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
  final VoidCallback? loadMore;

  const AlkamarTable(
      {super.key, required this.tableData, required this.stage, this.loadMore});

  @override
  State<AlkamarTable> createState() => _AlkamarTableState();
}

class _AlkamarTableState extends State<AlkamarTable> {
  ScrollController studentsScrollController = ScrollController();
  ScrollController verticalCellsScrollController = ScrollController();
  List<ScrollController> horizontalCellsController = [];

  ScrollController headersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addScrollControllers(widget.tableData.rows.length);
    studentsScrollController.addListener(_verticalScrollListener1);
    verticalCellsScrollController.addListener(_verticalScrollListener2);

    headersScrollController.addListener(() {
      _horizontalScrollListenter(headersScrollController);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      headersScrollController
          .jumpTo(headersScrollController.position.maxScrollExtent);
    });
  }

  void _addScrollControllers(int len) {
    horizontalCellsController.addAll(List.generate(len, (_) {
      final controller = ScrollController();
      controller.addListener(() {
        _horizontalScrollListenter(controller);
      });

      return controller;
    }));
  }

  void _horizontalScrollListenter(ScrollController controller) {
    double offset = controller.position.pixels;
    for (int i = 0; i < horizontalCellsController.length; i++) {
      if (horizontalCellsController[i].hasClients) {
        if (offset != horizontalCellsController[i].position.pixels) {
          horizontalCellsController[i].jumpTo(offset);
        }
      }
    }
    if (offset != headersScrollController.position.pixels) {
      headersScrollController.jumpTo(offset);
    }
  }

  void _verticalScrollListener1() {
    double offset = studentsScrollController.position.pixels;
    if (offset != verticalCellsScrollController.position.pixels) {
      verticalCellsScrollController.jumpTo(offset);
    }
    _horizontalScrollListenter(headersScrollController);
    if (verticalCellsScrollController.position.pixels ==
            verticalCellsScrollController.position.maxScrollExtent &&
        !StudentCubit.instance(context).isLoadingMoreStudents) {
      if (widget.loadMore != null) widget.loadMore!();
    }
  }

  void _verticalScrollListener2() {
    double offset = verticalCellsScrollController.position.pixels;
    if (offset != studentsScrollController.position.pixels) {
      studentsScrollController.jumpTo(offset);
    }
    _horizontalScrollListenter(headersScrollController);
  }

  @override
  void dispose() {
    studentsScrollController.dispose();
    verticalCellsScrollController.dispose();
    headersScrollController.dispose();

    for (var element in horizontalCellsController) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AlkamarTable oldWidget) {
    int oldLen = oldWidget.tableData.rows.length,
        newLen = widget.tableData.rows.length;
    if (oldLen != newLen) {
      _addScrollControllers(max(newLen - oldLen, oldLen - newLen));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final headers = widget.tableData.headers;
    final rows = widget.tableData.rows;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final cellHeight = height / 15;
    final cellWidth = width / 4.5;
    final legendHeight = height * (widget.tableData.headerHeightRatio ?? 0.11);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _StickyLegend(
                  tableData: widget.tableData,
                  height: legendHeight,
                  legend: Row(
                    children: [
                      if (widget.tableData.hasCheckbox)
                        Checkbox(
                            value: StudentCubit.instance(context)
                                .selectAllStudents,
                            onChanged: (val) {
                              StudentCubit.instance(context)
                                  .toggleSelectAllIds();
                            }),
                      TextWidget(label: generateLegendText()),
                    ],
                  ),
                  data: Scrollbar(
                    interactive: true,
                    controller: studentsScrollController,
                    child: ListView.builder(
                      controller: studentsScrollController,
                      itemBuilder: (_, j) {
                        return Row(
                          children: [
                            Expanded(child: Builder(builder: (context) {
                              final row = rows[j];
                              final student = row.student;
                              return Container(
                                height: cellHeight,
                                decoration: BoxDecoration(
                                  color: _getColor(student, j),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Methods.navigateTo(
                                        context,
                                        StudentProfileScreen(
                                          studentId: student.id,
                                        ));
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (widget.tableData.hasCheckbox)
                                        Checkbox(
                                            value:
                                                StudentCubit.instance(context)
                                                    .selectedIds
                                                    .contains(student.id),
                                            onChanged: (val) {
                                              StudentCubit.instance(context)
                                                  .toggleSelectedId(student.id);
                                            }),
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: TextWidget(
                                              fontSize: FontSize.s12,
                                              label:
                                                  student.generateCodeWithName),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                          ],
                        );
                      },
                      itemCount: rows.length,
                    ),
                  ),
                ),
              ),
              SizedBox(
                // height: cellHeight,
                width: cellWidth,
                child: _StickyLegend(
                  tableData: widget.tableData,
                  height: legendHeight,
                  legend: ListView.builder(
                    itemCount: headers.length,
                    controller: headersScrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return SizedBox(
                          width: cellWidth, child: _Header(header: headers[i]));
                    },
                  ),
                  data: ListView.builder(
                      itemCount: rows.length,
                      controller: verticalCellsScrollController,
                      itemBuilder: (context, j) {
                        return SizedBox(
                          height: cellHeight,
                          width: cellWidth,
                          child: ListView.builder(
                            itemCount: headers.length,
                            controller: horizontalCellsController[j],
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final student = rows[j].student;
                              final cell = rows[j].cells[i];
                              return SizedBox(
                                width: cellWidth,
                                height: cellHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getColor(student, j),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  child: _ContentCell(
                                    cell: cell,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
        StudentCubit.instance(context).isLoadingMoreStudents
            ? const DefaultLoader()
            : const SizedBox.shrink()
      ],
    );
  }

  String generateLegendText() {
    String totalStudents = '';
    if (widget.tableData.totalItems != null) {
      totalStudents = '${widget.tableData.totalItems}/';
    }
    return 'الطلاب ($totalStudents${widget.tableData.rows.length})';
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

class _StickyLegend extends StatelessWidget {
  const _StickyLegend(
      {required this.height,
      required this.legend,
      required this.tableData,
      required this.data});
  final double height;
  final Widget legend;
  final Widget data;
  final TableData tableData;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: height,
        child: legend,
      ),
      SizedBox(height: 8.h),
      Expanded(
        child: data,
      )
    ]);
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
            child: TextWidget(
          fontSize: FontSize.s12,
          label: cell.content,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
