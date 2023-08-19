import 'package:alqamar/models/stage/stage_type_model.dart';
import 'package:alqamar/screens/stages/widgets/stages_listview.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class StageTypeItem extends StatelessWidget {
  const StageTypeItem({
    super.key,
    required this.stageType,
  });

  final StageTypeModel stageType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              dense: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: ColorManager.accentColor,
              title: TextWidget(
                label: stageType.name,
              ),
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: StagesListView(stages: stageType.stages),
        )
      ],
    );
  }
}
