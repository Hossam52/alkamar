import 'package:alqamar/cubits/stage_cubit/stage_cubit.dart';
import 'package:alqamar/screens/auth/widgets/auth_text_field.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class GroupsDropDownWidget extends StatefulWidget {
  const GroupsDropDownWidget(
      {super.key, this.selectedGroupId, required this.onChangeSelection});
  final int? selectedGroupId;
  final void Function(int?) onChangeSelection;

  @override
  State<GroupsDropDownWidget> createState() => _GroupsDropDownWidgetState();
}

class _GroupsDropDownWidgetState extends State<GroupsDropDownWidget> {
  int? groupId;
  @override
  void initState() {
    groupId = widget.selectedGroupId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = StageCubit.instance(context).groups;

    return AuthTextField.customTextField(
        controller: TextEditingController(),
        label: 'المجموعة',
        textField: DropdownButtonFormField<int?>(
            dropdownColor: ColorManager.primary,
            value: groupId,
            items: groups
                .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: TextWidget(
                      label: e.title,
                    )))
                .toList(),
            onChanged: (item) {
              setState(() {
                groupId = item;
              });
              widget.onChangeSelection(item);
            }));
  }
}
