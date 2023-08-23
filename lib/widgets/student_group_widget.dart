import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentGroupWidget extends StatefulWidget {
  const StudentGroupWidget(
      {super.key, required this.onChangeGroup, this.groupId});
  final void Function(int?) onChangeGroup;
  final int? groupId;

  @override
  State<StudentGroupWidget> createState() => _StudentGroupWidgetState();
}

class _StudentGroupWidgetState extends State<StudentGroupWidget> {
  int? groupId;
  @override
  void initState() {
    groupId = widget.groupId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = StageCubit.instance(context).groups;
    if (groups.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(label: 'مجموعة الطالب'),
          SizedBox(height: 10.h),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 1,
                mainAxisSpacing: 10.h),
            itemBuilder: (_, index) => Center(
              child: RadioListTile<int>(
                  value: groups[index].id,
                  groupValue: groupId,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.all(0),
                  selected: groupId == groups[index].id,
                  activeColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                  selectedTileColor: ColorManager.accentColor,
                  title: TextWidget(label: groups[index].title),
                  onChanged: (group) {
                    setState(() {
                      groupId = group;
                    });
                    widget.onChangeGroup(group);
                  }),
            ),
            shrinkWrap: true,
            primary: false,
            itemCount: groups.length,
          ),
        ],
      ),
    );
  }
}
